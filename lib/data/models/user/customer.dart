import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:zili_coffee/data/models/user/staff.dart';

import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/enums/user_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../entity/user/customer_entity.dart';
import '../address/address.dart';
import '../order/payment_detail/seller_payment_method.dart';
import '../payment/collaborator.dart';
import 'customer_group.dart';

/// Customer Model - DTO for API responses
/// Extends CustomerEntity and adds helper methods for UI
class Customer extends CustomerEntity {
  List<Address> customerAddresses;
  Address? purchaseAddress;
  Address? billingAddress;
  Staff? personInCharge;
  Collaborator? collaboratorInCharge;
  CustomerGroup? customerGroup;
  String? website;
  DefaultPrice? defaultPrice;
  num? discount;
  SellerPaymentMethod? paymentMethod;
  String? paymentMethodName;
  Customer({
    required super.id,
    super.code,
    super.fullName,
    required super.username,
    super.email,
    super.phone,
    super.birthday,
    super.nickname,
    super.referralCode,
    this.personInCharge,
    this.collaboratorInCharge,
    super.status = UserStatus.active,
    super.avatar,
    super.country,
    super.gender,
    required super.createdAt,
    super.currentDebt = 0,
    super.totalSpending = 0,
    super.totalOrder = 0,
    super.returnedTotalAmount = 0,
    super.returnedProductQuantity = 0,
    super.failedDeliveryTotalAmount = 0,
    super.failedDeliveryOrderCount = 0,
    super.totalPurchasedProduct = 0,
    super.lastPurchaseAt,
    super.taxCode,
    super.note,
    this.customerAddresses = const [],
    this.purchaseAddress,
    this.billingAddress,
    this.customerGroup,
    this.website,
    this.defaultPrice,
    this.discount,
    this.paymentMethod,
    this.paymentMethodName,
  });

  String? get defaultPriceName {
    switch (defaultPrice) {
      case DefaultPrice.costPrice:
        return 'Giá nhập';
      case DefaultPrice.retailPrice:
        return 'Giá bán lẻ';
      case DefaultPrice.wholesalePrice:
        return 'Giá bán buôn';
      case DefaultPrice.purchasePrice:
        return 'Giá mua';
      default:
        return null;
    }
  }

