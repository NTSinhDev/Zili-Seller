# Hướng Dẫn Xây Dựng Màn Hình (Screen Development Guide)

## Tổng Quan

Tài liệu này mô tả cấu trúc thư mục, naming conventions, và best practices khi xây dựng một màn hình mới trong dự án Flutter này.

## Cấu Trúc Thư Mục

### 1. Cấu Trúc Tổng Quan

```
lib/
├── views/                    # Tất cả các màn hình UI
│   ├── {feature}/           # Thư mục feature/module
│   │   ├── {feature}_screen.dart    # Screen chính
│   │   ├── components/      # Components riêng của screen
│   │   │   ├── {component}_section.dart
│   │   │   └── {component}_item.dart
│   │   └── {sub_feature}/   # Sub-screens nếu cần
│   │       └── {sub_feature}_screen.dart
│   └── module_common/       # Components dùng chung nhiều màn hình
├── bloc/                    # State management
│   └── {feature}/
│       ├── {feature}_cubit.dart
│       └── {feature}_state.dart
├── data/                    # Data layer
│   ├── models/             # Data models
│   ├── middlewares/        # API integration
│   └── repositories/       # Data repositories
└── utils/                   # Utilities
    └── widgets/            # Reusable widgets
```

### 2. Ví Dụ Cấu Trúc Thực Tế

#### Ví dụ 1: Order Module (phức tạp)
```
lib/views/order/
├── create_order/
│   ├── create_order_screen.dart          # Screen chính
│   ├── select_customers_screen.dart     # Sub-screen
│   ├── select_products_screen.dart      # Sub-screen
│   ├── config_product_variant_screen.dart
│   ├── edit_customer_address_screen.dart
│   └── components/                      # Components riêng
│       ├── customer_section.dart
│       ├── products_section.dart
│       ├── payment_section.dart
│       ├── branch_section.dart
│       ├── delivery_methods.dart
│       ├── additional_info_section.dart
│       ├── bottom_action_bar.dart
│       ├── customer_list_item.dart
│       └── product_list_item.dart
├── order_details/
│   ├── order_details_screen.dart
│   └── components/
│       └── ...
└── orders_history/
    ├── orders_history_screen.dart
    └── components/
        └── ...
```

#### Ví dụ 2: Product Module (đơn giản)
```
lib/views/product/
├── products/
│   ├── products_screen.dart
│   └── components/
│       ├── lineages_coffee.dart
│       ├── tool_bar.dart
│       ├── app_bar.dart
│       └── ...
└── product_detail/
    ├── product_detail_screen.dart
    └── components/
        └── ...
```

#### Ví dụ 3: Customer Module (mới)
```
lib/views/customer/
├── customer_screen.dart
├── docs.md                    # UI/UX documentation
└── components/
    ├── customer_list_item.dart
    ├── customer_search_bar.dart
    ├── customer_filter_tabs.dart
    └── ...
```

## Naming Conventions

### 1. Files

#### Screen Files
- **Format**: `{feature_name}_screen.dart` (snake_case)
- **Ví dụ**: 
  - `create_order_screen.dart`
  - `customer_screen.dart`
  - `product_detail_screen.dart`

#### Component Files
- **Format**: `{component_name}.dart` (snake_case)
- **Ví dụ**:
  - `customer_list_item.dart`
  - `payment_section.dart`
  - `product_search_bar.dart`

#### State Files
- **Format**: `{feature}_state.dart` (snake_case)
- **Ví dụ**:
  - `order_state.dart`
  - `customer_state.dart`

#### Cubit Files
- **Format**: `{feature}_cubit.dart` (snake_case)
- **Ví dụ**:
  - `order_cubit.dart`
  - `customer_cubit.dart`

### 2. Classes

#### Screen Classes
- **Format**: `{FeatureName}Screen` (PascalCase)
- **Ví dụ**:
  - `CreateOrderScreen`
  - `CustomerScreen`
  - `ProductDetailScreen`

#### State Classes
- **Format**: `_{FeatureName}ScreenState` (private với underscore prefix)
- **Ví dụ**:
  - `_CreateOrderScreenState`
  - `_CustomerScreenState`

