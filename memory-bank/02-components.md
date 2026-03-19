# Components Documentation

## Key Components

### Data Layer Components

#### Middlewares (`lib/data/middlewares/`)
- **BaseMiddleware**: Base class for all middlewares with common Dio instances
  - Provides: `dio`, `authDio`, `coreDio` instances
  - Handles: Cancel tokens, error handling
- **OrderMiddleware**: Handles order-related API calls
  - `getProductsForOrder()`: Filter products for order creation
    - Uses `coreDio` for Core Service API
    - Returns `ResponseState` with `{count, products}`
  - `getProductVariantsFilter()`: Filter product variants
  - `getWarehouses()`: Get warehouse list
  - `createOrder()`, `updateOrder()`, `getAllOrders()`: Order CRUD
  - `getOrderBase({required String code})`: Get base order information
    - API: `GET /company/order-app/:code/base` (Core Service)
    - Returns `ResponseSuccessState<Order>` (supports both Order và Quotation)
  - `getOrderShipment({required String code})`: Get order shipment information
    - API: `GET /company/order-app/:code/shipment` (Core Service)
    - Returns `ResponseSuccessState<OrderDelivery>`
  - `getOrderCustomer({required String code})`: Get order customer information
    - API: `GET /company/order-app/:code/customer` (Core Service)
    - Returns `ResponseSuccessState<Customer>`
  - `getOrderAdditional({required String code})`: Get additional order information
    - API: `GET /company/order-app/:code/additional` (Core Service)
    - Returns `ResponseSuccessState<Map<String, dynamic>>` với orderInfo, warehouse, staff, company
- **ProductMiddleware**: Handles product-related API calls
  - `getProductsByCompany({int limit = 20, int offset = 0})`: Get company products list với pagination (Core Service)
    - Uses `coreDio` for Core Service API
    - Endpoint: `/product/get-by-company`
    - Query params: `limit`, `offset`
    - Response format: `{products: List, count: int, totalProducts: int}`
    - Returns `ResponseSuccessState<CompanyProductsResult>`
  - `getCompanyProductDetail({required String productId})`: Get company product detail by ID (Core Service)
    - Uses `coreDio` for Core Service API
    - Endpoint: `/company/product/detail/{productId}`
    - Response format: `{status: 1, data: {...}}` hoặc direct product object
    - Returns `ResponseSuccessState<CompanyProduct>`
  - `getProductCartByID()`, `getDetailProduct()`, `getProducts()`, `filterProducts()`: Existing product methods
- **AuthMiddleware**: Handles authentication API calls
- **CustomerMiddleware**: Handles customer/profile API calls
  - `filterCustomers()`: Filter customers by keyword (User Service)
  - `getDefaultCustomerAddress()`: Get default address for customer (User Service)
  - `filterCustomerAddresses()`: Filter customer addresses by customer ID (User Service)
  - `updateCustomerAddress()`: Update customer address by ID (User Service)
  - `getCustomerTransactions({required String customerId, int limit = 20, int offset = 0})`: Get customer order transactions
    - API: `GET /enterprise/order/{customerId}/filter` (Core Service)
    - Uses `coreDio` for Core Service API
    - Returns `ResponseSuccessListState<List<Order>>` với pagination
  - `getCustomerDebts({required String customerId, int limit = 20, int offset = 0})`: Get customer debt logs
    - API: `GET /company/debt-log/filter` (Auth Service)
    - Uses `authDio` for Auth Service API
    - Query params: `userId` (customerId), `limit`, `offset`
    - Returns `ResponseSuccessListState<List<Debt>>` với pagination
  - Uses `userDio` for User Service APIs, `coreDio` for Core Service APIs, `authDio` for Auth Service APIs
- **AddressMiddleware**: Handles address management API calls
  - `filterDistrictsByType()`: Filter districts by type (PRE_MERGER/POST_MERGER)
  - `getWardsByType()`: Get wards by district code and type
  - `getProvincesByType()`: Get provinces by type (POST_MERGER only)
  - Uses `systemDio` for System Service APIs
- **PaymentMiddleware**: Handles payment processing
  - `getPaymentMethods()`: Get payment methods from System Service
    - Uses `systemDio` for System Service API
    - Endpoint: `/system/api/v1/seller/payment-method/synthetic/active`
    - Parameters: `isActive` (bool, optional, deprecated), `notMethods` (List<String>, optional)
    - Returns `ResponseState` with `List<SellerPaymentMethod>`
    - Handles response format: `{listData: List, total: int}`
    - Parses `BankInfo` from response if available
