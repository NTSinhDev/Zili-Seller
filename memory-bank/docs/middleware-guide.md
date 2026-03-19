# Middleware & Model Pattern - Hướng dẫn

## 🎯 Kiến trúc Simplified

### Pattern hiện tại:
```
Presentation Layer (UI/BLoC)
    ↓ gọi middleware trực tiếp
Data Layer (Middlewares)
    ↓ gọi REST API
    ↓ parse response → Model
    ↓ trả về Model
Presentation Layer nhận Model
```

### Vai trò các lớp:

**Middleware**:
- Gọi REST API
- Parse response từ API
- Trả về **Model** (nếu thành công) hoặc `ResponseFailedState` (nếu lỗi)
- Model là các lớp được customize để match với API response

**Model**:
- Match với structure của API response
- Có `fromMap()` để parse từ API response
- Có thể có thêm fields/methods cần thiết cho UI
- Không cần kế thừa từ Entity, độc lập để match API response

## 🏗️ Cấu trúc Middleware (Pattern chính)

### 1. Middleware Structure

```dart
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/[domain]/[model].dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';

class [Feature]Middleware extends BaseMiddleware {
  /// [Mô tả method]
  /// 
  /// Gọi REST API và trả về Model nếu thành công
  /// 
  /// Parameters:
  /// - [param1]: [Mô tả]
  /// 
  /// Returns:
  /// - ResponseState chứa Model hoặc List<Model>
  Future<ResponseState> [methodName]({
    // parameters
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        NetworkUrl.[feature].[method](),
        queryParameters: {
          // query params
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        
        // Parse response thành Model
        if (data is Map<String, dynamic>) {
          final count = data['count'] ?? 0;
          final itemsData = data['[key]'] as List<dynamic>?;
          
          if (itemsData != null) {
            final models = itemsData
                .map((item) => [Model].fromMap(item as Map<String, dynamic>))
                .toList();

            return ResponseSuccessState(
              statusCode: response.statusCode ?? -1,
              responseData: {
                'count': count,
                '[key]': models,
              },
            );
          }
        }

        // Single item case
        if (data is Map<String, dynamic>) {
          final model = [Model].fromMap(data);
          return ResponseSuccessState(
            statusCode: response.statusCode ?? -1,
            responseData: model,
          );
        }
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }
}
```

### 2. Model Structure (kế thừa từ Entity)

```dart
import 'package:zili_coffee/data/entity/[domain]/[entity].dart';

/// Model cho [Feature] - Customize từ Entity để match API response
class [Model] extends [Entity] {
  // Thêm fields mới nếu cần (không có trong Entity)
  final String? customField;
  
  // Override hoặc thêm methods
  [Model]({
    // Gọi super constructor với fields từ Entity
    required super.id,
    // ... other Entity fields
    this.customField,
  }) : super(
    // Initialize Entity fields
  );

  /// Factory constructor từ API response
  factory [Model].fromMap(Map<String, dynamic> map) {
    return [Model](
      // Map từ API response
      id: map['id'] as String,
      // ... map other fields
      customField: map['customField']?.toString(),
    );
  }

  /// Helper methods cho UI
  String get displayName => titleVi ?? titleEn ?? '';
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // ... other fields
    };
  }
}
```

## 📝 Ví dụ thực tế

### Example 1: OrderMiddleware.getProductsForOrder()

```dart
// Middleware trả về Model trực tiếp
Future<ResponseState> getProductsForOrder({
  int limit = 10,
  int offset = 0,
  String? keyword,
  String? branchId,
}) async {
  try {
    final response = await coreDio.get<NWResponse>(
      NetworkUrl.orderProduct.filter(
        limit: limit,
        offset: offset,
        keyword: keyword,
        branchId: branchId,
      ),
      cancelToken: cancelToken,
    );

    final resultData = response.data;
    if (resultData is NWResponseSuccess) {
      final data = resultData.data;
      int count = 0;
      List<OrderProduct> products = []; // Model, không phải Entity

      if (data is Map<String, dynamic>) {
        count = data['count'] ?? 0;
        final productsData = data['products'] as List<dynamic>?;
        if (productsData != null) {
          // Parse thành Model
          products = productsData
              .map((item) => OrderProduct.fromMap(item as Map<String, dynamic>))
              .toList();
        }
      }

      // Trả về Model trực tiếp
      return ResponseSuccessState(
        statusCode: response.statusCode ?? -1,
        responseData: {
          'count': count,
          'products': products, // List<Model>
        },
      );
    }

    if (resultData is NWResponseFailed) {
      return ResponseFailedState.fromNWResponse(resultData);
    }

    return ResponseFailedState.unknownError();
  } on DioException catch (e) {
    return handleResponseFailedState(e);
  }
}
```

### Example 2: OrderProduct Model

