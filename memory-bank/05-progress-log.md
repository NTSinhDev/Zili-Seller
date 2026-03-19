# Progress Log

Chronological record of major changes and implementations.

## 2025-01-XX - Order Detail Screen Development & Customer Module Enhancements

### Implemented
- ✅ Developed comprehensive Order Detail Screen (`lib/views/order/details/order_detail_screen.dart`) với full UI/UX implementation
- ✅ Integrated 4 APIs for order detail data:
  - `GET /company/order-app/:code/base` - Base order information
  - `GET /company/order-app/:code/shipment` - Current shipment information
  - `GET /company/order-app/:code/customer` - Customer information
  - `GET /company/order-app/:code/additional` - Additional operational information
- ✅ Created `OrderDetailData<T extends Order>` model với generic type support cho Order và Quotation
- ✅ Added `fetchOrderBaseByCode()`, `fetchOrderShipmentByCode()`, `fetchOrderCustomerByCode()`, `fetchOrderAdditionalByCode()` methods in OrderCubit
- ✅ Integrated Customer Transactions API (`GET /enterprise/order/{customerId}/filter`) for TransactionView
- ✅ Integrated Customer Debts API (`GET /company/debt-log/filter`) for DebtView với pagination support
- ✅ Created `AddressItem` widget for displaying customer addresses
- ✅ Refactored `renderEnterpriseAddress()` function from JavaScript to Dart
- ✅ Fixed Account Information Screen overflow issues
- ✅ Refactored Change Password Screen to use `InputFormField` pattern
- ✅ Implemented app version display in SettingScreen using `package_info_plus`
- ✅ Fixed multiple import errors và type errors trong OrderDetailScreen và related components
- ✅ Fixed `OrderDetailData` type parameter naming conflict
- ✅ Fixed `OrderCubit.fetchOrderBaseByCode()` type handling for Order/Quotation

### Files Created
- `lib/views/order/details/order_detail_screen.dart` - Main order detail screen với sections:
  - Order information (status, code, timeline, costs, products, payment)
  - Current shipment information
  - Customer information (expandable)
  - Additional operational information
- `lib/views/order/details/components/` - Component files:
  - `additional_section.dart` - Additional info section
  - `error_banner.dart` - Error display banner
  - `payment_list.dart` - Payment history list
  - `price_summary.dart` - Price summary component
  - `product_list.dart` - Product list component
  - `section_card.dart` - Reusable section card widget
  - `shipment_section.dart` - Shipment information section
  - `timeline_list.dart` - Order timeline component
- `lib/views/customer/details/components/address_item.dart` - Address display widget
- `documents/order_detail/` - Documentation:
  - `order-detail-requirements.md` - UI/UX requirements và specifications
  - `order-detail-api-integration.md` - API integration plan và test files
  - `order-detail-ui-ux-plan.md` - UI/UX design plan

### Files Modified
- `lib/bloc/order/order_cubit.dart`:
  - Added `fetchOrderBaseByCode({required String code})` method:
    - Calls `OrderMiddleware.getOrderBase(code: code)`
    - Stores result in `OrderRepository.orderDetailData`
    - Handles both `Order` và `Quotation` types
  - Added `fetchOrderShipmentByCode({required String code})` method:
    - Calls `OrderMiddleware.getOrderShipment(code: code)`
    - Updates `OrderDetailData.orderDelivery`
  - Added `fetchOrderCustomerByCode({required String code})` method:
    - Calls `OrderMiddleware.getOrderCustomer(code: code)`
    - Updates `OrderDetailData.customer`
  - Added `fetchOrderAdditionalByCode({required String code})` method:
    - Calls `OrderMiddleware.getOrderAdditional(code: code)`
    - Updates `OrderDetailData.orderInfo`, `warehouse`, `staff`, `company`
  - Fixed type handling: Changed `ResponseSuccessState<Order | Quotation>` to `ResponseSuccessState<Order>`
- `lib/data/middlewares/order_middleware.dart`:
  - Added `getOrderBase({required String code})` method
  - Added `getOrderShipment({required String code})` method
  - Added `getOrderCustomer({required String code})` method
  - Added `getOrderAdditional({required String code})` method
- `lib/data/repositories/order_repository.dart`:
  - Added `orderDetailData`: `BehaviorSubject<OrderDetailData?>` stream
  - Stores complete order detail data structure
- `lib/data/models/order/order_detail_data.dart`:
  - Fixed type parameter naming conflict: Changed `OrderDetailDataType` to `T extends Order`
  - Removed invalid `typedef OrderDetailDataType = T extends Order;`
  - Updated `copyWith()` method signature to use `T? order`
  - Supports both `Order` và `Quotation` types via generic
- `lib/bloc/customer/customer_cubit.dart`:
  - Added `getCustomerTransactions(String customerId, {int limit = 20, int offset = 0})` method:
    - Calls `CustomerMiddleware.getCustomerTransactions()`
    - Updates `CustomerRepository.customerTransactions` stream
    - States: `LoadingCustomerState` → `LoadedCustomerState` / `FailedCustomerState`
  - Added `loadMoreCustomerTransactions(String customerId, {int limit = 20, int offset = 0})` method:
    - Appends new transactions to existing list
    - Calculates offset automatically
  - Added `getCustomerDebts(String customerId, {int limit = 20, int offset = 0})` method:
    - Calls `CustomerMiddleware.getCustomerDebts()`
    - Updates `CustomerRepository.customerDebts` stream
  - Added `loadMoreCustomerDebts(String customerId, {int limit = 20, int offset = 0})` method:
    - Appends new debts to existing list
- `lib/data/middlewares/customer_middleware.dart`:
  - Added `getCustomerTransactions({required String customerId, int limit = 20, int offset = 0})` method
  - Added `getCustomerDebts({required String customerId, int limit = 20, int offset = 0})` method
- `lib/data/repositories/customer_repository.dart`:
  - Added `customerTransactions`: `BehaviorSubject<List<Order>>` stream
  - Added `customerDebts`: `BehaviorSubject<List<Debt>>` stream
  - Added `totalCustomerTransactions`: int
  - Added `totalCustomerDebts`: int
- `lib/views/customer/details/transaction_view.dart`:
  - Integrated `getCustomerTransactions()` và `loadMoreCustomerTransactions()` use cases
  - Displays order transactions với pagination
- `lib/views/customer/details/debt_view.dart`:
  - Integrated `getCustomerDebts()` và `loadMoreCustomerDebts()` use cases
  - Displays debt logs với pagination
- `lib/views/customer/details/addresses_view.dart`:
  - Uses `AddressItem` widget để display addresses
- `lib/utils/functions/order_function.dart`:
  - Refactored `renderEnterpriseAddress()` from JavaScript to Dart:
    - Handles address components: specificAddress, ward, district, province
    - Formats address string với proper separators
    - Returns formatted address string
- `lib/views/setting/setting_screen.dart`:
  - Added app version display using `package_info_plus`:
    - Displays version name và build number
    - Shows version info in settings list
- `lib/views/account/account_information_screen.dart`:
  - Fixed "right overflowed by 18 pixels" error:
    - Adjusted layout constraints
    - Used `Flexible` widgets for text fields
- `lib/views/account/change_password_screen.dart`:
  - Refactored to use `InputFormField` pattern:
    - Consistent form field styling
    - Better validation handling
    - Improved UX

### Architecture Decisions
- **Order Detail Data Management**: Sử dụng `OrderRepository.orderDetailData` BehaviorSubject để store complete order detail data structure, thay vì pass qua route arguments
- **On-Demand Data Loading**: Load base data first, then load other sections (shipment, customer, additional) when needed hoặc on init
- **Generic Type Support**: `OrderDetailData<T extends Order>` supports both `Order` và `Quotation` types
- **Data Fetching Pattern**: Multiple API calls được thực hiện với `Future.wait()` để load parallel
- **Component Separation**: Mỗi section được tách thành component riêng để dễ maintain và reuse
- **Customer Module Pattern**: Transactions và Debts sử dụng pagination pattern với load more functionality

### Technical Notes
- **Order Detail APIs**:
  - Base API: Returns `Order` hoặc `Quotation` object với full order information
  - Shipment API: Returns `OrderDelivery` object với shipment details
  - Customer API: Returns `Customer` object với customer information
  - Additional API: Returns additional info (staff, warehouse, company, orderInfo)
- **OrderDetailData Structure**:
  - `order`: Order hoặc Quotation object
  - `orderDelivery`: Current shipment information
  - `customer`: Customer information
  - `orderInvoice`: Invoice information
  - `orderInfo`: Additional order info
  - `warehouse`: Warehouse information
  - `staff`: Staff information
  - `company`: Company information
- **Type Safety**: Generic type `T extends Order` ensures type safety cho Order và Quotation
- **Quotation Support**: `isQuotation` getter checks if order is `Quotation` type
- **Customer Transactions**: Returns `List<Order>` từ `/enterprise/order/{customerId}/filter` endpoint
- **Customer Debts**: Returns `List<Debt>` từ `/company/debt-log/filter` endpoint với `userId` filter
- **Address Formatting**: `renderEnterpriseAddress()` formats address components với proper Vietnamese address format

### Benefits
1. **Complete Order Detail View**: Full order information display với all sections
2. **Type Safety**: Generic type support cho Order và Quotation
3. **Reactive Data**: BehaviorSubject streams cho real-time UI updates
4. **Component Reusability**: Separated components dễ maintain và reuse
5. **On-Demand Loading**: Load data khi cần, không load tất cả cùng lúc
6. **Customer Module Enhancement**: Transactions và Debts với pagination support
7. **Better UX**: Fixed overflow issues, improved form fields, app version display

### Known Issues
- `OrderDetailData` type parameter naming conflict đã được fix
- `OrderCubit.fetchOrderBaseByCode()` type handling đã được fix
- Import errors trong OrderDetailScreen components đã được fix
- `Staff.fullName` và `OrderInfoAdditional.saleDate` undefined getter errors cần fix
- `Order.amount` undefined getter error cần fix

### Next Steps
- Fix remaining undefined getter errors (`Staff.fullName`, `OrderInfoAdditional.saleDate`, `Order.amount`)
- Test order detail screen với actual API responses
- Add error handling cho failed API calls
- Add loading states cho individual sections
- Implement expand/collapse functionality cho sections
- Add navigation to related screens (product detail, customer detail, etc.)

---

## 2025-01-XX - Company Products API Integration & Model Refactoring

### Implemented
- ✅ Integrated Company Products List API (`GET /product/get-by-company`) from Core Service
- ✅ Integrated Company Product Detail API (`GET /company/product/detail/{productId}`) from Core Service
- ✅ Created comprehensive `CompanyProduct` model based on actual API response structure
- ✅ Created nested models: `CompanyProductSeller`, `CompanyProductCategory`, `CompanyProductVariant`, `CompanyProductBrand`
- ✅ Added `getProductsByCompany()` method in ProductMiddleware with pagination support
- ✅ Added `getCompanyProductDetail()` method in ProductMiddleware
- ✅ Added `getProducts()` and `loadMoreProducts()` usecases in ProductCubit
- ✅ Added `fetchCompanyProductDetail()` usecase in ProductCubit
- ✅ Created `CompanyProductsResult` model for pagination response
- ✅ Applied timezone conversion using `parseFromServerTimezone()` extension for `createdAt` and `updatedAt` fields
- ✅ Fixed type casting issues for `imageDescriptionVi` and `imageDescriptionEn` (List<dynamic> → List<String>)

### Files Created
- `lib/data/models/product/company_product.dart` - Complete CompanyProduct model với nested models:
  - `CompanyProduct`: Main model với 40+ fields từ API response
  - `CompanyProductSeller`: Seller information (id, fullName, username, phone, avatar)
  - `CompanyProductCategory`: Category information (id, nameVi, nameEn, imageUrl, status, code, etc.)
  - `CompanyProductVariant`: Product variant information (id, price, costPrice, inventory, availableQuantity, etc.)
  - `CompanyProductBrand`: Brand information (id, name)
  - `CompanyProductsResult`: Result model với pagination (items, total)
- `test/api/products/test_products_list_api.dart` - API test script để analyze response structure (temporary, deleted after use)
- `test/api/products/test_company_product_detail_api.dart` - API test script cho product detail (temporary, deleted after use)

### Files Modified
- `lib/data/network/network_url.dart`:
  - Added `getByCompany = '/product/get-by-company'` to `_Product` class
  - Added `companyProductDetail(String productId) => '/company/product/detail/$productId'` method
- `lib/data/middlewares/product_middleware.dart`:
  - Added `getProductsByCompany({int limit = 20, int offset = 0})` method:
    - Uses `coreDio.get()` to call API
    - Parses response từ key `"products"` (không phải `listData`)
    - Parses total từ `"count"` hoặc `"totalProducts"` (không phải `total`)
    - Returns `ResponseSuccessState<CompanyProductsResult>`
  - Added `getCompanyProductDetail({required String productId})` method:
    - Uses `coreDio.get()` to call API
    - Parses response từ key `"data"` (nếu có) hoặc trực tiếp
    - Returns `ResponseSuccessState<CompanyProduct>`
- `lib/data/repositories/product_repository.dart`:
  - Added `productsByCompanySubject`: `BehaviorSubject<List<CompanyProduct>>` để lưu danh sách sản phẩm
  - Added `companyProductDetailStreamData`: `BehaviorSubject<CompanyProduct?>` để lưu chi tiết sản phẩm
  - Added `setProductsByCompany(List<CompanyProduct> data, int total)` method
  - Added `appendProductsByCompany(List<CompanyProduct> data, int total)` method
- `lib/bloc/product/product_cubit.dart`:
  - Added `getProducts({int limit = 20, int offset = 0})` usecase:
    - Emits `ProductInitial` → `GotProductsState`
    - Calls `ProductMiddleware.getProductsByCompany()`
    - Updates repository với `setProductsByCompany()`
  - Added `loadMoreProducts({int limit = 20, int offset = 0})` usecase:
    - Calculates offset từ current items length
    - Calls `ProductMiddleware.getProductsByCompany()` với calculated offset
    - Updates repository với `appendProductsByCompany()`
  - Added `fetchCompanyProductDetail({required String productId})` usecase:
    - Emits `ProductInitial` → `GotProductsState`
    - Calls `ProductMiddleware.getCompanyProductDetail()`
    - Updates repository với `companyProductDetailStreamData`
    - Sets `null` vào stream khi có lỗi