- **ReviewMiddleware**: Handles product reviews
- **BlogMiddleware**: Handles blog/content API calls
- **CategoryMiddleware**: Handles category API calls
- **FlashSaleMiddleware**: Handles flash sale API calls
- **UploadMiddleware**: Handles file uploads

#### Repositories (`lib/data/repositories/`)
- Abstract data access layer
- Implement repository pattern
- Bridge between use cases and middlewares
- Use BehaviorSubject (rxdart) for reactive data streams
- **ProductRepository**: Manages product-related data streams
  - `productsByCompanySubject`: `BehaviorSubject<List<CompanyProduct>>` - Company products list
  - `companyProductDetailStreamData`: `BehaviorSubject<CompanyProduct?>` - Company product detail
  - `setProductsByCompany(List<CompanyProduct> data, int total)`: Set new products list
  - `appendProductsByCompany(List<CompanyProduct> data, int total)`: Append products for pagination
  - `totalProducts`: int - Total products count for pagination

**OrderRepository** (`lib/data/repositories/order_repository.dart`):
- Manages warehouses with BehaviorSubject
- Auto-selects default warehouse
- Provides streams for reactive updates
- Manages seller orders with pagination support
- `orderDetailData`: `BehaviorSubject<OrderDetailData?>` - Complete order detail data structure
  - Stores `OrderDetailData<T extends Order>` với order, orderDelivery, customer, orderInvoice, orderInfo, warehouse, staff, company
  - Supports both `Order` và `Quotation` types via generic

**PaymentRepository** (`lib/data/repositories/payment_repository.dart`):
- Manages payment methods with `BehaviorSubject<List<SellerPaymentMethod>>`
- Provides `paymentMethodsStream` for reactive updates
- Method `setPaymentMethods()` to update data
- Method `paymentMethods` getter to access current value

**CustomerRepository** (`lib/data/repositories/customer_repository.dart`):
- `customerTransactions`: `BehaviorSubject<List<Order>>` - Customer order transactions
- `customerDebts`: `BehaviorSubject<List<Debt>>` - Customer debt logs
- `totalCustomerTransactions`: int - Total transactions count for pagination
- `totalCustomerDebts`: int - Total debts count for pagination

#### Business Services (`lib/services/`) - **NEW**
- Business logic layer giữa Cubit và Repository
- Trách nhiệm:
  - Xử lý business logic
  - Validate dữ liệu trước khi lưu
  - Phối hợp giữa các repositories
  - Transform data nếu cần
- **BaseService**: Base class cho tất cả business services
- **OrderService**: Service cho Order (đang được implement)
- **CategoryService**: Service cho Category (đang được implement)
- **Pattern**: Cubit → Service → Repository → Middleware
- **Lưu ý**: Services KHÔNG được gọi trực tiếp từ UI, chỉ từ Cubit

#### Use Cases
- **Không sử dụng Use Cases nữa**: Gọi Middleware trực tiếp từ Repository
- Middleware trả về Model trực tiếp, không cần layer UseCase

### Domain Entities (`lib/data/entity/`)

#### Product Entities
- **ProductEntity**: Main product entity with all fields from TypeORM
  - Enums: `ProductStatus`, `ProductType`, `WalletCaseBackWallet`
  - Methods: `fromMap`, `fromJson`, `toMap`, `toJson`, `copyWith`
  
- **ProductVariantEntity**: Product variant entity
  - Enums: `ProductVariantStatus`, `CalculateByUnit`
  - Methods: `fromMap`, `fromJson`, `toMap`, `toJson`, `copyWith`

### Presentation Layer Components

#### BLoC/Cubit (`lib/bloc/`)
- **AppCubit**: Global app state
- **AuthCubit**: Authentication state
- **OrderCubit**: Order management state
  - `fetchOrderBaseByCode({required String code})`: Fetch base order information
    - API: `GET /company/order-app/:code/base` (Core Service)
    - Stores result in `OrderRepository.orderDetailData`
    - Handles both `Order` và `Quotation` types
  - `fetchOrderShipmentByCode({required String code})`: Fetch order shipment information
    - API: `GET /company/order-app/:code/shipment` (Core Service)
    - Updates `OrderDetailData.orderDelivery`
  - `fetchOrderCustomerByCode({required String code})`: Fetch order customer information
    - API: `GET /company/order-app/:code/customer` (Core Service)
    - Updates `OrderDetailData.customer`
  - `fetchOrderAdditionalByCode({required String code})`: Fetch additional order information
    - API: `GET /company/order-app/:code/additional` (Core Service)
    - Updates `OrderDetailData.orderInfo`, `warehouse`, `staff`, `company`
