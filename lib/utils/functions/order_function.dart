import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zili_coffee/utils/helpers/crash_logger.dart';

import '../../data/models/address/base_address.dart';
import '../../data/models/order/order_line_item.dart';
import '../../data/models/order/payment_detail/order_payment.dart';
import '../../data/models/order/payment_detail/seller_payment_method.dart';
import '../../data/models/product/product_variant.dart'
    show ProductVariant, ProductVariantOption;
import '../../res/res.dart';
import '../enums/order_enum.dart'
    show
        OrderTimelineProcessStatus,
        OrderStatus,
        OrderShipmentStatus,
        QuoteStatus;
import '../enums/payment_enum.dart' show PaymentStatus;
import '../enums/product_enum.dart' show WeightUnitTypes;
import '../enums.dart';

/// Render customer address as a formatted string
/// Combines address, ward, district, and province separated by commas
///
/// Example:
/// ```dart
/// final address = BaseAddress(
///   address: '123 Đường ABC',
///   ward: 'Phường 1',
///   district: 'Quận 1',
///   province: 'TP. HCM',
/// );
/// final formatted = renderBaseAddress(address);
/// // Result: "123 Đường ABC, Phường 1, Quận 1, TP. HCM"
/// ```
String renderBaseAddress(BaseAddress? data) {
  if (data == null) return '';

  final addressArray = [data.address, data.ward, data.district, data.province];

  // Filter out null and empty strings, then join with ", "
  return addressArray
      .where((item) => item != null && item.toString().trim().isNotEmpty)
      .map((item) => item.toString().trim())
      .join(', ');
}

/// Render variant options as a formatted string
/// Combines all option values separated by " - "
///
/// Example:
/// ```dart
/// final options = [
///   ProductVariantOption(name: 'Size', value: 'L'),
///   ProductVariantOption(name: 'Color', value: 'Đỏ'),
/// ];
/// final formatted = renderVariantOptions(options);
/// // Result: "L - Đỏ"
/// ```
///
/// Returns null if options is null or empty
String? renderVariantOptions(List<ProductVariantOption>? options) {
  if (options == null || options.isEmpty) return null;

  return options
      .map((opt) => opt.value.trim())
      .where((value) => value.isNotEmpty)
      .join(' - ');
}

/// Render product variant name with language preference
/// Combines product title (Vi/En) with variant options
///
/// Example:
/// ```dart
/// final product = ProductInfo(
///   id: '1',
///   titleVi: 'Cà phê đen',
///   titleEn: 'Black coffee',
/// );
/// final options = [
///   ProductVariantOption(name: 'Size', value: 'L'),
/// ];
/// final name = renderProductVariantName('vi', product, options);
/// // Result: "Cà phê đen - L"
/// ```
///
/// Parameters:
/// - language: Language code ('vi' or 'en')
/// - item: ProductInfo object with titleVi/titleEn or object with productNameVi/productNameEn
/// - options: List of ProductVariantOption or null
///
/// Returns formatted string or AppConstant.strings.DEFAULT_EMPTY_VALUE if no data available
String renderProductVariantName(
  ProductVariant? item,
  List<ProductVariantOption>? options, {
  String language = 'vi',
}) {
  final List<String> titleArr = [];

  // Try to get title from ProductInfo or item with titleVi/titleEn
  String? title;
  if (item?.product != null) {
    title = language == 'vi'
        ? (item?.product?.titleVi ?? item?.product?.titleEn)
        : (item?.product?.titleEn ?? item?.product?.titleVi);
  } else if (item != null) {
    // Try to access titleVi/titleEn dynamically
    final titleVi = _getDynamicValue(item, 'titleVi');
    final titleEn = _getDynamicValue(item, 'titleEn');

    if (titleVi != null || titleEn != null) {
      title = language == 'vi' ? (titleVi ?? titleEn) : (titleEn ?? titleVi);
    } else {
      // Fallback to productNameVi/productNameEn
      final productNameVi = _getDynamicValue(item, 'productNameVi');
      final productNameEn = _getDynamicValue(item, 'productNameEn');
      title = language == 'vi'
          ? (productNameVi ?? productNameEn)
          : (productNameEn ?? productNameVi);
    }
  }

  if (title != null && title.trim().isNotEmpty) {
    titleArr.add(title.trim());
  }

  // Add options if available
  if (options != null && options.isNotEmpty) {
    final optionValues = options
        .map((opt) => opt.value.trim())
        .where((value) => value.isNotEmpty);
    titleArr.addAll(optionValues);
  }

  return titleArr.isNotEmpty
      ? titleArr.join(' - ')
      : AppConstant.strings.DEFAULT_EMPTY_VALUE;
}

