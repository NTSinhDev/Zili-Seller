# API Documentation

## Order APIs

### Create Order by Seller
- **Endpoint**: `POST /enterprise/order/create`
- **Service**: Core
- **Method**: `OrderMiddleware.sellerCreateOrder(CreateOrderInput input)`
- **Request Body**: `CreateOrderInput` model (converted to Map via `toMap()`)
- **Response Structure**: 
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
      "totalAmount": 125000,
      "deliveryFee": 0,
      "deliveryCode": "DELIVERY_LATER",
      "warehouseId": "...",
      ...
    }
  }
  ```
- **Response Model**: `Order.fromMapNew()` parses the response
- **Validation**: 
  - Validates customerId, addressCustomerId, branchId, products, soldById
  - Emits `InvalidOrderState` with error message if validation fails
- **States**: 
  - `ValidateOrderState`: Validation started
  - `InvalidOrderState`: Validation failed with message
  - `LoadingOrderState`: API call in progress
  - `LoadedOrderState`: Order created successfully
  - `ErrorOrderState`: API call failed

### Get Active Delivery Groups
- **Endpoint**: `GET /enterprise/delivery-group/active`
- **Service**: Core
- **Method**: `OrderMiddleware.getActiveDeliveryGroups()`
- **Response**: `List<DeliveryGroup>`
- **Usage**: Used to populate delivery method selection in order creation

## Delivery Mapping

### mapDeliveryForCreateShipment
- **Location**: `CreateOrderScreen._mapDeliveryForCreateShipment()`
- **Purpose**: Map delivery data for create shipment API
- **Logic**:
  - `DELIVERY_LATER`: Returns `{deliveryCode, warehouseId}`
  - `GET_AT_STORE`: Returns `{deliveryCode, warehouseId}`
  - Default: Returns basic info (to be completed when documentation is available)
- **Data Source**: 
  - `selectedDeliveryCode`: Selected delivery method code
  - `selectedWarehouse?.id`: Warehouse/branch ID

# API Documentation

## Base URLs

### Environment Configuration
- Base URLs configured in `app_flavor_config.dart`
- Multiple services: `authBaseUrl`, `coreBaseUrl`, `userBaseUrl`
- Domain: `https://stg-gw.wowi.cafe` (staging)

### Service Endpoints
- **Auth Service**: `{domain}/auth/api/v1`
- **Core Service**: `{domain}/core/api/v1`
- **User Service**: `{domain}/user/api/v1`
- **System Service**: `{domain}/system/api/v1`
  - Used for: Administrative regions, payment methods, system configurations

## API Endpoints

### Authentication (`lib/data/network/network_url.dart` - `_Authentication`)
- `POST /auth/seller/login` - Login
- `POST /auth/seller/register` - Register
- `POST /auth/seller/forgot` - Forgot password
- `POST /auth/seller/verify-otp` - Verify OTP
- `POST /auth/seller/reset` - Reset password
- `POST /auth/seller/social/verify-token` - Social login

### Products (`lib/data/network/network_url.dart` - `_Product`)
- `GET /product/local/search/` - Search products
- `GET /product/slug/{slug}` - Get product by slug
- `GET /product/local/detail/{id}` - Get product by ID
- `GET /product/get-by-company` - Get company products list với pagination (Core Service)
  - Query params: `limit` (default: 20), `offset` (default: 0)
  - Response format: `{products: List<CompanyProduct>, count: int, totalProducts: int}`
  - Method: `ProductMiddleware.getProductsByCompany()`
  - Usecase: `ProductCubit.getProducts()`, `ProductCubit.loadMoreProducts()`
- `GET /company/product/detail/{productId}` - Get company product detail by ID (Core Service)
  - Response format: `{status: 1, data: CompanyProduct}` hoặc direct `CompanyProduct` object
  - Method: `ProductMiddleware.getCompanyProductDetail()`
  - Usecase: `ProductCubit.fetchCompanyProductDetail()`