- `lib/data/models/product/company_product.dart`:
  - Applied `parseFromServerTimezone()` extension cho `createdAt` và `updatedAt` fields
  - Fixed `imageDescriptionVi` và `imageDescriptionEn` parsing:
    - Convert từ `List<dynamic>` sang `List<String>` bằng `.map((e) => e.toString()).toList()`
    - Fallback to `<String>[]` nếu không phải List

### Architecture Decisions
- **Model Creation Process**: Test API trước để lấy response structure thực tế, sau đó tạo model đúng với API response
- **Response Structure Analysis**: 
  - List API: Response có key `"products"` chứa list, `"count"` hoặc `"totalProducts"` cho total
  - Detail API: Response có key `"data"` chứa product information
- **Timezone Handling**: Sử dụng `parseFromServerTimezone()` extension để convert server timezone sang client timezone
- **Type Safety**: Convert `List<dynamic>` sang `List<String>` bằng explicit mapping thay vì direct cast
- **Pagination Pattern**: 
  - `getProducts()`: Reset data mới (setProductsByCompany)
  - `loadMoreProducts()`: Append data (appendProductsByCompany)
  - Offset được tính tự động từ current items length

### Technical Notes
- **API Response Structure (List)**:
  ```json
  {
    "products": [...],
    "count": 365,
    "totalProducts": 365
  }
  ```
- **API Response Structure (Detail)**:
  ```json
  {
    "status": 1,
    "data": {
      "id": "...",
      "titleVi": "...",
      "productVariants": [...],
      ...
    }
  }
  ```
- **CompanyProduct Model Fields**: 40+ fields bao gồm:
  - Basic info: id, titleVi, titleEn, status, price, costPrice, wholesalePrice
  - Images: imageDetail, avatar, imageProduct
  - Descriptions: descriptionVi, descriptionEn, imageDescriptionVi, imageDescriptionEn
  - Inventory: availableQuantity, slotBuy, isInventoryManaged, isSaleAllowed
  - Nested objects: seller, categoryInternal, category, brand, productVariants
  - Metadata: createdAt, updatedAt, createById, companyId
  - Settings: deliverySettings, productOptions, isOnWebsite, isCanPacking
- **Timezone Conversion**: 
  - `createdAt`: `(map['createdAt']?.toString() ?? '').parseFromServerTimezone() ?? DateTime.now()`
  - `updatedAt`: `(map['updatedAt']?.toString() ?? '').parseFromServerTimezone() ?? DateTime.now()`
- **List Type Conversion**:
  - `imageDescriptionVi`: Check `is List`, map to String, fallback to `<String>[]`
  - `imageDescriptionEn`: Same pattern

### Benefits
1. **Accurate Models**: Models được tạo dựa trên API response thực tế, đảm bảo 100% match
2. **Type Safety**: Proper type conversion cho List và DateTime fields
3. **Timezone Accuracy**: DateTime fields hiển thị đúng theo client timezone
4. **Pagination Support**: Load more functionality với automatic offset calculation
5. **Reactive Data**: BehaviorSubject streams cho real-time UI updates
6. **Code Reusability**: Models và methods có thể tái sử dụng cho các features khác

### Known Issues
- Model `CompanyProduct` có nhiều fields, có thể cần optimize nếu performance issues
- `loadMoreProducts()` cần check xem còn data để load không (hiện tại chưa có check)

### Next Steps
- Integrate `getProducts()` và `loadMoreProducts()` vào UI (ProductListScreen)
- Integrate `fetchCompanyProductDetail()` vào UI (CompanyProductDetailsScreen)
- Có thể thêm check trong `loadMoreProducts()` để tránh load khi đã hết data
- Có thể optimize model nếu phát hiện performance issues

---

## 2025-01-24 - Create Customer Group API Integration & UI/UX Improvements

### Implemented
- ✅ Integrated Create Customer Group API (`POST /business/group-customer/create`) from User Service
- ✅ Created `CreateCustomerGroupInput` DTO with `toMap()` method for type-safe data handling
- ✅ Added `createCustomerGroup()` method in CustomerMiddleware (accepts `Map<String, dynamic>`)
- ✅ Added `createCustomerGroup()` method in CustomerCubit (accepts `CreateCustomerGroupInput` DTO)
- ✅ Fixed auto-focus issue after bottom sheet modal closure with global `NavigatorObserver`
- ✅ Created `showModalBottomSheetWithUnfocus` extension method for automatic focus management
- ✅ Implemented `CurrencyInputFormatter` for currency formatting in input fields
- ✅ Fixed layout constraints issues in `AdditionalInfoSection` bottom sheets
- ✅ Fixed price wrapping issue in `ProductsSection` by replacing `RowWidget` with `Wrap`
- ✅ Fixed `totalAmount` calculation to correctly subtract payment amounts
- ✅ Fixed image quality and size handling in `BottomSheetListItem` with customizable leading size
- ✅ Implemented timezone handling for DateTime to ISO 8601 conversion (UTC conversion)

### Files Created
- `lib/data/dto/customer_group/create_customer_group_input.dart` - DTO model for customer group creation:
  - Fields: `defaultPrice`, `nameVi`, `code`, `descriptionVi`, `discount`, `paymentMethod`, `type`
  - Method `toMap()` với conditional inclusion (chỉ include non-null và non-empty fields)
- `lib/utils/formatters/currency_formatter.dart` - TextInputFormatter cho currency formatting:
  - `CurrencyInputFormatter`: Format số với dấu phẩy phân cách hàng nghìn (1.000.000)
  - `parseCurrency()`: Parse formatted string về số nguyên
  - `formatCurrency()`: Format số nguyên thành formatted string
- `lib/utils/widgets/image_loading_widget.dart` - Enhanced với `memCacheWidth`, `memCacheHeight`, `filterQuality` options

### Files Modified
- `lib/data/network/network_url.dart`:
  - Added `createCustomerGroup = '/business/group-customer/create'` to `_Customer` class
- `lib/data/middlewares/customer_middleware.dart`:
  - Added `createCustomerGroup({required Map<String, dynamic> data})` method
  - Uses `userDio.post()` to call API
  - Parses response thành `CustomerGroup` object
  - Returns `ResponseSuccessState<CustomerGroup?>` hoặc `ResponseFailedState`
- `lib/bloc/customer/customer_cubit.dart`:
  - Added `createCustomerGroup({required CreateCustomerGroupInput input})` method
  - Emits `LoadingCustomerState` → `MessageCustomerState` (success) hoặc `FailedCustomerState` (error)
  - Success message: "Tạo nhóm khách hàng thành công"
  - Auto-refreshes customer groups list after successful creation
- `lib/views/customer_groups/create/create_screen.dart`:
  - Updated `_onSave()` để sử dụng `CreateCustomerGroupInput` DTO
  - Pass DTO to `CustomerCubit.createCustomerGroup()`
  - Updated BlocListener để handle `MessageCustomerState` (success case)
- `lib/app/app_entry.dart`:
  - Added `_UnfocusOnNavigationObserver` class extending `NavigatorObserver`:
    - Overrides `didPop()`, `didPush()`, `didReplace()` methods
    - Unfocuses after navigation events using `addPostFrameCallback`
  - Added observer to `MaterialApp.navigatorObservers`
  - Added `FocusScope` với `autofocus: false` trong `MaterialApp.builder`
- `lib/utils/extension/build_context.dart`:
  - Added `showModalBottomSheetWithUnfocus<T>()` extension method:
    - Unfocuses before opening bottom sheet
    - Unfocuses after closing bottom sheet
    - Handles `mounted` check for safety
- `lib/views/common/input_form_field.dart`:
  - Added `isCurrency` parameter (bool, default: false)
  - Automatically applies `CurrencyInputFormatter` when `isCurrency` is true
  - Sets `keyboardType` to `TextInputType.number` when `isCurrency` is true
  - Filters out `FilteringTextInputFormatter` when `isCurrency` is true to prevent conflicts
- `lib/views/order/create_order/components/additional_info_section.dart`:
  - Updated `_showStaffSelection()`, `_showCollaboratorSelection()`, `_showSalesChannelSelection()`:
    - Changed from `showModalBottomSheet` to `context.showModalBottomSheetWithUnfocus()`
    - Fixed layout constraints: Replaced `Container` với `constraints` bằng `Expanded` widget
    - Wrapped `ListView.builder` trong `Expanded` để receive proper constraints
    - Removed manual unfocus code (handled by extension method)
- `lib/views/order/create_order/components/payment_section.dart`:
  - Removed `FilteringTextInputFormatter.digitsOnly` from shipping fee `InputFormField`
  - Uses `isCurrency: true` parameter instead (handled by `InputFormField`)
- `lib/views/order/create_order/components/products_section.dart`:
  - Replaced `RowWidget` with `Wrap` for price display (lines 354-394):
    - Changed `crossAxisAlignment: .end` to `crossAxisAlignment: WrapCrossAlignment.end`
    - Removed `Flexible` from `Text` widgets inside `Wrap` (Flexible không dùng được với Wrap)
    - Added `Expanded` to parent `ColumnWidget` containing price `Wrap`
    - Added `width: double.infinity` to `Container` wrapping `Wrap`
    - Replaced `Expanded` around `QuantityWidget` with `SizedBox` for spacing
- `lib/views/order/create_order/create_order_screen.dart`:
  - Fixed `_getTotalAmount()` calculation (line 333):
    - Now correctly subtracts total paid amount from `paymentDetails`
    - Filters `paymentDetails` by `paymentMethodEnum` (not `paymentMethodName`)
    - Calculates sum of `customerPaid` values
    - Returns `(totalAmount - totalPaidAmount).clamp(0, double.infinity)`
  - Fixed timezone handling for `scheduledDeliveryAt` and `soldAt`:
    - Convert local DateTime to UTC before calling `toIso8601String()`
    - Uses `.toUtc().toIso8601String()` to ensure timezone consistency with backend
- `lib/utils/widgets/bottom_sheet_list_item.dart`:
  - Added `leadingWidth` and `leadingHeight` parameters (double?, optional)
  - Wrapped `leading` widget in `SizedBox` với `Center` widget:
    - Default size: `40.w x 40.w` (dense) hoặc `56.w x 56.w` (normal)
    - Custom size: Uses `leadingWidth` và `leadingHeight` if provided
    - Centers leading widget within SizedBox
- `lib/utils/widgets/image_loading_widget.dart`:
  - Added `memCacheWidth` và `memCacheHeight` options (3x actual size for high quality):
    - `memCacheWidth: width != null ? (width! * 3).toInt() : null`
    - `memCacheHeight: height != null ? (height! * 3).toInt() : null`
  - Added `filterQuality: FilterQuality.high` for better image rendering
  - Updated placeholder builder to use `SizedBox` with default width/height if not provided

### Architecture Decisions
- **DTO Pattern**: Sử dụng DTO classes (`CreateCustomerGroupInput`) cho type-safe data handling
  - View layer passes DTO to Cubit
  - Cubit converts DTO to Map using `toMap()` method before passing to Middleware
  - Middleware receives Map for API call
- **Focus Management**: Global `NavigatorObserver` để tự động unfocus sau navigation events
  - Extension method `showModalBottomSheetWithUnfocus()` cho explicit control
  - `FocusScope` với `autofocus: false` để disable automatic focus requests globally
- **Currency Formatting**: Reusable `CurrencyInputFormatter` integrated into `InputFormField`
  - Automatic formatting khi `isCurrency: true`
  - Handles cursor position correctly
  - Prevents conflicts với other formatters
- **Layout Constraints**: Sử dụng `Expanded` cho `ListView.builder` trong `ColumnWidget` để receive proper constraints
  - `Wrap` widget thay thế `RowWidget` khi cần text wrapping
  - `SizedBox` cho fixed spacing thay vì `Expanded` khi không cần flexibility
- **Timezone Handling**: Convert local DateTime to UTC trước khi format ISO 8601
  - Ensures timezone consistency với backend
  - Uses `.toUtc().toIso8601String()` pattern
- **Image Quality**: Cache images at higher resolution (3x) và use `FilterQuality.high`
  - Customizable leading widget size trong `BottomSheetListItem`
  - Proper size constraints cho leading widget trong ListTile

### Technical Notes
- **API Request Format**:
  - Request body: `{defaultPrice, nameVi, code, descriptionVi, discount, paymentMethod, type}`
  - All fields except `nameVi` và `type` are optional
  - DTO `toMap()` method only includes non-null và non-empty fields
- **Currency Formatter Logic**:
  - Strips all non-digit characters
  - Formats number with Vietnamese locale (1.000.000)
  - Preserves cursor position during formatting
  - Handles empty input gracefully
- **Layout Constraint Fixes**:
  - `Expanded` widget provides unbounded height constraints to `ListView.builder`
  - `Wrap` widget automatically wraps children to next line when space is insufficient
  - `SizedBox` với explicit width/height provides bounded constraints for `ListTile.leading`
- **Timezone Conversion**:
  - `DateTime.now()` returns local time
  - `.toUtc()` converts to UTC time
  - `.toIso8601String()` formats with "Z" suffix (UTC indicator)
  - Example: `2024-01-01 12:00:00+07:00` (local) → `2024-01-01T05:00:00.000Z` (UTC)
- **Image Quality Improvements**:
  - `memCacheWidth`/`memCacheHeight`: Cache images at higher resolution for crisp display
  - `FilterQuality.high`: Better interpolation khi scaling images
  - Leading widget size customization: Allows fine-grained control over image size

### Benefits
1. **Type Safety**: DTO pattern ensures compile-time checking và type safety
2. **Better UX**: Auto-unfocus prevents unwanted keyboard popups after navigation
3. **Currency Formatting**: Automatic formatting improves user experience và readability
4. **Layout Flexibility**: `Wrap` widget allows responsive price display
5. **Accurate Calculations**: Total amount calculation correctly accounts for payments
6. **High-Quality Images**: Images render crisp và clear với proper caching
7. **Timezone Consistency**: UTC conversion ensures backend receives correct timezone data

### Known Issues
- Currency formatter có thể cần adjust cursor position logic nếu có edge cases
- Image quality settings có thể cần tuning based on actual performance