#### Component Classes
- **Format**: `_{ComponentName}` (private với underscore prefix)
- **Ví dụ**:
  - `_CustomerListItem`
  - `_PaymentSection`
  - `_ProductSearchBar`

#### Cubit Classes
- **Format**: `{FeatureName}Cubit` (PascalCase)
- **Ví dụ**:
  - `OrderCubit`
  - `CustomerCubit`

#### State Classes (BLoC)
- **Format**: `{FeatureName}State` (PascalCase)
- **Ví dụ**:
  - `OrderState`
  - `CustomerState`

### 3. Routes

#### Route Names
- **Format**: `static String keyName = '/{route-name}'` (kebab-case với leading slash)
- **Ví dụ**:
  ```dart
  static String keyName = '/create-order';
  static String keyName = '/customer';
  static String keyName = '/product-detail';
  ```

### 4. Variables & Methods

#### Variables
- **Format**: `camelCase`
- **Ví dụ**:
  - `selectedCustomer`
  - `isLoading`
  - `_searchController` (private với underscore)

#### Methods
- **Format**: `camelCase`
- **Ví dụ**:
  - `_loadInitialData()` (private)
  - `_onSearchChanged()` (private)
  - `onCustomerSelected()` (public)

## Template: Tạo Màn Hình Mới

### Bước 1: Tạo Cấu Trúc Thư Mục

```bash
# Tạo thư mục feature
mkdir -p lib/views/{feature_name}

# Tạo thư mục components nếu cần
mkdir -p lib/views/{feature_name}/components
```

### Bước 2: Tạo Screen File

**File**: `lib/views/{feature_name}/{feature_name}_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

// Import components nếu dùng part directive
part 'components/{component_name}.dart';

class {FeatureName}Screen extends StatefulWidget {
  const {FeatureName}Screen({super.key});
  
  static String keyName = '/{route-name}';

  @override
  State<{FeatureName}Screen> createState() => _{FeatureName}ScreenState();
}

class _{FeatureName}ScreenState extends State<{FeatureName}Screen> {
  // Dependencies
  final {FeatureName}Cubit _{featureName}Cubit = di<{FeatureName}Cubit>();
  final {FeatureName}Repository _{featureName}Repository = di<{FeatureName}Repository>();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    // Dispose controllers, cancel subscriptions, etc.
    super.dispose();
  }

  void _loadInitialData() {
    // Load initial data
    _{featureName}Cubit.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget.lightAppBar(
        context,
        label: 'Screen Title',
        actions: [
          // Action buttons
        ],
      ),
      backgroundColor: AppColors.white,
      body: BlocBuilder<{FeatureName}Cubit, {FeatureName}State>(
        bloc: _{featureName}Cubit,
        builder: (context, state) {
          if (state is Loading{FeatureName}State) {
            return _buildLoadingState();
          }
          
          if (state is Loaded{FeatureName}State) {
            return _buildContent(state);
          }
          
          if (state is Failed{FeatureName}State) {
            return _buildErrorState(state);
          }
          
          return _buildInitialState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(Loaded{FeatureName}State state) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // Content widgets
      ],
    );
  }

  Widget _buildErrorState(Failed{FeatureName}State state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.errorMessage,
            style: AppStyles.text.medium(fSize: 14.sp),
          ),
          SizedBox(height: 16.h),
          CustomButton(
            label: 'Thử lại',
            onPressed: _loadInitialData,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return SizedBox.shrink();
  }
}
```

### Bước 3: Tạo Cubit (nếu cần)

**File**: `lib/bloc/{feature_name}/{feature_name}_cubit.dart`

```dart
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/{feature_name}_middleware.dart';
import 'package:zili_coffee/data/repositories/{feature_name}_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import '{feature_name}_state.dart';

class {FeatureName}Cubit extends BaseCubit<{FeatureName}State> {
  {FeatureName}Cubit() : super({FeatureName}Initial());
  
  final {FeatureName}Repository _{featureName}Repository = di<{FeatureName}Repository>();
  final {FeatureName}Middleware _{featureName}Middleware = di<{FeatureName}Middleware>();

  Future<void> loadData() async {
    emit(Loading{FeatureName}State());
    
    final result = await _{featureName}Middleware.getData();
    
    if (result is ResponseSuccessState) {
      _{featureName}Repository.data.sink.add(result.responseData);
      emit(Loaded{FeatureName}State());
    } else if (result is ResponseFailedState) {
      emit(Failed{FeatureName}State(error: result.errorMessage));
    }
  }
}
```

