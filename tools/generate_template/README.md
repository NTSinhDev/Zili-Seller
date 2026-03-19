# Code Generation Templates

Hệ thống generate code tự động từ templates để tăng tốc độ phát triển và đảm bảo consistency.

## 📁 Cấu trúc

```
tools/generate_template/
├── README.md (file này)
├── templates/
│   ├── model_template.txt
│   ├── dto_template.txt
│   ├── middleware_template.txt
│   ├── cubit_template.txt
│   ├── cubit_state_template.txt
│   ├── repository_template.txt
│   ├── service_template.txt
│   ├── screen_template.txt
│   ├── list_screen_template.txt (NEW)
│   └── widget_template.txt
```

## 🚀 Cách sử dụng

### Sử dụng với Cursor AI

Gõ các shortcuts trong chat với Cursor AI:

#### 1. Generate Model
```
#generate-model Product
#generate-model Customer user
```

#### 2. Generate Middleware
```
#generate-middleware Customer
#generate-middleware Order order
```

#### 3. Generate Repository
```
#generate-repository Customer
#generate-repository Order order
```

#### 4. Generate Service
```
#generate-service Order
#generate-service Payment payment
```

#### 5. Generate Cubit
```
#generate-cubit Customer
#generate-cubit Order order
```
→ Tự động tạo cả Cubit và State files

#### 6. Generate Screen
```
#generate-screen ProductList
#generate-screen CustomerCreate
```

#### 6.1. Generate List Screen (NEW)
```
#generate-list-screen Product
#generate-list-screen Customer user
gen list-screen Product
gen list-screen Customer user
```
→ Tạo screen sử dụng `ListScreenTemplate` pattern với search, refresh, load more
→ File: `lib/views/{domain}/{name}_list_screen.dart`
→ Pattern reference: `documents/list_screen/list-screen-ui-pattern.md`

#### 7. Generate Widget
```
#generate-widget ProductCard
#generate-widget CustomButton
```

#### 8. Generate Full Feature
```
#generate-feature Order
#generate-feature Customer user
```
→ Tạo toàn bộ feature: Model, Middleware, Repository, Service, Cubit, State

#### 9. Generate from cURL (NEW)
```
#generate-from-curl "curl -X POST https://api.example.com/customers -H 'Content-Type: application/json' -d '{\"name\":\"John\"}'"
```
Hoặc paste curl trực tiếp:
```
curl -X GET https://api.example.com/products?limit=10
```
→ Tự động generate: DTO, Model, Middleware method, Cubit method, Repository stream

## 📝 Template Variables

Các templates sử dụng các biến sau để thay thế:

- `{{ClassName}}` - Tên class (PascalCase), ví dụ: `Product`, `Customer`
- `{{class_name}}` - Tên file (snake_case), ví dụ: `product`, `customer`
- `{{className}}` - Tên biến (camelCase), ví dụ: `product`, `customer`
- `{{domain}}` - Domain/feature name, ví dụ: `product`, `user`, `order`
- `{{DisplayName}}` - Display name cho UI, ví dụ: `Product List`

## 🗂️ Đường dẫn files

### Model
- **Path**: `lib/data/models/{domain}/{name}.dart`
- **Ví dụ**: `lib/data/models/product/product.dart`

### Middleware
- **Path**: `lib/data/middlewares/{name}_middleware.dart`
- **Ví dụ**: `lib/data/middlewares/customer_middleware.dart`

### Repository
- **Path**: `lib/data/repositories/{name}_repository.dart`
- **Ví dụ**: `lib/data/repositories/customer_repository.dart`

### Service
- **Path**: `lib/services/{name}_service.dart`
- **Ví dụ**: `lib/services/order_service.dart`

### DTO
- **Path**: `lib/data/dto/{domain}/{action}_{name}_input.dart` hoặc `lib/data/models/{domain}/{action}_{name}_input.dart`
- **Ví dụ**: `lib/data/dto/customer/create_customer_input.dart`

### Cubit
- **Path**: `lib/bloc/{name}/{name}_cubit.dart`
- **Ví dụ**: `lib/bloc/customer/customer_cubit.dart`

### State
- **Path**: `lib/bloc/{name}/{name}_state.dart`
- **Ví dụ**: `lib/bloc/customer/customer_state.dart`

### Screen
- **Path**: `lib/views/{name}/{name}_screen.dart`
- **Ví dụ**: `lib/views/product_list/product_list_screen.dart`

### List Screen
- **Path**: `lib/views/{domain}/{name}_list_screen.dart`
- **Ví dụ**: `lib/views/product/product_list_screen.dart`
- **Template**: Sử dụng `ListScreenTemplate` pattern
- **Features**: Search, Refresh, Load More, Tabs (optional), Filter (optional)

### Widget
- **Path**: `lib/utils/widgets/{name}_widget.dart` hoặc `lib/views/{domain}/components/{name}_widget.dart`
- **Ví dụ**: `lib/utils/widgets/product_card_widget.dart`

