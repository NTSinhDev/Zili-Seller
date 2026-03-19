// ignore_for_file: public_member_api_docs

import 'dart:convert';

/// Enum cho trạng thái product variant
enum ProductVariantStatus {
  active,
  inactive;

  static ProductVariantStatus fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'ACTIVE':
        return ProductVariantStatus.active;
      case 'INACTIVE':
        return ProductVariantStatus.inactive;
      default:
        return ProductVariantStatus.active;
    }
  }

  String get value {
    switch (this) {
      case ProductVariantStatus.active:
        return 'ACTIVE';
      case ProductVariantStatus.inactive:
        return 'INACTIVE';
    }
  }
}

/// Enum cho calculate by unit
enum CalculateByUnit {
  weight,
  quantity,
  volume;

  static CalculateByUnit? fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'WEIGHT':
        return CalculateByUnit.weight;
      case 'QUANTITY':
        return CalculateByUnit.quantity;
      case 'VOLUME':
        return CalculateByUnit.volume;
      default:
        return null;
    }
  }

  String get value {
    switch (this) {
      case CalculateByUnit.weight:
        return 'WEIGHT';
      case CalculateByUnit.quantity:
        return 'QUANTITY';
      case CalculateByUnit.volume:
        return 'VOLUME';
    }
  }
}

/// Entity cho ProductVariant
class ProductVariantEntity {
  final String id;
  final String? options;
  final double? price; // giá bán lẻ
  final double originalPrice; // giá gốc
  final double costPrice; // giá nhập
  final double wholesalePrice; // giá bán buôn
  final double? promotion;
  final String? imageVariant;
  final double? inventory;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? deleteFlag;
  final DateTime? deletedAt;
  final double length;
  final double width;
  final double height;
  final double weight;
  final String productId;
  final String? barcode;
  final String? sku;
  final double slotBuy; // tồn kho
  final double transactionCount; // hàng đang giao dịch
  final double inTransitCount; // hàng đang về
  final double deliveryCount; // hàng đang giao
  final double availableQuantity; // có thể bán
  final ProductVariantStatus status;
  final CalculateByUnit? calculateByUnit;
  final double? commission;
  final double? commissionWeight;
  final double roastedWeight;
  final double packedWeight;
  final bool isSpecial;

  ProductVariantEntity({
    required this.id,
    this.options,
    this.price,
    this.originalPrice = 0,
    this.costPrice = 0,
    this.wholesalePrice = 0,
    this.promotion,
    this.imageVariant,
    this.inventory,
    this.createdAt,
    this.updatedAt,
    this.deleteFlag,
    this.deletedAt,
    this.length = 0,
    this.width = 0,
    this.height = 0,
    this.weight = 0,
    required this.productId,
    this.barcode,
    this.sku,
    this.slotBuy = 0,
    this.transactionCount = 0,
    this.inTransitCount = 0,
    this.deliveryCount = 0,
    this.availableQuantity = 0,
    this.status = ProductVariantStatus.active,
    this.calculateByUnit,
    this.commission,
    this.commissionWeight,
    this.roastedWeight = 0,
    this.packedWeight = 0,
    this.isSpecial = false,
  });

