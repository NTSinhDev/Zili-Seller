# Order Body Generation Documentation

## Overview
Method `_generateOrderBody()` trong `CreateOrderScreen` collect tất cả data từ các components và format thành body structure để gửi lên API tạo order.

## Method Location
- **File**: `lib/views/order/create_order/create_order_screen.dart`
- **Method**: `_generateOrderBody()` (Line 441-571)
- **Return Type**: `CreateOrderInput` (type-safe model)
- **Caller**: `_createOrder()` method (Line 573-645)
- **Model**: `lib/data/models/order/create_order_input.dart`

## Data Sources

### 1. Products
- **Source**: `_orderRepository.selectedProductVariants.valueOrNull ?? []`
- **Type**: `List<ProductVariant>`
- **Mapping**:
  - `productId`: từ `variant.productId ?? variant.product?.id ?? ''`
  - `productVariantId`: `variant.id`
  - `quantity`: `variant.quantity.toInt()`
  - `discount`/`discountPercent`: Tính từ `variant.discount` và `variant.discountUnit`
  - `price`: `variant.price.toInt()`
  - `note`: `variant.note` (from ProductVariant model)

### 2. Customer
- **Source**: `selectedCustomer` (state variable)
- **Type**: `Customer?`
- **Fields used**:
  - `id`: cho `customerId`
  - `purchaseAddress?.id`: cho `addressCustomerId`
  - `taxCode`: cho `invoice.taxCode`
  - `billingAddress` hoặc `purchaseAddress`: cho `invoice` data

### 3. Discount (Order-level)
- **Source**: `discount` và `_discountUnit` (state variables)
- **Calculation**:
  - Nếu `_discountUnit == '%'`: `discountPercent = discount`, `discountValue = totalProductPrice * (discount / 100)`
  - Nếu `_discountUnit == 'đ'`: `discountValue = discount`, `discountPercent = null`

### 4. Shipping Fee
- **Source**: `shippingFee` (state variable)
- **Type**: `double`
- **Format**: Convert to int

### 5. Payment Details
- **Source**: `paymentDetails` (state variable)
- **Type**: `List<Map<String, dynamic>>`
- **Filter**: Chỉ lấy items có `paymentMethodEnum` hoặc `paymentMethodName` và `customerPaid > 0`
- **Format**: `{method: paymentMethodEnum ?? paymentMethodName, amount: customerPaid.toInt()}`
- **Note**: Supports both `paymentMethodEnum` (new) and `paymentMethodName` (legacy) for backward compatibility

### 6. Delivery
- **Source**: `selectedDeliveryCode` và `selectedWarehouse` (state variables)
- **Method**: `_mapDeliveryForCreateShipment()`
- **Logic**:
  - `DELIVERY_LATER`: `{deliveryCode: "DELIVERY_LATER", warehouseId: selectedWarehouse?.id}`
  - `GET_AT_STORE`: `{deliveryCode: "GET_AT_STORE", warehouseId: selectedWarehouse?.id}`
  - Default: Basic info (to be completed when documentation is available)
- **Returns**: `Map<String, dynamic>?` - Delivery object hoặc null

### 7. Company ID
- **Source**: `_authRepository.currentUser?.company?.id`
- **Type**: `String?`
- **Usage**: Used in `OrderInput.companyId`

### 6. Additional Info
- **Source**: State variables
- **Fields**:
  - `selectedWarehouse?.id`: cho `branchId`
  - `selectedStaff?.id`: cho `soldById`
  - `selectedSource`: cho `saleChannel`
  - `deliveryDate`: Combine với current time, format ISO 8601
  - `noteController.text`: cho `order.note`

## Body Structure

Method `_generateOrderBody()` return `CreateOrderInput` model (type-safe). Structure:

### CreateOrderInput Model
```dart
CreateOrderInput(
  order: OrderInput(...),
  customerId: String,
  collaboratorId: String?,
  addressCustomerId: String?,
  paid: List<PaymentInput>,
  delivery: Map<String, dynamic>?,  // User sẽ tự implement
  infoAdditional: InfoAdditionalInput(...),
  invoice: InvoiceInput(...),
)
```

### OrderInput
```dart
OrderInput(
  status: String?,  // 'PROCESSING' nếu có payment, null nếu không
  deliveryFee: int,
  discount: int?,  // Nếu có discount
  discountPercent: double?,  // Nếu discount theo %
  discountReason: String?,
  companyId: String?,
  products: List<OrderProductInput>,
  note: String?,
  tags: List<String>?,
)
```

### OrderProductInput
```dart
OrderProductInput(
  productId: String,
  productVariantId: String,
  quantity: int,
  discountPercent: double?,  // Nếu variant discount theo %
  discount: int?,  // Nếu variant discount theo đ
  price: int,
  note: String?,
)
```