## 🔧 Dependency Injection

Khi generate các components sau, hệ thống sẽ tự động register vào DI:

### Middleware
```dart
..registerFactory<{ClassName}Middleware>({ClassName}Middleware.new)
```

### Repository
```dart
..registerLazySingleton<{ClassName}Repository>({ClassName}Repository.new)
```

### Service
```dart
..registerLazySingleton<{ClassName}Service>({ClassName}Service.new)
```

### Cubit
```dart
..registerFactory<{ClassName}Cubit>({ClassName}Cubit.new)
```

File DI: `lib/di/dependency_injection.dart`

## 📋 Ví dụ đầy đủ

### Generate Feature "Order"

```
#generate-feature Order order
```

**Kết quả:**

1. **Model**: `lib/data/models/order/order.dart`
2. **Middleware**: `lib/data/middlewares/order_middleware.dart`
   - ✅ Đã register vào DI
3. **Repository**: `lib/data/repositories/order_repository.dart`
   - ✅ Đã register vào DI
4. **Service**: `lib/services/order_service.dart`
   - ✅ Đã register vào DI
5. **Cubit**: `lib/bloc/order/order_cubit.dart`
   - ✅ Đã register vào DI
6. **State**: `lib/bloc/order/order_state.dart`

## 🚀 Generate từ cURL Request (NEW)

Tính năng mới: Tự động generate code từ cURL request!

### Cách sử dụng:

**Format 1: Với shortcut**
```
#generate-from-curl "curl -X POST https://api.example.com/customers -H 'Content-Type: application/json' -d '{\"name\":\"John\"}'"
```

**Format 2: Paste curl trực tiếp**
```
curl -X GET https://api.example.com/products?limit=10&offset=0
```

### Agent sẽ tự động:

1. **Parse cURL**:
   - Extract method (GET, POST, PUT, DELETE)
   - Extract endpoint path
   - Extract request body (nếu có)
   - Extract query parameters

2. **Generate DTO** (nếu có request body):
   - Tạo Input DTO từ JSON body
   - Ví dụ: POST `/customers` với body `{"name":"John"}` → `CreateCustomerInput`

3. **Generate Model** (nếu có response structure):
   - Tạo Model từ response JSON
   - Hoặc infer từ endpoint pattern

4. **Generate Middleware Method**:
   - Tạo method trong middleware
   - Map endpoint vào NetworkUrl structure
   - Handle request/response

5. **Generate Cubit Method**:
   - Tạo method trong cubit
   - Handle states (Loading, Loaded, Failed)
   - Call middleware và update repository

6. **Generate Repository Stream** (nếu GET request):
   - Tạo BehaviorSubject stream để lưu data
   - Ví dụ: `final BehaviorSubject<List<Customer>> customers = BehaviorSubject();`

7. **Update NetworkUrl** (nếu cần):
   - Thêm endpoint vào NetworkUrl class
   - Tạo method trong class tương ứng

### Ví dụ:

**Input:**
```bash
curl -X POST https://api.example.com/company/customer \
  -H 'Content-Type: application/json' \
  -d '{"name":"John","email":"john@example.com","phone":"0123456789"}'
```

**Output tự động:**
- ✅ `CreateCustomerInput` DTO với fields: `name`, `email`, `phone`
- ✅ `createCustomer` method trong `CustomerMiddleware`
- ✅ `createCustomer` method trong `CustomerCubit`
- ✅ Update `NetworkUrl.customer.create()` nếu chưa có
- ✅ Register vào DI nếu cần

## 📝 Lưu ý về Template Files

- Template files sử dụng extension `.txt` thay vì `.dart` để:
  - Tránh lỗi linter (không cần ignore comments)
  - Rõ ràng đây là template, không phải code thực sự
  - Dễ maintain và đọc hơn
- Agent sẽ đọc file `.txt`, replace placeholders, và tạo file `.dart` mới

## ⚙️ Customization

Sau khi generate, bạn cần:

1. **Model**: Thêm/sửa fields để match với API response
2. **Middleware**: Cập nhật NetworkUrl và API endpoints
3. **Repository**: Thêm BehaviorSubject streams nếu cần
4. **Service**: Thêm business logic và validation
5. **Cubit**: Thêm methods và state management logic
6. **Screen**: Customize UI và thêm BlocConsumer logic
7. **Widget**: Customize widget UI

## 🔍 Kiểm tra sau khi generate

- [ ] Files đã được tạo đúng vị trí
- [ ] DI đã được register (nếu cần)
- [ ] Imports đã đúng
- [ ] Template variables đã được replace đúng
- [ ] Code compile không có lỗi

## 📚 Tham khảo

- Architecture: `memory-bank/01-architecture.md`
- Development Process: `memory-bank/03-development-process.md`
- Middleware Guide: `memory-bank/docs/middleware-guide.md`