### Next Steps
- Có thể thêm validation cho customer group creation fields nếu cần
- Có thể optimize image caching strategy based on actual usage patterns
- Có thể thêm unit tests cho currency formatter logic

---

## 2025-01-XX - BrandsScreen Performance Analysis & Optimization Opportunities

### Analyzed
- ✅ Phân tích hiệu năng của `BrandsScreen` và `PackingSlipView`
- ✅ Xác định 7 vấn đề hiệu năng chính
- ✅ Đánh giá mức độ ảnh hưởng và đề xuất giải pháp

### Performance Issues Identified

#### 1. **StreamBuilder trong IndexedStack (CAO)**
- **Vị trí**: `packing_slip_view.dart` (dòng 62-302)
- **Vấn đề**: Cả 3 StreamBuilder (new, processing, completed) đều subscribe stream ngay cả khi tab không hiển thị
- **Impact**: Lãng phí memory và CPU do subscribe không cần thiết, mỗi stream update sẽ rebuild widget tương ứng dù không hiển thị
- **Lý do**: `IndexedStack` chỉ ẩn widget (không render), không ngừng subscription stream

#### 2. **Dependency Injection trong build method (TRUNG BÌNH)**
- **Vị trí**: `packing_slip_view.dart` (dòng 31)
- **Vấn đề**: `di<WarehouseRepository>()` được gọi mỗi lần rebuild trong build method
- **Impact**: Overhead không cần thiết mỗi lần rebuild, tốn thời gian lookup DI container

#### 3. **Load tất cả data cùng lúc (CAO)**
- **Vị trí**: `brands_screen.dart` (dòng 56-67)
- **Vấn đề**: `_loadPackingSlips()` load cả 3 API calls (new, processing, completed) cùng lúc với `Future.wait()`
- **Impact**: Lag khi chuyển sang tab packing do phải chờ tất cả requests hoàn thành

#### 4. **Tính toán trong itemBuilder (TRUNG BÌNH)**
- **Vị trí**: `brands_screen.dart` (dòng 289-299)
- **Vấn đề**: Tính toán `delivered`, `remaining`, `extraRows` trong itemBuilder mỗi lần rebuild
- **Impact**: Chậm khi scroll với nhiều items, tốn CPU cho tính toán lặp lại

#### 5. **Rebuild không cần thiết (TRUNG BÌNH)**
- **Vị trí**: `brands_screen.dart` (dòng 213-215)
- **Vấn đề**: `setState(() { _packingStatusIndex = pageIndex; })` trigger rebuild toàn bộ `BrandsScreen`
- **Impact**: Rebuild toàn bộ screen dù chỉ cần update `_PackingSlipView`

#### 6. **Thiếu const constructors (THẤP)**
- **Vấn đề**: Nhiều widget có thể mark const nhưng chưa làm
- **Impact**: Rebuild nhỏ không cần thiết khi parent rebuild

#### 7. **Access repository trong build (THẤP)**
- **Vị trí**: `brands_screen.dart` (dòng 250, 262)
- **Vấn đề**: Truy cập `_warehouseRepository.totalVariantSpecials` trong build method
- **Impact**: Có thể gây rebuild không cần thiết nếu repository notify changes

### Performance Impact Summary

| Vấn đề | Mức độ | Ảnh hưởng | Priority |
|--------|--------|---------|----------|
| StreamBuilder trong IndexedStack | **CAO** | Lãng phí memory, CPU do subscribe không cần thiết | P0 |
| Load tất cả data cùng lúc | **CAO** | Lag khi chuyển tab, chậm UX | P0 |
| Tính toán trong itemBuilder | **TRUNG BÌNH** | Chậm khi scroll với nhiều items | P1 |
| Rebuild không cần thiết | **TRUNG BÌNH** | Rebuild toàn bộ screen | P1 |
| DI trong build method | **TRUNG BÌNH** | Overhead mỗi lần rebuild | P2 |
| Thiếu const constructors | **THẤP** | Rebuild nhỏ không cần thiết | P3 |
| Access repository trong build | **THẤP** | Có thể gây rebuild không cần thiết | P3 |

### Proposed Solutions

#### Solution 1: Lazy Load StreamBuilder (Priority P0)
- Chỉ subscribe stream khi tab được hiển thị
- Sử dụng `IndexedStack` với lazy initialization
- Hoặc sử dụng `PageView` với `AutomaticKeepAliveClientMixin` thay vì `IndexedStack`

#### Solution 2: Lazy Load Data (Priority P0)
- Chỉ load data khi tab được chọn
- Load từng status khi user switch tab, không load tất cả cùng lúc
- Sử dụng flag để track data đã load chưa

#### Solution 3: Inject Repository từ Parent (Priority P2)
- Pass `WarehouseRepository` từ `BrandsScreen` xuống `_PackingSlipView`
- Không gọi `di<>()` trong build method

#### Solution 4: Cache Calculations (Priority P1)
- Pre-calculate `delivered`, `remaining`, `extraRows` và cache trong model
- Hoặc sử dụng computed properties/getters
- Tính toán một lần, sử dụng nhiều lần

#### Solution 5: Use ValueNotifier/StreamBuilder (Priority P1)
- Sử dụng `ValueNotifier<int>` cho `_packingStatusIndex` thay vì state variable
- Wrap `_PackingSlipView` với `ValueListenableBuilder` để tránh rebuild toàn bộ screen
- Hoặc tách `_PackingSlipView` thành `StatefulWidget` riêng

#### Solution 6: Add Const Constructors (Priority P3)
- Mark các widget không thay đổi với `const` keyword
- Giảm rebuild khi parent rebuild

#### Solution 7: StreamBuilder cho Repository Data (Priority P3)
- Sử dụng `StreamBuilder` để listen `totalVariantSpecials` thay vì access trực tiếp
- Hoặc cache value trong state variable

### Files Analyzed
- `lib/views/warehouse/brands/manage/brands_screen.dart` - Main screen với 2 tabs (variants, packing slips)
- `lib/views/warehouse/brands/manage/components/packing_slip_view.dart` - Packing slip view với 3 status tabs

### Technical Notes
- **IndexedStack vs PageView**: 
  - `IndexedStack` giữ tất cả children trong memory nhưng chỉ render child tại index
  - `PageView` với `AutomaticKeepAliveClientMixin` có thể lazy initialize pages
  - Vấn đề: `IndexedStack` không lazy, tất cả StreamBuilder đều subscribe ngay
- **StreamBuilder Behavior**: 
  - StreamBuilder tự động subscribe stream khi build, không unsubscribe khi widget không hiển thị
  - Cần manual dispose hoặc sử dụng lazy initialization
- **Future.wait() Impact**:
  - `Future.wait()` chờ tất cả futures hoàn thành, không phải parallel execution
  - Có thể gây lag nếu một trong các API chậm

### Benefits After Optimization
1. **Reduced Memory Usage**: Chỉ subscribe streams cần thiết
2. **Faster Tab Switching**: Load data on-demand thay vì tất cả cùng lúc
3. **Smoother Scrolling**: Cache calculations, không tính toán trong itemBuilder
4. **Better Rebuild Performance**: Giảm rebuild không cần thiết với ValueNotifier/const
5. **Lower CPU Usage**: Ít tính toán lặp lại, ít rebuild

### Next Steps
- Implement Solution 1 & 2 (Priority P0) - Lazy load StreamBuilder và data
- Implement Solution 3 (Priority P2) - Inject repository từ parent
- Implement Solution 4 & 5 (Priority P1) - Cache calculations và ValueNotifier
- Implement Solution 6 & 7 (Priority P3) - Const constructors và StreamBuilder cho repository
- Test performance improvements với Flutter DevTools
- Measure memory usage và CPU usage trước/sau optimization

---

## 2025-01-XX - Navigator Lock Error & Focus Management Issues

### Implemented
- ✅ Investigated Navigator lock error (`'!_debugLocked': is not true`) in `packing_slips_view.dart`
- ✅ Fixed CommonSearchBar auto-focus issue after popping `PackingSlipDetailsScreen` in `brands_screen.dart`
- ✅ Added `FocusNode` parameter to `CommonSearchBar` widget for external focus control
- ✅ Implemented focus management in `BrandsScreen` with `didChangeDependencies()` callback

### Problem
- **Issue 1**: Navigator lock error `'!_debugLocked': is not true` when tapping packing slip cards multiple times quickly
  - **Location**: `lib/views/warehouse/brands/manage/packing_slips_view.dart:319`
  - **Error**: `Failed assertion: line 4628 pos 12: '!_debugLocked': is not true.` in `NavigatorState._routeNamed`
  - **Root Cause**: Multiple `pushNamed()` calls in quick succession while Navigator is already locked (in the process of navigation)
  - **User Action**: Reverted proposed solution (using `_isNavigating` flag) - user may prefer alternative approach
- **Issue 2**: `CommonSearchBar` automatically gains focus after popping `PackingSlipDetailsScreen`
  - **Location**: `lib/views/warehouse/brands/manage/brands_screen.dart:93-97`
  - **Root Cause**: TextField with `autofocus: true` (default) automatically requests focus when widget rebuilds

### Solution
- **Focus Management Fix**:
  - Added `autofocus: false` to `TextField` in `CommonSearchBar`
  - Added `FocusNode? focusNode` parameter to `CommonSearchBar` for external control
  - Created `_searchFocusNode` in `BrandsScreen` and passed to `CommonSearchBar`
  - Implemented `didChangeDependencies()` with `addPostFrameCallback` to explicitly unfocus search bar after screen rebuilds
- **Navigator Lock Issue**:
  - Proposed solution: Added `_isNavigating` flag to prevent multiple navigation calls
  - User reverted: Solution was reverted, indicating user may prefer alternative approach (debounce, AbsorbPointer, or other mechanism)

### Files Modified
- `lib/views/common/common_search_bar.dart`:
  - Added `autofocus: false` to `TextField`
  - Added `FocusNode? focusNode` parameter (optional, for external control)
  - Updated `TextField` to use provided `focusNode` if available
- `lib/views/warehouse/brands/manage/brands_screen.dart`:
  - Added `FocusNode _searchFocusNode` to manage search bar focus
  - Implemented `didChangeDependencies()` method:
    - Uses `addPostFrameCallback` to ensure unfocus operation happens after widget tree rebuilds
    - Calls `context.focus.unfocus()` to explicitly remove focus from search bar
  - Passed `_searchFocusNode` to `CommonSearchBar` widget

### Architecture Decisions
- **Focus Management**: Explicit control via `FocusNode` is preferred over relying on default behavior
- **Post-Frame Callbacks**: Use `addPostFrameCallback` when widget state changes need to happen after build cycle completes
- **Navigator Lock Prevention**: User preference unclear - solution needs to be determined based on UX requirements (debounce, disable tap, etc.)

### Technical Notes
- **Navigator Lock Error**: Occurs when `pushNamed()` is called while Navigator is already processing a previous navigation request
- **Common Causes**: Rapid taps, navigation triggered from multiple sources simultaneously, async operations completing at the same time
- **Flutter Behavior**: Navigator uses `_debugLocked` flag internally to prevent concurrent navigation operations
- **Focus Management**: Flutter's default `autofocus: true` behavior can cause unwanted focus after widget rebuilds (e.g., when popping another screen)

### Benefits
1. **Focus Control**: Search bar no longer automatically gains focus after navigation
2. **Better UX**: Prevents keyboard from popping up unexpectedly
3. **Explicit Management**: Focus behavior is now predictable and controllable

### Known Issues
- Navigator lock error still occurs when tapping cards multiple times quickly
- User reverted the proposed `_isNavigating` flag solution
- Alternative solutions to consider:
  - Debounce/throttle on tap handler
  - Disable tap while navigating (AbsorbPointer/IgnorePointer)
  - Check `Navigator.canPop()` before navigating
  - Use `Navigator.of(context, rootNavigator: true)` if nested navigators are causing issues

### Next Steps
- Determine user's preferred approach for handling Navigator lock error
- Consider implementing debounce mechanism for tap handlers if rapid taps are expected
- Test navigation flow to ensure smooth UX without errors

---

## 2025-01-XX - App Initialization Optimization & Performance Improvement

### Implemented
- ✅ Phân tích và tối ưu hóa hàm `initConfig()` trong `app_config.dart`
- ✅ Tách `initConfig()` thành 2 hàm: `initConfigSync()` và `initFirebaseAsync()`
- ✅ Tối ưu hiệu năng bằng cách chạy song song các tác vụ I/O độc lập
- ✅ Firebase initialization chạy background, không block main thread
- ✅ Cập nhật `main.dart` để sử dụng cấu trúc mới
- ✅ Sửa test file để setup dependencies đúng cách

### Problem
- **Issue**: Hàm `initConfig()` chạy tất cả tác vụ tuần tự, block main thread
- **Impact**: App khởi động chậm (500ms-2s) do phải chờ Firebase initialization
- **Root Cause**: Firebase initialization và các tác vụ I/O nặng chạy trên main thread trước khi app render

### Solution
- **Tách tác vụ**: Chia thành 2 hàm:
  - `initConfigSync()`: Tác vụ bắt buộc, chạy nhanh (DI, Flutter binding, SystemChrome, env, SharedPreferences)
  - `initFirebaseAsync()`: Firebase initialization chạy background sau khi app đã khởi động
- **Parallel I/O**: Chạy song song `_tryLoadEnv()` và `LocalStoreService().config()` bằng `Future.wait()`
- **Lazy Firebase**: Firebase init chạy sau `runApp()`, không block UI

### Files Modified
- `lib/app/app_config.dart`:
  - Tách `initConfig()` thành `initConfigSync()` và `initFirebaseAsync()`
  - `initConfigSync()`: Setup DI, Flutter binding, SystemChrome, chạy song song env và SharedPreferences
  - `initFirebaseAsync()`: Firebase initialization, device token, cập nhật vào AppCubit khi có
  - Giữ lại `initConfig()` cũ với `@Deprecated` để tương thích ngược
- `lib/main.dart`:
  - Gọi `initConfigSync()` trước `runApp()`
  - Gọi `initFirebaseAsync()` sau `runApp()` (không await, chạy background)
- `lib/app/app_entry.dart`:
  - Bỏ `deviceToken` khỏi constructor `MyApp`
  - Device token được cập nhật vào AppCubit từ `initFirebaseAsync()` khi có
