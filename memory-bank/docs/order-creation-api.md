# Order Creation API Documentation

## Overview
API endpoint để tạo đơn hàng bởi seller với đầy đủ thông tin: products, customer, payment, delivery, invoice.

## Endpoint
- **URL**: `POST /enterprise/order/create`
- **Service**: Core Service
- **Base URL**: Core Service base URL
- **Authentication**: Bearer token required

## Request

### Request Body Structure
```json
{
  "order": {
    "status": "PROCESSING",
    "deliveryFee": "25000",
    "discount": "15000",
    "discountPercent": 0,
    "discountReason": null,
    "companyId": "6599fa5a-a83b-473c-a64d-73a1d9dd6f38",
    "products": [
      {
        "productId": "7a1fa4c0-1407-45ff-9908-e09ecf647410",
        "productVariantId": "3ec9a77b-9796-42cf-89ac-f82abce5de3e",
        "quantity": 1,
        "discountPercent": 0,
        "discount": 0,
        "price": 0,
        "note": null
      }
    ],
    "note": "",
    "tags": null
  },
  "customerId": "57169855-fb83-4de7-ad02-935f8e1653a7",
  "addressCustomerId": "560a2359-147f-48f8-81cc-960bf9c3d8e7",
  "paid": [
    {
      "method": "CASH",
      "amount": 120000
    }
  ],
  "delivery": {
    "deliveryCode": "DELIVERY_LATER",
    "warehouseId": "9852f20e-5728-4ac1-b6d9-1f1f7341269c"
  },
  "infoAdditional": {
    "salesType": "RETAIL_PRICE",
    "branchId": "9852f20e-5728-4ac1-b6d9-1f1f7341269c",
    "soldById": "276af2b8-ad50-4e69-b318-d50a8832c730",
    "saleChannel": "TIKTOK",
    "scheduledDeliveryAt": null
  },
  "invoice": {
    "type": "COMPANY",
    "taxCode": null,
    "email": "haiminhle88888@yopmail.com",
    "addressId": "560a2359-147f-48f8-81cc-960bf9c3d8e7",
    "name": "WOWI VIETNAM"
  }
}
```

### Request Models
- **CreateOrderInput**: Main request model
  - `order`: OrderInput
  - `customerId`: String (required)
  - `addressCustomerId`: String? (required if customer has address)
  - `paid`: List<PaymentInput>
  - `delivery`: Map<String, dynamic>? (from `_mapDeliveryForCreateShipment()`)
  - `infoAdditional`: InfoAdditionalInput
  - `invoice`: InvoiceInput

### Field Notes
- `deliveryFee` và `discount` trong `OrderInput` phải là String (not int)
- `paymentMethod` trong `PaymentInput` có thể là enum (e.g., "CASH") hoặc name
- `delivery` được map từ `_mapDeliveryForCreateShipment()` function
- `companyId` lấy từ `_authRepository.currentUser?.company?.id`

## Response

