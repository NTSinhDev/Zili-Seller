import 'dart:convert';

import '../order_packing_item.dart';
import '../product/product_variant.dart';

/// OrderItem Model - DTO cho orderItems trong response
///
/// Model này đại diện cho một item trong đơn hàng
class OrderItem extends OrderPackingItem {
  final int amount;
  final int price;
  final int originalPrice;
  final int discount;
  final double discountPercent;
  final bool isReview;
  final DateTime? reviewAt;
  final dynamic wallet;
  final int cashbackAmount;
  final String type;
  final Map<String, dynamic>? order; // Nested order info

  OrderItem({
    required super.id,
    required super.quantity,
    required this.amount,
    super.sku,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.discountPercent,
    this.isReview = false,
    this.reviewAt,
    this.wallet,
    required this.cashbackAmount,
    required super.productId,
    super.productNameVi,
    super.productNameEn,
    super.productImage,
    required super.variantId,
    super.variantName,
    super.variantImage,
    super.measureUnit,
    super.options = const [],
    super.note,
    required this.type,
    this.order,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    final optionsData = map['options'] ?? [];
    final optionsList = optionsData is List
        ? optionsData
              .map(
                (e) => ProductVariantOption.fromMap(
                  e is Map<String, dynamic> ? e : {},
                ),
              )
              .toList()
        : <ProductVariantOption>[];

    return OrderItem(
      id: map['id']?.toString() ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      amount: (map['amount'] as num?)?.toInt() ?? 0,
      sku: map['sku']?.toString(),
      price: (map['price'] as num?)?.toInt() ?? 0,
      originalPrice: (map['originalPrice'] as num?)?.toInt() ?? 0,
      discount: (map['discount'] as num?)?.toInt() ?? 0,
      discountPercent: (map['discountPercent'] as num?)?.toDouble() ?? 0.0,
      isReview: map['isReview'] as bool? ?? false,
      reviewAt: map['reviewAt'] != null
          ? DateTime.tryParse(map['reviewAt'].toString())
          : null,
      wallet: map['wallet'],
      cashbackAmount: (map['cashbackAmount'] as num?)?.toInt() ?? 0,
      productId: map['productId']?.toString() ?? '',
      productNameVi: map['productNameVi']?.toString(),
      productNameEn: map['productNameEn']?.toString(),
      productImage: map['productImage']?.toString(),
      variantId: map['variantId']?.toString() ?? '',
      variantName: map['variantName']?.toString(),
      variantImage: map['variantImage']?.toString(),
      measureUnit: map['measureUnit']?.toString(),
      options: optionsList,
      note: map['note']?.toString(),
      type: map['type']?.toString() ?? 'PRODUCT',
      order: map['order'] != null
          ? Map<String, dynamic>.from(map['order'] as Map)
          : null,
    );
  }

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'amount': amount,
      if (sku != null) 'sku': sku,
      'price': price,
      'originalPrice': originalPrice,
      'discount': discount,
      'discountPercent': discountPercent,
      'isReview': isReview,
      if (reviewAt != null) 'reviewAt': reviewAt?.toIso8601String(),
      if (wallet != null) 'wallet': wallet,
      'cashbackAmount': cashbackAmount,
      'productId': productId,
      if (productNameVi != null) 'productNameVi': productNameVi,
      if (productNameEn != null) 'productNameEn': productNameEn,
      if (productImage != null) 'productImage': productImage,
      'variantId': variantId,
      if (variantName != null) 'variantName': variantName,
      if (variantImage != null) 'variantImage': variantImage,
      if (measureUnit != null) 'measureUnit': measureUnit,
      'options': options,
      if (note != null) 'note': note,
      'type': type,
      if (order != null) 'order': order,
    };
  }

  String toJson() => json.encode(toMap());
}