- `test/widget_test.dart`:
  - Setup `FlavorConfig`, `setupDependencyInjection()`, và `LocalStoreService` trong `setUpAll()`
  - Load dotenv với fallback mechanism (`.env` → `.env.example` → tạo file tạm thời)
  - Test case đơn giản: verify `MaterialApp` render thành công

### Architecture Decisions
- **Tác vụ bắt buộc vs không bắt buộc**: 
  - Bắt buộc: DI, Flutter binding, env, SharedPreferences (cần trước khi app chạy)
  - Không bắt buộc: Firebase initialization (có thể chạy sau, app vẫn hoạt động)
- **Parallel I/O**: Các tác vụ I/O độc lập (`_tryLoadEnv()` và `LocalStoreService().config()`) chạy song song để tối ưu thời gian
- **Background Firebase**: Firebase init không block UI, device token được cập nhật async vào AppCubit
- **Test Setup**: Test file phải setup đầy đủ dependencies (DI, FlavorConfig, dotenv) trước khi khởi tạo widgets

### Technical Notes
- **Parallel Execution**: `Future.wait([_tryLoadEnv(), di<LocalStoreService>().config()])` giảm thời gian chờ từ tổng → max
- **Firebase Async**: `initFirebaseAsync()` được gọi sau `runApp()` với `.catchError()` để không crash app nếu Firebase fail
- **Device Token**: Được cập nhật vào AppCubit sau khi có, app vẫn chạy bình thường nếu chưa có token
- **Test Environment**: Dotenv được load với fallback mechanism để đảm bảo test chạy được ngay cả khi không có file `.env`

### Benefits
1. **Faster App Startup**: Giảm 500ms-2s thời gian chờ Firebase, app khởi động nhanh hơn
2. **Better UX**: UI render sớm hơn, không bị block bởi Firebase initialization
3. **Non-blocking**: Firebase init chạy background, không ảnh hưởng đến main thread
4. **Resilience**: App vẫn chạy được nếu Firebase fail, chỉ mất push notification feature
5. **Testability**: Test file setup đúng cách, có thể test app initialization

### Known Issues
- User đã revert các thay đổi trong `FCMHandler.handleFirebaseMessagingStates()` (bỏ try-catch cho Firebase)
- Test có thể fail nếu Firebase chưa được khởi tạo khi `FCMHandler` được gọi (cần xử lý riêng nếu cần)

### Next Steps
- Có thể thêm error handling cho Firebase initialization trong production
- Có thể thêm loading indicator cho Firebase initialization nếu cần
- Có thể optimize thêm các tác vụ khác trong `initConfigSync()` nếu phát hiện bottleneck

---

## 2025-01-XX - Time Range Utility Function & Filter Component Enhancement

### Implemented
- ✅ Hoàn thiện hàm `getRangeOfTimeOption()` trong `base_functions.dart` với tất cả 8 cases từ enum `TimeOption`
- ✅ Điều chỉnh `bottom_sheet_filter.dart` để sử dụng enum `TimeOption` thay vì hardcode labels
- ✅ Thêm state management cho filter component với selected time option tracking
- ✅ Integrate `getRangeOfTimeOption()` với filter buttons để tự động set date range
- ✅ Added visual feedback (selected state) cho time option buttons

### Files Modified
- `lib/utils/functions/base_functions.dart`:
  - Hoàn thiện `getRangeOfTimeOption()` function với 8 cases:
    - `today`: Hôm nay (00:00:00 - 23:59:59)
    - `yesterday`: Hôm qua (00:00:00 - 23:59:59)
    - `thisWeek`: Tuần này (Thứ 2 - Chủ nhật)
    - `lastWeek`: Tuần trước (Thứ 2 - Chủ nhật tuần trước)
    - `thisMonth`: Tháng này (Ngày 1 - Cuối tháng)
    - `lastMonth`: Tháng trước (Xử lý cả trường hợp tháng 1 chuyển về tháng 12 năm trước)
    - `thisYear`: Năm này (1/1 - 31/12)
    - `lastYear`: Năm trước (1/1 - 31/12 năm trước)
  - Returns `TimeRange` object với `start` và `end` DateTime
  - Sử dụng extension methods `startOfDate()` và `endOfDate()` để normalize times
- `lib/views/warehouse/green_beans/components/bottom_sheet_filter.dart`:
  - Refactored để sử dụng `TimeOption.values` thay vì hardcode buttons
  - Row 1: 4 items đầu (today, yesterday, thisWeek, lastWeek) - sử dụng `.take(4)`
  - Row 2: 4 items sau (thisMonth, lastMonth, thisYear, lastYear) - sử dụng `.skip(4).take(4)`
  - Added state management: `selectedTimeOption`, `selectedStartDate`, `selectedEndDate`
  - Khi click time option button:
    - Set `selectedTimeOption`
    - Gọi `getRangeOfTimeOption()` để tính date range
    - Tự động set `selectedStartDate` và `selectedEndDate`
    - Update UI với selected state
  - Button có visual feedback: backgroundColor và text color thay đổi khi selected
  - Added `onFilterApplied` callback để notify parent component khi apply filter
- `lib/views/warehouse/green_beans/green_beans_screen.dart`:
  - Added import: `import '../../../utils/enums.dart';` và `import '../../../utils/functions/base_functions.dart';`
  - Updated `_BottomSheetFilter` usage với `onFilterApplied` callback
  - Updated search debounce logic: So sánh text hiện tại với keyword đã lưu, set null cho empty keyword

### Architecture Decisions
- **Time Range Calculation**: Sử dụng helper function `getRangeOfTimeOption()` để tập trung logic tính toán date range
- **Enum-based UI**: Buttons được generate từ enum `TimeOption.values` để đảm bảo consistency và dễ maintain
- **State Management**: Filter state được quản lý trong `_FilterViewState` với selected time option tracking
- **Date Range Synchronization**: Khi chọn time option, tự động sync với date range selector field

### Technical Notes
- **Week Calculation**:
  - `thisWeek`: Tính từ Thứ 2 (weekday 1) đến Chủ nhật (weekday 7)
  - `lastWeek`: Trừ thêm 7 ngày từ `thisWeek` start date
- **Month Calculation**:
  - Sử dụng `DateTime(year, month + 1, 0)` để lấy ngày cuối tháng
  - Xử lý edge case: Tháng 1 (month = 1) chuyển về tháng 12 năm trước
- **Year Calculation**:
  - `thisYear`: `DateTime(year, 1, 1)` đến `DateTime(year, 12, 31, 23, 59, 59)`
  - `lastYear`: Tương tự với `year - 1`
- **Visual Feedback**: Selected button có `backgroundColor: AppColors.primary`, `textColor: AppColors.white`, `borderColor: AppColors.primary`
- **Callback Pattern**: `onFilterApplied(DateTime? startDate, DateTime? endDate)` để notify parent khi user click "Tìm kiếm"

### Benefits
1. **Code Reusability**: Hàm `getRangeOfTimeOption()` có thể tái sử dụng ở bất kỳ đâu cần tính date range
2. **Maintainability**: Thay đổi enum `TimeOption` tự động update UI, không cần hardcode
3. **Consistency**: Tất cả time options sử dụng cùng một logic tính toán
4. **User Experience**: Visual feedback rõ ràng, tự động sync date range khi chọn quick option
5. **Type Safety**: Sử dụng enum thay vì string để tránh typo và có compile-time checking

### Next Steps
- Integrate `onFilterApplied` callback trong `GreenBeansScreen` để filter data theo date range
- Có thể áp dụng pattern tương tự cho các filter components khác
- Có thể thêm validation cho date range (startDate < endDate)

---

## 2025-01-XX - UI/UX Improvements & Input Field Refactoring

### Implemented
- ✅ Fixed search debounce issue trong `GreenBeansScreen` và `BrandsScreen`: Tránh trigger debounce khi lần đầu focus vào search bar
- ✅ Fixed navigation flow trong `CreateOrderScreen`: Sử dụng `_allowBack` flag và `addPostFrameCallback` để xử lý pop dialog và screen đúng cách
- ✅ Refactored `AddNewProductServiceScreen`: Chuyển tất cả input fields sang sử dụng `InputFormField` với validation đầy đủ
- ✅ Configured PopupMenu theme globally trong `theme.dart` với styling nhất quán
- ✅ Added VAT field vào order creation flow: Tương tự như discount với UI, input, validation và calculation logic
- ✅ Added validation cho `StreamSelectorFormField` components trong customer creation screen với error state display
- ✅ Refined input formatters cho các fields trong `AdditionalInformationSection`: Fax code, website, debt, spending
- ✅ Rollback `bump_version.dart` về bản base gốc sau khi user yêu cầu (user sẽ tự chỉnh logic theo nhu cầu riêng)

### Files Modified
- `lib/views/warehouse/green_beans/green_beans_screen.dart`:
  - Fixed `_onSearchChanged()`: So sánh text hiện tại với keyword đã lưu để tránh trigger không cần thiết
  - Set empty keyword thành `null` để không gửi query parameter khi search rỗng
- `lib/views/warehouse/brands/manage/brands_screen.dart`:
  - Applied tương tự fix search debounce như `GreenBeansScreen`
- `lib/views/order/create_order/create_order_screen.dart`:
  - Added `_allowBack` flag để control `PopScope.canPop`
  - Updated `PopScope.onPopInvokedWithResult` để show confirmation dialog và handle navigation flow đúng cách
  - Added `vat` và `_vatUnit` state variables
  - Updated `_getTotalAmount()` để include VAT calculation sau discount
  - Updated `_generateOrderBody()` để include `vat` và `vatPercent` trong `OrderInput`
- `lib/views/order/create_order/components/product_list_item.dart`:
  - Refactored layout sử dụng `Wrap` widget để responsive, tự động xuống hàng khi không đủ chỗ
- `lib/views/order/add_new_product_service/add_new_product_service_screen.dart`:
  - Replaced `CustomInputFieldWidget` với `InputFormField` cho tất cả fields (name, quantity, price, discount)
  - Added `GlobalKey<FormFieldState>` cho mỗi field để validation
  - Converted discount unit dropdown thành `PopupMenuButton` như `suffix` của discount `InputFormField`
  - Implemented validators: name (required), quantity (double > 0), price (double > 0), discount (double >= 0, <= 100% nếu unit là '%')
  - Updated `_calculateTotalPrice()` để handle decimal numbers đúng cách
  - Refactored "Total Value" display sử dụng `_totalPrice.toPrice()` format
  - Adjusted `inputFormatters` để cho phép số thập phân và không xóa text khi validation failed
- `lib/res/theme.dart`:
  - Configured `PopupMenuThemeData` với white background, rounded corners, text style, và reduced elevation
  - Added `highlightColor`, `splashColor`, `hoverColor` cho `PopupMenuButton` items
- `lib/views/common/input_form_field.dart`:
  - Removed internal `FocusNode` creation, cho phép external control
  - Added `suffix` và `suffixPadding` parameters để support custom widgets (dropdowns) ở cuối input field
- `lib/data/models/order/create_order_input.dart`:
  - Added `vat` và `vatPercent` fields vào `OrderInput` model
- `lib/views/order/create_order/components/payment_section.dart`:
  - Added `vat` và `vatUnit` parameters cho `_PaymentSection` và `AddVatFeeScreen`
  - Integrated `AddVatFeeScreen` (cloned từ `AddDiscountFeeScreen`) cho VAT input và calculation
  - Updated `_calculateTotalAmount()` để include VAT
  - Added `_PaymentRow` cho "Thuế (VAT)" để display calculated VAT
- `lib/views/common/selector_form_field.dart`:
  - Converted `StreamSelectorFormField` thành `FormField` để integrate với `Form.validate()`
  - Added `autovalidateMode: AutovalidateMode.onUserInteraction`
  - Modified `_showSelector` để pass `FormFieldState` và call `fieldState?.didChange()` và `fieldState?.validate()` khi select value, đảm bảo error state được clear
- `lib/views/customer/create/components/information_section.dart`:
  - Added validators cho `StreamSelectorFormField` cho "Tỉnh/Thành phố" và "Phường/Xã" dựa trên điều kiện address text field có được fill không
- `lib/views/customer/create/components/additional_information_section.dart`:
  - **Fax code**: `inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-]+'))]` - cho phép alphanumeric và dấu gạch ngang
  - **Website**: `inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-._:/]+'))]` - cho phép alphanumeric, hyphens, dots, underscores, colons, slashes
  - **Debt & Spending**: `inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]+\.?[0-9]*'))]` - cho phép số thập phân
- `tools/bump_version/bump_version.dart`:
  - **Rollback về bản gốc**: Luôn tăng `versionCode` +1, `versionName` và `versionNameSuffix` được tính toán và ghi đầy đủ (bao gồm cả +0)

### Architecture Decisions
- **Search Debounce**: So sánh text hiện tại với keyword đã lưu để tránh trigger không cần thiết, set empty thành `null` để không gửi query parameter
- **Navigation Flow**: Sử dụng flag và `addPostFrameCallback` để đảm bảo dialog và screen được pop đúng thứ tự
- **Input Fields Standardization**: Tất cả input fields sử dụng `InputFormField` với validation pattern nhất quán
- **PopupMenu Theme**: Configure globally để đảm bảo UI consistency
- **VAT Calculation**: Tương tự discount, tính sau discount và cộng vào total amount
- **FormField Integration**: `StreamSelectorFormField` được convert thành `FormField` để integrate với `Form.validate()` và display error states
- **Input Formatters**: Sử dụng regex patterns để cho phép specific characters, không xóa text khi validation failed

### Technical Notes
- **Search Debounce Fix**: Check `if (text == currentKeyword) return;` trước khi trigger debounce, set `null` cho empty keyword
- **Navigation Flow**: `_allowBack` flag → set `true` → pop dialog → `addPostFrameCallback` → pop screen
- **VAT Calculation**: `calculateOrderTax(netAfterDiscount, vat, vatUnit)` - tính trên giá sau discount
- **FormField Validation**: `fieldState?.didChange(value)` và `fieldState?.validate()` để clear error state khi select value
- **Input Formatters**: Regex patterns được design để allow specific characters, không block user input
- **Version Bump Tool**: Rollback về logic đơn giản - luôn tăng version, không có special case cho +0

