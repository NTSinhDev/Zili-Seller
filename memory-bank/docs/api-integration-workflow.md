# API Integration Workflow - Tích hợp API từ cURL

## Tổng quan

Đây là quy trình chuẩn để tích hợp một API mới từ cURL command vào project Flutter. Quy trình này đảm bảo tính nhất quán và dễ bảo trì.

## Quy trình tích hợp API (5 bước)

### Bước 1: Tạo test API và kiểm thử request

**Mục đích**: Xác nhận API hoạt động đúng và hiểu rõ response structure.

**Các bước**:
1. Tạo file `.http` trong thư mục `test/api/{service}/` (ví dụ: `test/api/user/customer_filter.http`)
2. Copy cURL command và chuyển đổi sang format REST Client
3. Thêm các test cases:
   - Test với keyword
   - Test không có keyword (get all)
   - Test pagination
   - Test với empty keyword
   - Test với limit nhỏ

**Ví dụ**:
```http
### Customer Filter API Tests
### Service: User
### API: GET /business/customer/filter

@domain = https://stg-gw.wowi.cafe
@userBaseUrl = {{domain}}/user/api/v1
@token = YOUR_TOKEN_HERE

GET {{userBaseUrl}}/business/customer/filter?keyword=s&limit=10&offset=0
Authorization: Bearer {{token}}
```

**Lưu ý**:
- Test API trước khi code để xác nhận response structure
- Nếu response structure khác với dự đoán, cần điều chỉnh parsing logic

### Bước 2: Tạo model từ response (nếu cần)

**Mục đích**: Tạo model để parse response data.

**Các bước**:
1. Xem response từ test API
2. Nếu đã có model tương ứng (ví dụ: `Customer`), kiểm tra xem có cần thêm fields không
3. Nếu chưa có model, tạo model mới trong `lib/data/models/`
4. Implement `fromMap()`, `toMap()`, `copyWith()` methods

**Lưu ý**:
- Nếu chưa có entity tương ứng, hỏi người dùng để cung cấp entity
- Model phải match với response structure từ API

### Bước 3: Thêm method vào Middleware

**Mục đích**: Tạo method để gọi API từ middleware.

**Các bước**:
1. Xác định service của API (auth/core/user)
2. Nếu chưa có Dio instance cho service đó:
   - Thêm `{service}BaseURL` vào `FlavorConfig`
   - Thêm `{service}Dio` vào `NetworkCommon`
   - Thêm `{service}Dio` vào `BaseMiddleware`
3. Thêm method vào Middleware tương ứng (ví dụ: `CustomerMiddleware`)

**Ví dụ**:
```dart
// 1. Thêm vào FlavorConfig
String get userBaseUrl {
  return 'https://stg-gw.wowi.cafe/user/api/v1';
}

// 2. Thêm vào NetworkCommon
Dio get userDio {
  final dio = Dio();
  dio.options.baseUrl = NetworkUrl.userBaseURL;
  // ... interceptors, timeout, etc.
  return dio;
}

// 3. Thêm vào BaseMiddleware
Dio get userDio => di<NetworkCommon>().userDio;

// 4. Thêm method vào CustomerMiddleware
// KHÔNG cần khai báo endpoint trong NetworkUrl, đặt thẳng vào request
Future<ResponseState> filterCustomers({
  int limit = 10,
  int offset = 0,
  String? keyword,
}) async {
  try {
    // GET request: dùng queryParameters
    final response = await userDio.get<NWResponse>(
      '/business/customer/filter', // Endpoint path đặt trực tiếp
      queryParameters: { // Query params truyền qua Dio
        'limit': limit,
        'offset': offset,
        'keyword': keyword, // Dio tự động loại bỏ nếu null
      },
      cancelToken: cancelToken,
    );
    
    final resultData = response.data;
    if (resultData is NWResponseSuccess) {
      // Parse response
      return ResponseSuccessState(
        responseData: {
          'count': count,
          'customers': customers,
        },
      );
    }
    // Error handling...
  } on DioException catch (e) {
    return handleResponseFailedState(e);
  }
}
```

