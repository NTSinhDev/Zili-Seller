# Service Layer Refactor

## Tổng quan

Dự án đang được refactor để tuân theo pattern trong `STATE_MANAGEMENT_FLOW.md`:
- **Pattern mới**: UI → BLoC/Cubit → **Service** → Repository → Middleware → API
- **Pattern cũ**: UI → BLoC/Cubit → Middleware/Repository → API

## Cấu trúc

### Business Services (`lib/services/`)
- `base_service.dart` - Base class cho tất cả services
- `order_service.dart` - Service cho Order (template)
- `category_service.dart` - Service cho Category (template)
- `README.md` - Documentation

### Trách nhiệm của Service
1. **Business Logic**: Xử lý logic nghiệp vụ
2. **Validation**: Validate dữ liệu trước khi lưu
3. **Coordination**: Phối hợp giữa các repositories
4. **Transformation**: Transform data nếu cần

## Quy tắc

1. **Service KHÔNG được gọi từ UI**
   - Chỉ được gọi từ Cubit
   
2. **Service KHÔNG gọi Middleware trực tiếp**
   - Service chỉ gọi Repository
   - Repository gọi Middleware (nếu cần)

3. **Cubit giữ nguyên API**
   - Không thay đổi public methods
   - Không thay đổi State classes
   - UI không cần thay đổi

## Kế hoạch Refactor

Xem chi tiết trong `documents/REFACTOR_PLAN.md`

### Thứ tự ưu tiên:
1. Order Module (phức tạp nhất)
2. Category Module
3. Product Module
4. Cart Module
5. Các module khác

## Template

### Service Template
```dart
import 'package:zili_coffee/data/repositories/{module}_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/services/base_service.dart';

class {Module}Service extends BaseService {
  final {Module}Repository _repository = di<{Module}Repository>();

  {Module}Service();

  // Implement methods với business logic
}
```

### Cubit Template (sau refactor)
```dart
class {Module}Cubit extends BaseCubit<{Module}State> {
  final {Module}Service _service = di<{Module}Service>();

  Future<void> someMethod() async {
    final result = await _service.someMethod();
    // Handle result và emit state
  }
}
```

## Status

- ✅ Phase 1: Setup Infrastructure (Completed)
- ⏳ Phase 2: Refactor từng module (In Progress)