### Company Products (Core Service - `lib/data/network/network_url.dart` - `_Product`)
- `GET /product/get-by-company` - Get company products list với pagination
  - Query params: `limit` (default: 20), `offset` (default: 0)
  - Response format: `{products: List<CompanyProduct>, count: int, totalProducts: int}`
  - Method: `ProductMiddleware.getProductsByCompany()`
  - Usecase: `ProductCubit.getProducts()`, `ProductCubit.loadMoreProducts()`
  - Response structure:
    ```json
    {
      "products": [
        {
          "id": "uuid",
          "titleVi": "Tên sản phẩm",
          "titleEn": null,
          "price": 120000,
          "costPrice": 100000,
          "availableQuantity": -24,
          "productVariants": [...],
          "seller": {...},
          "categoryInternal": {...},
          "createdAt": "2026-01-05T06:54:17.302Z",
          "updatedAt": "2026-01-16T08:03:09.564Z",
          ...
        }
      ],
      "count": 365,
      "totalProducts": 365
    }
    ```
- `GET /company/product/detail/{productId}` - Get company product detail by ID
  - Response format: `{status: 1, data: CompanyProduct}` hoặc direct `CompanyProduct` object
  - Method: `ProductMiddleware.getCompanyProductDetail()`
  - Usecase: `ProductCubit.fetchCompanyProductDetail()`
  - Response structure:
    ```json
    {
      "status": 1,
      "data": {
        "id": "uuid",
        "titleVi": "Tên sản phẩm",
        "descriptionVi": "<p>Mô tả</p>",
        "productVariants": [...],
        "deliverySettings": [],
        "productOptions": [],
        ...
      }
    }
    ```

### Product Variants
- `GET /company/product/variant/filter` - Filter product variants
  - Query params: `keyword`, `limit`, `offset`
  - Returns: `{count: int, variants: List<ProductVariantEntity>}`

### Orders (`lib/data/network/network_url.dart` - `_Order`)
- `GET /order/customer/all` - Get all orders
- `GET /order/customer/{id}` - Get order by ID
- `POST /order/customer/create` - Create order
- `PUT /order/customer/update` - Update order

### Order Products (`lib/data/network/network_url.dart` - `_OrderProduct`)
- `GET /company/product/order/filter` - Filter products for order
  - Query params: `keyword` (optional, search by name/SKU), `limit` (default: 20), `offset` (default: 0), `branchId` (optional, filter by warehouse)
  - Returns: `{count: int, products: List<OrderProduct>}`
  - Response format:
    ```json
    {
      "count": 100,
      "products": [
        {
          "id": "uuid",
          "titleVi": "Tên sản phẩm",
          "avatar": "image-url",
          "productVariants": [
            {
              "id": "variant-uuid",
              "options": [{"name": "Loại", "value": "S16"}],
              "price": 100000,
              "availableQuantity": "2017.0", // String format
              "status": "ACTIVE"
            }
          ],
          "availableQuantity": 2360.9 // num format
        }
      ]
    }
    ```
  - Important: `availableQuantity` in variant is String, in product is num

### Customer/Profile (`lib/data/network/network_url.dart` - `_Customer`)
- `GET /seller/profile` - Get profile
- `PUT /seller/update` - Update profile
- `GET /seller/addresses` - Get addresses
- `POST /seller/address` - Create address
- `GET /seller/address/{id}` - Get address by ID
- `PUT /seller/change-password` - Change password
- `DELETE /seller/delete` - Delete account

### Business Customer (User Service - `lib/data/network/network_url.dart` - `_Customer`)
- `GET /business/customer/filter` - Filter customers for business
  - Query params: `keyword` (optional, search by name/phone/email), `limit` (default: 10), `offset` (default: 0)
  - Returns: `{count: int, customers: List<Customer>}`
  - Uses `userDio` instance (User Service)
  - Response format:
    ```json
    {
      "count": 10,
      "customers": [
        {
          "id": "uuid",
          "fullName": "Customer Name",
          "phone": "0123456789",
          "email": "email@example.com",
          "avatar": "avatar-url",
          "gender": 0,
          "dob": "1990-01-01T00:00:00.000Z"
        }
      ]
    }
    ```