- **ProductCubit**: Product browsing state
  - `getProducts({int limit = 20, int offset = 0})`: Get company products list
    - Calls `ProductMiddleware.getProductsByCompany()`
    - Updates `ProductRepository.productsByCompanySubject`
    - States: `ProductInitial` → `GotProductsState`
  - `loadMoreProducts({int limit = 20, int offset = 0})`: Load more company products (pagination)
    - Calculates offset từ current items length
    - Calls `ProductMiddleware.getProductsByCompany()` với calculated offset
    - Updates `ProductRepository.productsByCompanySubject` với append
    - States: `ProductInitial` → `GotProductsState`
  - `fetchCompanyProductDetail({required String productId})`: Fetch company product detail by ID
    - Calls `ProductMiddleware.getCompanyProductDetail()`
    - Updates `ProductRepository.companyProductDetailStreamData`
    - Sets `null` vào stream khi có lỗi
    - States: `ProductInitial` → `GotProductsState`
  - `getDetailProduct()`, `getFeaturedProduct()`, `filterPurchaseOrderProducts()`: Existing product methods
- **CartCubit**: Shopping cart state
- **CustomerCubit**: Customer profile state
  - `filterCustomers()`: Filter customers with pagination
  - `loadMoreCustomers()`: Load more customers
  - `getDefaultCustomerAddress()`: Get default address
  - `getCustomerAddresses()`: Get all addresses for customer
  - `updateCustomerAddress()`: Update customer address
    - States: `WaitingCustomerState` → `MessageCustomerState` (success) / `FailedCustomerState` (error)
  - `getCustomerTransactions(String customerId, {int limit = 20, int offset = 0})`: Get customer order transactions
    - API: `GET /enterprise/order/{customerId}/filter` (Core Service)
    - Updates `CustomerRepository.customerTransactions` stream
    - States: `LoadingCustomerState` → `LoadedCustomerState` / `FailedCustomerState`
  - `loadMoreCustomerTransactions(String customerId, {int limit = 20, int offset = 0})`: Load more transactions
    - Appends new transactions to existing list
  - `getCustomerDebts(String customerId, {int limit = 20, int offset = 0})`: Get customer debt logs
    - API: `GET /company/debt-log/filter` (Auth Service)
    - Updates `CustomerRepository.customerDebts` stream
    - States: `LoadingCustomerState` → `LoadedCustomerState` / `FailedCustomerState`
  - `loadMoreCustomerDebts(String customerId, {int limit = 20, int offset = 0})`: Load more debts
    - Appends new debts to existing list
- **AddressCubit**: Address management state
- **PaymentCubit**: Payment methods state management
  - `getPaymentMethods()`: Fetch payment methods from API
    - Parameters: `isActive` (bool, optional), `notMethods` (List<String>, optional)
    - States: `PaymentLoadingState` → `PaymentLoadedState` / `PaymentErrorState`
    - Updates `PaymentRepository` với data từ API
- **ReviewCubit**: Review management state
- **BlogCubit**: Blog content state
- **CategoryCubit**: Category browsing state
- **FlashSaleCubit**: Flash sale state
- **NotificationCubit**: Notification state

