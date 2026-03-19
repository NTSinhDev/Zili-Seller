# Development Process

## Workflow

### Feature Development Flow (Target Pattern)
1. **Planning**: Define feature requirements and architecture
2. **Entity Creation**: Create domain entities if needed
3. **API Integration**: Add middleware methods for API calls
4. **Repository**: Create/update repository for data access
5. **Business Service**: Create service with business logic and validation
6. **BLoC/Cubit**: Implement state management (calls Service, not Repository/Middleware)
7. **UI Implementation**: Create screens and widgets
8. **Testing**: Test API integration and UI
9. **Documentation**: Update Memory Bank and code comments

### Feature Development Flow (Current Pattern - Đang được refactor)
1. **Planning**: Define feature requirements and architecture
2. **Entity Creation**: Create domain entities if needed
3. **API Integration**: Add middleware methods for API calls
4. **Repository**: Create/update repository for data access
5. **BLoC/Cubit**: Implement state management (calls Middleware/Repository directly)
6. **UI Implementation**: Create screens and widgets
7. **Testing**: Test API integration and UI
8. **Documentation**: Update Memory Bank and code comments

### Code Organization
- Follow Clean Architecture layers strictly
- Keep entities pure (no dependencies on outer layers)
- **Business Services** orchestrate business logic (NEW)
- Middlewares handle only API communication
- Repositories abstract data sources
- **Data Flow**: UI → Cubit → Service → Repository → Middleware → API

### UI/UX Pattern Standards
- **List Screen Pattern**: Tuân theo pattern chung cho màn hình list với tabs, filter và search
- **Reference**: Xem `documents/list-screen-ui-pattern.md` để tham khảo pattern UI/UX chung
- **Pattern bao gồm**: AppBar với filter button, Search bar, Filter tabs, List content với refresh/load more, Loading/Empty states, Filter bottom sheet
- **Mục đích**: Đảm bảo consistency trong app cho tất cả các màn hình list tương tự

### State Management Flow (ENFORCED – highest priority)
- UI chỉ gọi **một method** của Cubit/BLoC kèm input đã gom; không gọi middleware/service trực tiếp trong UI.
- Cubit chịu trách nhiệm toàn bộ: emit state (idle/loading/success/failure), gọi Middleware/Service, kiểm tra response, xử lý/transform data nếu cần, ghi vào Repository nếu cần lưu, rồi emit success/failure.
- Failure: chỉ emit state failure kèm thông tin lỗi; không xử lý UI lỗi bên trong Cubit.
- UI lắng nghe state và đổi UI tương ứng: show loading khi state loading, render kết quả khi success, hiển thị dialog/toast lỗi khi failure, điều hướng/popup sau success nếu cần.
- Nếu user yêu cầu flow khác (bỏ Cubit, gọi API trực tiếp ở UI, bỏ confirm/validate, v.v.), **luôn hỏi lại để xác nhận**; chỉ đổi flow khi user chấp thuận, nếu không vẫn áp dụng pattern này.
- Tham chiếu mẫu: `lib/views/auth/authentication/login/login_screen.dart` (`_handleLogin` chỉ gọi `authCubit.login`, UI lắng nghe state của Cubit).

### Cubit Conventions (ENFORCED – module-level, not per-action)
- Cubit quản lý logic nghiệp vụ và trạng thái cho **một module/đối tượng rõ ràng** (ví dụ: `RoastingSlip`), không tạo Cubit riêng cho một hành động lẻ (tránh kiểu `RoastingSlipCreateCubit`).
- Với một đối tượng/module, dùng **một Cubit** (folder riêng chứa cubit + state) và bổ sung method cho các use case (create/update/fetch/filter…) thay vì tạo Cubit rời.
- Mỗi Cubit phải nằm trong folder riêng dưới `lib/bloc/{module}/` kèm file `*_cubit.dart` và `*_state.dart` của chính module đó; không đặt chung vào folder module khác.
- Mỗi Cubit gắn với Repository tương ứng để lưu và chia sẻ dữ liệu module cho các màn hình khác; Cubit gọi Service/Middleware qua Repository/Service (tùy kiến trúc hiện tại).
- Cubit/state phải được khai báo vào `lib/di/dependency_injection.dart`.
- Đặt tên theo đối tượng (ví dụ `RoastingSlipCubit` + `RoastingSlipState`), không theo hành động.
- Nếu có yêu cầu tạo Cubit theo hành động, **luôn hỏi lại để xác nhận**; mặc định vẫn hợp nhất vào Cubit module.

### Shared Components UX Consistency (ENFORCED)
- Các component dùng chung (ví dụ `InputFormField`) phải giữ UX/validation/màu sắc/hành vi thống nhất với các màn đã dùng; không tự ý thay đổi khiến trải nghiệm khác biệt giữa các màn.
- Khi cần tùy biến, ưu tiên thêm tùy chọn cấu hình (params) nhưng giữ mặc định giống hành vi hiện tại.

## Branching Strategy
- Main branch: Production-ready code
- Feature branches: `feature/feature-name`
- Bug fixes: `fix/bug-description`

## Testing Strategy

### API Testing
- Use `.http` files in `test/api/` for REST Client testing
- Organize by service: `test/api/core/`, `test/api/auth/`, etc.
- Use `variables.http` for shared variables (domain, token, etc.)

### Unit Testing
- Test use cases independently
- Mock middlewares and repositories
- Test business logic thoroughly
- Test validation logic và data transformation

### Integration Testing
- Test full flow from UI to API
- Test error handling and edge cases