### Bước 4: Tạo State (nếu cần)

**File**: `lib/bloc/{feature_name}/{feature_name}_state.dart`

```dart
part of '{feature_name}_cubit.dart';

abstract class {FeatureName}State extends Equatable {
  const {FeatureName}State();

  @override
  List<Object?> get props => [];
}

class {FeatureName}Initial extends {FeatureName}State {}

class Loading{FeatureName}State extends {FeatureName}State {}

class Loaded{FeatureName}State extends {FeatureName}State {}

class Failed{FeatureName}State extends {FeatureName}State {
  final String errorMessage;
  
  const Failed{FeatureName}State({required this.errorMessage});
  
  @override
  List<Object?> get props => [errorMessage];
}
```

### Bước 5: Tạo Component (nếu cần)

**File**: `lib/views/{feature_name}/components/{component_name}.dart`

```dart
part of '../{feature_name}_screen.dart';

class _{ComponentName} extends StatelessWidget {
  final {DataType} data;
  final VoidCallback? onTap;
  
  const _{ComponentName}({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Component content
          ],
        ),
      ),
    );
  }
}
```

### Bước 6: Đăng Ký Route

**File**: `lib/app/app_wireframe.dart`

```dart
static final Map<String, WidgetBuilder> routes = {
  // ... existing routes
  {FeatureName}Screen.keyName: (_) => const {FeatureName}Screen(),
};
```

### Bước 7: Đăng Ký Dependency (nếu cần)

**File**: `lib/di/dependency_injection.dart`

```dart
// Register Cubit
_getIt.registerLazySingleton<{FeatureName}Cubit>(
  () => {FeatureName}Cubit(),
);

// Register Repository
_getIt.registerLazySingleton<{FeatureName}Repository>(
  () => {FeatureName}Repository(),
);

// Register Middleware
_getIt.registerLazySingleton<{FeatureName}Middleware>(
  () => {FeatureName}Middleware(),
);
```

## Best Practices

### 1. State Management

#### Sử dụng BLoC/Cubit
- **Cubit**: Cho state management đơn giản
- **BLoC**: Cho state management phức tạp với events
- **Pattern**: Screen → Cubit → Middleware → API

#### State Naming
- `{FeatureName}Initial`: State ban đầu
- `Loading{FeatureName}State`: Đang loading
- `Loaded{FeatureName}State`: Load thành công
- `Failed{FeatureName}State`: Load thất bại
- `{Action}{FeatureName}State`: State cho action cụ thể

#### BlocBuilder vs BlocListener
- **BlocBuilder**: Rebuild UI khi state thay đổi
- **BlocListener**: Thực hiện side effects (navigate, show dialog, etc.)

```dart
// BlocBuilder cho UI updates
BlocBuilder<OrderCubit, OrderState>(
  bloc: _orderCubit,
  builder: (context, state) {
    // Build UI based on state
  },
)

// BlocListener cho side effects
BlocListener<OrderCubit, OrderState>(
  bloc: _orderCubit,
  listener: (context, state) {
    if (state is LoadedOrderState) {
      Navigator.pushNamed(context, OrderDetailScreen.keyName);
    }
  },
  child: // UI widget
)
```

### 2. Component Organization

#### Part Directive
- Sử dụng `part` directive để chia nhỏ file lớn
- Components trong cùng screen có thể dùng `part`

```dart
// Main screen file
part 'components/customer_section.dart';
part 'components/products_section.dart';

class CreateOrderScreen extends StatefulWidget {
  // ...
}
```

#### Separate Component Files
- Components dùng chung nhiều screen → đặt trong `lib/utils/widgets/`
- Components chỉ dùng trong 1 screen → đặt trong `components/` folder

### 3. Dependency Injection

#### Pattern
```dart
// Khai báo dependencies ở đầu class
final OrderCubit _orderCubit = di<OrderCubit>();
final OrderRepository _orderRepository = di<OrderRepository>();

// Sử dụng trong methods
void _loadData() {
  _orderCubit.loadData();
}
```

