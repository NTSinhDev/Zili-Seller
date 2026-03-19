import 'product/product_variant.dart';

class OrderPackingItem {
  final String id;
  final int quantity;
  final String? sku;
  final String productId;
  final String? productNameVi;
  final String? productNameEn;
  final String? productImage;
  final String variantId;
  final String? variantName;
  final String? variantImage;
  final String? measureUnit;
  final List<ProductVariantOption> options;
  final String? note;

  OrderPackingItem({
    required this.id,
    required this.quantity,
    this.sku,
    required this.productId,
    this.productNameVi,
    this.productNameEn,
    this.productImage,
    required this.variantId,
    this.variantName,
    this.variantImage,
    this.measureUnit,
    this.options = const [],
    this.note,
  });
}