/// Render product variant title + options (pattern tương tự JS renderProductVariantTitle)
/// - Ưu tiên titleVi/titleEn từ product nếu có; fallback productNameVi/productNameEn
/// - Options: hỗ trợ List<ProductVariantOption>, List<dynamic>, hoặc chuỗi JSON list
/// - Ngăn null/empty và join bằng " - "
/// Helper function to get dynamic value from object
String? _getDynamicValue(dynamic item, String key) {
  if (item == null) return null;

  try {
    // Try to access as Map
    if (item is Map) {
      final value = item[key];
      return value?.toString();
    }

    // Try to access using reflection-like approach
    // This is a fallback for dynamic objects
    return null;
  } catch (e) {
    return null;
  }
}

/// Render payment method name from dynamic data
///
/// Helper function to extract payment name from dynamic object
/// Supports nameVi/nameEn, titleVi/titleEn, or name fields
String _renderPaymentName(dynamic data) {
  if (data == null) return '';

  // Try to access as Map
  if (data is Map<String, dynamic>) {
    // Try nameVi/nameEn first (for SellerPaymentMethod-like structure)
    final nameVi = data['nameVi']?.toString();
    final nameEn = data['nameEn']?.toString();
    if (nameVi != null || nameEn != null) {
      return nameVi ?? nameEn ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;
    }

    // Try titleVi/titleEn (for BankInfo-like structure)
    final titleVi = data['titleVi']?.toString();
    final titleEn = data['titleEn']?.toString();
    if (titleVi != null || titleEn != null) {
      return titleVi ?? titleEn ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;
    }

    // Fallback to name field
    return data['name']?.toString() ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;
  } else if (data is SellerPaymentMethod) {
    return data.nameVi.isNotEmpty ? data.nameVi : data.nameEn;
  }

  return AppConstant.strings.DEFAULT_EMPTY_VALUE;
}

