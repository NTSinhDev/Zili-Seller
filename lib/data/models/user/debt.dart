import 'dart:convert';
import 'package:zili_coffee/utils/functions/base_functions.dart';

import '../../../utils/extension/int.dart';

/// Debt Model - DTO cho debt log trong response
/// 
/// Model này chứa thông tin về công nợ của khách hàng
class Debt {
  final String id;
  final String userId;
  final String group; // CUSTOMER, etc.
  final String operator; // SUBTRACTION, ADDITION, etc.
  final String status; // COMPLETED, etc.
  final DebtType? type;
  final String? note;
  final String code;
  final String amount; // Số tiền (String từ API)
  final String? paymentMethod;
  final DateTime? recordedDate;
  final DateTime? cancelledAt;
  final String? reference;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? createdBy; // User info
  final Map<String, dynamic>? branch; // Branch info
  final Map<String, dynamic>? user; // Customer info
  final Map<String, dynamic>? paymentMethodInfo;
  final int? currentDebt; // Công nợ hiện tại sau transaction này
  final bool? isChangeDebtPayerRecipient;
  final String? orderId;
  final String? purchaseOrderId;
  final String? originalDocumentCode;
  final String? originalDocumentType;
  final String? action;
  final Map<String, dynamic>? bankInfo;

  Debt({
    required this.id,
    required this.userId,
    required this.group,
    required this.operator,
    required this.status,
    this.type,
    this.note,
    required this.code,
    required this.amount,
    this.paymentMethod,
    this.recordedDate,
    this.cancelledAt,
    this.reference,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.branch,
    this.user,
    this.paymentMethodInfo,
    this.currentDebt,
    this.isChangeDebtPayerRecipient,
    this.orderId,
    this.purchaseOrderId,
    this.originalDocumentCode,
    this.originalDocumentType,
    this.action,
    this.bankInfo,
  });

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      group: map['group']?.toString() ?? '',
      operator: map['operator']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      type: map['type'] != null
          ? DebtType.fromMap(map['type'] as Map<String, dynamic>)
          : null,
      note: map['note']?.toString(),
      code: map['code']?.toString() ?? '',
      amount: map['amount']?.toString() ?? '0',
      paymentMethod: map['paymentMethod']?.toString(),
      recordedDate: parseServerTimeZoneDateTime(map['recordedDate']),
      cancelledAt: parseServerTimeZoneDateTime(map['cancelledAt']),
      reference: map['reference']?.toString(),
      createdAt: parseServerTimeZoneDateTime(map['createdAt']),
      updatedAt: parseServerTimeZoneDateTime(map['updatedAt']),
      createdBy: map['createdBy'] as Map<String, dynamic>?,
      branch: map['branch'] as Map<String, dynamic>?,
      user: map['user'] as Map<String, dynamic>?,
      paymentMethodInfo: map['paymentMethodInfo'] as Map<String, dynamic>?,
      currentDebt: map['currentDebt'] != null
          ? (map['currentDebt'] as num?)?.toInt()
          : null,
      isChangeDebtPayerRecipient: map['isChangeDebtPayerRecipient'] as bool?,
      orderId: map['orderId']?.toString(),
      purchaseOrderId: map['purchaseOrderId']?.toString(),
      originalDocumentCode: map['originalDocumentCode']?.toString(),
      originalDocumentType: map['originalDocumentType']?.toString(),
      action: map['action']?.toString(),
      bankInfo: map['bankInfo'] as Map<String, dynamic>?,
    );
  }

  factory Debt.fromJson(String source) =>
      Debt.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'group': group,
      'operator': operator,
      'status': status,
      if (type != null) 'type': type?.toMap(),
      if (note != null) 'note': note,
      'code': code,
      'amount': amount,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (recordedDate != null) 'recordedDate': recordedDate?.toIso8601String(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toIso8601String(),
      if (reference != null) 'reference': reference,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      if (createdBy != null) 'createdBy': createdBy,
      if (branch != null) 'branch': branch,
      if (user != null) 'user': user,
      if (paymentMethodInfo != null) 'paymentMethodInfo': paymentMethodInfo,
      if (currentDebt != null) 'currentDebt': currentDebt,
      if (isChangeDebtPayerRecipient != null)
        'isChangeDebtPayerRecipient': isChangeDebtPayerRecipient,
      if (orderId != null) 'orderId': orderId,
      if (purchaseOrderId != null) 'purchaseOrderId': purchaseOrderId,
      if (originalDocumentCode != null)
        'originalDocumentCode': originalDocumentCode,
      if (originalDocumentType != null) 'originalDocumentType': originalDocumentType,
      if (action != null) 'action': action,
      if (bankInfo != null) 'bankInfo': bankInfo,
    };
  }

  String toJson() => json.encode(toMap());

  /// Get amount as int
  int get amountInt => int.tryParse(amount) ?? 0;

  /// Get formatted amount
  String get formattedAmount => amountInt.toPrice();
}

/// DebtType Model - Nested trong Debt
class DebtType {
  final String id;
  final String name;
  final String code;
  final String? note;
  final DateTime? createdAt;
  final bool? isBusinessResultAccounted;
  final String operator; // RECEIPT, PAYMENT, etc.

  DebtType({
    required this.id,
    required this.name,
    required this.code,
    this.note,
    this.createdAt,
    this.isBusinessResultAccounted,
    required this.operator,
  });

  factory DebtType.fromMap(Map<String, dynamic> map) {
    return DebtType(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      code: map['code']?.toString() ?? '',
      note: map['note']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      isBusinessResultAccounted: map['isBusinessResultAccounted'] as bool?,
      operator: map['operator']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      if (note != null) 'note': note,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (isBusinessResultAccounted != null)
        'isBusinessResultAccounted': isBusinessResultAccounted,
      'operator': operator,
    };
  }
}