#### Views (`lib/views/`)
- **Order Module**: Order creation, tracking, management
  - `OrderDetailScreen`: Comprehensive order detail screen (`lib/views/order/details/order_detail_screen.dart`)
    - Features:
      - Order information section: Status, code, timeline, costs, products, payment history
      - Current shipment section: Shipment details, delivery information
      - Customer information section: Expandable customer info với debt và spending
      - Additional information section: Staff, warehouse, company, sale channel
    - Data Management:
      - Uses `OrderRepository.orderDetailData` BehaviorSubject stream
      - Loads data on-demand: Base first, then shipment/customer/additional
      - Supports both `Order` và `Quotation` types via generic `OrderDetailData<T>`
    - API Integration:
      - `GET /company/order-app/:code/base` - Base order information
      - `GET /company/order-app/:code/shipment` - Current shipment
      - `GET /company/order-app/:code/customer` - Customer information
      - `GET /company/order-app/:code/additional` - Additional info
    - Components:
      - `SectionCard`: Reusable section card widget
      - `TimelineList`: Order timeline display
      - `PriceSummary`: Price summary component
      - `ProductList`: Product list component
      - `PaymentList`: Payment history list
      - `ShipmentSection`: Shipment information section
      - `AdditionalSection`: Additional info section
      - `ErrorBanner`: Error display banner
  - `SelectProductsScreen`: Product selection for order creation
    - Features: Search, pagination, variant selection, barcode scan
    - State management: Local state with OrderMiddleware
    - Output: List<Map<String, dynamic>> with selected products
  - `CreateOrderScreen`: Order creation form
    - Features:
      - Branch selection
      - Product selection (via SelectProductsScreen)
      - Customer selection
      - Payment section với discount, shipping fee, payment method
      - Order-level discount (khác với product-level discount)
      - Additional info: staff, sale channel, delivery date, note
    - State management: Local state với callbacks
    - Key methods:
      - `_createOrder(BuildContext context)`: Main method để tạo order
        - Validation: Kiểm tra products và customer
        - Generate order body: Gọi `_generateOrderBody()`
        - Show loading và success dialog
      - `_generateOrderBody()`: Collect và format data thành body structure
        - Collect từ: products, customer, discount, shipping fee, payment details, additional info
        - Return: `CreateOrderInput` model (type-safe)
        - Logic:
          - Order status: 'PROCESSING' nếu có payment, null nếu không
          - Discount: Tính từ order-level discount (percentage hoặc absolute)
          - Payment details: Filter và format thành `PaymentInput` objects
          - Products: Map variants thành `OrderProductInput` objects với discount per unit
          - Delivery date: Combine với current time, format ISO 8601
          - Invoice: Lấy từ billingAddress (ưu tiên) hoặc purchaseAddress
        - Convert to Map: Sử dụng `orderInput.toMap()` để convert sang Map khi gọi API
  - `PaymentScreen`: Payment details screen (trong `payment_section.dart`)
    - Features:
      - Load payment methods từ API qua `PaymentCubit.getPaymentMethods()`
      - Select payment method từ danh sách (bottom sheet)
      - Input amount paid by customer với validation
      - Calculate remaining amount (totalAmount - customerPaid)
      - Returns payment details: `paymentMethodName`, `paymentMethodId`, `paymentMethodEnum`, `paymentMethod`, `customerPaid`, `remainingAmount`
    - **Architecture**: Clean Architecture pattern
      - UI → PaymentCubit → PaymentRepository → PaymentMiddleware → API
      - Uses `StreamBuilder` với `paymentMethodsStream` từ repository
      - No direct middleware calls from UI
    - State management: 
      - Uses `PaymentCubit` for business logic
      - Uses `PaymentRepository` for data storage (BehaviorSubject)
      - Local state cho form validation và selected payment method
    - Uses `SellerPaymentMethod` model với `BankInfo` support
    - Payment name rendering: Sử dụng `displayPaymentName` extension
      - Logic: `nameVi` (fallback `nameEn`) + `bankCode` + `accountOwner` nếu có bankInfo
    - Payment method comparison: Sử dụng `compareWith()` method (bao gồm cả bankInfo)
  - `AddShippingFeeScreen`: Shipping fee configuration screen (trong `payment_section.dart`)
    - Features:
      - Radio buttons: "Phí cấu hình" vs "Phí khác"
      - Input field (hiển thị khi chọn "Phí khác")
      - "Gợi ý phí giao hàng" với options: "Giao hàng sau", "Nhận tại cửa hàng"
      - "Hủy áp dụng" và "Lưu" buttons
  - `AddDiscountFeeScreen`: Order discount configuration screen (trong `payment_section.dart`)
    - Features:
      - Input discount value
      - Select discount unit (% or đ)
      - Display initial discount values nếu đã config trước đó
      - "Hủy áp dụng" button để reset discount về 0
      - "Xác nhận" button để save
  - `EntryOrderScreen`: Order entry point
