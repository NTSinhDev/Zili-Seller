import 'package:zili_coffee/data/models/product/order_product.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';

class PurchaseOrderProduct extends OrderProduct {
  final String? code;
  final bool? isInventoryManaged;
  final List<String> images;
  final List<Map<String, dynamic>> warehouseProducts;
  final Map<String, dynamic> raw;

  PurchaseOrderProduct({
    required super.id,
    required super.titleVi,
    required super.titleEn,
    required super.shortName,
    required super.barcode,
    required super.sku,
    required super.measureUnit,
    required super.price,
    required super.costPrice,
    required super.originalPrice,
    required super.wholesalePrice,
    required super.slotBuy,
    required super.productVariants,
    required super.availableQuantity,
    super.avatar,
    this.code,
    this.isInventoryManaged,
    this.images = const [],
    this.warehouseProducts = const [],
    Map<String, dynamic>? raw,
  }) : raw = raw ?? const {};

  factory PurchaseOrderProduct.fromMap(Map<String, dynamic> map) {
    String? s(dynamic v) => v?.toString();
    num n(dynamic v, {num fallback = 0}) {
      if (v is num) return v;
      if (v == null) return fallback;
      return num.tryParse(v.toString()) ?? fallback;
    }

    final List<ProductVariant> variants = (map['productVariants'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(ProductVariant.fromMap)
            .toList() ??
        [];

    // Fallback availableQuantity: product-level -> variant-level -> 0
    num availableQty = n(map['availableQuantity']);
    if (availableQty == 0 && variants.isNotEmpty) {
      final String vAvail = variants.first.availableQuantity;
      availableQty = num.tryParse(vAvail) ?? 0;
    }

    final images = <String>[
      if (map['avatar'] != null) s(map['avatar'])!,
      if (map['imageProduct'] != null) s(map['imageProduct'])!,
      ...((map['imageDetail'] as List?)?.whereType<String>() ?? const []),
    ].where((e) => e.isNotEmpty).toList();

    return PurchaseOrderProduct(
      id: s(map['id']) ?? '',
      titleVi: s(map['titleVi']) ?? s(map['name']) ?? '',
      titleEn: s(map['titleEn']),
      shortName: s(map['shortName']),
      barcode: s(map['barcode']),
      sku: s(map['sku']),
      measureUnit: s(map['measureUnit']) ?? '',
      price: n(map['price']),
      costPrice: n(map['costPrice']),
      originalPrice: n(map['originalPrice']),
      wholesalePrice: n(map['wholesalePrice']),
      slotBuy: n(map['slotBuy']),
      productVariants: variants,
      availableQuantity: availableQty,
      avatar: images.isNotEmpty ? images.first : null,
      code: s(map['code']),
      isInventoryManaged: map['isInventoryManaged'] as bool?,
      images: images,
      warehouseProducts:
          (map['warehouseProducts'] as List?)?.whereType<Map<String, dynamic>>().toList() ??
              const [],
      raw: Map<String, dynamic>.from(map),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'code': code,
      'isInventoryManaged': isInventoryManaged,
      'images': images,
      'warehouseProducts': warehouseProducts,
      'raw': raw,
    };
  }
}

class PurchaseOrderProductsResult {
  final List<PurchaseOrderProduct> items;
  final int total;

  PurchaseOrderProductsResult({
    required this.items,
    required this.total,
  });
}