### Success Response Structure
```json
{
  "status": 1,
  "data": {
    "id": "ca0aa47c-afb6-49c2-9111-321523a86e9a",
    "status": "PENDING",
    "code": "SON00817",
    "orderCode": null,
    "note": null,
    "orderItems": [
      {
        "id": "f918a90d-46a1-473e-89bf-c8e0c1118606",
        "quantity": 1,
        "amount": 125000,
        "sku": "HR00016",
        "price": 125000,
        "originalPrice": 0,
        "discount": 0,
        "discountPercent": 0,
        "productId": "b0ca1d60-a3c7-4ef9-b7a3-06de7362c45a",
        "variantId": "492243e5-c520-4283-8524-52a1890466c9",
        "note": null,
        "type": "PRODUCT"
      }
    ],
    "orderInfo": {
      "id": "9ba37cf1-fdb2-4396-be8c-563c765e4234",
      "userId": "57169855-fb83-4de7-ad02-935f8e1653a7",
      "fullName": "WOWI VIETNAM",
      "email": "haiminhle88888@yopmail.com",
      "phoneNumber": "(+84) 798 615 992",
      "infoAdditional": {
        "salesType": "RETAIL_PRICE",
        "branchId": "9852f20e-5728-4ac1-b6d9-1f1f7341269c",
        "soldById": "671c5283-0957-46e7-8db2-86ddb041f36e",
        "saleChannel": "TIKTOK"
      }
    },
    "orderDelivery": {
      "address": "hfjcjcjcjvjvkvjvnvjv",
      "province": "Tỉnh An Giang",
      "ward": "Phường Mỹ Thới",
      "deliveryCode": "DELIVERY_LATER",
      "deliveryFee": 0,
      "cod": 0
    },
    "delivery": {
      "id": "8e2d8457-051f-4a16-85bf-74fa5e4c932a",
      "code": "DELIVERY_LATER",
      "nameVi": "Giao hàng sau",
      "nameEn": "Giao hàng sau"
    },
    "totalAmount": 125000,
    "totalPaid": 0,
    "deliveryFee": 0,
    "deliveryCode": "DELIVERY_LATER",
    "warehouseId": "9852f20e-5728-4ac1-b6d9-1f1f7341269c",
    "createdAt": "2025-11-24T11:23:06.644Z",
    "updatedAt": "2025-11-24T11:23:06.644Z"
  }
}
```

### Response Models
- **Order**: Main response model (parsed using `Order.fromMapNew()`)
  - `orderItems`: List<OrderItem>
  - `orderInfo`: OrderInfo
  - `orderDelivery`: OrderDelivery
  - `delivery`: DeliveryGroup
  - New fields: `totalAmount`, `totalPaid`, `deliveryFee`, `deliveryCode`, `warehouseId`, etc.

## Validation

### Client-Side Validation (OrderCubit.sellerCreateOrder)
1. **Customer**: `customerId` must not be empty
2. **Address**: `addressCustomerId` must not be null or empty
3. **Branch**: `branchId` in `infoAdditional` must not be null or empty
4. **Products**: Must have at least one product
5. **Product Quantity**: Each product must have quantity > 0
6. **Staff**: `soldById` in `infoAdditional` must not be null or empty

### Validation States
- `ValidateOrderState`: Validation started
- `InvalidOrderState`: Validation failed (contains error message)
- `LoadingOrderState`: API call in progress
- `LoadedOrderState`: Order created successfully
- `ErrorOrderState`: API call failed

## Implementation

### OrderCubit
```dart
Future<void> sellerCreateOrder(CreateOrderInput input) async {
  emit(ValidateOrderState());
  
  // Validation logic...
  
  emit(LoadingOrderState());
  final result = await _orderMiddleware.sellerCreateOrder(input);
  if (result is ResponseSuccessState<Order>) {
    _orderRepository.currentOrder = result.responseData;
    emit(LoadedOrderState());
  } else if (result is ResponseFailedState) {
    emit(ErrorOrderState(error: result.errorMessage, detail: result));
  }
}
```

### OrderMiddleware
```dart
Future<ResponseState> sellerCreateOrder(CreateOrderInput input) async {
  final response = await coreDio.post<NWResponse>(
    '/enterprise/order/create',
    data: input.toMap(),
  );
  
  final resultData = response.data;
  if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
    final data = resultData.data['data'] ?? resultData.data;
    return ResponseSuccessState(
      responseData: Order.fromMapNew(data as Map<String, dynamic>),
    );
  }
  // Error handling...
}
```

## Delivery Mapping

### Function: _mapDeliveryForCreateShipment()
- **Location**: `CreateOrderScreen._mapDeliveryForCreateShipment()`
- **Purpose**: Map delivery data for create shipment
- **Cases**:
  - `DELIVERY_LATER`: `{deliveryCode: "DELIVERY_LATER", warehouseId: selectedWarehouse?.id}`
  - `GET_AT_STORE`: `{deliveryCode: "GET_AT_STORE", warehouseId: selectedWarehouse?.id}`
  - Default: Basic info (to be completed when documentation is available)

## Notes
- `deliveryFee` and `discount` in request must be String type
- Payment method supports both enum and name for backward compatibility
- Product variant notes are included in `OrderProductInput.note`
- Company ID is retrieved from current user's company information