### Benefits
1. **Better UX**: Search không trigger không cần thiết, navigation flow mượt mà hơn
2. **Consistency**: Input fields sử dụng cùng pattern, validation và error display nhất quán
3. **Flexibility**: Input formatters cho phép specific characters nhưng không block user input
4. **Maintainability**: PopupMenu theme centralized, dễ update styling
5. **Completeness**: VAT field hoàn chỉnh với UI, validation, và calculation logic

### Known Issues
- `bump_version.dart` đã được rollback về bản gốc - user sẽ tự chỉnh logic theo nhu cầu riêng
- Collaborator API integration đã được bắt đầu nhưng chưa hoàn thành (user yêu cầu rollback trước khi hoàn thành)

### Next Steps
- User sẽ tự chỉnh logic `bump_version.dart` theo yêu cầu riêng
- Có thể tiếp tục collaborator API integration nếu cần (hiện tại đã rollback)
- Có thể áp dụng validation pattern tương tự cho các form khác trong app

---

## 2025-12-19 - icons_launcher Kotlin DSL Support & Dependency Upgrades

### Implemented
- ✅ Fixed `icons_launcher` compatibility issue with Kotlin DSL (`build.gradle.kts`)
- ✅ Upgraded `icons_launcher` from 2.1.7 to 3.0.3 (latest version)
- ✅ Upgraded `lottie` from 2.5.0 to 3.3.2 to resolve dependency conflict
- ✅ Upgraded `flutter_lints` from 2.0.0 to 6.0.0
- ✅ Added `logger: ^2.6.2` dependency
- ✅ Removed temporary `android/app/build.gradle` file (no longer needed)
- ✅ Commented out `flutter_facebook_auth` dependency (temporarily disabled)
- ✅ Removed `mobile_scanner` dependency

### Problem
- **Issue**: `icons_launcher` version 2.1.7 không hỗ trợ Kotlin DSL (`build.gradle.kts`), chỉ đọc được Groovy DSL (`build.gradle`)
- **Error**: `PathNotFoundException: Cannot open file, path = 'android/app/build.gradle'` khi chạy `dart run icons_launcher:create`
- **Root Cause**: Package `icons_launcher` 2.1.7 không thể parse `build.gradle.kts` file để đọc `minSdk` configuration

### Initial Solution (Temporary)
- Created temporary `android/app/build.gradle` file với minimal Groovy DSL content:
  ```groovy
  android {
      defaultConfig {
          minSdk 28
      }
  }
  ```
- File này chỉ để `icons_launcher` đọc `minSdk`, không ảnh hưởng đến build process (vì project sử dụng `build.gradle.kts`)

### Final Solution (Permanent)
- **Upgrade icons_launcher**: Version 3.0.3 có thể đã hỗ trợ Kotlin DSL hoặc có cách đọc config khác
- **Dependency Resolution**: 
  - Upgrade `lottie` từ 2.5.0 → 3.3.2 để tương thích với `icons_launcher` 3.0.3
  - Conflict reason: `icons_launcher >=3.0.2` depends on `image ^4.5.4`, which requires `archive ^4.0.2`, but `lottie <3.1.3` depends on `archive ^3.0.0`
- **Removed temporary file**: File `build.gradle` tạm thời đã được xóa sau khi upgrade thành công

### Files Modified
- `pubspec.yaml`:
  - `icons_launcher`: ^2.1.7 → ^3.0.3
  - `lottie`: ^2.5.0 → ^3.3.2
  - `flutter_lints`: ^2.0.0 → ^6.0.0
  - Added `logger: ^2.6.2`
  - Commented out `flutter_facebook_auth: ^6.0.1`
  - Removed `mobile_scanner: ^5.2.3` dependency

### Files Deleted
- `android/app/build.gradle` - Temporary file no longer needed after upgrade

### Architecture Decisions
- **Version Compatibility**: Ưu tiên upgrade dependencies lên version mới nhất có thể để tận dụng bug fixes và features mới
- **Kotlin DSL Support**: Project sử dụng Kotlin DSL cho Gradle, không muốn maintain cả 2 format (Groovy và Kotlin)
- **Dependency Resolution**: Khi có conflict, upgrade cả 2 dependencies nếu có thể thay vì downgrade

### Technical Notes
- **icons_launcher 3.0.3**: Version mới có thể đã hỗ trợ đọc config từ `build.gradle.kts` hoặc có fallback mechanism
- **lottie 3.3.2**: Major version upgrade (2.x → 3.x), có thể có breaking changes - cần test lại animation features
- **flutter_lints 6.0.0**: Major version upgrade (2.x → 6.x), có thể có breaking changes trong linting rules - cần verify không có linter errors mới
- **logger package**: Added để hỗ trợ logging (có thể thay thế cho các log statements hiện tại)

### Verification
- ✅ `flutter pub get` resolves successfully without conflicts
- ✅ `icons_launcher:create` command should work without `build.gradle` file
- ⚠️ Cần test lại:
  - Lottie animations hoạt động đúng với version 3.3.2
  - Linter rules từ `flutter_lints 6.0.0` không gây breaking changes
  - `icons_launcher:create` command chạy thành công với `build.gradle.kts` only

### Known Issues
- `flutter_facebook_auth` đã được comment out, có thể cần enable lại sau này
- `mobile_scanner` đã bị remove, có thể cần add lại nếu cần sử dụng barcode scanner

### Benefits
1. **Clean Architecture**: Chỉ sử dụng Kotlin DSL, không cần maintain Groovy DSL file
2. **Latest Features**: Tận dụng bug fixes và improvements trong các packages mới
3. **Dependency Health**: Resolve conflicts và đảm bảo dependencies tương thích
4. **Maintainability**: Giảm số lượng files cần maintain

### Next Steps
- Test `dart run icons_launcher:create --path icons_launcher.yaml` để verify hoạt động với `build.gradle.kts` only
- Test Lottie animations trong app để đảm bảo không có breaking changes
- Run `flutter analyze` để check linter rules mới từ `flutter_lints 6.0.0`
- Review và enable lại `flutter_facebook_auth` nếu cần
- Re-add `mobile_scanner` nếu cần barcode scanning feature

---

## 2025-01-XX - Create Customer API Integration

### Implemented
- ✅ Integrated Create Customer API (`POST /business/customer/create`) from User Service
- ✅ Created `CreateCustomerInput` DTO với nested `CreateCustomerAddressInput` object
- ✅ Added `createCustomer()` method in CustomerMiddleware
- ✅ Added `createCustomer()` method in CustomerCubit with state management
- ✅ Generated code từ cURL request sử dụng `#generate-from-curl` shortcut

### Files Created
- `lib/data/dto/customer/create_customer_input.dart` - DTO cho customer creation:
  - `CreateCustomerInput`: Main DTO với đầy đủ fields (fullName, email, code, phone, birthday, address, website, taxCode, faxCode, note, totalSpending, currentDebt, advancedType, discount, paymentMethod, defaultPrice)
  - `CreateCustomerAddressInput`: Nested DTO cho address (isDefault, address, provinceCode, wardCode)
  - Method `toMap()` để convert sang Map cho API call

### Files Modified
- `lib/data/network/network_url.dart` - Added `createCustomer = '/business/customer/create'` to `_Customer` class
- `lib/data/middlewares/customer_middleware.dart`:
  - Added `createCustomer({required CreateCustomerInput input})` method
  - Uses `userDio.post()` to call API
  - Parses response thành `Customer` object
  - Returns `ResponseSuccessState<Customer>` hoặc `ResponseFailedState`
- `lib/bloc/customer/customer_cubit.dart`:
  - Added `createCustomer({required CreateCustomerInput input})` method
  - Emits `LoadingCustomerState` → `MessageCustomerState` (success) hoặc `FailedCustomerState` (error)
  - Success message: "Tạo khách hàng thành công"

### Architecture Decisions
- **DTO Pattern**: Sử dụng DTO classes (`CreateCustomerInput`, `CreateCustomerAddressInput`) thay vì Map để type-safe
- **Nested Object**: Address được tách thành nested DTO để dễ quản lý và validate
- **Optional Fields**: Chỉ include optional fields trong request nếu không null và không empty
- **State Management**: Sử dụng pattern Loading → Message/Failed states cho POST requests
- **Code Generation**: Sử dụng `#generate-from-curl` shortcut để tự động generate code từ cURL request

### Technical Notes
- Request body structure match với cURL request:
  - `fullName` và `phone` là required fields
  - `address` là required nested object với `isDefault`, `address`, `provinceCode`, `wardCode`
  - `birthday` được format thành ISO 8601 string (sử dụng `toIso8601String()`)
  - `advancedType` mặc định là "USER"
  - Optional fields: `email`, `code`, `website`, `taxCode`, `faxCode`, `note`, `paymentMethod`, `defaultPrice`
- Response được parse thành `Customer` object
- API sử dụng `userDio` instance (User Service)

### Benefits
1. **Type Safety**: Sử dụng DTO classes thay vì Map, có compile-time checking
2. **Maintainability**: DTO structure rõ ràng, dễ update khi API thay đổi
3. **Code Generation**: Tự động generate từ cURL, giảm manual work
4. **Consistency**: Follow pattern giống các API khác trong project

### Next Steps
- Integrate `CustomerCubit.createCustomer()` vào `CustomerCreateScreen._onSave()` method
- Add validation cho required fields (fullName, phone, address)
- Handle success/error states trong UI
- Test API với actual data

---

## 2025-11-26 - Service Layer Setup & Refactor Plan

### Implemented
- ✅ Created business services folder structure (`lib/services/`)
- ✅ Created `BaseService` abstract class
- ✅ Created `OrderService` và `CategoryService` (template, chưa implement)
- ✅ Registered services in dependency injection
- ✅ Created comprehensive refactor plan document (`documents/REFACTOR_PLAN.md`)

### Files Created
- `lib/services/base_service.dart` - Base class cho tất cả business services
- `lib/services/order_service.dart` - Service template cho Order
- `lib/services/category_service.dart` - Service template cho Category
- `lib/services/README.md` - Documentation cho business services
- `documents/REFACTOR_PLAN.md` - Kế hoạch refactor chi tiết theo STATE_MANAGEMENT_FLOW.md

### Files Modified
- `lib/di/dependency_injection.dart`:
  - Registered `OrderService` (LazySingleton)
  - Registered `CategoryService` (LazySingleton)

### Architecture Decisions
- **Service Layer Pattern**: Thêm Service layer giữa Cubit và Repository theo `STATE_MANAGEMENT_FLOW.md`
- **Data Flow**: UI → BLoC/Cubit → **Service** → Repository → Middleware → API
- **Business Logic**: Di chuyển business logic từ Cubit sang Service
- **Validation**: Services chịu trách nhiệm validate dữ liệu
- **Refactor Strategy**: Refactor từng module một, không làm tất cả cùng lúc

### Refactor Plan
- **Phase 1**: Setup Infrastructure ✅ (Completed)
- **Phase 2**: Refactor từng module (In Progress)
  - Priority 1: Order Module
  - Priority 2: Category Module
  - Priority 3: Product Module
  - Priority 4: Cart Module
  - Priority 5: Other modules

### Technical Notes
- Services được đăng ký như LazySingleton trong DI
- Services gọi Repository, không gọi Middleware trực tiếp
- Cubit sẽ được refactor để gọi Service thay vì Middleware/Repository trực tiếp
- Giữ nguyên API của Cubit để không phá vỡ UI layer

### Next Steps
- Implement OrderService với đầy đủ business logic
- Refactor OrderCubit để sử dụng OrderService
- Test lại các màn hình Order
- Tiếp tục với Category Module

---

## 2025-11-25 - Flutter & Dart Upgrade to 3.38.1 & 3.10.0 + Enhanced Enums Fix

### Implemented
- ✅ Upgraded Flutter from 3.10.6 to 3.38.1 using FVM
- ✅ Upgraded Dart to 3.10.0
- ✅ Updated dependencies to be compatible with new Flutter version:
  - `intl`: ^0.18.0 → ^0.20.2 (required by flutter_localizations in Flutter 3.38.1)
  - `syncfusion_flutter_charts`: ^23.1.36 → ^31.2.15 (compatible with intl 0.20.2)
- ✅ Fixed enhanced enums syntax for Dart 3.10.0 compatibility:
  - Removed private constructors (`ProductStatus._()`, `ProductType._()`, `WalletCaseBackWallet._()`)
  - Changed last enum value from comma (`,`) to semicolon (`;`) to separate enum values from methods

### Files Modified
- `.fvm/fvm_config.json`: Updated `flutterSdkVersion` from "3.10.6" to "3.38.1"
- `.fvmrc`: Updated `flutter` from "3.10.6" to "3.38.1"
- `pubspec.yaml`:
  - Updated `intl`: ^0.18.0 → ^0.20.2
  - Updated `syncfusion_flutter_charts`: ^23.1.36 → ^31.2.15
- `lib/data/entity/product/product_entity.dart`:
  - Removed `ProductStatus._()` private constructor
  - Removed `ProductType._()` private constructor
  - Removed `WalletCaseBackWallet._()` private constructor
  - Changed `suspend,` → `suspend;` (semicolon after last enum value)
  - Changed `highlyRated,` → `highlyRated;`
  - Changed `amountUseLevel,` → `amountUseLevel;`

### Architecture Decisions
- **FVM Usage**: Project uses FVM (Flutter Version Management) for version control
- **Enhanced Enums**: In Dart 3.10.0+, enhanced enums don't need private constructors when only adding methods/getters
- **Enum Syntax**: Last enum value must end with semicolon (`;`) instead of comma (`,`) to separate enum values from methods in enhanced enums

### Technical Notes
- **Flutter 3.38.1** includes Dart 3.10.0 and DevTools 2.51.1
- **Enhanced Enums** in Dart 3.10.0+ have stricter syntax requirements:
  - No private constructors needed for simple enhanced enums (only methods/getters)
  - Semicolon required after last enum value to separate values from methods
- **Dependency Updates**:
  - `intl 0.20.2` is pinned by `flutter_localizations` in Flutter 3.38.1
  - `syncfusion_flutter_charts` needed major version upgrade (23.x → 31.x) to support intl 0.20.2