/// Render payment method name with full logic
///
/// Handles COD collection, expected payment method, payment method info, and bank info
///
/// Parameters:
/// - data: Dynamic object containing payment information (Map or typed object)
/// - language: Language code ('vi' or 'en')
/// - t: Translation function (String Function(String))
/// - isCODCollect: Whether this is a COD collection payment
///
/// Returns formatted payment method name string
String renderPaymentMethodName(dynamic data, bool isCODCollect) {
  if (isCODCollect) {
    // Check if status is COMPLETED
    String? status;
    if (data is Map<String, dynamic>) {
      status = data['status']?.toString();
    } else if (data is OrderPayment) {
      status = data.status;
    }

    final isCompleted = status == PaymentStatus.completed.toConstant;
    return isCompleted ? "Thu hộ COD" : "Chờ thu hộ COD";
  }

  String title = "";

  // Check for expectedPaymentMethodInfo
  dynamic expectedPaymentMethodInfo;
  if (data is Map<String, dynamic>) {
    expectedPaymentMethodInfo = data['expectedPaymentMethodInfo'];
  }

  if (expectedPaymentMethodInfo != null) {
    final payment = expectedPaymentMethodInfo;
    title = _renderPaymentName(payment);

    // Check for bankInfo in payment
    dynamic bankInfo;
    if (payment is Map<String, dynamic>) {
      bankInfo = payment['bankInfo'];
    }

    if (bankInfo != null) {
      // Check for methodName in bankInfo
      String? methodName;
      if (bankInfo is Map<String, dynamic>) {
        methodName = bankInfo['methodName']?.toString();
      }

      if (methodName != null && methodName.isNotEmpty) {
        return methodName;
      }

      // Build from title, bankCode, accountOwner
      final parts = <String>[title];

      String? bankCode;
      String? accountOwner;
      if (payment is Map<String, dynamic>) {
        bankCode = payment['bankCode']?.toString();
      }
      if (bankInfo is Map<String, dynamic>) {
        accountOwner = bankInfo['accountOwner']?.toString();
        bankCode ??= bankInfo['bankCode']?.toString();
      }

      if (bankCode != null && bankCode.isNotEmpty) {
        parts.add(bankCode);
      }
      if (accountOwner != null && accountOwner.isNotEmpty) {
        parts.add(accountOwner);
      }

      return parts.where((part) => part.isNotEmpty).join(" ");
    }

    return title;
  }

  // Check for paymentMethodInfo
  dynamic paymentMethodInfo;
  if (data is Map<String, dynamic>) {
    paymentMethodInfo = data['paymentMethodInfo'];
  } else if (data is OrderPayment) {
    paymentMethodInfo = data.paymentMethodInfo;
  }

  if (paymentMethodInfo != null) {
    title = _renderPaymentName(paymentMethodInfo);
  } else {
    title = _renderPaymentName(data);
  }

  // Check for bankInfo (can be nested: bankInfo.bankInfo or bankInfo)
  dynamic bankInfo;
  if (data is Map<String, dynamic>) {
    final bankInfoData = data['bankInfo'];
    if (bankInfoData is Map<String, dynamic> &&
        bankInfoData['bankInfo'] != null) {
      bankInfo = bankInfoData['bankInfo'];
    } else {
      bankInfo = bankInfoData;
    }
  } else if (data is OrderPayment) {
    bankInfo = data.bankInfo;
  }

  if (bankInfo != null) {
    // Check for methodName in bankInfo
    String? methodName;
    if (bankInfo is Map<String, dynamic>) {
      if (bankInfo['bankInfo'] != null) {
        methodName = bankInfo['bankInfo']['methodName']?.toString();
      } else {
        methodName = bankInfo['methodName']?.toString();
      }
    }

    if (methodName != null && methodName.isNotEmpty) {
      return methodName;
    }

    // Build from title, bankCode, accountOwner
    final parts = <String>[title];

    String? bankCode;
    String? accountOwner;
    if (bankInfo is Map<String, dynamic>) {
      bankCode = bankInfo['bankCode']?.toString();
      accountOwner = bankInfo['accountOwner']?.toString();
    }

    if (bankCode != null && bankCode.isNotEmpty) {
      parts.add(bankCode);
    }
    if (accountOwner != null && accountOwner.isNotEmpty) {
      parts.add(accountOwner);
    }

    return parts.where((part) => part.isNotEmpty).join(" ");
  }

  return title;
}

Color? paymentColorByCOD(bool isAwaitCOD, [bool isCompleted = false]) {
  if (isAwaitCOD) {
    return isCompleted ? AppColors.success : AppColors.warning;
  } else {
    return isCompleted ? AppColors.success : AppColors.warning;
  }
}

/// Render timeline process status label
///
/// Maps timeline process status type to Vietnamese label
///
/// Parameters:
/// - type: String value of timeline process status (e.g., "PENDING", "PROCESSING")
///
/// Returns Vietnamese label string or original type if not found
String renderTimelineProcessStatusLabel(String? type) {
  if (type == null || type.isEmpty) return '--';

  final status = OrderTimelineProcessStatus.fromString(type);
  return status?.label ?? type;
}

String? renderOrderStatus(OrderStatus? status) {
  switch (status) {
    case .pending:
      return "Đặt hàng";
    case .processing:
      return "Đang giao dịch";
    case .completed:
      return "Đã hoàn thành";
    case .cancelled:
      return "Đã hủy";
    default:
      log("renderOrderStatus: $status");
      return null;
  }
}

Color? orderStatusColor(OrderStatus? status) {
  switch (status) {
    case .pending:
      return AppColors.info;
    case .processing:
      return AppColors.warning;
    case .completed:
      return AppColors.success;
    case .cancelled:
      return AppColors.cancel;
    default:
      log("renderOrderStatus: $status");
      return null;
  }
}