### Widget Testing
- Test UI components với `flutter_test`
- Mock dependencies với `mockito`
- Test validation flows và user interactions
- Test error states và edge cases

### Test Plan Structure
- **Test Plan Document**: Document test cases trong `.md` file
  - Mô tả rõ ràng input và expected output
  - Phân loại test cases: Validation, Success Flow, Edge Cases, Data Format
- **Test File**: Implement test cases trong `.dart` file
  - Setup mocks và test data
  - Group tests theo functionality
  - Use descriptive test names (TC-001, TC-002, etc.)
- **Error List**: Document các lỗi phát hiện trong quá trình test
  - Phân loại theo mức độ: Critical, Logic, Validation, Performance, Error Handling, Testing
  - Mô tả impact và giải pháp cho mỗi lỗi

## Widget Extraction Process

Khi cần tạo widget mới từ code base để tái sử dụng, follow quy trình 4 bước:

### Step 1: Phân tích code và xác định params
- Check tất cả biến được sử dụng trong code
- Xác định các dependencies (imports, functions, models)
- List ra các params cần thiết cho widget:
  - Required params: các biến bắt buộc
  - Optional params: các biến có thể null hoặc có default value
  - Callbacks: các function callbacks (onTap, onChanged, etc.)
- Xác định các functions/helpers cần import trong widget mới

### Step 2: Tạo file widget mới
- Tạo file trong `lib/utils/widgets/` với tên mô tả rõ ràng (snake_case)
- Đặt tên class theo PascalCase, có prefix `_` nếu là private widget
- Copy code từ code base và refactor thành widget:
  - Chuyển các biến thành params của widget
  - Import các dependencies cần thiết
  - Thêm documentation cho widget (mô tả features, params)
  - Đảm bảo widget là StatelessWidget hoặc StatefulWidget phù hợp

### Step 3: Export trong widgets.dart
- Thêm export statement vào `lib/utils/widgets/widgets.dart`
- Format: `export 'widget_file_name.dart';`
- Đặt theo thứ tự alphabet hoặc nhóm theo chức năng

### Step 4: Replace code cũ bằng widget mới
- Tìm và replace code cũ trong file gốc
- Import widget từ `widgets.dart` (nếu chưa có)
- Đảm bảo truyền đúng params:
  - Required params: bắt buộc truyền
  - Optional params: chỉ truyền nếu cần
  - Callbacks: truyền function từ parent
- Test để đảm bảo functionality không thay đổi
- Check linter errors và fix nếu có

### Example: AddressListItem Widget
```dart
// Step 1: Phân tích
// - address: Address (required)
// - isSelected: bool (required) 
// - onTap: Function(Address) (required)
// - renderCustomerAddress: function từ address_functions.dart

// Step 2: Tạo file lib/utils/widgets/address_list_item.dart
class AddressListItem extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final Function(Address) onTap;
  // ...
}

// Step 3: Export trong widgets.dart
export 'address_list_item.dart';

// Step 4: Replace code cũ
// Từ: 50+ dòng code ListTile phức tạp
// Thành: AddressListItem(address: address, isSelected: isSelected, onTap: onTap)
```

### Best Practices
- Widget nên là reusable và không phụ thuộc vào context cụ thể
- Đặt tên widget rõ ràng, mô tả đúng chức năng
- Thêm documentation cho widget và params
- Giữ widget đơn giản, dễ hiểu
- Test widget ở nhiều context khác nhau nếu có thể

## Code Standards

### Naming Conventions
- **Files**: snake_case (e.g., `order_middleware.dart`)
- **Classes**: PascalCase (e.g., `OrderMiddleware`)
- **Variables/Methods**: camelCase (e.g., `getProductVariantsFilter`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `BASE_URL`)

### File Structure
- One class per file
- Group related files in directories
- Use clear, descriptive names

### Documentation
- Document all public APIs
- Add comments for complex logic
- Update Memory Bank after major changes
- Keep README files updated

## Refactoring Process

### Refactoring to Service Layer Pattern
Khi refactor module để tuân theo `STATE_MANAGEMENT_FLOW.md`:

1. **Phân tích Cubit hiện tại**
   - Xác định methods đang gọi Middleware/Repository trực tiếp
   - Xác định business logic cần di chuyển sang Service

2. **Implement Service**
   - Tạo service trong `lib/services/{module}_service.dart`
   - Di chuyển business logic từ Cubit sang Service
   - Service gọi Repository (không gọi Middleware trực tiếp)
   - Thêm validation nếu cần

3. **Refactor Cubit**
   - Thay thế: Middleware/Repository → Service
   - Giữ nguyên state management
   - Giữ nguyên error handling
   - Giữ nguyên public API (không phá vỡ UI)

4. **Test**
   - Test các chức năng cơ bản
   - Test error cases
   - Test UI vẫn hoạt động đúng

5. **Cập nhật DI**
   - Đăng ký service trong `dependency_injection.dart` nếu chưa có

### Refactor Plan
Xem chi tiết trong `documents/REFACTOR_PLAN.md`

## Memory Bank Maintenance

### When to Update Memory Bank
- After implementing major features
- After architectural changes
- After adding new patterns or conventions
- After fixing critical bugs
- When learning new project-specific information
- **After setting up new infrastructure** (e.g., Service layer)

### How to Update
1. Update relevant core files (`00-05-*.md`)
2. Add feature-specific notes in `notes/` directory
3. Update progress log with chronological changes
4. Keep files concise and focused

## Deployment Process
- Build for target platform
- Run tests before deployment
- Update version in `pubspec.yaml`
- Tag release in version control
- Deploy to app stores (if applicable)