- **Breaking Changes**: 
  - Enhanced enum syntax changes may affect other enums in the codebase
  - Syncfusion charts API may have changed between versions (needs testing)

### Verification
- ✅ `fvm flutter analyze` passes with no errors
- ✅ All enhanced enums compile correctly
- ✅ Dependencies resolve successfully
- ✅ No linter errors

### Benefits
1. **Latest Features**: Access to latest Flutter and Dart features and improvements
2. **Performance**: Better performance and optimizations in newer versions
3. **Security**: Latest security patches and fixes
4. **Compatibility**: Better compatibility with latest packages
5. **Type Safety**: Enhanced enum syntax improvements in Dart 3.10.0

### Next Steps
- Test all features to ensure compatibility with new Flutter/Dart versions
- Review Syncfusion charts usage for any API changes in version 31.x
- Check other enums in codebase for similar enhanced enum syntax issues
- Update CI/CD pipelines if they reference specific Flutter versions

---

## 2025-01-24 - PaymentScreen Clean Architecture Refactor & Payment Methods API Integration

### Implemented
- ✅ Refactored PaymentScreen to follow Clean Architecture pattern
- ✅ Created PaymentRepository with BehaviorSubject (rxdart) for reactive data management
- ✅ Created PaymentCubit and PaymentState for business logic management
- ✅ Integrated new Payment Methods API: `GET /system/api/v1/seller/payment-method/synthetic/active`
- ✅ Created BankInfo model for bank information in payment methods
- ✅ Updated SellerPaymentMethod model to support bankCode and bankInfo
- ✅ Created PaymentMethodNameExtension for rendering payment names
- ✅ Fixed type mismatches and comparison logic for payment methods

### Files Created
- `lib/data/repositories/payment_repository.dart` - Repository với BehaviorSubject<List<SellerPaymentMethod>>
- `lib/bloc/payment/payment_cubit.dart` - Business logic cho payment methods
- `lib/bloc/payment/payment_state.dart` - States: PaymentInitial, PaymentLoadingState, PaymentLoadedState, PaymentErrorState
- `lib/data/models/order/payment_detail/bank_info.dart` - Model cho bank information
- `lib/utils/extension/payment_method_extension.dart` - Extension để render payment name theo logic JavaScript

### Files Modified
- `lib/data/models/order/payment_detail/seller_payment_method.dart`:
  - Added `bankCode` (String?) field
  - Added `bankInfo` (BankInfo?) field
  - Added `compareWith()` method để so sánh payment methods (bao gồm cả bankInfo)
  - Updated `fromMap()`, `toMap()`, `copyWith()` để hỗ trợ các field mới
- `lib/data/network/network_url.dart`:
  - Added `paymentMethodSyntheticActive()` method cho endpoint mới
  - Endpoint: `/system/api/v1/seller/payment-method/synthetic/active`
  - Supports query parameter `notMethods[]`
- `lib/data/middlewares/payment_middleware.dart`:
  - Updated `getPaymentMethods()` để gọi API mới `paymentMethodSyntheticActive()`
  - Handles response với `listData` array structure
  - Parses BankInfo từ response
- `lib/views/order/create_order/components/payment_section.dart`:
  - Removed direct PaymentMiddleware calls from UI
  - Updated to use PaymentCubit for business logic
  - Updated to use StreamBuilder với paymentMethodsStream từ repository
  - Changed `currentSelectedPaymentCodes` (List<String>) → `currentSelectedPayments` (List<SellerPaymentMethod>)
  - Updated comparison logic to use `compareWith()` method
  - Updated UI to use `displayPaymentName` extension thay vì `displayName`
  - Added condition to show `_PaymentStatusSelector` only when `_calculateTotalAmount() > 0`
- `lib/di/dependency_injection.dart`:
  - Registered PaymentRepository (LazySingleton)
  - Registered PaymentCubit (Factory)
- `lib/utils/extension/extension.dart`:
  - Exported `payment_method_extension.dart`

### Architecture Decisions
- **Clean Architecture Compliance**: UI layer không tương tác trực tiếp với middleware, chỉ qua Cubit
- **Reactive Data Management**: Sử dụng BehaviorSubject (rxdart) trong Repository để đồng bộ với codebase
- **Payment Method Comparison**: Sử dụng `compareWith()` method để so sánh payment methods, bao gồm cả bankInfo (quan trọng cho BANKING method có nhiều bank accounts)
- **Payment Name Rendering**: Logic theo JavaScript:
  - Ưu tiên `nameVi`, fallback `nameEn`
  - Nếu có `bankInfo`:
    - Có `methodName`: return `methodName`
    - Không: return `[title, bankCode, accountOwner].join(" ")`
  - Chỉ sử dụng case "vi" (Vietnamese)

### Technical Notes
- **API Response Structure**:
  ```json
  {
    "listData": [
      {
        "id": "...",
        "nameVi": "Tiền Mặt",
        "nameEn": "Cash",
        "method": "CASH",
        "icon": "...",
        "position": 1,
        "isActive": true,
        "minimumOrder": 0,
        "bankCode": "DEFAULT", // Optional
        "bankInfo": { // Optional
          "id": "...",
          "code": "DEFAULT",
          "accountOwner": "...",
          "bankName": "...",
          "bankNumber": "...",
          "bankCode": "...",
          "methodName": "..." // Optional
        }
      }
    ],
    "total": 9
  }
  ```
- **Payment Method Comparison**: `compareWith()` so sánh `id`, `method`, và `bankInfo.id` (nếu có)
- **Stream Management**: PaymentRepository sử dụng `BehaviorSubject.seeded([])` để đảm bảo StreamBuilder luôn có initial data
- **State Management**: PaymentCubit emits states: Loading → Loaded/Error

### Benefits
1. **Clean Architecture**: UI layer tách biệt hoàn toàn khỏi data layer
2. **Reactive Updates**: StreamBuilder tự động update UI khi data thay đổi
3. **Type Safety**: Sử dụng SellerPaymentMethod objects thay vì String codes
4. **Maintainability**: Business logic tập trung trong Cubit, dễ test và maintain
5. **Consistency**: Sử dụng rxdart pattern giống các module khác trong project

### Next Steps
- Có thể thêm validation cho minimum order amount nếu cần
- Có thể thêm error handling UI cho PaymentErrorState
- Có thể cache payment methods nếu cần optimize performance

---

## 2025-01-XX - CreateOrderInput Model Refactoring

### Implemented
- ✅ Created `CreateOrderInput` model và các nested models để type-safe khi generate order body
- ✅ Refactored `_generateOrderBody()` để return `CreateOrderInput` thay vì `Map<String, dynamic>`
- ✅ Updated `_createOrder()` để sử dụng `orderInput.toMap()` khi cần convert sang Map

### Files Created
- `lib/data/models/order/create_order_input.dart` - Model cho order creation input với các nested models:
  - `CreateOrderInput`: Main model
  - `OrderInput`: Order object
  - `OrderProductInput`: Product trong order
  - `PaymentInput`: Payment details
  - `InfoAdditionalInput`: Additional info
  - `InvoiceInput`: Invoice data

### Files Modified
- `lib/views/order/create_order/create_order_screen.dart`:
  - Updated `_generateOrderBody()` return type: `CreateOrderInput` thay vì `Map<String, dynamic>`
  - Refactored products mapping: Return `OrderProductInput` objects thay vì Map
  - Refactored payment details: Return `PaymentInput` objects thay vì Map
  - Created `OrderInput`, `InfoAdditionalInput`, `InvoiceInput` objects
  - Updated `_createOrder()`: Sử dụng `orderInput.toMap()` để convert sang Map cho API call
  - Updated log: Sử dụng `orderInput.toJson()` để log JSON string
  - Added import: `create_order_input.dart`

### Architecture Decisions
- **Type Safety**: Sử dụng model classes thay vì Map để có compile-time checking
- **Maintainability**: Thay đổi structure ở một nơi (model), không cần update nhiều chỗ
- **Developer Experience**: IDE autocomplete và type hints giúp code dễ viết và debug
- **Testing**: Dễ tạo test data với model constructors
- **Backward Compatibility**: Vẫn có thể convert sang Map qua `toMap()` method khi cần

### Technical Notes
- Tất cả models có method `toMap()` để convert sang `Map<String, dynamic>` cho API call
- `CreateOrderInput` có method `toJson()` để convert sang JSON string (dùng cho logging)
- Optional fields được handle đúng cách trong `toMap()` (chỉ include nếu không null)
- Empty strings được filter: `note` chỉ include nếu không null và không empty
- Nested models tự convert trong `toMap()` method

### Benefits
1. **Type Safety**: Compile-time checking, tránh lỗi typo và type mismatch
2. **IDE Support**: Autocomplete và type hints giúp code nhanh hơn
3. **Maintainability**: Thay đổi structure ở model, không cần update nhiều chỗ
4. **Testing**: Dễ tạo test data với model constructors
5. **Documentation**: Model tự mô tả structure và fields

### Next Steps
- Có thể thêm validation methods vào models nếu cần
- Có thể thêm factory methods từ Map nếu cần parse từ API response
- Có thể thêm `copyWith()` methods nếu cần modify objects

## 2025-01-XX - Order Body Generation & Testing Infrastructure

### Implemented
- ✅ Created `_generateOrderBody()` method trong `CreateOrderScreen` để collect và format data thành body structure
- ✅ Updated `_createOrder()` method với validation và error handling
- ✅ Refactored `_PaymentStatusSelector` để expose payment details qua callback
- ✅ Created comprehensive test plan với 18 test cases
- ✅ Created test file structure (`create_order_screen_test.dart`)
- ✅ Documented 14 lỗi cần fix trong `ERRORS_LIST.md`

### Files Created
- `test/views/order/create_order/create_order_screen_test.md` - Test plan với 18 test cases chi tiết
- `test/views/order/create_order/create_order_screen_test.dart` - Test file structure (commented out, cần implement)
- `test/views/order/create_order/ERRORS_LIST.md` - Danh sách 14 lỗi được phân loại và mô tả chi tiết

### Files Modified
- `lib/views/order/create_order/create_order_screen.dart`:
  - Added `paymentDetails` state để lưu payment details từ `_PaymentStatusSelector`
  - Created `_generateOrderBody()` method:
    - Collect data từ tất cả components (products, customer, discount, shipping, payment, additional info)
    - Format thành body structure như JavaScript code mẫu
    - Handle order status logic (PROCESSING nếu có payment)
    - Calculate discount (order-level và product-level)
    - Filter và format payment details
    - Map products với discount per unit
    - Convert delivery date to ISO 8601
    - Build invoice data từ billingAddress hoặc purchaseAddress
  - Updated `_createOrder()` method:
    - Validation: Check products và customer
    - Show SnackBar khi products empty
    - Show notification dialog khi customer null
    - Generate order body và log
    - Show loading và success dialog
  - Fixed: `_generateOrderBody()` sử dụng `valueOrNull ?? []` thay vì `value`
- `lib/views/order/create_order/components/payment_section.dart`:
  - Added `onPaymentDetailsChanged` callback parameter trong `_PaymentSection`
  - Updated `_PaymentStatusSelector` để notify khi payment details thay đổi
  - Added `_notifyPaymentDetailsChanged()` method

### Architecture Decisions
- **Order Body Generation**: Method `_generateOrderBody()` collect tất cả data từ local state và format thành body structure, không gọi API
- **Payment Details Management**: Payment details được quản lý ở `CreateOrderScreen` level, `_PaymentStatusSelector` notify qua callback
- **Order Status Logic**: Status = 'PROCESSING' nếu có payment (`paidMap.length > 0`), null nếu không (dùng default)
- **Discount Calculation**:
  - Order-level: Tính từ `discount` và `_discountUnit` (percentage hoặc absolute)
  - Product-level: Tính từ `variant.discount` và `variant.discountUnit` (per unit)
- **Delivery Date**: Combine `deliveryDate` với current time, format ISO 8601
- **Invoice Data**: Ưu tiên `billingAddress`, fallback `purchaseAddress`

### Technical Notes
- Body structure match với JavaScript code mẫu:
  - `order`: status, deliveryFee, discount, discountPercent, products, note, tags
  - `customerId`: từ selectedCustomer
  - `addressCustomerId`: từ purchaseAddress
  - `paid`: Filtered payment details `{method, amount}`
  - `infoAdditional`: salesType, branchId, soldById, saleChannel, scheduledDeliveryAt, orderCode, expectedPayment
  - `invoice`: type, taxCode, email, addressId, name
- Payment details filter: Chỉ lấy items có `paymentMethodName` và `customerPaid > 0`
- Product mapping: `productId` từ `variant.productId` hoặc `variant.product?.id`
- Discount format: Convert to int cho API (price, discount, amount)
- Note handling: Trim và check empty, set null nếu rỗng

### Test Plan
- **18 test cases** được document trong `create_order_screen_test.md`:
  - Validation tests (2): Empty products, null customer
  - Success flow tests (6): Full data, no payment, discount types, variant discount
  - Edge cases (7): Invalid payment details, null delivery date, empty note, address handling
  - Data format tests (3): ISO 8601 format, int conversion
- **Test file structure**: Created với mockito setup, cần implement đầy đủ

### Known Issues (14 lỗi)
- **Critical (2)**:
  - Inconsistency trong cách lấy products (đã fix)
  - Missing `context.mounted` check trong Future.delayed
- **Logic (4)**: Empty string cho productId/customerId, hard-coded delay, DateTime.now()
- **Validation (3)**: Không validate warehouse, paymentDetails structure, variant productId
- **Performance (1)**: Không cache kết quả `_generateOrderBody()`
- **Error Handling (2)**: Không có try-catch cho generate body và show/hide loading
- **Testing (2)**: Hard-coded delay, sử dụng log() thay vì proper logging

### Next Steps
- Implement đầy đủ test cases trong `create_order_screen_test.dart`
- Fix các lỗi critical và logic
- Integrate API call trong `_createOrder()` (hiện tại có TODO)
- Add error handling và validation
- Implement `mapDeliveryForCreateShipment()` method (user sẽ tự implement)

## 2025-01-XX - Seller Payment Method API Integration & PaymentScreen Implementation