/// Converts weight in grams to a human-readable string format.
///
/// Converts grams to kilograms if the value is >= 1000 and divisible by 1000,
/// otherwise returns the value in grams.
///
/// **Examples:**
/// ```dart
/// convertProductWeight(0);      // Returns: "0g"
/// convertProductWeight(500);    // Returns: "500g"
/// convertProductWeight(1000);   // Returns: "1kg"
/// convertProductWeight(2000);  // Returns: "2kg"
/// convertProductWeight(1500);  // Returns: "1500g" (not divisible by 1000)
/// convertProductWeight(null);   // Returns: "0g"
/// ```
///
/// **Parameters:**
/// - [grams]: Weight in grams. Can be null, int, double, or num.
///
/// **Returns:**
/// - Formatted string: `"{value}kg"` if >= 1000 and divisible by 1000
/// - Formatted string: `"{value}g"` otherwise
/// - `"0g"` if grams is null, 0, or invalid
String convertProductWeight(num? grams) {
  // Handle null or zero values
  if (grams == null || grams <= 0) {
    return '0g';
  }

  // Convert to int for cleaner division check
  final gramsInt = grams.toInt();

  // Convert to kg if >= 1000 and divisible by 1000
  if (gramsInt >= 1000 && gramsInt % 1000 == 0) {
    return '${gramsInt ~/ 1000}kg';
  }

  // Return in grams
  return '${gramsInt}g';
}

/// Checks if a unit string matches any weight unit type from [WeightUnitTypes] enum.
///
/// These units are considered "weight units" themselves, so displaying
/// weight alongside them would be redundant.
bool _isWeightUnitType(String unit) {
  return WeightUnitTypes.values.any(
    (weightUnit) => weightUnit.valueVi.toLowerCase() == unit.toLowerCase(),
  );
}

/// Interface for objects that have measure unit and weight properties.
///
/// This mixin defines the contract for extracting measure unit and weight
/// from different object types for rendering product units.
mixin MeasureUnitAndWeight {
  /// Gets the measure unit string (e.g., 'g', 'kg', 'cái', 'chai', 'hũ').
  String? get measureUnit;

  /// Gets the weight value in grams.
  num? get weight;
}

