## Warehouse module – green beans & roasting slips (2025-12-19)

### Scope
- Hợp nhất các tính năng “green bean”/“roasting slip” vào module `warehouse`.
- Thay thế việc dùng `ProductVariant` cho roasting slip bằng model riêng.
- Bổ sung UI cho danh sách hạt xanh & phiếu rang, màn chi tiết phiếu rang, và màn tạo phiếu rang (mock data).

### API endpoints
- Filter green bean variants: `GET /core/api/v1/coffee-variant/green-bean/filter?limit=&offset=`
- Filter roasting slips: `GET /core/api/v1/coffee-variant/roasting-slip/filter?limit=&offset=`
- Roasting slip detail: `GET /core/api/v1/coffee-variant/roasting-slip/{code}`

### Models
- `RoastingSlip`: id, code, status, weight, creator, createdAt; có `statusEnum` getter cho render trạng thái.
- `RoastingSlipDetail`: thông tin chung + nested `ProductVariant` cho green/roasted beans, warehouse info, notes/dates; parse đúng theo response detail API.
- Green bean list vẫn dùng `ProductVariant` hiện hữu.

### Data layer
- Middleware: `warehouse_middleware.dart` thêm `filterWarehouseVariants`, `filterRoastingSlips`, `getRoastingSlipDetail`.
- Repository: `warehouse_repository.dart` quản lý BehaviorSubject cho greenBeans, roastingSlips và total; phương thức set/append cho pagination.
- DI: đăng ký `WarehouseMiddleware`, `WarehouseRepository`, `WarehouseCubit` trong `dependency_injection.dart`.

### Cubit
- `WarehouseCubit`: methods `filterGreenBeans`, `filterRoastingSlips`, `getRoastingSlipDetail`; state `WarehouseLoaded` có field `type` để phân biệt luồng green beans vs roasting slips.

### UI
- `green_beans_screen.dart`: Tabs cho hạt xanh / phiếu rang; search, refresh, load-more indicator; hiển thị tổng số item; card list cho hạt xanh (ProductVariant) và phiếu rang (RoastingSlip); render theo `_tabIndex`.
- `roasting_slip_detail_screen.dart`: Hiển thị detail từ `WarehouseCubit.getRoastingSlipDetail` + `RoastingSlipDetail`; các section thông tin chung, hạt xanh, hạt rang, ghi chú, ngày giờ.
- `roasting_slip_create_screen.dart`: Màn tạo phiếu rang (mock data), AppBar style theo yêu cầu; có branch dropdown, search product input, empty state sản phẩm, action buttons; có thể gắn `WarehouseCubit` sau.

### Permissions
- Phân quyền màn hình đã áp dụng: abilities/sellerPermissions lưu trong auth; helper `PermissionHelper` với constants `AbilityAction/AbilitySubject`; home tabs filter bằng permission (warehouse liên quan `warehouses/warehouse_management`).

### Misc
- `SelectorFormField` đã bổ sung comment note chuẩn hóa cách dùng (renderValue phải gọi onTap, hỗ trợ options tĩnh/stream, placeholder null item). 