**Lưu ý quan trọng**:
- **Đặt endpoint path trực tiếp vào request**, không cần khai báo trong NetworkUrl
- **Dio tự động loại bỏ null values** trong queryParameters, không cần check null
- **GET requests**: Dùng `queryParameters` trong Dio
- **POST/PUT requests**: Dùng `data` parameter trong Dio

**Pattern xử lý response**:
- Response có thể có các keys khác nhau: `customers`, `data`, `listData`
- Luôn check và handle nhiều trường hợp
- Trả về format chuẩn: `{count: int, items: List<T>}`

### Bước 4: Thêm method vào BLoC/Cubit (nếu là GET request)

**Mục đích**: Tạo method trong Cubit với 3 states chuẩn.

**Các bước**:
1. Thêm state mới cho loaded data (ví dụ: `CustomerFilterLoadedState`)
2. Thêm method vào Cubit với pattern:
   - Emit loading state
   - Gọi middleware method
   - Emit loaded state nếu success
   - Emit error state nếu failed

**Ví dụ**:
```dart
// 1. Thêm state vào customer_state.dart
class CustomerFilterLoadedState extends CustomerState {
  final int count;
  final List<Customer> customers;
  const CustomerFilterLoadedState({
    required this.count,
    required this.customers,
  });
}

// 2. Thêm method vào CustomerCubit
Future<void> filterCustomers({
  int limit = 10,
  int offset = 0,
  String? keyword,
}) async {
  emit(WaitingCustomerState()); // Loading
  final result = await _customerMiddleware.filterCustomers(...);
  if (result is ResponseSuccessState) {
    emit(CustomerFilterLoadedState(...)); // Loaded
  } else if (result is ResponseFailedState) {
    emit(FailedCustomerState(error: result)); // Error
  }
}
```

**3 States chuẩn**:
- **Loading State**: `Waiting{Entity}State()` hoặc `{Entity}LoadingState()`
- **Loaded State**: `{Entity}FilterLoadedState()` với data
- **Error State**: `Failed{Entity}State(error: ResponseFailedState)`

### Bước 5: Sử dụng trong UI

**Ví dụ sử dụng**:
```dart
final customerCubit = di<CustomerCubit>();

// Gọi API
customerCubit.filterCustomers(
  keyword: 's',
  limit: 10,
  offset: 0,
);

// Listen states
BlocBuilder<CustomerCubit, CustomerState>(
  builder: (context, state) {
    if (state is WaitingCustomerState) {
      return LoadingWidget();
    } else if (state is CustomerFilterLoadedState) {
      return ListView.builder(
        itemCount: state.customers.length,
        itemBuilder: (context, index) {
          return CustomerItem(customer: state.customers[index]);
        },
      );
    } else if (state is FailedCustomerState) {
      return ErrorWidget(message: state.error.errorMessage);
    }
    return SizedBox();
  },
)
```

## Checklist tích hợp API

- [ ] Bước 1: Tạo test API file và test request
- [ ] Bước 2: Tạo/kiểm tra model từ response
- [ ] Bước 3: Thêm method vào Middleware
  - [ ] Thêm service Dio instance (nếu chưa có)
  - [ ] Thêm URL endpoint vào NetworkUrl
  - [ ] Implement method trong Middleware
- [ ] Bước 4: Thêm method vào Cubit (nếu là GET)
  - [ ] Thêm loaded state
  - [ ] Implement method với 3 states
- [ ] Bước 5: Test và sử dụng trong UI

## Ví dụ thực tế: Customer Filter API

### cURL Command:
```bash
curl 'https://stg-gw.wowi.cafe/user/api/v1/business/customer/filter?keyword=s&limit=10&offset=0' \
  -H 'authorization: Bearer TOKEN'
```

### Files đã tạo/cập nhật:

1. **Test API**: `test/api/user/customer_filter.http`
2. **FlavorConfig**: Thêm `userBaseUrl`
3. **NetworkCommon**: Thêm `userDio`
4. **BaseMiddleware**: Thêm `userDio` getter
5. **NetworkUrl**: Thêm `filterCustomers()` trong `_Customer`
6. **CustomerMiddleware**: Thêm `filterCustomers()` method
7. **CustomerCubit**: Thêm `filterCustomers()` method và `CustomerFilterLoadedState`

### Response Structure:
```json
{
  "count": 10,
  "customers": [
    {
      "id": "uuid",
      "fullName": "Customer Name",
      "phone": "0123456789",
      "email": "email@example.com",
      // ... other fields
    }
  ]
}
```

## Lưu ý quan trọng

1. **Luôn test API trước**: Test API bằng REST Client extension trước khi code để hiểu rõ response structure
2. **Xử lý nhiều response formats**: API có thể trả về với keys khác nhau (`data`, `listData`, `customers`, etc.)
3. **Error handling**: Luôn handle `DioException` và `ResponseFailedState`
4. **Consistent naming**: Sử dụng naming convention nhất quán:
   - Method: `filter{Entity}s()` hoặc `get{Entity}s()`
   - State: `{Entity}FilterLoadedState` hoặc `{Entity}LoadedState`
5. **Service Dio instances**: Mỗi service (auth/core/user) có Dio instance riêng với base URL tương ứng

## Request Parameters Pattern

### Quy tắc chung về Parameters

#### 1. GET Request - Query Parameters
- **Nếu method là GET**, thì đoạn sau dấu `?` được tính là params
- **Sử dụng `queryParameters`** để truyền params
- **Dio tự động loại bỏ null values**, không cần check null trước khi truyền

**Ví dụ**:
```dart
// GET request với query parameters
final response = await authDio.get<NWResponse>(
  '/company/user/active', // Endpoint path đặt trực tiếp
  queryParameters: {
    'isMe': isMe, // Nếu isMe = null, Dio tự động loại bỏ key này
    'limit': limit,
    'offset': offset,
  },
  cancelToken: cancelToken,
);
```

**Lưu ý**:
- Không cần check `if (isMe != null)` vì Dio tự động loại bỏ null values
- Có thể truyền nhiều params, Dio sẽ tự động build query string

#### 2. POST/PUT Request - Request Body
- **Nếu method là POST hoặc PUT**, sử dụng `data` thay vì `queryParameters`
- **`data` chứa request body** (JSON object)

**Ví dụ**:
```dart
// POST request với request body
final response = await userDio.post<NWResponse>(
  '/company/customer-address', // Endpoint path đặt trực tiếp
  data: { // Request body
    'customerId': customerId,
    'name': name,
    'phone': phone,
    'email': email,
    'provinceCode': provinceCode,
    'districtCode': districtCode,
    'wardCode': wardCode,
    'address': address,
  },
  cancelToken: cancelToken,
);

// PUT request với request body
final response = await userDio.put<NWResponse>(
  '/company/customer-address/$addressId', // Endpoint path đặt trực tiếp
  data: { // Request body
    'customerId': customerId,
    'name': name,
    // ... other fields
  },
  cancelToken: cancelToken,
);
```

#### 3. Endpoint Path
- **Đặt endpoint path trực tiếp vào request**, không cần khai báo trong NetworkUrl
- **Endpoint path là đường dẫn tương đối** (không bao gồm base URL)
- **Base URL đã được cấu hình trong Dio instance** (authDio, userDio, coreDio, systemDio)

**Ví dụ**:
```dart
// ✅ Đúng: Đặt endpoint trực tiếp
final response = await authDio.get<NWResponse>(
  '/company/user/active', // Endpoint path
  queryParameters: {'isMe': isMe},
  cancelToken: cancelToken,
);

// ❌ Sai: Không cần khai báo trong NetworkUrl
// NetworkUrl.auth.activeUser(isMe: isMe) // KHÔNG CẦN
```