/// Renders product unit with optional weight information.
///
/// Combines product weight and measure unit into a formatted string.
/// If weight should be hidden (based on unit type and flag), returns only the unit.
///
/// **Type Safety:**
/// The function uses generic type `T` constrained to [MeasureUnitAndWeight].
/// Supported types: [OrderLineItem] (implements [MeasureUnitAndWeight]),
/// [ProductVariant] (via extension), or any object implementing [MeasureUnitAndWeight] mixin.
///
/// **Examples:**
/// ```dart
/// // Using OrderLineItem
/// final orderItem = OrderLineItem(...);
/// renderProductUnit(orderItem, hideWeightWithOtherUnit: false);
/// // Returns: "500g/g" or "kg" based on unit and weight
///
/// // Using ProductVariant
/// final variant = ProductVariant(...);
/// renderProductUnit(variant, hideWeightWithOtherUnit: true);
/// // Returns: "kg" if unit is weight unit, otherwise "500g/g"
///
/// // No weight provided
/// final itemWithoutWeight = OrderLineItem(unitValue: null, ...);
/// renderProductUnit(itemWithoutWeight);
/// // Returns: measureUnit only (e.g., "cái")
///
/// // Invalid object (no measureUnit/weight)
/// renderProductUnit(SomeOtherObject());
/// // Throws: ArgumentError
/// ```
///
/// **Parameters:**
/// - [data]: Object of type `T` that implements [MeasureUnitAndWeight] mixin.
///   Supported types: [OrderLineItem] (implements mixin), [ProductVariant] (via extension),
///   or any object implementing [MeasureUnitAndWeight] mixin.
/// - [hideWeightWithOtherUnit]: If true, hides weight for weight-based units
///   from [WeightUnitTypes] enum (g, kg, cái, chai, hũ). Defaults to `false`.
///
/// **Returns:**
/// - Empty string `""` if `measureUnit` is null or empty
/// - `measureUnit` only if:
///   - `weight` is null/0, OR
///   - `hideWeightWithOtherUnit` is true AND unit is a weight unit
/// - `"{weight}/{measureUnit}"` format otherwise
///
/// **Throws:**
/// - [ArgumentError] if the object type `T` does not implement
///   [MeasureUnitAndWeight] mixin or have accessible `measureUnit` and `weight`.
///
/// **Note:**
/// - [OrderLineItem] implements [MeasureUnitAndWeight] directly with override getters.
/// - [ProductVariant] uses extension [ProductVariantMeasureUnitExtension] for `measureUnit`.
/// - For new types, implement [MeasureUnitAndWeight] mixin or add extension.
String renderProductUnit<T>(T data, {bool hideWeightWithOtherUnit = false}) {
  try {
    // Extract measureUnit and weight from data
    String? measureUnit;
    num? weight;

    // Check if data implements MeasureUnitAndWeight mixin
    if (data is MeasureUnitAndWeight) {
      // OrderLineItem implements mixin directly
      measureUnit = data.measureUnit;
      weight = data.weight;
    } else if (data is ProductVariant) {
      // ProductVariant uses extension for measureUnit
      measureUnit = data.measureUnit;
      weight = data.weight;
    } else {
      // Invalid type - log error and return empty string
      log(
        'renderProductUnit: Object of type ${T.toString()} does not implement '
        '[MeasureUnitAndWeight] mixin or have accessible `measureUnit` and `weight`. '
        'Supported types: OrderLineItem (implements MeasureUnitAndWeight), '
        'ProductVariant (via extension), or objects implementing MeasureUnitAndWeight mixin.',
      );
      return '';
    }

    // Validate that measureUnit exists
    if (measureUnit == null || measureUnit.trim().isEmpty) {
      return '';
    }

    // Normalize measure unit for comparison (case-insensitive)
    final normalizedUnit = measureUnit.trim().toLowerCase();

    // Check if weight should be hidden
    final shouldHideWeight =
        hideWeightWithOtherUnit && _isWeightUnitType(normalizedUnit);

    // Return only unit if no weight or should hide weight
    if (weight == null || weight <= 0 || shouldHideWeight) {
      return measureUnit.trim();
    }

    // Return combined format: "weight/unit"
    return '${convertProductWeight(weight)}/${measureUnit.trim()}';
  } catch (e, stackTrace) {
    // Catch any unexpected errors and log them
    log(
      'renderProductUnit: Unexpected error occurred',
      error: e,
      stackTrace: stackTrace,
    );
    // Try to return measureUnit if available, otherwise return empty string
    try {
      if (data is MeasureUnitAndWeight) {
        final measureUnit = data.measureUnit;
        if (measureUnit != null && measureUnit.trim().isNotEmpty) {
          return measureUnit.trim();
        }
      } else if (data is ProductVariant) {
        final measureUnit = data.measureUnit;
        if (measureUnit != null && measureUnit.trim().isNotEmpty) {
          return measureUnit.trim();
        }
      }
    } catch (e) {
      CrashLogger.tryToRecordError(
        'renderProductUnit: Unexpected error occurred',
        error: e,
        stackTrace: stackTrace,
      );
    }
    return '';
  }
}