  /// Parse từ API response
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id']?.toString() ?? '',
      code: map['code']?.toString(),
      fullName: map['fullName']?.toString() ?? map['full_name']?.toString(),
      username: map['username']?.toString() ?? '',
      email: map['email']?.toString(),
      phone: map['phone']?.toString(),
      birthday: map['birthday'] != null
          ? DateTime.tryParse(map['birthday'].toString())
          : null,
      nickname: map['nickname']?.toString(),
      referralCode:
          map['referralCode']?.toString() ?? map['referral_code']?.toString(),
      personInCharge: map['personInCharge'] != null
          ? Staff.fromMap(map['personInCharge'] as Map<String, dynamic>)
          : null,
      status: UserStatus.fromString(
        map['status']?.toString() ?? UserStatus.active.value,
      ),
      avatar: map['avatar']?.toString(),
      country: map['country']?.toString(),
      gender: map['gender'] != null ? (map['gender'] as num).toInt() : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      currentDebt: map['currentDebt'] != null
          ? (map['currentDebt'] as num).toDouble()
          : map['current_debt'] != null
          ? (map['current_debt'] as num).toDouble()
          : 0,
      totalSpending: map['totalSpending'] != null
          ? (map['totalSpending'] as num).toDouble()
          : map['total_spending'] != null
          ? (map['total_spending'] as num).toDouble()
          : 0,
      totalOrder: map['totalOrder'] != null
          ? (map['totalOrder'] as num).toDouble()
          : map['total_order'] != null
          ? (map['total_order'] as num).toDouble()
          : 0,
      returnedTotalAmount: map['returnedTotalAmount'] != null
          ? (map['returnedTotalAmount'] as num).toDouble()
          : map['returned_total_amount'] != null
          ? (map['returned_total_amount'] as num).toDouble()
          : 0,
      returnedProductQuantity: map['returnedProductQuantity'] != null
          ? (map['returnedProductQuantity'] as num).toDouble()
          : map['returned_product_quantity'] != null
          ? (map['returned_product_quantity'] as num).toDouble()
          : 0,
      failedDeliveryTotalAmount: map['failedDeliveryTotalAmount'] != null
          ? (map['failedDeliveryTotalAmount'] as num).toDouble()
          : map['failed_delivery_total_amount'] != null
          ? (map['failed_delivery_total_amount'] as num).toDouble()
          : 0,
      failedDeliveryOrderCount: map['failedDeliveryOrderCount'] != null
          ? (map['failedDeliveryOrderCount'] as num).toDouble()
          : map['failed_delivery_order_count'] != null
          ? (map['failed_delivery_order_count'] as num).toDouble()
          : 0,
      totalPurchasedProduct: map['totalPurchasedProduct'] != null
          ? (map['totalPurchasedProduct'] as num).toDouble()
          : map['total_purchased_product'] != null
          ? (map['total_purchased_product'] as num).toDouble()
          : 0,
      lastPurchaseAt: map['lastPurchaseAt'] != null
          ? map['lastPurchaseAt'].toString().parseFromServerTimezone() ??
                DateTime.tryParse(map['lastPurchaseAt'].toString())
          : map['last_purchase_at'] != null
          ? map['last_purchase_at'].toString().parseFromServerTimezone() ??
                DateTime.tryParse(map['last_purchase_at'].toString())
          : null,
      taxCode: map['taxCode']?.toString() ?? map['tax_code']?.toString(),
      note: map['note']?.toString(),
      customerAddresses: map['addresses'] != null
          ? List<Address>.from(
              (map['addresses'] as List<dynamic>).map<Address>(
                (x) => Address.fromMap(x as Map<String, dynamic>),
              ),
            )
          : map['customer_addresses'] != null
          ? List<Address>.from(
              (map['customer_addresses'] as List<dynamic>).map<Address>(
                (x) => Address.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      customerGroup: map['group'] != null
          ? CustomerGroup.fromMap(map['group'] as Map<String, dynamic>)
          : null,
      website: map['website']?.toString(),
      defaultPrice: map['defaultPrice'] != null
          ? DefaultPrice.values
                .where((item) => item.toConstant == map['defaultPrice'])
                .firstOrNull
          : null,
      discount: map['discount'] != null ? map['discount'] as num : null,
      paymentMethod: map['paymentMethod'] != null
          ? map['paymentMethod'] is Map<String, dynamic>
                ? SellerPaymentMethod.fromMap(
                    map['paymentMethod'] as Map<String, dynamic>,
                  )
                : null
          : null,
      collaboratorInCharge: map['collaboratorInCharge'] != null
          ? Collaborator.fromMap(
              map['collaboratorInCharge'] as Map<String, dynamic>,
            )
          : null,
      paymentMethodName:
          (map['paymentMethodInfo'])?["nameVi"]?.toString() ??
          (map['paymentMethodInfo'])?["nameEn"]?.toString(),
    );
  }

  /// Parse từ JSON string
  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Convert từ CustomerEntity
  factory Customer.fromEntity(CustomerEntity entity) {
    return Customer(
      id: entity.id,
      code: entity.code,
      fullName: entity.fullName,
      username: entity.username,
      email: entity.email,
      phone: entity.phone,
      birthday: entity.birthday,
      nickname: entity.nickname,
      referralCode: entity.referralCode,
      status: entity.status,
      avatar: entity.avatar,
      country: entity.country,
      gender: entity.gender,
      createdAt: entity.createdAt,
      currentDebt: entity.currentDebt,
      totalSpending: entity.totalSpending,
      totalOrder: entity.totalOrder,
      returnedTotalAmount: entity.returnedTotalAmount,
      returnedProductQuantity: entity.returnedProductQuantity,
      failedDeliveryTotalAmount: entity.failedDeliveryTotalAmount,
      failedDeliveryOrderCount: entity.failedDeliveryOrderCount,
      totalPurchasedProduct: entity.totalPurchasedProduct,
      lastPurchaseAt: entity.lastPurchaseAt,
      taxCode: entity.taxCode,
      note: entity.note,
    );
  }

