import 'dart:convert';

import 'package:zili_coffee/utils/functions/base_functions.dart';

/// OrderInfo Model - DTO cho orderInfo trong response
///
/// Model này chứa thông tin bổ sung về đơn hàng
class OrderInfo {
  final String id;
  final String userId;
  final String? fullName;
  final String? avatarUrl;
  final String? email;
  final String? phoneNumber;
  final String? nickname;
  final OrderInfoAdditional? infoAdditional;

  OrderInfo({
    required this.id,
    required this.userId,
    this.fullName,
    this.avatarUrl,
    this.email,
    this.phoneNumber,
    this.nickname,
    this.infoAdditional,
  });

  factory OrderInfo.fromMap(Map<String, dynamic> map) {
    return OrderInfo(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      fullName: map['fullName']?.toString(),
      avatarUrl: map['avatarUrl']?.toString(),
      email: map['email']?.toString(),
      phoneNumber: map['phoneNumber']?.toString(),
      nickname: map['nickname']?.toString(),
      infoAdditional: map['infoAdditional'] != null
          ? OrderInfoAdditional.fromMap(
              map['infoAdditional'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  factory OrderInfo.fromJson(String source) =>
      OrderInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      if (fullName != null) 'fullName': fullName,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (nickname != null) 'nickname': nickname,
      if (infoAdditional != null) 'infoAdditional': infoAdditional?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

/// OrderInfoAdditional Model
class OrderInfoAdditional {
  final String? salesType;
  final String? branchId;
  final String? soldById;
  final String? saleChannel;
  final DateTime? saleDate;
  final DateTime? scheduledDeliveryAt;
  final String? expectedPayment;

  OrderInfoAdditional({
    this.salesType,
    this.branchId,
    this.soldById,
    this.saleChannel,
    this.saleDate,
    this.scheduledDeliveryAt,
    this.expectedPayment,
  });

  factory OrderInfoAdditional.fromMap(Map<String, dynamic> map) {
    return OrderInfoAdditional(
      salesType: map['salesType']?.toString(),
      branchId: map['branchId']?.toString(),
      soldById: map['soldById']?.toString(),
      saleChannel: map['saleChannel']?.toString(),
      saleDate: parseServerTimeZoneDateTime(map['saleDate']),
      scheduledDeliveryAt: parseServerTimeZoneDateTime(
        map['scheduledDeliveryAt'],
      ),
      expectedPayment: map['expectedPayment']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (salesType != null) 'salesType': salesType,
      if (branchId != null) 'branchId': branchId,
      if (soldById != null) 'soldById': soldById,
      if (saleChannel != null) 'saleChannel': saleChannel,
      if (saleDate != null) 'saleDate': saleDate?.toIso8601String(),
      if (scheduledDeliveryAt != null)
        'scheduledDeliveryAt': scheduledDeliveryAt?.toIso8601String(),
      if (expectedPayment != null) 'expectedPayment': expectedPayment,
    };
  }
}