- **Product Module**: Product browsing, detail, search
- **Cart Module**: Shopping cart management
- **Auth Module**: Login, registration, password recovery
- **Address Module**: Address management
  - `AddressItem` (`lib/views/customer/details/components/address_item.dart`): Address display widget
    - Features:
      - Displays address information với proper formatting
      - Shows address components: specific address, ward, district, province
      - Uses `renderEnterpriseAddress()` function for formatting
  - `EditCustomerAddressScreen`: Edit customer purchase/billing address
    - Features: 
      - Form validation với dynamic height adjustment
      - Address selection (PRE_MERGER/POST_MERGER)
      - Province/District/Ward selection với search
      - API integration để update address
    - State management: 
      - Validation state variables (`_isNameFieldValid`, `_isPhoneFieldValid`, `_isEmailFieldValid`)
      - `_validateAllFields()`: Validate all fields và update UI
      - `_validateFieldOnChange()`: Real-time validation sau lần validate đầu tiên
    - API integration:
      - Calls `CustomerCubit.updateCustomerAddress()` nếu có `initialAddress.id`
      - Uses BlocListener để handle success/error states
      - Auto-pop với updated Address khi thành công
- **Payment Module**: Payment processing
- **Review Module**: Product reviews and ratings
- **Blog Module**: Blog content browsing
- **Setting Module**: App settings and profile

### Network Components (`lib/data/network/`)

#### NetworkUrl
- Centralized API endpoint definitions
- Organized by feature/service
- Supports multiple base URLs (auth, core, user)

#### Network Response Handling
- **NWResponse**: Generic API response wrapper
- **ResponseState**: State management for API responses
  - `ResponseSuccessState`: Success responses
  - `ResponseFailedState`: Error responses

### Dependency Injection (`lib/di/`)
- **GetIt**: Service locator for dependency injection
- Centralized registration of all dependencies
- Easy to mock for testing

## Component Relationships

### Middleware → UseCase → BLoC Flow
```
Middleware (API call)
  ↓ returns Entity
UseCase (business logic, map Entity → Output)
  ↓ returns Output
BLoC/Cubit (state management)
  ↓ emits State
UI (displays data)
```

### Example: Product Variant Filter
1. **OrderMiddleware.getProductVariantsFilter()**: Calls API, parse response → `List<ProductVariant>` Model
2. **BLoC/Cubit**: Receives Models trực tiếp từ Middleware, updates state
3. **UI**: Displays Models

**Note**: Gọi Middleware trực tiếp từ UI/BLoC, không cần UseCase layer

### Example: SelectProductsScreen
1. **SelectProductsScreen**: Calls `OrderMiddleware.getProductsForOrder()` directly (no UseCase)
2. **OrderMiddleware.getProductsForOrder()**: Calls API, returns `List<OrderProduct>`
3. **SelectProductsScreen**: Displays products, handles selection
4. **User selects**: Formats selected products as `Map<String, dynamic>`
5. **Returns**: List of selected products to `CreateOrderScreen`

### Data Models

#### SellerPaymentMethod (`lib/data/models/order/payment_detail/seller_payment_method.dart`)
- **Model mới** cho API `/system/api/v1/seller/payment-method/synthetic/active` (System Service)
- **Khác với PaymentMethod cũ** để tránh breaking changes với các module khác
- Fields:
  - `id`: String (UUID)
  - `nameVi`: String (Vietnamese name)
  - `nameEn`: String (English name)
  - `method`: String (Payment method enum, e.g., "CASH", "BANKING")
  - `icon`: String? (Icon URL)
  - `position`: int
  - `isActive`: bool
  - `createdAt`: DateTime?
  - `updatedAt`: DateTime?
  - `minimumOrder`: double
  - `bankCode`: String? (Optional, for BANKING method)
  - `bankInfo`: BankInfo? (Optional, for BANKING method với bank account details)
- Methods:
  - `fromMap()`: Parse từ API response (bao gồm BankInfo nếu có)
  - `toMap()`: Convert sang Map
  - `displayName`: Getter trả về `nameVi` (fallback `nameEn`) - **Deprecated, dùng `displayPaymentName` extension**
  - `compareWith()`: So sánh payment methods (bao gồm cả bankInfo.id) - **Quan trọng cho BANKING method có nhiều accounts**
  - `copyWith()`: Tạo bản sao với thay đổi