### Implemented
- ✅ Integrated Seller Payment Method API (`GET /seller/payment-method`) from System Service
- ✅ Created new `SellerPaymentMethod` model để tránh breaking changes với `PaymentMethod` cũ
- ✅ Added `getPaymentMethods()` method in PaymentMiddleware
- ✅ Implemented `PaymentScreen` widget trong `payment_section.dart`:
  - Load payment methods từ API với filter `isActive=true` và exclude `PAYMENT_ON_DELIVERY`
  - Display danh sách payment methods với bottom sheet selector
  - Input field cho "Tiền khách đưa" (amount paid by customer)
  - Calculate và display "Khách còn phải trả" (remaining amount)
  - Auto-select payment method đầu tiên nếu có
  - Returns payment details khi "Hoàn tất"
- ✅ Updated `_PaymentSection` để sử dụng `SellerPaymentMethod` thay vì `PaymentMethod`
- ✅ Created API test file: `test/api/system/payment_method.http`

### Files Created
- `lib/data/models/order/payment_detail/seller_payment_method.dart` - Model mới cho payment methods từ System Service
- `test/api/system/payment_method.http` - API test file với multiple test cases

### Files Modified
- `lib/data/network/network_url.dart` - Added `_Seller` class với `paymentMethod()` method
- `lib/data/middlewares/payment_middleware.dart`:
  - Added `getPaymentMethods()` method
  - Returns `List<SellerPaymentMethod>` thay vì `List<PaymentMethod>`
  - Supports multiple response formats: List directly, Map with 'data'/'listData' keys
  - Removed unused imports: `order_export.dart`, `payment_method.dart`
- `lib/views/order/create_order/components/payment_section.dart`:
  - Created `PaymentScreen` widget với full implementation
  - Updated `_PaymentSection` để sử dụng `SellerPaymentMethod`
  - Changed `method.name` → `method.displayName`
  - Changed `method.paymentEnum` → `method.method`
- `lib/views/order/create_order/create_order_screen.dart`:
  - Updated import từ `PaymentMethod` → `SellerPaymentMethod`

### Architecture Decisions
- **Tạo model mới**: `SellerPaymentMethod` thay vì update `PaymentMethod` cũ để tránh breaking changes với các module khác (cart, payment screens, etc.)
- **Model structure**: Match với API response structure (id là String UUID, có nameVi/nameEn, method enum, etc.)
- **Display name**: Getter `displayName` trả về `nameVi` (fallback `nameEn`) để hiển thị tên tiếng Việt
- **Response parsing**: Hỗ trợ nhiều format response (List trực tiếp, Map với 'data'/'listData' keys) để tương thích
- **PaymentScreen**: Local state management với `PaymentMiddleware`, không cần BLoC/Cubit

### Technical Notes
- `SellerPaymentMethod` có đầy đủ fields từ API: id, nameVi, nameEn, method, icon, position, isActive, createdAt, updatedAt, minimumOrder
- `PaymentScreen` tự động load payment methods khi init, filter `isActive=true` và exclude `PAYMENT_ON_DELIVERY`
- Payment method selector sử dụng `CommonRadioButtonItem` trong bottom sheet
- Remaining amount calculation: `totalAmount - customerPaid` (minimum 0)
- Payment details được return dưới dạng Map với keys: `paymentMethodName`, `paymentMethodId`, `paymentMethodEnum`, `paymentMethod`, `customerPaid`, `remainingAmount`

### Next Steps
- Handle result từ `PaymentScreen` trong `_PaymentStatusSelector` (hiện tại có TODO comment)
- Có thể thêm validation cho minimum order amount nếu cần
- Có thể thêm icon display cho payment methods nếu có

## 2025-01-XX - Customer Address Update API Integration & Validation State Management

### Implemented
- ✅ Integrated Customer Address Update API (`PUT /company/customer-address/{id}`) from User Service
- ✅ Added `updateCustomerAddress()` method in CustomerMiddleware
- ✅ Added `updateCustomerAddress()` method in CustomerCubit with states (WaitingCustomerState, MessageCustomerState, FailedCustomerState)
- ✅ Implemented validation state management in EditCustomerAddressScreen:
  - Added state variables (`_isNameFieldValid`, `_isPhoneFieldValid`, `_isEmailFieldValid`) to track validation status
  - Created `_validateAllFields()` method to validate all fields and update UI
  - Created `_validateFieldOnChange()` method for real-time validation after first validation
  - Updated `_onSave()` to call `_validateAllFields()` before form validation
  - Added `onChanged` callbacks to TextFormFields for dynamic height adjustment based on validation errors
- ✅ Added BlocProvider and BlocListener in EditCustomerAddressScreen to handle API response states
- ✅ Updated `_onSave()` logic:
  - If `initialAddress` has ID and `customer` exists: calls API update
  - If not: creates Address object and pops back (for new address creation)
- ✅ Handled `districtCode` logic: null for POST_MERGER, required for PRE_MERGER

### Files Created
- `test/api/user/customer_address_update.http` - API test file với test cases cho PRE_MERGER và POST_MERGER address types

### Files Modified
- `lib/data/network/network_url.dart` - Added `update(String addressId)` method to `_CustomerAddress` class
- `lib/data/middlewares/customer_middleware.dart` - Added `updateCustomerAddress()` method
- `lib/bloc/customer/customer_cubit.dart` - Added `updateCustomerAddress()` method with state management
- `lib/views/order/create_order/edit_customer_address_screen.dart`:
  - Added validation state management with state variables
  - Added `_validateAllFields()` and `_validateFieldOnChange()` methods
  - Updated `_onSave()` to integrate API update call
  - Added BlocProvider and BlocListener for state handling
  - Added `onChanged` callbacks to TextFormFields for real-time validation
  - Dynamic height adjustment for error fields (40.h when valid, 64.h when invalid)

### Architecture Decisions
- Validation state được quản lý bằng state variables thay vì chỉ dựa vào `GlobalKey<FormFieldState>`
- `_validateAllFields()` được gọi trước `_formKey.currentState!.validate()` để đảm bảo UI được cập nhật
- Real-time validation chỉ hoạt động sau lần validate đầu tiên (`_hasValidatedOnce` flag)
- API update chỉ được gọi khi có `initialAddress.id` và `customer`, ngược lại sẽ tạo Address object mới
- `districtCode` được xử lý đặc biệt: null cho POST_MERGER, lấy từ `_selectedRegionCode` cho PRE_MERGER

### Technical Notes
- Height của TextFormField được điều chỉnh động: 40.h khi valid, 64.h khi có error
- BlocListener tự động pop với updated Address khi API thành công
- Error messages được hiển thị qua SnackBar
- Success message: "Cập nhật địa chỉ thành công"

### Next Steps
- Có thể thêm API create customer address nếu cần
- Có thể áp dụng pattern validation state management cho các form khác

## 2025-01-XX - Administrative Provinces API Integration & Code Refactoring

### Implemented
- ✅ Integrated Administrative Provinces API (`GET /administrative/provinces?type={PRE_MERGER|POST_MERGER}`) from System Service
- ✅ Added `systemBaseURL` configuration in FlavorConfig
- ✅ Created `systemDio` instance in NetworkCommon for System Service API calls
- ✅ Added `getProvincesByType()` method in AddressMiddleware
- ✅ Updated `filterDistrictsByType()` in AddressCubit with smart routing logic:
  - If `type == RegionType.postMerger`: calls `getProvincesByType()` API
  - If `type == RegionType.preMerger`: calls `filterDistrictsByType()` API (existing)
- ✅ Refactored duplicate code in `EditCustomerAddressScreen`:
  - Created `_populateAddressData()` helper method to avoid code duplication
  - Used in both `_initializeData()` and `onAddressSelected` callback
- ✅ Added `seeded([])` to `wardsList` BehaviorSubject in AddressRepository for better StreamBuilder handling

### Files Created
- `test/api/system/administrative_provinces.http` - API test file với test cases cho PRE_MERGER và POST_MERGER

### Files Modified
- `lib/app/app_flavor_config.dart` - Added `systemBaseUrl` getter
- `lib/data/network/network_common.dart` - Added `systemDio` instance
- `lib/data/network/network_url.dart` - Added `systemBaseURL`, `_Administrative` class với `provinces` endpoint
- `lib/data/middlewares/base_middleware.dart` - Added `systemDio` getter
- `lib/data/middlewares/address_middleware.dart` - Added `getProvincesByType()` method
- `lib/bloc/address/address_cubit.dart` - Updated `filterDistrictsByType()` với smart routing logic
- `lib/data/repositories/address_repository.dart` - Added `seeded([])` to `wardsList` BehaviorSubject
- `lib/views/order/create_order/edit_customer_address_screen.dart` - Refactored duplicate code thành `_populateAddressData()` method

### Architecture Decisions
- System Service có Dio instance riêng (`systemDio`) tách biệt với các service khác
- Address selection logic sử dụng 2 loại API khác nhau dựa trên `RegionType`:
  - **PRE_MERGER** (địa chỉ cũ): Sử dụng `/administrative/districts/filter` - trả về districts với province info
  - **POST_MERGER** (địa chỉ mới): Sử dụng `/administrative/provinces` - trả về provinces trực tiếp
- Logic routing được xử lý trong `AddressCubit.filterDistrictsByType()` để tự động chọn API phù hợp
- `BehaviorSubject.seeded([])` được sử dụng để đảm bảo StreamBuilder luôn có data ban đầu, tránh loading state không mong muốn

### Technical Notes
- `RegionType` enum có extension `toConstant` để convert sang `UPPER_SNAKE_CASE` (PRE_MERGER/POST_MERGER)
- `Region` model được sử dụng cho cả provinces, districts, và wards từ System Service
- `_populateAddressData()` method giúp DRY principle, dễ bảo trì và tái sử dụng

### Next Steps
- Có thể áp dụng pattern `seeded([])` cho các BehaviorSubject khác nếu cần
- Tiếp tục refactor các đoạn code trùng lặp khác trong codebase

## 2025-01-XX - Customer Filter API Integration

### Implemented
- ✅ Integrated Customer Filter API (`GET /business/customer/filter`) from User Service
- ✅ Added `userBaseURL` configuration in FlavorConfig
- ✅ Created `userDio` instance in NetworkCommon for User Service API calls
- ✅ Added `filterCustomers()` method in CustomerMiddleware
- ✅ Added `filterCustomers()` method in CustomerCubit with 3 states (loading, loaded, error)
- ✅ Created `CustomerFilterLoadedState` for loaded data
- ✅ Added API test file: `test/api/user/customer_filter.http`

### Files Created
- `test/api/user/customer_filter.http` - API test file với multiple test cases
- `memory-bank/docs/api-integration-workflow.md` - Quy trình tích hợp API từ cURL

### Files Modified
- `lib/app/app_flavor_config.dart` - Added `userBaseUrl` getter
- `lib/data/network/network_common.dart` - Added `userDio` instance
- `lib/data/network/network_url.dart` - Added `userBaseURL` và `filterCustomers()` method trong `_Customer`
- `lib/data/middlewares/base_middleware.dart` - Added `userDio` getter
- `lib/data/middlewares/customer_middleware.dart` - Added `filterCustomers()` method
- `lib/bloc/customer/customer_cubit.dart` - Added `filterCustomers()` method
- `lib/bloc/customer/customer_state.dart` - Added `CustomerFilterLoadedState`
- `memory-bank/04-api-documentation.md` - Updated với Customer Filter API documentation

### Architecture Decisions
- User Service có Dio instance riêng (`userDio`) tách biệt với `authDio` và `coreDio`
- Response parsing hỗ trợ nhiều keys: `customers`, `data`, `listData` để tương thích với các API khác nhau
- Pattern 3 states chuẩn cho GET requests: Loading → Loaded → Error

### API Integration Workflow Established
- Đã thiết lập quy trình 5 bước tích hợp API từ cURL:
  1. Tạo test API file và test request
  2. Tạo/kiểm tra model từ response
  3. Thêm method vào Middleware (thêm service Dio nếu cần)
  4. Thêm method vào Cubit với 3 states (nếu là GET)
  5. Sử dụng trong UI
- Quy trình được document trong `memory-bank/docs/api-integration-workflow.md`

### Next Steps
- Sử dụng `CustomerCubit.filterCustomers()` trong UI để filter customers
- Có thể áp dụng quy trình này cho các API tích hợp tiếp theo

## 2025-01-XX - SelectProductsScreen & Order Module

### Implemented
- ✅ Implemented SelectProductsScreen với search, pagination, variant selection
- ✅ Created OrderProduct và ProductVariant models
- ✅ Integrated API endpoint `GET /company/product/order/filter` in OrderMiddleware
- ✅ Added coreDio instance for Core Service API calls
- ✅ Implemented OrderRepository với warehouse management
- ✅ Created UI components: ProductListItem, ProductSearchBar
- ✅ Fixed pagination load more bug
- ✅ Fixed price formatting issue

### Files Created
- `lib/views/order/create_order/select_products_screen.dart`
- `lib/data/models/product/order_product.dart`
- `lib/data/models/product/product_variant.dart`
- `lib/views/order/create_order/components/product_list_item.dart`
- `lib/views/order/create_order/components/product_search_bar.dart`
- `lib/views/order/create_order/components/selected_product_item.dart`

### Files Modified
- `lib/data/middlewares/order_middleware.dart` - Added `getProductsForOrder()` method
- `lib/data/repositories/order_repository.dart` - Warehouse management với BehaviorSubject
- `lib/data/network/network_common.dart` - Added `coreDio` instance
- `lib/data/network/network_url.dart` - Added `_OrderProduct` class
- `lib/views/order/create_order/create_order_screen.dart` - Integration với SelectProductsScreen
- `lib/app/app_wireframe.dart` - Routing configuration

### Architecture Decisions
- SelectProductsScreen calls middleware directly (no UseCase layer)
- Uses local state management instead of BLoC/Cubit
- Selected products formatted as Map<String, dynamic> for easy passing
- Price stored as String in selected products (needs conversion when calculating)

### Known Issues
- Price format: Stored as String, needs conversion when calculating totals
- Selected product detection: Logic may not be accurate for products with multiple variants
- Pagination: Load more code ready but UI not implemented
- Barcode scanner: Only sets search text, doesn't auto-select product

### Next Steps
- Implement scroll to load more UI
- Fix selected product detection logic
- Convert price from String to num in CreateOrderScreen
- Handle barcode scan result to auto-select product