#### Lazy Initialization
- Sử dụng `di<>()` để get dependencies
- Không cần khởi tạo thủ công

### 4. Error Handling

#### Error States
```dart
if (state is FailedOrderState) {
  return _buildErrorState(state.errorMessage);
}
```

#### Error Messages
- Hiển thị error message rõ ràng
- Có retry button nếu cần
- Log errors để debug

### 5. Loading States

#### Initial Load
- Show full screen loading (shimmer/skeleton)
- State: `Loading{FeatureName}State`

#### Search/Filter Load
- Show inline loading indicator
- State: `Loading{FeatureName}State(event: "search")`

#### Load More
- Show loading indicator ở cuối list
- State: `Loading{FeatureName}State(event: "loadMore")`

### 6. Empty States

#### No Data
```dart
Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox, size: 64.sp, color: AppColors.grey84),
        SizedBox(height: 16.h),
        Text(
          'Chưa có dữ liệu',
          style: AppStyles.text.medium(fSize: 16.sp),
        ),
      ],
    ),
  );
}
```

### 7. Navigation

#### Named Routes
```dart
// Navigate to screen
Navigator.pushNamed(
  context,
  CustomerDetailScreen.keyName,
  arguments: customer, // Pass data
);

// Navigate back with result
Navigator.pop(context, result);
```

#### Route Arguments
```dart
// In destination screen
final customer = ModalRoute.of(context)!.settings.arguments as Customer;
```

### 8. Responsive Design

#### ScreenUtil
```dart
// Use .w, .h, .sp for responsive sizing
Container(
  width: 100.w,
  height: 50.h,
  child: Text(
    'Text',
    style: AppStyles.text.medium(fSize: 14.sp),
  ),
)
```

### 9. Code Organization

#### Import Order
1. Flutter packages
2. Third-party packages
3. Project packages (res, utils, data, bloc, views)
4. Relative imports (components)

```dart
// 1. Flutter
import 'package:flutter/material.dart';

// 2. Third-party
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Project
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

// 4. Relative
import 'components/customer_section.dart';
```

#### Method Organization
1. Lifecycle methods (`initState`, `dispose`)
2. Public methods
3. Private methods (prefix `_`)
4. Build methods (`build`, `_buildContent`, etc.)

### 10. Documentation

#### Screen Documentation
- Thêm comment mô tả chức năng screen
- Document các state và interactions
- Document navigation flow

#### Component Documentation
- Mô tả props và usage
- Document callbacks

## Checklist: Tạo Màn Hình Mới

### Setup
- [ ] Tạo cấu trúc thư mục
- [ ] Tạo screen file với template
- [ ] Tạo Cubit (nếu cần)
- [ ] Tạo State (nếu cần)
- [ ] Đăng ký route trong `app_wireframe.dart`
- [ ] Đăng ký dependencies trong `dependency_injection.dart`

### Implementation
- [ ] Implement UI layout
- [ ] Implement state management
- [ ] Implement API integration
- [ ] Implement error handling
- [ ] Implement loading states
- [ ] Implement empty states
- [ ] Implement navigation

### Components
- [ ] Tạo components nếu cần
- [ ] Extract reusable widgets
- [ ] Organize components trong `components/` folder

### Testing
- [ ] Test initial load
- [ ] Test error states
- [ ] Test empty states
- [ ] Test navigation
- [ ] Test user interactions

### Documentation
- [ ] Thêm comments cho complex logic
- [ ] Update Memory Bank nếu cần
- [ ] Tạo UI/UX docs nếu cần (như `customer/docs.md`)

## Ví Dụ Thực Tế

### Ví dụ: CustomerScreen

Xem file `lib/views/customer/docs.md` để tham khảo đặc tả UI/UX chi tiết.

### Ví dụ: CreateOrderScreen

Xem file `lib/views/order/create_order/create_order_screen.dart` để tham khảo implementation thực tế.

## Tài Liệu Liên Quan

- [Architecture Documentation](../01-architecture.md)
- [Development Process](../03-development-process.md)
- [API Integration Workflow](./api-integration-workflow.md)
- [Middleware Guide](./middleware-guide.md)