- Extension: `PaymentMethodNameExtension.displayPaymentName`
  - Render payment name theo logic JavaScript
  - Logic: `nameVi` (fallback `nameEn`) + `bankCode` + `accountOwner` nếu có bankInfo
  - Nếu có `bankInfo.methodName`: return `methodName`
  - Chỉ sử dụng case "vi" (Vietnamese)
- Usage: Dùng trong `PaymentScreen` để hiển thị danh sách phương thức thanh toán

#### BankInfo (`lib/data/models/order/payment_detail/bank_info.dart`)
- Model cho thông tin ngân hàng trong payment method (BANKING method)
- Fields:
  - `id`: String
  - `titleEn`, `titleVi`: String? (Bank title)
  - `code`: String (Bank code)
  - `accountOwner`: String? (Account owner name)
  - `bankName`: String? (Bank name)
  - `bankNumber`: String? (Account number)
  - `bankCode`: String? (Bank code)
  - `bankBin`: String? (Bank BIN)
  - `methodName`: String? (Optional, custom method name)
  - `isDefault`: bool
  - `createdAt`, `updatedAt`: DateTime?
- Usage: Nested trong `SellerPaymentMethod.bankInfo` cho BANKING payment methods

#### OrderProduct (`lib/data/models/product/order_product.dart`)
- Fields: `id`, `avatar`, `titleVi`, `titleEn`, `shortName`, `barcode`, `sku`, `measureUnit`, `price`, `costPrice`, `originalPrice`, `wholesalePrice`, `slotBuy`, `productVariants`, `availableQuantity`
- Helper methods: `displayName`, `displayUnit`, `hasVariants` (length > 1), `firstVariant`
- Parsing: `fromMap()`, `toMap()`, `toJson()`

#### ProductVariant (`lib/data/models/product/product_variant.dart`)
- **Model** match với API response structure
- Fields: `id`, `productId` (optional), `options` (List<ProductVariantOption>), `imageVariant`, `price`, `originalPrice`, `costPrice`, `wholesalePrice`, `promotion`, `inventory`, `sku`, `barcode`, `availableQuantity` (String), `status`, `slotBuy` (String), `transactionCount` (String), etc.
- ProductVariantOption: `name`, `value`
- Note: Một số fields là String (slotBuy, transactionCount, availableQuantity) để match với API response
- Parse từ API: `ProductVariant.fromMap()` factory method

#### CompanyProduct (`lib/data/models/product/company_product.dart`)
- **Model cho company products** từ API `/product/get-by-company` và `/company/product/detail/{productId}`
- **Created based on actual API response** sau khi test API để đảm bảo 100% match
- **Main Model**: `CompanyProduct` với 40+ fields:
  - Basic info: `id`, `titleVi`, `titleEn`, `shortName`, `status`, `price` (num), `costPrice` (num), `wholesalePrice` (num)
  - Images: `imageDetail` (List<String>), `avatar`, `imageProduct`, `imageDescriptionVi` (List<String>), `imageDescriptionEn` (List<String>)
  - Descriptions: `descriptionVi`, `descriptionEn`
  - Inventory: `availableQuantity`, `slotBuy`, `isInventoryManaged`, `isSaleAllowed`
  - Nested objects: `seller` (CompanyProductSeller?), `categoryInternal` (CompanyProductCategory?), `category` (CompanyProductCategory?), `brand` (CompanyProductBrand?), `productVariants` (List<CompanyProductVariant>)
  - Metadata: `createdAt` (DateTime, converted từ server timezone), `updatedAt` (DateTime, converted từ server timezone), `createById`, `companyId`
  - Settings: `deliverySettings` (List<dynamic>), `productOptions` (List<dynamic>), `isOnWebsite`, `isCanPacking`
  - Commission: `commission` (num), `calculateByUnit`, `commissionWeight`
- **Nested Models**:
  - `CompanyProductSeller`: Seller info (id, fullName, username, phone, avatar)
  - `CompanyProductCategory`: Category info (id, nameVi, nameEn, imageUrl, status, code, etc.)
  - `CompanyProductVariant`: Variant info (id, price, costPrice, inventory, availableQuantity, etc.)
  - `CompanyProductBrand`: Brand info (id, name)
- **Result Model**: `CompanyProductsResult` với `items` (List<CompanyProduct>) và `total` (int)
- **Timezone Handling**: 
  - `createdAt` và `updatedAt` sử dụng `parseFromServerTimezone()` extension để convert từ server timezone sang client timezone
  - Fallback to `DateTime.now()` nếu parse failed