### So sánh Pattern cũ và mới

#### Pattern cũ (KHÔNG dùng nữa):
```dart
// 1. Khai báo endpoint trong NetworkUrl
class _Authentication {
  String activeUser({bool? isMe}) {
    final queryParams = <String>[];
    if (isMe != null) {
      queryParams.add('isMe=$isMe');
    }
    return '/company/user/active?${queryParams.join('&')}';
  }
}

// 2. Sử dụng trong Middleware
final response = await authDio.get<NWResponse>(
  NetworkUrl.auth.activeUser(isMe: isMe), // Phức tạp, không cần thiết
  cancelToken: cancelToken,
);
```

#### Pattern mới (HIỆN TẠI):
```dart
// 1. Đặt endpoint trực tiếp trong Middleware
final response = await authDio.get<NWResponse>(
  '/company/user/active', // Đơn giản, trực tiếp
  queryParameters: {'isMe': isMe}, // Dio tự động xử lý null
  cancelToken: cancelToken,
);
```

## Pattern cho các loại request

### GET Request (Filter/Search)
- **Endpoint**: Đặt trực tiếp trong request
- **Parameters**: Sử dụng `queryParameters`
- **Null handling**: Dio tự động loại bỏ null values
- Middleware: Trả về `ResponseSuccessState` với `{count, items}`
- Cubit: 3 states (loading, loaded, error)
- State: `{Entity}FilterLoadedState` với `count` và `items`

**Ví dụ**:
```dart
Future<ResponseState> getActiveStaff({bool? isMe}) async {
  try {
    final response = await authDio.get<NWResponse>(
      '/company/user/active',
      queryParameters: {'isMe': isMe}, // Dio tự loại bỏ nếu null
      cancelToken: cancelToken,
    );
    // ... handle response
  } on DioException catch (e) {
    return handleResponseFailedState(e);
  }
}
```

### POST Request (Create)
- **Endpoint**: Đặt trực tiếp trong request
- **Body**: Sử dụng `data`
- Middleware: Trả về created entity
- Cubit: 2 states (loading, success/error)
- State: `Message{Entity}State` cho success message

**Ví dụ**:
```dart
Future<ResponseState> createCustomerAddress({
  required String customerId,
  required String name,
  // ... other params
}) async {
  try {
    final response = await userDio.post<NWResponse>(
      '/company/customer-address',
      data: { // Request body
        'customerId': customerId,
        'name': name,
        // ... other fields
      },
      cancelToken: cancelToken,
    );
    // ... handle response
  } on DioException catch (e) {
    return handleResponseFailedState(e);
  }
}
```

### PUT Request (Update)
- **Endpoint**: Đặt trực tiếp trong request (có thể có path params)
- **Body**: Sử dụng `data`
- Middleware: Trả về updated entity hoặc message
- Cubit: 2 states (loading, success/error)
- State: `Message{Entity}State` cho success message

**Ví dụ**:
```dart
Future<ResponseState> updateCustomerAddress({
  required String addressId,
  required String customerId,
  // ... other params
}) async {
  try {
    final response = await userDio.put<NWResponse>(
      '/company/customer-address/$addressId', // Path param trong endpoint
      data: { // Request body
        'customerId': customerId,
        // ... other fields
      },
      cancelToken: cancelToken,
    );
    // ... handle response
  } on DioException catch (e) {
    return handleResponseFailedState(e);
  }
}
```

### DELETE Request
- **Endpoint**: Đặt trực tiếp trong request
- **Parameters**: Có thể dùng `queryParameters` nếu cần
- Middleware: Trả về success message
- Cubit: 2 states (loading, success/error)
- State: `Message{Entity}State` cho success message

## Tài liệu tham khảo

- API Documentation: `memory-bank/04-api-documentation.md`
- Middleware Guide: `memory-bank/docs/middleware-guide.md`
- Test API Files: `test/api/README.md`