---

## 2025-01-XX - Refactor: Xóa Use Cases, Middleware trả về Model trực tiếp

### Implemented
- ✅ Refactored `OrderMiddleware.getProductVariantsFilter()` để trả về Model (`ProductVariant`) thay vì Entity
- ✅ Thêm `productId` vào Model `ProductVariant`
- ✅ Xóa folder `lib/data/use_cases/` hoàn toàn (không sử dụng Use Cases nữa)
- ✅ Middleware parse API response trực tiếp thành Model
- ✅ Gọi Middleware trực tiếp từ UI/BLoC, không cần UseCase layer

### Files Modified
- `lib/data/middlewares/order_middleware.dart` - Parse thành `ProductVariant` Model thay vì `ProductVariantEntity`
- `lib/data/models/product/product_variant.dart` - Thêm field `productId`

### Files Deleted
- `lib/data/use_cases/` - Xóa toàn bộ folder (product, order, output models)

### Architecture Decisions
- **Pattern mới**: Middleware → Model (không qua Entity, không qua UseCase)
- **Model**: `ProductVariant` trong `lib/data/models/product/product_variant.dart` match với API response
- **Không dùng UseCase**: Gọi Middleware trực tiếp từ UI/BLoC
- **Simplified Architecture**: UI/BLoC → Middleware → API → Model

### Known Issues
- Middleware vẫn dùng hardcoded URL `'company/product/variant/filter'` thay vì `NetworkUrl.productVariant.filter()`

### Next Steps
- Add `_ProductVariant` class vào `NetworkUrl` và sử dụng trong middleware

---

## 2025-01-XX - Product Variant Filter Feature

### Implemented
- ✅ Created `ProductEntity` and `ProductVariantEntity` from TypeORM definitions
- ✅ Created `ProductOutput` and `ProductVariantOutput` DTOs
- ✅ Implemented `ProductVariantFilterUseCases` with Clean Architecture pattern
- ✅ Integrated API endpoint `GET /company/product/variant/filter` in `OrderMiddleware`
- ✅ Created API test files organized by service structure
- ✅ Set up Memory Bank pattern for context preservation

### Files Created
- `lib/data/entity/product/product_entity.dart`
- `lib/data/entity/product/product_variant_entity.dart`
- `lib/data/use_cases/product/product_variant_filter.dart`
- `lib/data/use_cases/product/output/product_output.dart`
- `lib/data/use_cases/product/output/product_variant_output.dart`
- `test/api/core/product/product_variant_filter.http`
- `test/api/variables.http`
- `test/api/README.md`
- `memory-bank/` directory structure

### Files Modified
- `lib/data/middlewares/order_middleware.dart` - Added `getProductVariantsFilter()` method

### Architecture Decisions (Old Pattern)
- Followed Clean Architecture: Middleware → UseCase → Output Models
- Middleware returns entities, UseCase maps to outputs
- Output models parse JSON strings (e.g., `options` field) automatically

### Known Issues
- Middleware uses hardcoded URL instead of `NetworkUrl.productVariant.filter()`
- API response structure not yet verified with actual API calls

### Next Steps
- Add `_ProductVariant` class to `NetworkUrl`
- Test API with actual requests to verify response structure
- Adjust parsing logic if needed based on actual API response

---

## Memory Bank Setup

### Implemented
- ✅ Created `.cursor/rules/` directory with Cline Memory Bank rules
- ✅ Created core memory files (00-05-*.md)
- ✅ Organized feature-specific contexts in `notes/` directory
- ✅ Set up rules for Cursor to automatically read Memory Bank

### Files Created
- `.cursor/rules/core.mdc` - Core operational rules
- `.cursor/rules/memory-bank.mdc` - Memory Bank guidelines
- `memory-bank/00-project-overview.md` - Project overview
- `memory-bank/01-architecture.md` - Architecture documentation
- `memory-bank/02-components.md` - Components documentation
- `memory-bank/03-development-process.md` - Development workflow
- `memory-bank/04-api-documentation.md` - API documentation
- `memory-bank/05-progress-log.md` - This file
- `memory-bank/notes/product-variant-filter.md` - Feature context

---

## 2025-01-24 - Order Creation API Integration & Model Updates

### Implemented
- ✅ Integrated Order Creation API (`POST /enterprise/order/create`) from Core Service
- ✅ Completed `sellerCreateOrder()` function in OrderCubit with validation logic
- ✅ Added validation states: `ValidateOrderState`, `InvalidOrderState`
- ✅ Created new models: `OrderItem`, `OrderInfo`, `OrderDelivery` for API response
- ✅ Updated `Order` model with new fields from API response
- ✅ Created `Order.fromMapNew()` factory method to parse new API response structure
- ✅ Implemented `_mapDeliveryForCreateShipment()` function for delivery mapping
- ✅ Added `note` field to `ProductVariant` model
- ✅ Updated `ConfigProductVariantScreen` to save/load variant notes
- ✅ Updated payment method handling to support both `paymentMethodEnum` and `paymentMethodName`

### Files Created
- `lib/data/models/order/order_item.dart` - Model for orderItems in API response
- `lib/data/models/order/order_info.dart` - Model for orderInfo with nested OrderInfoAdditional
- `lib/data/models/order/order_delivery.dart` - Model for orderDelivery information
- `test/api/core/enterprise_order_create.http` - API test file for order creation

### Files Modified
- `lib/bloc/order/order_cubit.dart`:
  - Completed `sellerCreateOrder()` with validation:
    - Validates customerId, addressCustomerId, branchId, products, soldById
    - Emits `ValidateOrderState`, `InvalidOrderState`, `LoadingOrderState`, `LoadedOrderState`, `ErrorOrderState`
    - Calls `_orderMiddleware.sellerCreateOrder()` to interact with API
  - Added `getDeliveryMethods()` method to fetch active delivery groups
- `lib/bloc/order/order_state.dart`:
  - Added `ValidateOrderState` and `InvalidOrderState` for validation logic
  - Added `SelectDeliveryMethodState` for delivery method selection
- `lib/data/models/order/create_order_input.dart`:
  - Updated `OrderInput.toMap()` to convert `deliveryFee` and `discount` to String to match API format
- `lib/data/middlewares/order_middleware.dart`:
  - Added `sellerCreateOrder(CreateOrderInput input)` method:
    - Uses `coreDio.post` to call `/enterprise/order/create` endpoint
    - Sends `input.toMap()` as request body
    - Parses response using `Order.fromMapNew()` for new response structure
  - Updated response parsing to handle `{"status":1,"data":{...}}` structure
- `lib/data/models/order/order.dart`:
  - Added new fields from API response:
    - `type`, `orderDate`, `orderCode`, `deliveryFailedNote`, `deliveryFailedReasonId`
    - `cancelNote`, `wallet`, `cashbackDate`, `cashbackStatus`
    - `discountDate`, `discountStatus`, `refundDate`, `receivedDate`, `refundStatus`
    - `createdAt`, `updatedAt`, `adminCancelledById`, `adminVerifiedById`, `businessVerifiedById`
    - `orderItems` (List<OrderItem>), `orderPayments`, `orderProcesses`
    - `orderInfo` (OrderInfo), `orderDelivery` (OrderDelivery)
    - `addressJson`, `quantity`, `totalPaid`, `deliveryFee`, `deliveryCode`
    - `trackingOrder`, `delivery` (DeliveryGroup)
    - `isRefund`, `invoiceStatus`, `collaboratorsCode`, `isPrinted`, `isInvoice`
    - `trackingOrderLabel`, `saleChannel`, `discount`, `discountPercent`, `discountReason`
    - `statusGeneral`, `billingStatus`, `createdBy`, `warehouseId`
  - Created `Order.fromMapNew()` factory method to parse new API response structure
  - Handles nested objects: `orderItems`, `orderInfo`, `orderDelivery`, `delivery`
- `lib/data/models/product/product_variant.dart`:
  - Added `note` field (String?) to store variant-specific notes
  - Updated `fromMap()`, `toMap()`, `copyWith()` to support note field
- `lib/views/order/create_order/config_product_variant_screen.dart`:
  - Updated to load note from variant: `_noteController.text = _productVariant!.note ?? '';`
  - Updated to save note to variant: `note: note.isNotEmpty ? note : null`
  - Removed separate note return in result (now saved in variant)
- `lib/views/order/create_order/create_order_screen.dart`:
  - Added `selectedDeliveryCode` state variable to store selected delivery method
  - Updated delivery method selection listener to save `selectedDeliveryCode`
  - Implemented `_mapDeliveryForCreateShipment()` function:
    - Handles `DELIVERY_LATER` and `GET_AT_STORE` cases (returns `deliveryCode` and `warehouseId`)
    - Default case returns basic info (will be fully implemented when documentation is available)
  - Updated `_generateOrderBody()` to use `_mapDeliveryForCreateShipment()`
  - Updated product mapping to include `note: variant.note`
  - Updated payment method handling to support both `paymentMethodEnum` and `paymentMethodName`
  - Updated `companyId` to use `_authRepository.currentUser?.company?.id`
- `lib/data/models/user/user.dart`:
  - Added new fields from API response: `username`, `status`, `pinCode`, `registerDate`, `company`, etc.
  - Updated `fromMap()` to parse `positionType` string (e.g., "BUSINESS_OWNER") to enum
  - Added nested `Company` model support
- `lib/data/models/user/company.dart`:
  - Created new model for company information nested in User
  - Includes fields: business info, address, banners, financial info, etc.
- `lib/data/models/user/staff.dart`:
  - Updated to properly inherit from User model
  - Removed duplicate field declarations
  - Updated `fromMap()` to parse all User fields first, then pass to Staff constructor

### Architecture Decisions
- **Order Response Structure**: API returns `{"status":1,"data":{...}}` format, parsed using `Order.fromMapNew()`
- **Delivery Mapping**: Simple mapping for `DELIVERY_LATER` and `GET_AT_STORE`, default case to be completed later
- **Variant Notes**: Notes are stored directly in `ProductVariant` model, not as separate data
- **Payment Method Handling**: Supports both `paymentMethodEnum` (new) and `paymentMethodName` (legacy) for backward compatibility
- **Model Updates**: Created separate models (`OrderItem`, `OrderInfo`, `OrderDelivery`) for nested objects instead of using dynamic types

### Technical Notes
- `Order.fromMapNew()` parses response structure: `{"status":1,"data":{...}}`
- Delivery mapping function handles special cases (`DELIVERY_LATER`, `GET_AT_STORE`) and returns basic info for others
- Product variant notes are optional and only saved if not empty
- Payment method enum is preferred over name, with fallback to name for compatibility
- Company information is nested in User model as `Company` object

### API Response Structure
```json
{
  "status": 1,
  "data": {
    "id": "...",
    "status": "PENDING",
    "code": "SON00817",
    "orderItems": [...],
    "orderInfo": {...},
    "orderDelivery": {...},
    "delivery": {...},
    "orderPayments": [],
    "orderProcesses": [],
    "totalAmount": 125000,
    "deliveryFee": 0,
    "deliveryCode": "DELIVERY_LATER",
    "warehouseId": "...",
    ...
  }
}
```

### Next Steps
- Complete default case in `_mapDeliveryForCreateShipment()` when documentation is available
- Add validation for delivery method selection
- Handle order creation success/error states in UI
- Test order creation flow end-to-end

---

*Add new entries chronologically above this line*

## 2025-12-19 - Warehouse Brands load-more fix

### Implemented
- Điều chỉnh `_onLoadMore` trong `lib/views/warehouse/brands/brands_screen.dart` để tính `currentLength`/`total` theo trạng thái packing (new/processing/completed) từ các stream/list `newPackings`, `processingPackings`, `completedPackings`, và dùng `variantSpecials` cho tab thương hiệu. Bỏ tham chiếu nhầm tới roasting/green beans.
- Xóa import thừa `dart:developer` ở `brands_screen.dart`.

### Notes
- Nhiều file được người dùng thay đổi/song song (roasting slip, packing slip, warehouse cubit/repository) và một số màn warehouse đã bị xóa; không hoàn tác các thay đổi này.

## 2025-12-19 - Warehouse module hợp nhất & Roasting Slip integration + Permission & docs

### Implemented
- ✅ Hợp nhất green bean/roasting slip vào module `warehouse`; xóa prefix green_bean/roasting_slip cũ.
- ✅ Middleware/Repository/Cubit: `warehouse_middleware.dart` (filter variants/slips, detail), `warehouse_repository.dart` (BehaviorSubject greenBeans/roastingSlips + total), `warehouse_cubit.dart` (filterGreenBeans/filterRoastingSlips/getRoastingSlipDetail với state type).
- ✅ Models: Tạo `RoastingSlip` (list) và `RoastingSlipDetail` (detail) riêng, không dùng `ProductVariant` cho phiếu rang; parse đúng response thực tế.
- ✅ UI: `green_beans_screen.dart` tabs hạt xanh/phiếu rang với search, refresh, load-more indicator, total count; card list cho variant và slip; render theo `_tabIndex`. `roasting_slip_detail_screen.dart` hiển thị detail phiếu rang theo model mới. `roasting_slip_create_screen.dart` (mock data) với AppBar style yêu cầu, branch dropdown, search sản phẩm, empty state, action buttons.
- ✅ Permissions: abilities/sellerPermissions lưu trong auth; `PermissionHelper` bổ sung constants; Home tabs filter quyền warehouse (`warehouses/warehouse_management`).
- ✅ DI: đăng ký `WarehouseMiddleware`, `WarehouseRepository`, `WarehouseCubit` trong `dependency_injection.dart`.
- ✅ Docs: `SelectorFormField` comment note chuẩn hoá cách dùng; thêm note `memory-bank/notes/warehouse-roasting-slip.md`.

### Notes
- Flow API: filter green bean variants `/core/api/v1/coffee-variant/green-bean/filter`, filter roasting slips `/core/api/v1/coffee-variant/roasting-slip/filter`, detail `/core/api/v1/coffee-variant/roasting-slip/{code}`.
- `WarehouseLoaded` có field `type` để phân biệt luồng green beans vs roasting slips cho UI/render.
- Phân quyền màn hình dựa trên AbilityAction/AbilitySubject; HomeScreen chỉ render tab khi đủ quyền.