- **Type Safety**: 
  - `imageDescriptionVi` và `imageDescriptionEn` được convert từ `List<dynamic>` sang `List<String>` bằng explicit mapping
  - Fallback to `<String>[]` nếu không phải List
- **Helper Methods**:
  - `displayName`: Getter trả về `titleVi ?? titleEn ?? shortName ?? 'Sản phẩm'`
  - `primaryImage`: Getter trả về `avatar ?? imageDetail.first ?? imageProduct`
- **Usage**: 
  - List API: `ProductCubit.getProducts()`, `ProductCubit.loadMoreProducts()`
  - Detail API: `ProductCubit.fetchCompanyProductDetail()`
  - Repository: `ProductRepository.productsByCompanySubject`, `ProductRepository.companyProductDetailStreamData`

#### CreateOrderInput (`lib/data/models/order/create_order_input.dart`)
- **Model cho input khi tạo order mới**
- **Purpose**: Type-safe model thay vì sử dụng `Map<String, dynamic>` trực tiếp
- **Main Model**: `CreateOrderInput`
  - Fields: `order` (OrderInput), `customerId`, `collaboratorId`, `addressCustomerId`, `paid` (List<PaymentInput>), `delivery`, `infoAdditional` (InfoAdditionalInput), `invoice` (InvoiceInput)
  - Methods: `toMap()`, `toJson()`, `toString()`
- **Nested Models**:
  - `OrderInput`: Order object với status, deliveryFee (String), discount (String), discountPercent, products, note, tags
  - `OrderProductInput`: Product trong order với productId, productVariantId, quantity, discount, price, note
  - `PaymentInput`: Payment details với method và amount
  - `InfoAdditionalInput`: Additional info với salesType, branchId, soldById, saleChannel, scheduledDeliveryAt, etc.
  - `InvoiceInput`: Invoice data với type, taxCode, email, addressId, name
- **Usage**: 
  - `_generateOrderBody()` return `CreateOrderInput` thay vì `Map<String, dynamic>`
  - Convert sang Map: `orderInput.toMap()` khi gọi API
  - Benefits: Type safety, IDE autocomplete, easier testing, better maintainability

#### Order Models (`lib/data/models/order/`)
- **Order** (`order.dart`): Main order model với 2 factory methods
  - `Order.fromMap()`: Parse old API response format
  - `Order.fromMapNew()`: Parse new API response format `{"status":1,"data":{...}}`
  - New fields: `orderItems`, `orderInfo`, `orderDelivery`, `delivery`, `totalAmount`, `totalPaid`, `deliveryFee`, `deliveryCode`, `warehouseId`, etc.
- **OrderDetailData** (`order_detail_data.dart`): Complete order detail data structure
  - Generic type: `OrderDetailData<T extends Order>` supports both `Order` và `Quotation`
  - Fields: `order` (T), `orderDelivery` (OrderDelivery?), `customer` (Customer?), `orderInvoice` (OrderInvoice?), `orderInfo` (OrderInfo?), `warehouse` (Warehouse?), `staff` (Staff?), `company` (Company?)
  - Methods: `copyWith()`, `isQuotation` getter
  - Implements `QuotationData` mixin
- **OrderItem** (`order_item.dart`): Model cho orderItems trong response
  - Fields: `id`, `quantity`, `amount`, `sku`, `price`, `originalPrice`, `discount`, `discountPercent`, `productId`, `variantId`, `note`, `type`, etc.
- **OrderInfo** (`order_info.dart`): Model cho orderInfo với nested OrderInfoAdditional
  - Fields: `id`, `userId`, `fullName`, `email`, `phoneNumber`, `nickname`, `infoAdditional`
  - `OrderInfoAdditional`: `salesType`, `branchId`, `soldById`, `saleChannel`
- **OrderDelivery** (`order_delivery.dart`): Model cho orderDelivery information
  - Fields: `address`, `province`, `district`, `ward`, `deliveryCode`, `deliveryFee`, `cod`, `note`, `totalPrice`, etc.
- **Debt** (`lib/data/models/user/debt.dart`): Model cho customer debt logs
  - Fields: `id`, `userId`, `amount`, `type`, `note`, `createdAt`, etc.

