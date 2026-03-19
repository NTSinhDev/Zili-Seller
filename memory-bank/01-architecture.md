# Architecture Documentation

## System Architecture
The application follows **Clean Architecture** principles with three main layers:

### 1. Presentation Layer (`lib/views/`, `lib/bloc/`)
- **Responsibility**: UI components and state management
- **Components**: 
  - Screens (`views/`)
  - BLoC/Cubit for state management (`bloc/`)
  - Widgets and UI components

### 2. Domain Layer (`lib/bloc/`, `lib/services/`, `lib/data/repositories/`)
- **Responsibility**: Business logic and state management
- **Components**:
  - BLoC/Cubit: State management (`bloc/`)
  - **Business Services**: Business logic layer (`services/`) - **NEW**
  - Repositories: Data abstraction với reactive streams (`repositories/`)
  - **Note**: Pattern mới: Cubit → Service → Repository → Middleware

### 3. Data Layer (`lib/data/middlewares/`, `lib/data/repositories/`, `lib/data/models/`)
- **Responsibility**: Data access and API integration
- **Components**:
  - Middlewares: API calls (`middlewares/`)
  - Repositories: Data abstraction (`repositories/`)
  - Models: Data transfer objects (`models/`)

## Design Patterns

### Clean Architecture Pattern
- **Separation of Concerns**: Each layer has distinct responsibilities
- **Dependency Rule**: Inner layers don't depend on outer layers
- **Data Flow**: Presentation → Domain → Data

### Repository Pattern
- Repositories abstract data sources với reactive streams (BehaviorSubject)
- Middlewares handle API communication
- **Business Services**: Business logic layer giữa Cubit và Repository
- Repositories lưu trữ data và cung cấp streams cho UI

### Service Pattern (NEW)
- Business Services (`lib/services/`) chứa business logic
- Services được gọi từ Cubit, không từ UI
- Services gọi Repositories, không gọi Middleware trực tiếp
- Trách nhiệm: Validation, tính toán, phối hợp repositories, transform data

### BLoC Pattern
- State management using flutter_bloc
- Cubit for simpler state management
- Clear separation between UI and business logic
- **Reactive Data**: Repositories sử dụng BehaviorSubject (rxdart) để cung cấp streams
- **UI Layer Rule**: UI không được gọi trực tiếp Middleware/Service, chỉ qua Cubit
- **Service Layer Rule**: Cubit gọi Service, Service gọi Repository, Repository gọi Middleware

## Data Flow Examples

### General Flow (Target Pattern - Đang refactor)
```
UI Screen
  ↓ (user action)
BLoC/Cubit
  ↓ (call service)
Business Service (business logic, validation)
  ↓ (call repository)
Repository
  ↓ (call middleware if needed)
Middleware
  ↓ (HTTP request)
API
  ↓ (response)
Middleware (parse to Model)
  ↓ (return ResponseState)
Repository (update BehaviorSubject)
  ↓ (return data)
Service (transform/validate data)
  ↓ (return result)
BLoC/Cubit (emit state)
  ↓ (UI listens to state)
UI (rebuild via BlocBuilder/BlocConsumer)
```

### General Flow (Current Pattern - Đang được refactor)
```
UI Screen
  ↓ (user action)
BLoC/Cubit
  ↓ (call middleware/repository directly)
Middleware/Repository
  ↓ (HTTP request)
API
  ↓ (response)
Middleware (parse to Model)
  ↓ (return ResponseState)
BLoC/Cubit (update Repository)
  ↓ (Repository updates BehaviorSubject)
Repository (sink data to stream)
  ↓ (emit state)
BLoC/Cubit (emit state)
  ↓ (UI listens to stream/state)
UI (rebuild via StreamBuilder/BlocBuilder)
```

### Payment Module Flow (Example)
```
PaymentScreen (UI)
  ↓ (initState)
PaymentCubit.getPaymentMethods()
  ↓
PaymentMiddleware.getPaymentMethods()
  ↓
API: GET /system/api/v1/seller/payment-method/synthetic/active
  ↓ (response)
PaymentMiddleware (parse to List<SellerPaymentMethod>)
  ↓
PaymentCubit (update PaymentRepository)
  ↓
PaymentRepository.setPaymentMethods() (sink to BehaviorSubject)
  ↓
PaymentScreen (StreamBuilder listens to paymentMethodsStream)
  ↓
UI rebuilds with payment methods
```

### Order Module Flow
```
EntryOrderScreen
  ↓ (tap "Tạo đơn hàng")
LoadingScreen (load warehouses)
  ↓ (success)
CreateOrderScreen
  ↓ (tap Products Section)
SelectProductsScreen
  ↓ (load products via OrderMiddleware.getProductsForOrder())
API: GET /company/product/order/filter
  ↓ (response: List<OrderProduct>)
SelectProductsScreen (display products)
  ↓ (user selects products)
SelectProductsScreen (format selected products)
  ↓ (Navigator.pop with result)
CreateOrderScreen (update selectedProducts)
```

### SelectProductsScreen Data Flow
```
SelectProductsScreen (init)
  ↓
_loadProducts() → OrderMiddleware.getProductsForOrder()
  ↓
API Response → Parse to List<OrderProduct>
  ↓
Display in UI (_ProductListItem)
  ↓
User selects product → _addProduct() or _showVariantSelector()
  ↓
Format selected product → Map<String, dynamic>
  ↓
Return to CreateOrderScreen via Navigator.pop()
```

## Technical Decisions

### Why Clean Architecture?
- Maintainability: Clear separation makes code easier to maintain
- Testability: Each layer can be tested independently
- Scalability: Easy to add new features without affecting existing code
- Team Collaboration: Different developers can work on different layers

### Why BLoC Pattern?
- Predictable state management
- Easy to test business logic
- Good separation of concerns
- Works well with Clean Architecture

### Entity vs Model vs Output
- **Entity**: Domain objects, pure business logic (`lib/data/entity/`)
- **Model**: Data transfer objects for API (`lib/data/models/`)
- **Output**: DTOs for presentation layer (`lib/data/use_cases/*/output/`)
- **Note**: Không sử dụng Use Cases và Output models nữa, Middleware trả về Model trực tiếp

## App Initialization Pattern

### Initialization Flow
App initialization được tối ưu để giảm thời gian khởi động:

1. **Synchronous Setup** (`initConfigSync()`):
   - Setup Dependency Injection
   - Initialize Flutter binding
   - Configure SystemChrome (orientation, UI overlay)
   - Load environment variables và SharedPreferences (chạy song song)

2. **Background Firebase** (`initFirebaseAsync()`):
   - Firebase initialization chạy sau khi app đã render
   - Device token được lấy và cập nhật vào AppCubit khi có
   - Không block main thread, app vẫn hoạt động nếu Firebase fail

### Performance Optimization
- **Parallel I/O**: `_tryLoadEnv()` và `LocalStoreService().config()` chạy song song
- **Lazy Firebase**: Firebase init không block app startup
- **Non-blocking**: App render ngay sau `initConfigSync()`, Firebase chạy background

### Main Entry Point
```dart
Future<void> main() async {
  await AppConfig.initConfigSync();  // Tác vụ bắt buộc
  runApp(const MyApp());              // App render ngay
  AppConfig.initFirebaseAsync();      // Firebase background
}
```

## Security Considerations
- API authentication via Bearer tokens
- Secure storage for sensitive data
- Input validation at multiple layers
- Network security through HTTPS