/// Render order shipment status label
///
/// Maps shipment status string to Vietnamese label
///
/// Parameters:
/// - status: String value of shipment status (e.g., "PENDING_PICKUP", "DELIVERING")
///   or special values: "ALL", "FILTER_RESULTS"
///
/// Returns Vietnamese label string or "---" if not found
String renderOrderShipmentStatus(String? status) {
  if (status == null || status.isEmpty) {
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  // Handle special filter values
  if (status == 'ALL') {
    return 'Tất cả đơn hàng';
  }
  if (status == 'FILTER_RESULTS') {
    return 'Kết quả tìm kiếm';
  }

  if (status == OrderShipmentStatus.pendingPickup.toConstant) {
    return "Chờ lấy hàng";
  }
  if (status == OrderShipmentStatus.delivering.toConstant) {
    return "Đang giao hàng";
  }
  if (status == OrderShipmentStatus.delivered.toConstant) {
    return "Đã giao hàng";
  }
  if (status == OrderShipmentStatus.returnWaiting.toConstant) {
    return "Hủy giao hàng - Chờ trả hàng";
  }
  if (status == OrderShipmentStatus.returned.toConstant) {
    return "Hủy giao hàng - Đã nhận lại";
  }
  if (status == OrderShipmentStatus.redeliveryWaiting.toConstant) {
    return "Chờ giao lại";
  }
  if (status == OrderShipmentStatus.packingCancelled.toConstant) {
    return "Hủy đóng gói";
  }

  return AppConstant.strings.DEFAULT_EMPTY_VALUE;
}

/// Render order shipment status color
///
/// Maps shipment status string to Color based on status type
///
/// Parameters:
/// - status: String value of shipment status (e.g., "PENDING_PICKUP", "DELIVERING")
///
/// Returns Color based on status:
/// - warning: DELIVERING
/// - success: DELIVERED
/// - info: REDELIVERY_WAITING, PENDING_PICKUP
/// - danger: RETURNED, RETURN_WAITING, PACKING_CANCELLED
/// - secondary: default/unknown
Color? renderOrderShipmentStatusColor(String? status) {
  if (status == null || status.isEmpty) return AppColors.grey84;

  if (status == OrderShipmentStatus.pendingPickup.toConstant) {
    return SystemColors.primaryBlue;
  }
  if (status == OrderShipmentStatus.delivering.toConstant) {
    return AppColors.warning;
  }
  if (status == OrderShipmentStatus.delivered.toConstant) {
    return AppColors.green;
  }
  if (status == OrderShipmentStatus.returnWaiting.toConstant) {
    return SystemColors.tertiaryRed;
  }
  if (status == OrderShipmentStatus.returned.toConstant) {
    return SystemColors.tertiaryRed;
  }
  if (status == OrderShipmentStatus.redeliveryWaiting.toConstant) {
    return SystemColors.primaryBlue;
  }
  if (status == OrderShipmentStatus.packingCancelled.toConstant) {
    return SystemColors.tertiaryRed;
  }
  return AppColors.grey84;
}

String? renderPriceType(String? priceType) {
  switch (priceType) {
    case 'COST_PRICE':
      return 'Giá nhập';
    case 'WHOLESALE_PRICE':
      return 'Giá bán buôn';
    case 'RETAIL_PRICE':
      return 'Giá bán lẻ';
    default:
      return null;
  }
}

String? renderRequiredDelivery(String? type) {
  switch (type) {
    case 'NO_VIEW':
      return "Không cho xem hàng";
    case 'VIEW_AND_TRY':
      return 'Cho xem hàng, cho thử';
    case 'VIEW_ONLY':
      return 'Cho xem hàng, không cho thử';
    default:
      return null;
  }
}

String? renderPayingParty(String? type) {
  switch (type) {
    case 'CUSTOMER':
      return "Khách hàng";
    case 'STORE':
      return 'Cửa hàng';
    default:
      return null;
  }
}

String? renderReconciliation(String? type) {
  switch (type) {
    case 'NOT_RECONCILED':
      return "Chưa đối soát";
    case 'RECONCILING':
      return 'Đang đối soát';
    case 'RECONCILED':
      return 'Đã đối soát';
    default:
      return null;
  }
}

String? renderQuoteStatus(QuoteStatus? status) {
  switch (status) {
    case QuoteStatus.pending:
      return "Đang chờ duyệt";
    case QuoteStatus.approved:
      return "Đã duyệt";
    case QuoteStatus.rejected:
      return "Từ chối";
    case QuoteStatus.cancelled:
      return "Đã hủy";
    default:
      return null;
  }
}

Color? quoteStatusColor(QuoteStatus? status) {
  switch (status) {
    case QuoteStatus.pending:
      return AppColors.warning;
    case QuoteStatus.approved:
      return AppColors.success;
    case QuoteStatus.rejected:
    case QuoteStatus.cancelled:
      return AppColors.cancel;
    default:
      return null;
  }
}
