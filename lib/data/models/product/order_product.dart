// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'product_variant.dart';

class OrderProduct {
  final String id;
  final String? avatar;
  final String? titleVi;
  final String? titleEn;
  final String? shortName;
  final String? barcode;
  final String? sku;
  final String? measureUnit;
  final num price;
  final num costPrice;
  final num originalPrice;
  final num wholesalePrice;
  final num slotBuy;
  final List<ProductVariant> productVariants;
  final num availableQuantity;

  OrderProduct({
    required this.id,
    this.avatar,
    required this.titleVi,
    required this.titleEn,
    required this.shortName,
    required this.barcode,
    required this.sku,
    required this.measureUnit,
    required this.price,
    required this.costPrice,
    required this.originalPrice,
    required this.wholesalePrice,
    required this.slotBuy,
    required this.productVariants,
    required this.availableQuantity,
  });

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    try {
      return OrderProduct(
        id: map['id'] as String,
        avatar: map['avatar'] != null ? map['avatar'] as String : null,
        titleVi: map['titleVi'] != null ? map['titleVi'] as String : null,
        titleEn: map['titleEn'] != null ? map['titleEn'] as String : null,
        shortName: map['shortName'] != null ? map['shortName'] as String : null,
        barcode: map['barcode'] != null ? map['barcode'] as String : null,
        sku: map['sku'] != null ? map['sku'] as String : null,
        measureUnit:
            map['measureUnit'] != null ? map['measureUnit'] as String : null,
        price: map['price'] as num,
        costPrice: map['costPrice'] as num,
        originalPrice: map['originalPrice'] as num,
        wholesalePrice: map['wholesalePrice'] as num,
        slotBuy: map['slotBuy'] as num,
        productVariants: List<ProductVariant>.from(
          (map['productVariants'] as List<dynamic>? ?? []).map<ProductVariant>(
            (x) => ProductVariant.fromMap(x as Map<String, dynamic>),
          ),
        ),
        availableQuantity: map['availableQuantity'] as num,
      );
    } catch (e) {
      log('Error parsing OrderProduct from map: ${e.toString()}');
      throw Exception('Error parsing OrderProduct from map: ${e.toString()}');
    }
  }

  /// Get display name (prefer Vietnamese title)
  String get displayName => titleVi ?? titleEn ?? shortName ?? 'Sản phẩm';

  /// Get display unit
  String get displayUnit => measureUnit ?? '';

  /// Check if product has variants
  bool get hasVariants => productVariants.length > 1;

  /// Get first variant (for products without variants)
  ProductVariant? get firstVariant => productVariants.first;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar,
      'titleVi': titleVi,
      'titleEn': titleEn,
      'shortName': shortName,
      'barcode': barcode,
      'sku': sku,
      'measureUnit': measureUnit,
      'price': price,
      'costPrice': costPrice,
      'originalPrice': originalPrice,
      'wholesalePrice': wholesalePrice,
      'slotBuy': slotBuy,
      'productVariants': productVariants.map((x) => x.toMap()).toList(),
      'availableQuantity': availableQuantity,
    };
  }

  String toJson() => json.encode(toMap());

  factory OrderProduct.fromJson(String source) =>
      OrderProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