```dart
// Model không kế thừa Entity nhưng có structure riêng match với API
class OrderProduct {
  final String id;
  final String? avatar;
  final String? titleVi;
  final List<ProductVariant> productVariants; // Nested models
  final num availableQuantity;
  
  // Helper methods cho UI
  String get displayName => titleVi ?? titleEn ?? '';
  bool get hasVariants => productVariants.length > 1;
  ProductVariant? get firstVariant => productVariants.isNotEmpty ? productVariants.first : null;

  OrderProduct({...});

  // Parse từ API response
  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      id: map['id'] as String,
      avatar: map['avatar']?.toString(),
      titleVi: map['titleVi']?.toString(),
      productVariants: (map['productVariants'] as List<dynamic>?)
          ?.map((v) => ProductVariant.fromMap(v as Map<String, dynamic>))
          .toList() ?? [],
      availableQuantity: map['availableQuantity'] as num? ?? 0,
    );
  }
}
```

## 🚀 Quick Start Templates

### Template 1: Middleware - List API

```dart
// File: lib/data/middlewares/[feature]_middleware.dart

import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/[domain]/[model].dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';

class [Feature]Middleware extends BaseMiddleware {
  Future<ResponseState> get[Feature]s({
    int limit = 20,
    int offset = 0,
    String? keyword,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        NetworkUrl.[feature].filter(
          limit: limit,
          offset: offset,
          keyword: keyword,
        ),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int count = 0;
        List<[Model]> models = [];

        if (data is Map<String, dynamic>) {
          count = data['count'] ?? 0;
          final itemsData = data['[key]'] as List<dynamic>?;
          if (itemsData != null) {
            models = itemsData
                .map((item) => [Model].fromMap(item as Map<String, dynamic>))
                .toList();
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: {
            'count': count,
            '[key]': models, // Trả về Model
          },
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }
}
```

### Template 2: Middleware - Single Item API

```dart
Future<ResponseState> get[Feature]ById({
  required String id,
}) async {
  try {
    final response = await coreDio.get<NWResponse>(
      NetworkUrl.[feature].get(id: id),
      cancelToken: cancelToken,
    );

    final resultData = response.data;
    if (resultData is NWResponseSuccess) {
      final data = resultData.data;
      final model = [Model].fromMap(data as Map<String, dynamic>);

      return ResponseSuccessState(
        statusCode: response.statusCode ?? -1,
        responseData: model, // Trả về Model
      );
    }

    if (resultData is NWResponseFailed) {
      return ResponseFailedState.fromNWResponse(resultData);
    }

    return ResponseFailedState.unknownError();
  } on DioException catch (e) {
    return handleResponseFailedState(e);
  }
}
```

### Template 3: Model Structure

```dart
// File: lib/data/models/[domain]/[model].dart

import 'package:zili_coffee/data/entity/[domain]/[entity].dart';

/// Model cho [Feature] - Customize từ Entity để match API response
class [Model] {
  // Fields từ Entity hoặc customize
  final String id;
  final String name;
  // ... other fields

  [Model]({
    required this.id,
    required this.name,
    // ...
  });

  /// Parse từ API response
  factory [Model].fromMap(Map<String, dynamic> map) {
    return [Model](
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      // Map các fields khác từ API response
    );
  }

  /// Helper methods cho UI
  String get displayName => name;
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // ...
    };
  }
}
```

## 📋 Checklist khi tạo Middleware & Model

### Middleware Checklist:
- [ ] **Tạo file** trong `lib/data/middlewares/[feature]_middleware.dart`
- [ ] **Extend BaseMiddleware** để có `coreDio`, `authDio`, `dio`
- [ ] **Import**:
  - `BaseMiddleware` từ `lib/data/middlewares/base_middleware.dart`
  - Model từ `lib/data/models/[domain]/[model].dart`
  - `ResponseState` từ `lib/data/network/network_response_state.dart`
  - `NetworkUrl` từ `lib/data/network/network_url.dart`
- [ ] **Implement method**:
  - Gọi API qua `coreDio` hoặc `authDio`
  - Parse response thành Model
  - Return `ResponseSuccessState` với Model
  - Handle errors với `ResponseFailedState`
- [ ] **Add endpoint** vào `NetworkUrl` nếu chưa có

### Model Checklist:
- [ ] **Tạo file** trong `lib/data/models/[domain]/[model].dart`
- [ ] **Define fields** match với API response structure
- [ ] **Create constructor** với required/optional fields
- [ ] **Implement `fromMap()`** factory để parse từ API response
- [ ] **Add helper methods** nếu cần (displayName, hasVariants, etc.)
- [ ] **Optional**: `toMap()`, `toJson()` nếu cần serialize
- [ ] **Optional**: `copyWith()` nếu cần immutable updates

## 🎨 Models (thay thế Output Models)

### Model là gì?

**Model** là các lớp được customize để match với API response structure:
- **Match API Response**: Structure giống hệt response từ API
- **Customize từ Entity**: Có thể kế thừa hoặc customize từ Entity
- **UI Ready**: Có helper methods cho UI (displayName, hasVariants, etc.)
- **Parse từ API**: Có `fromMap()` để parse từ JSON response

### Model vs Entity

- **Entity**: Domain objects, pure business logic, không phụ thuộc API structure
- **Model**: Customize từ Entity hoặc độc lập, match với API response, có helper methods cho UI