### PaymentInput
```dart
PaymentInput(
  method: String,  // paymentMethodName
  amount: int,  // customerPaid
)
```

### InfoAdditionalInput
```dart
InfoAdditionalInput(
  salesType: String,  // 'RETAIL_PRICE' (default)
  branchId: String?,
  soldById: String?,
  saleChannel: String?,
  scheduledDeliveryAt: String?,  // ISO 8601 format
  orderCode: String?,
  expectedPayment: String?,
)
```

### InvoiceInput
```dart
InvoiceInput(
  type: String,  // 'COMPANY'
  taxCode: String?,
  email: String?,
  addressId: String?,
  name: String?,
)
```

### Convert to Map
Khi cần gửi lên API, sử dụng `orderInput.toMap()` để convert sang `Map<String, dynamic>`:
```dart
final orderInput = _generateOrderBody();
final bodyMap = orderInput.toMap();  // Convert sang Map
```

## Logic Details

### Order Status
- **PROCESSING**: Nếu `paidMap.isNotEmpty` (có payment)
- **null**: Nếu không có payment (dùng default từ API)

### Discount Calculation

#### Order-level Discount
- **Percentage**: `discountValue = totalProductPrice * (discount / 100)`
- **Absolute**: `discountValue = discount`

#### Product-level Discount (per unit)
- **Percentage**: `variantDiscount = variant.price * (variant.discount / 100)`
- **Absolute**: `variantDiscount = variant.discount`
- **Note**: Discount được tính cho 1 đơn vị, sau đó nhân với quantity

### Payment Details Filter
```dart
final paidList = paymentDetails
    .where((item) {
      final label = item['paymentMethodName'] as String?;
      final value = (item['customerPaid'] as num?)?.toDouble() ?? 0.0;
      return label != null && label.isNotEmpty && value > 0;
    })
    .map((item) => PaymentInput(
          method: item['paymentMethodName'] as String,
          amount: ((item['customerPaid'] as num?)?.toDouble() ?? 0.0).toInt(),
        ))
    .toList();
```

### Delivery Date Format
- Combine `deliveryDate` với current time
- Format: ISO 8601 string (`toIso8601String()`)
- Example: `'2025-01-15T14:30:45.000Z'`

### Invoice Data Priority
1. **billingAddress** (ưu tiên)
2. **purchaseAddress** (fallback)

## Known Issues

### Fixed
- ✅ Inconsistency trong cách lấy products: Đã sửa từ `value` → `valueOrNull ?? []`

### Pending
- ⚠️ Empty string cho `productId` nếu cả `variant.productId` và `variant.product?.id` đều null
- ⚠️ Empty string cho `customerId` mặc dù đã validate
- ⚠️ `scheduledDeliveryAt` sử dụng `DateTime.now()` làm test khó kiểm tra
- ⚠️ Không validate `selectedWarehouse`, `paymentDetails` structure, variant `productId`
- ⚠️ Không cache kết quả, tính toán lại mỗi lần
- ⚠️ Không có try-catch để handle exception

## TODO Items
- `companyId`: Cần xác định cách lấy từ Staff hoặc Auth
- `collaboratorId`: Cần thêm nếu có
- `discountReason`: Cần thêm nếu có
- `tags`: Cần thêm nếu có
- `salesType`: Hiện mặc định `'RETAIL_PRICE'`, cần xác định logic
- `orderCode`: Cần thêm nếu có
- `expectedPayment`: Cần thêm nếu có
- `variant.note`: Cần thêm nếu có
- `delivery`: User sẽ tự implement `mapDeliveryForCreateShipment()`

## Testing

### Test Plan
- **File**: `test/views/order/create_order/create_order_screen_test.md`
- **18 test cases** được document:
  - Validation tests (2)
  - Success flow tests (6)
  - Edge cases (7)
  - Data format tests (3)

### Test File
- **File**: `test/views/order/create_order/create_order_screen_test.dart`
- **Status**: Structure created, cần implement đầy đủ

### Error List
- **File**: `test/views/order/create_order/ERRORS_LIST.md`
- **14 lỗi** được document và phân loại

## Related Files
- `lib/views/order/create_order/create_order_screen.dart` - Main implementation
- `lib/data/models/order/create_order_input.dart` - **CreateOrderInput model và nested models**
- `lib/views/order/create_order/components/payment_section.dart` - Payment details management
- `lib/data/repositories/order_repository.dart` - Products source
- `test/views/order/create_order/create_order_screen_test.md` - Test plan
- `test/views/order/create_order/ERRORS_LIST.md` - Error list