#### ProductVariant (`lib/data/models/product/product_variant.dart`)
- **Updated**: Added `note` field (String?) to store variant-specific notes
- **Usage**: Notes are saved when configuring variant in `ConfigProductVariantScreen`
- **Mapping**: Notes are included in `OrderProductInput` when creating order

### Extensions (`lib/utils/extension/`)

#### PaymentMethodNameExtension (`lib/utils/extension/payment_method_extension.dart`)
- Extension cho `SellerPaymentMethod` để render payment name
- Method: `displayPaymentName` (String getter)
- **Logic** (theo JavaScript `renderPaymentMethodName`):
  1. Lấy title từ `nameVi` (fallback `nameEn`) - chỉ dùng case "vi"
  2. Nếu có `bankInfo`:
     - Nếu có `bankInfo.methodName`: return `methodName`
     - Nếu không: return `[title, bankCode, accountOwner].filter(Boolean).join(" ")`
  3. Nếu không có `bankInfo`: return `title`
- **Usage**: 
  - Thay thế `displayName` getter (deprecated)
  - Sử dụng trong UI: `method.displayPaymentName`
- **Example**:
  - CASH method: "Tiền Mặt"
  - BANKING với bankInfo: "Chuyển khoản ngân hàng DEFAULT CONG TY TNHH ZILI"
  - BANKING với methodName: "Custom Bank Name"

### Utility Functions (`lib/utils/functions/`)

#### Base Functions (`base_functions.dart`)

**`formatCurrency(double amount)`**:
- Format số tiền thành chuỗi với dấu chấm phân cách hàng nghìn
- Ví dụ: `1000000` → `"1.000.000"`
- Returns: `String`

**`TimeRange` Class**:
- Class đại diện cho khoảng thời gian
- Fields:
  - `start`: `DateTime` - Thời điểm bắt đầu
  - `end`: `DateTime` - Thời điểm kết thúc
- Constructor: `TimeRange({required DateTime start, required DateTime end})`

**`getRangeOfTimeOption(TimeOption timeOption)`**:
- Tính toán `TimeRange` dựa trên `TimeOption` enum
- Returns: `TimeRange` object
- **Supported Options**:
  - `TimeOption.today`: Hôm nay (00:00:00 - 23:59:59)
  - `TimeOption.yesterday`: Hôm qua (00:00:00 - 23:59:59)
  - `TimeOption.thisWeek`: Tuần này (Thứ 2 - Chủ nhật)
  - `TimeOption.lastWeek`: Tuần trước (Thứ 2 - Chủ nhật tuần trước)
  - `TimeOption.thisMonth`: Tháng này (Ngày 1 - Cuối tháng)
  - `TimeOption.lastMonth`: Tháng trước (Xử lý edge case: tháng 1 → tháng 12 năm trước)
  - `TimeOption.thisYear`: Năm này (1/1 - 31/12)
  - `TimeOption.lastYear`: Năm trước (1/1 - 31/12 năm trước)
- **Technical Notes**:
  - Sử dụng `DateTime.startOfDate()` và `DateTime.endOfDate()` extensions để normalize times
  - Week calculation: Dựa trên `DateTime.weekday` (1 = Monday, 7 = Sunday)
  - Month calculation: Sử dụng `DateTime(year, month + 1, 0)` để lấy ngày cuối tháng
  - Year calculation: `DateTime(year, 1, 1)` đến `DateTime(year, 12, 31, 23, 59, 59)`
- **Usage Example**:
  ```dart
  final range = getRangeOfTimeOption(TimeOption.thisWeek);
  print('Start: ${range.start}'); // Thứ 2 00:00:00
  print('End: ${range.end}');     // Chủ nhật 23:59:59
  ```
- **Integration**: Được sử dụng trong filter components (ví dụ: `bottom_sheet_filter.dart`) để tự động set date range khi user chọn quick time option

**`renderEnterpriseAddress(CustomerAddress? address)`**:
- Format customer address thành string với proper Vietnamese address format
- Parameters: `address` (CustomerAddress?)
- Returns: `String` - Formatted address string
- **Logic**:
  - Combines: `specificAddress`, `ward?.name`, `district?.name`, `province?.name`
  - Uses proper separators (commas, spaces)
  - Returns empty string nếu address is null
- **Usage**: Display customer addresses trong UI components (AddressItem, etc.)