  factory ProductVariantEntity.fromMap(Map<String, dynamic> map) {
    return ProductVariantEntity(
      id: map['id']?.toString() ?? '',
      options: map['options']?.toString(),
      price: map['price'] != null ? (map['price'] as num).toDouble() : null,
      originalPrice: map['originalPrice'] != null
          ? (map['originalPrice'] as num).toDouble()
          : 0,
      costPrice:
          map['costPrice'] != null ? (map['costPrice'] as num).toDouble() : 0,
      wholesalePrice: map['wholesalePrice'] != null
          ? (map['wholesalePrice'] as num).toDouble()
          : 0,
      promotion: map['promotion'] != null ? (map['promotion'] as num).toDouble() : null,
      imageVariant: map['imageVariant']?.toString(),
      inventory: map['inventory'] != null ? (map['inventory'] as num).toDouble() : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      deleteFlag: map['deleteFlag'] as bool?,
      deletedAt: map['deletedAt'] != null
          ? DateTime.tryParse(map['deletedAt'].toString())
          : null,
      length: map['length'] != null ? (map['length'] as num).toDouble() : 0,
      width: map['width'] != null ? (map['width'] as num).toDouble() : 0,
      height: map['height'] != null ? (map['height'] as num).toDouble() : 0,
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : 0,
      productId: map['productId']?.toString() ??
          map['product']?['id']?.toString() ??
          '',
      barcode: map['barcode']?.toString(),
      sku: map['sku']?.toString(),
      slotBuy: map['slotBuy'] != null ? (map['slotBuy'] as num).toDouble() : 0,
      transactionCount: map['transactionCount'] != null
          ? (map['transactionCount'] as num).toDouble()
          : 0,
      inTransitCount: map['inTransitCount'] != null
          ? (map['inTransitCount'] as num).toDouble()
          : 0,
      deliveryCount: map['deliveryCount'] != null
          ? (map['deliveryCount'] as num).toDouble()
          : 0,
      availableQuantity: map['availableQuantity'] != null
          ? (map['availableQuantity'] as num).toDouble()
          : 0,
      status: ProductVariantStatus.fromString(map['status']?.toString()),
      calculateByUnit: CalculateByUnit.fromString(map['calculateByUnit']?.toString()),
      commission: map['commission'] != null ? (map['commission'] as num).toDouble() : null,
      commissionWeight: map['commissionWeight'] != null
          ? (map['commissionWeight'] as num).toDouble()
          : null,
      roastedWeight: map['roastedWeight'] != null
          ? (map['roastedWeight'] as num).toDouble()
          : 0,
      packedWeight: map['packedWeight'] != null
          ? (map['packedWeight'] as num).toDouble()
          : 0,
      isSpecial: map['isSpecial'] as bool? ?? false,
    );
  }

  factory ProductVariantEntity.fromJson(String source) =>
      ProductVariantEntity.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'options': options,
      'price': price,
      'originalPrice': originalPrice,
      'costPrice': costPrice,
      'wholesalePrice': wholesalePrice,
      'promotion': promotion,
      'imageVariant': imageVariant,
      'inventory': inventory,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deleteFlag': deleteFlag,
      'deletedAt': deletedAt?.toIso8601String(),
      'length': length,
      'width': width,
      'height': height,
      'weight': weight,
      'productId': productId,
      'barcode': barcode,
      'sku': sku,
      'slotBuy': slotBuy,
      'transactionCount': transactionCount,
      'inTransitCount': inTransitCount,
      'deliveryCount': deliveryCount,
      'availableQuantity': availableQuantity,
      'status': status.value,
      'calculateByUnit': calculateByUnit?.value,
      'commission': commission,
      'commissionWeight': commissionWeight,
      'roastedWeight': roastedWeight,
      'packedWeight': packedWeight,
      'isSpecial': isSpecial,
    };
  }

  String toJson() => json.encode(toMap());

  ProductVariantEntity copyWith({
    String? id,
    String? options,
    double? price,
    double? originalPrice,
    double? costPrice,
    double? wholesalePrice,
    double? promotion,
    String? imageVariant,
    double? inventory,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleteFlag,
    DateTime? deletedAt,
    double? length,
    double? width,
    double? height,
    double? weight,
    String? productId,
    String? barcode,
    String? sku,
    double? slotBuy,
    double? transactionCount,
    double? inTransitCount,
    double? deliveryCount,
    double? availableQuantity,
    ProductVariantStatus? status,
    CalculateByUnit? calculateByUnit,
    double? commission,
    double? commissionWeight,
    double? roastedWeight,
    double? packedWeight,
    bool? isSpecial,
  }) {
    return ProductVariantEntity(
      id: id ?? this.id,
      options: options ?? this.options,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      costPrice: costPrice ?? this.costPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      promotion: promotion ?? this.promotion,
      imageVariant: imageVariant ?? this.imageVariant,
      inventory: inventory ?? this.inventory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      deletedAt: deletedAt ?? this.deletedAt,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      productId: productId ?? this.productId,
      barcode: barcode ?? this.barcode,
      sku: sku ?? this.sku,
      slotBuy: slotBuy ?? this.slotBuy,
      transactionCount: transactionCount ?? this.transactionCount,
      inTransitCount: inTransitCount ?? this.inTransitCount,
      deliveryCount: deliveryCount ?? this.deliveryCount,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      status: status ?? this.status,
      calculateByUnit: calculateByUnit ?? this.calculateByUnit,
      commission: commission ?? this.commission,
      commissionWeight: commissionWeight ?? this.commissionWeight,
      roastedWeight: roastedWeight ?? this.roastedWeight,
      packedWeight: packedWeight ?? this.packedWeight,
      isSpecial: isSpecial ?? this.isSpecial,
    );
  }
}