- `POST /business/customer/create` - Create a new customer
  - **Endpoint**: `createCustomer`
  - **Method**: `CustomerMiddleware.createCustomer(CreateCustomerInput input)`
  - **Request Body**: `CreateCustomerInput` model (converted to Map via `toMap()`)
  - Uses `userDio` instance (User Service)
  - Request body structure:
    ```json
    {
      "fullName": "Customer Name",
      "email": "email@example.com",
      "code": "CUSTOMER_CODE",
      "phone": "0123456789",
      "birthday": "1990-01-01T00:00:00.000Z",
      "address": {
        "isDefault": true,
        "address": "Specific address",
        "provinceCode": "091",
        "wardCode": "030292"
      },
      "website": "https://example.com",
      "taxCode": "TAX_CODE",
      "faxCode": "FAX_CODE",
      "note": "Customer note",
      "totalSpending": 0,
      "currentDebt": 0,
      "advancedType": "USER",
      "discount": 0,
      "paymentMethod": null,
      "defaultPrice": null
    }
    ```
  - **Response Model**: `Customer` object parsed from response
  - **Cubit Method**: `CustomerCubit.createCustomer(CreateCustomerInput input)`
  - **States**: 
    - `LoadingCustomerState`: API call in progress
    - `MessageCustomerState`: Customer created successfully
    - `FailedCustomerState`: API call failed
  - **DTO**: `CreateCustomerInput` và `CreateCustomerAddressInput` (nested) trong `lib/data/dto/customer/create_customer_input.dart`
  - **Notes**:
    - `address` là nested object với `isDefault`, `address`, `provinceCode`, `wardCode`
    - Optional fields chỉ được include trong request nếu không null và không empty
    - `birthday` được format thành ISO 8601 string
    - `advancedType` mặc định là "USER"

### Customer Address (User Service - `lib/data/network/network_url.dart` - `_CustomerAddress`)
- `GET /company/customer-address/default` - Get default address for a customer
  - Query params: `customerId` (required)
  - Returns: `Address` object
  - Uses `userDio` instance (User Service)
- `GET /company/customer-address/filter` - Filter customer addresses by customer ID
  - Query params: `customerId` (required)
  - Returns: `{listData: List<Address>}`
  - Uses `userDio` instance (User Service)
- `PUT /company/customer-address/{id}` - Update customer address by ID
  - Path params: `id` (required) - Address ID
  - Request body:
    ```json
    {
      "customerId": "uuid",
      "name": "Customer Name",
      "phone": "0123456789",
      "email": "email@example.com",
      "provinceCode": "091",
      "districtCode": "001" | null,
      "wardCode": "030301",
      "address": "Specific address"
    }
    ```
  - Returns: `Address` object (updated)
  - Uses `userDio` instance (User Service)
  - Notes:
    - `districtCode` is `null` for POST_MERGER address type
    - `districtCode` is required for PRE_MERGER address type

### Address (`lib/data/network/network_url.dart` - `_Address`)
- `GET /address/provinces` - Get provinces (legacy API)
- `GET /address/districts/{provinceId}` - Get districts (legacy API)
- `GET /address/wards/{districtId}` - Get wards (legacy API)

### Administrative Regions (System Service - `lib/data/network/network_url.dart` - `_Administrative`)
- `GET /administrative/provinces?type={PRE_MERGER|POST_MERGER}` - Get provinces by type
  - Query params: `type` (required): `PRE_MERGER` or `POST_MERGER`
  - Returns: `List<Region>` - List of provinces
  - Uses `systemDio` instance (System Service)
  - Used when `RegionType.postMerger` is selected