### Cấu trúc Model

```dart
// File: lib/data/models/[domain]/[model].dart

/// Model cho [Feature] - Match với API response structure
class [Model] {
  // Fields match với API response
  final String id;
  final String name;
  final List<NestedModel> nestedItems;
  // ... other fields

  [Model]({
    required this.id,
    required this.name,
    required this.nestedItems,
    // ...
  });

  /// Parse từ API response
  factory [Model].fromMap(Map<String, dynamic> map) {
    return [Model](
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      nestedItems: (map['nestedItems'] as List<dynamic>?)
          ?.map((item) => NestedModel.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      // Map các fields khác
    );
  }

  /// Helper methods cho UI
  String get displayName => name;
  bool get hasNestedItems => nestedItems.isNotEmpty;
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nestedItems': nestedItems.map((e) => e.toMap()).toList(),
    };
  }
}
```

## 🔄 Data Flow mới (Simplified)

```
Presentation Layer (BLoC/Cubit/UI)
    ↓ call middleware trực tiếp
Middleware.[methodName](params)
    ↓ HTTP request
API
    ↓ response (JSON)
Middleware.parse → Model
    ↓ return ResponseState với Model
Presentation Layer nhận Model
    ↓ sử dụng Model trực tiếp trong UI
```


## ⚠️ Best Practices

### Middleware DO ✅
- ✅ Gọi REST API và parse response thành Model
- ✅ Trả về Model trong ResponseSuccessState nếu thành công
- ✅ Handle errors properly, return ResponseFailedState
- ✅ Sử dụng `coreDio` cho Core Service, `authDio` cho Auth Service
- ✅ Parse nested objects thành nested Models
- ✅ Handle null values safely với `??` operator
- ✅ Document rõ ràng API endpoint và parameters

### Middleware DON'T ❌
- ❌ Không trả Entity trực tiếp, phải parse thành Model
- ❌ Không bỏ qua error handling
- ❌ Không hardcode API URLs, sử dụng NetworkUrl
- ❌ Không parse response trong Presentation Layer

### Model DO ✅
- ✅ Match structure với API response
- ✅ Implement `fromMap()` để parse từ JSON
- ✅ Add helper methods cho UI (displayName, hasVariants, etc.)
- ✅ Handle null values và type conversions safely
- ✅ Parse nested objects thành nested Models

### Model DON'T ❌
- ❌ Không phụ thuộc vào UI components
- ❌ Không chứa business logic phức tạp
- ❌ Không bỏ qua null safety

## 📚 Related Files

- **Entities**: `lib/data/entity/` - Domain entities (pure business logic)
- **Models**: `lib/data/models/` - Customize từ Entity, match API response
- **Middlewares**: `lib/data/middlewares/` - API integration, trả về Model
- **ResponseState**: `lib/data/network/network_response_state.dart` - Response wrapper
- **NetworkUrl**: `lib/data/network/network_url.dart` - API endpoints

## 🎯 Quick Reference

### Tạo Middleware & Model mới trong 6 bước:

1. **Tạo Model**: `lib/data/models/[domain]/[model].dart`
   - Define fields match với API response
   - Implement `fromMap()` factory
   - Add helper methods cho UI

2. **Add API endpoint**: `lib/data/network/network_url.dart`
   - Thêm method vào class tương ứng

3. **Tạo Middleware**: `lib/data/middlewares/[feature]_middleware.dart`
   - Extend BaseMiddleware
   - Implement method gọi API
   - Parse response → Model
   - Return ResponseSuccessState với Model

4. **Test**: Gọi middleware và verify Model structure

5. **Sử dụng trong UI**: Gọi middleware trực tiếp từ BLoC/Cubit hoặc UI

### Sử dụng Middleware trong BLoC/Cubit:

```dart
class [Feature]Cubit extends Cubit<[Feature]State> {
  final [Feature]Middleware _middleware = di<[Feature]Middleware>();

  Future<void> load[Feature]s() async {
    emit([Feature]Loading());
    
    final result = await _middleware.get[Feature]s();
    
    if (result is ResponseSuccessState) {
      final data = result.responseData as Map<String, dynamic>;
      final models = data['[key]'] as List<[Model]>;
      emit([Feature]Loaded(models)); // Nhận Model trực tiếp
    } else if (result is ResponseFailedState) {
      emit([Feature]Error(result.message));
    }
  }
}
```

### Sử dụng Middleware trong UI trực tiếp:

```dart
class [Feature]Screen extends StatefulWidget {
  @override
  _[Feature]ScreenState createState() => _[Feature]ScreenState();
}

class _[Feature]ScreenState extends State<[Feature]Screen> {
  final [Feature]Middleware _middleware = di<[Feature]Middleware>();
  List<[Model]> _items = [];
  bool _isLoading = false;

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    
    final result = await _middleware.get[Feature]s();
    
    if (result is ResponseSuccessState) {
      final data = result.responseData as Map<String, dynamic>;
      setState(() {
        _items = data['[key]'] as List<[Model]>;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      // Show error
    }
  }
}
```

