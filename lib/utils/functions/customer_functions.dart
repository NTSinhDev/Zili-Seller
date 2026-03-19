import 'package:flutter/material.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/list.dart';

import '../../data/entity/user/customer_entity.dart';
import '../../res/res.dart';
import '../enums/customer_enum.dart';
import 'base_functions.dart';

String? labelCustomerGroupType(String? typeStr) {
  final typeFromString = CustomerGroupType.values.valueBy(
    (item) => item.toConstant == typeStr,
  );

  switch (typeFromString) {
    case null:
      return null;
    case .fixed:
      return 'Cố định';
    case .automatic:
      return 'Tự động';
  }
}

Color? colorCustomerGroupType(String? typeStr) {
  final typeFromString = CustomerGroupType.values.valueBy(
    (item) => item.toConstant == typeStr,
  );

  switch (typeFromString) {
    case null:
      return null;
    case .fixed:
      return SystemColors.secondaryPurple50;
    case .automatic:
      return SystemColors.primaryBlue50;
  }
}

String? renderUserStatus(UserStatus? status) {
  switch (status) {
    case null:
      return null;
    case UserStatus.active:
      return 'Hoạt động';
    case UserStatus.inactive:
      return 'Không hoạt động';
    case UserStatus.blocked:
      return 'Bị khóa';
    case UserStatus.suspend:
      return 'Bị tạm dừng';
  }
}

Color? colorUserStatus(UserStatus? status) {
  switch (status) {
    case null:
      return null;
    case UserStatus.active:
      return AppColors.success;
    case UserStatus.inactive:
      return AppColors.warning;
    case UserStatus.blocked:
      return AppColors.background;
    case UserStatus.suspend:
      return AppColors.scarlet;
  }
}

Color? renderCustomerStatusColor(UserStatus? status) {
  switch (status) {
    case UserStatus.active:
      return AppColors.success;
    case UserStatus.inactive:
    case UserStatus.suspend:
      return AppColors.warning;
    default:
      return null;
  }
}

String? renderCustomerStatus(UserStatus? status) {
  switch (status) {
    case UserStatus.active:
      return "Đang giao dịch";
    case UserStatus.inactive:
    case UserStatus.suspend:
      return "Ngừng giao dịch";
    default:
      return null;
  }
}
String? debtActionLabel(DebtAction? action) {
  if (action == null) return null;
  
  switch (action) {
    case DebtAction.createReceipt:
      return "Tạo phiếu chi";
    case DebtAction.createPayment:
      return "Tạo phiếu thu";
    case DebtAction.cancelReceipt:
      return "Hủy phiếu thu";
    case DebtAction.cancelPayment:
      return "Hủy phiếu chi";
    case DebtAction.orderPayment:
      return "Thanh toán thành công với đơn COD";
    case DebtAction.cancelDeliveryOrder:
      return "Hủy giao hàng thành công";
    case DebtAction.returnPurchaseOrder:
      return "Tạo đơn trả hàng";
    case DebtAction.returnOrder:
      return "Trả hàng";
    case DebtAction.orderDeliverySuccess:
      return "Giao thành công";
    case DebtAction.createPurchaseOrder:
      return "Tạo phiếu nhập hàng";
  }
}

/// Render voucher value with operator prefix and currency formatting (from Map)
/// 
/// - Extracts value at [key] from [row] Map
/// - Extracts operator from row['operator']
/// - Adds "-" prefix if operator is "SUBTRACTION", otherwise empty string
/// - Formats the value as currency
/// - Returns "0" if value is not a finite number
/// 
/// Example:
/// ```dart
/// final row = {'amount': 100000, 'operator': 'SUBTRACTION'};
/// renderVoucherValue(row, 'amount'); // Returns "-100.000"
/// ```
String renderVoucherValue(Map<String, dynamic> row, String key) {
  final value = row[key];
  final operator = row['operator']?.toString();
  return _renderVoucherValueInternal(value, operator);
}

/// Render voucher value with operator prefix and currency formatting (direct value)
/// 
/// - Checks if [value] is a finite number
/// - Adds "-" prefix if [operator] is "SUBTRACTION", otherwise empty string
/// - Formats the value as currency
/// - Returns "0" if value is not a finite number
/// 
/// Example:
/// ```dart
/// renderVoucherValueDirect('100000', operator: 'SUBTRACTION'); // Returns "-100.000"
/// renderVoucherValueDirect(100000, operator: 'ADDITION'); // Returns "100.000"
/// ```
String renderVoucherValueDirect(dynamic value, {String? operator}) {
  return _renderVoucherValueInternal(value, operator);
}

/// Internal helper function to render voucher value
String _renderVoucherValueInternal(dynamic value, String? operator) {
  // Try to parse value to double
  double? numericValue;
  if (value is num) {
    numericValue = value.toDouble();
  } else if (value is String) {
    numericValue = double.tryParse(value);
  }
  
  // Check if value is finite number
  if (numericValue != null && numericValue.isFinite) {
    final operatorPrefix = operator?.toString() == 'SUBTRACTION' ? '-' : '';
    final formattedValue = formatCurrency(numericValue);
    return '$operatorPrefix$formattedValue';
  }
  
  return '0';
}