- `GET /administrative/districts/filter?type={PRE_MERGER|POST_MERGER}` - Filter districts by type
  - Query params: `type` (required): `PRE_MERGER` or `POST_MERGER`
  - Returns: `List<Region>` - List of districts with province information
  - Uses `systemDio` instance (System Service)
  - Used when `RegionType.preMerger` is selected
- `GET /administrative/wards/{districtCode}?type={PRE_MERGER|POST_MERGER}` - Get wards by district code and type
  - Path params: `districtCode` (required): District code
  - Query params: `type` (required): `PRE_MERGER` or `POST_MERGER`
  - Returns: `List<Region>` - List of wards with district information
  - Uses `systemDio` instance (System Service)

### Warehouse (`lib/data/network/network_url.dart` - `_Warehouse`)
- `GET /seller/warehouse` - Get warehouses
  - Query params: `limit`, `offset`

### Seller Payment Methods (System Service - `lib/data/network/network_url.dart` - `_Seller`)
- `GET /system/api/v1/seller/payment-method/synthetic/active` - Get active payment methods (synthetic)
  - **Endpoint**: `paymentMethodSyntheticActive()`
  - Query params:
    - `notMethods[]`: string[] (optional) - Exclude payment methods (e.g., `['PAYMENT_ON_DELIVERY']`)
  - Returns: `{listData: List<SellerPaymentMethod>, total: int}`
  - Uses `systemDio` instance (System Service)
  - **Method**: `PaymentMiddleware.getPaymentMethods()`
  - **Cubit**: `PaymentCubit.getPaymentMethods()`
  - **Repository**: `PaymentRepository.paymentMethodsStream`
  - Response format:
    ```json
    {
      "listData": [
        {
          "id": "eda9a2aa-0e26-4976-9555-0420e460353f",
          "nameVi": "Tiền Mặt",
          "nameEn": "Cash",
          "method": "CASH",
          "icon": "https://data.wowi.vn/ecom/common/payment-method/cashondelivery.svg",
          "position": 1,
          "isActive": true,
          "createdAt": "2024-10-25T04:53:34.894Z",
          "updatedAt": "2024-10-25T04:53:34.894Z",
          "minimumOrder": 0,
          "bankCode": "DEFAULT", // Optional, for BANKING method
          "bankInfo": { // Optional, for BANKING method
            "id": "...",
            "titleEn": "Default",
            "titleVi": "Mặc định",
            "code": "DEFAULT",
            "contextDefault": "default",
            "isDefault": true,
            "accountOwner": "CONG TY TNHH ZILI",
            "bankName": "SACOMBANK CHI NHANH LAM DONG",
            "bankNumber": "20107947",
            "bankCode": "ACB",
            "bankBin": "970416",
            "methodName": "..." // Optional
          }
        }
      ],
      "total": 9
    }
    ```
  - Notes:
    - API trả về danh sách payment methods đang active với synthetic data
    - Có thể exclude một số methods (ví dụ: PAYMENT_ON_DELIVERY)
    - Model `SellerPaymentMethod` hỗ trợ `bankCode` và `bankInfo` cho BANKING method
    - Payment methods có thể có nhiều bank accounts (same id, method, different bankInfo)
    - Sử dụng `compareWith()` method để so sánh payment methods (bao gồm cả bankInfo)
    - Payment name rendering: Sử dụng `displayPaymentName` extension
      - Logic: `nameVi` (fallback `nameEn`) + `bankCode` + `accountOwner` nếu có bankInfo
      - Nếu có `bankInfo.methodName`: return `methodName`
- `GET /seller/payment-method` - Get payment methods (legacy, deprecated)
  - Query params:
    - `isActive`: bool (optional, default: true) - Filter by active status
    - `notMethods[]`: string[] (optional) - Exclude payment methods
  - **Note**: Endpoint cũ, đã được thay thế bởi `/synthetic/active`

### Reviews (`lib/data/network/network_url.dart` - `_Review`)
- `GET /review/product/total/{productId}` - Get product rating
- `GET /review/product/filter/{productId}` - Get product reviews
- `POST /review/create` - Create review