  /// Helper method: Get display name (fullName or username)
  String get displayName {
    return fullName?.trim().isNotEmpty == true
        ? fullName!
        : username.trim().isNotEmpty
        ? username
        : AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  /// Helper method: Get Gender enum from int
  Gender? get genderEnum {
    if (gender == null) return null;
    return gender == 1
        ? Gender.female
        : gender == 0
        ? Gender.male
        : Gender.other;
  }

  /// Set customer addresses
  void setCustomerAddresses(List<Address> addresses) {
    customerAddresses = addresses;
  }

  Customer copyWith({
    String? id,
    String? code,
    String? fullName,
    String? username,
    String? email,
    String? phone,
    DateTime? birthday,
    String? nickname,
    String? referralCode,
    UserStatus? status,
    String? avatar,
    String? country,
    int? gender,
    DateTime? createdAt,
    double? currentDebt,
    double? totalSpending,
    double? totalOrder,
    double? returnedTotalAmount,
    double? returnedProductQuantity,
    double? failedDeliveryTotalAmount,
    double? failedDeliveryOrderCount,
    double? totalPurchasedProduct,
    DateTime? lastPurchaseAt,
    String? website, // Required from parent class but not used in Customer
    String? taxCode,
    String? note,
    Address? purchaseAddress,
    Address? billingAddress,
    List<Address>? customerAddresses, // Additional parameter
  }) {
    return Customer(
      id: id ?? this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      nickname: nickname ?? this.nickname,
      referralCode: referralCode ?? this.referralCode,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      currentDebt: currentDebt ?? this.currentDebt,
      totalSpending: totalSpending ?? this.totalSpending,
      totalOrder: totalOrder ?? this.totalOrder,
      returnedTotalAmount: returnedTotalAmount ?? this.returnedTotalAmount,
      returnedProductQuantity:
          returnedProductQuantity ?? this.returnedProductQuantity,
      failedDeliveryTotalAmount:
          failedDeliveryTotalAmount ?? this.failedDeliveryTotalAmount,
      failedDeliveryOrderCount:
          failedDeliveryOrderCount ?? this.failedDeliveryOrderCount,
      totalPurchasedProduct:
          totalPurchasedProduct ?? this.totalPurchasedProduct,
      lastPurchaseAt: lastPurchaseAt ?? this.lastPurchaseAt,
      taxCode: taxCode ?? this.taxCode,
      note: note ?? this.note,
      customerAddresses: customerAddresses ?? this.customerAddresses,
      purchaseAddress: purchaseAddress ?? this.purchaseAddress,
      billingAddress: billingAddress ?? this.billingAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phone': phone,
      'birthday': birthday?.toIso8601String(),
      'nickname': nickname,
      'referralCode': referralCode,
      'status': status.value,
      'avatar': avatar,
      'country': country,
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
      'currentDebt': currentDebt,
      'totalSpending': totalSpending,
      'totalOrder': totalOrder,
      'returnedTotalAmount': returnedTotalAmount,
      'returnedProductQuantity': returnedProductQuantity,
      'failedDeliveryTotalAmount': failedDeliveryTotalAmount,
      'failedDeliveryOrderCount': failedDeliveryOrderCount,
      'totalPurchasedProduct': totalPurchasedProduct,
      'lastPurchaseAt': lastPurchaseAt?.toIso8601String(),
      'taxCode': taxCode,
      'note': note,
      'customerAddresses': customerAddresses
          .map<Map<String, dynamic>>((address) => address.toMap())
          .toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Customer(id: $id, fullName: $fullName, username: $username, email: $email, phone: $phone, status: ${status.value})';
  }

  @override
  bool operator ==(covariant Customer other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.avatar == avatar &&
        other.status == status &&
        listEquals(other.customerAddresses, customerAddresses);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        avatar.hashCode ^
        status.hashCode ^
        customerAddresses.hashCode;
  }
}