### Blog (`lib/data/network/network_url.dart` - `_Blog`)
- `GET /blog` - Get blogs
- `GET /blog-category/all` - Get blog categories

### Upload (`lib/data/network/network_url.dart` - `_Upload`)
- `POST /upload/image` - Upload image
- `POST /upload/images` - Upload multiple images
- `POST /upload/video` - Upload video
- `POST /upload/blob` - Upload blob

## Authentication

### Token Format
- Type: Bearer Token (JWT)
- Header: `Authorization: Bearer {token}`
- Stored in secure storage after login

### Request Headers
- `Content-Type: application/json`
- `Accept: application/json`
- `Authorization: Bearer {token}` (for authenticated requests)

## Response Format

### Success Response
```json
{
  "data": {
    // Response data
  },
  "statusCode": 200
}
```

### Error Response
```json
{
  "message": "Error message",
  "statusCode": 400
}
```

## Response State Handling

### ResponseState Types
- `ResponseSuccessState<T>`: Successful API response
- `ResponseFailedState`: Error response with message

### Usage Pattern
```dart
final response = await middleware.getData();
if (response is ResponseSuccessState) {
  final data = response.responseData;
  // Handle success
} else if (response is ResponseFailedState) {
  final error = response.message;
  // Handle error
}
```

## API Testing

### Test Files Location
- `test/api/core/` - Core service API tests
- `test/api/auth/` - Auth service API tests
- `test/api/user/` - User service API tests

### Variables File
- `test/api/variables.http` - Shared variables
  - `@domain`: Base domain URL
  - `@coreBaseUrl`: Core service URL
  - `@authBaseUrl`: Auth service URL
  - `@token`: Authentication token
  - `@contentType`: Content-Type header
  - `@accept`: Accept header

## Network Configuration

### Dio Instances (`lib/data/network/network_common.dart`)
- `dio`: Base API (`NetworkUrl.baseURL`)
- `authDio`: Auth Service (`NetworkUrl.authBaseURL`)
  - Base URL: `https://stg-gw.wowi.cafe/auth/api/v1`
  - Timeout: 10000ms
  - Used for: Authentication, seller profile APIs
- `coreDio`: Core Service (`NetworkUrl.coreBaseURL`) - Used for order/product APIs
  - Base URL: `https://stg-gw.wowi.cafe/core/api/v1`
  - Timeout: 180000ms
  - Used for: Orders, products, warehouses
- `userDio`: User Service (`NetworkUrl.userBaseURL`) - Used for business customer APIs
  - Base URL: `https://stg-gw.wowi.cafe/user/api/v1`
  - Timeout: 180000ms
  - Used for: Business customer filter/search
  - Interceptors: Auth (Bearer token), Response decoder, Error handler (401 → logout)
- `systemDio`: System Service (`NetworkUrl.systemBaseURL`) - Used for administrative region APIs
  - Base URL: `https://stg-gw.wowi.cafe/system/api/v1`
  - Timeout: 180000ms
  - Used for: Administrative regions (provinces, districts, wards) with PRE_MERGER/POST_MERGER types
  - Interceptors: Auth (Bearer token), Response decoder, Error handler (401 → logout)

## Notes
- All API endpoints use HTTPS
- Pagination: Use `limit` and `offset` parameters
- Search: Use `keyword` parameter for text search
- Filtering: Use query parameters for filtering
- Core Service APIs use `coreDio` instance
- Auth Service APIs use `authDio` instance
- User Service APIs use `userDio` instance

## API Integration Workflow

Khi tích hợp API mới từ cURL, follow quy trình 5 bước:
1. Tạo test API file và test request
2. Tạo/kiểm tra model từ response
3. Thêm method vào Middleware (thêm service Dio nếu cần)
4. Thêm method vào Cubit với 3 states (nếu là GET)
5. Sử dụng trong UI

Chi tiết: Xem `memory-bank/docs/api-integration-workflow.md`

