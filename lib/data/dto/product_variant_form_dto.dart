import '../models/product/product_variant.dart';
import 'order/create_order.dart';
import 'quotation/create_quotation.dart';

class ProductVariantFormDto {
  num qty;
  num price;
  num discount;
  num? discountPercent;
  String discountUnit;
  String? note;
  String? measureUnit;
  final ProductVariant? productVariant;
  ProductVariantFormDto({
    required this.qty,
    required this.price,
    required this.discount,
    required this.discountPercent,
    required this.discountUnit,
    this.note,
    this.measureUnit,
    this.productVariant,
  });

  bool get isService => throw UnimplementedError();
  num get totalAmount => throw UnimplementedError();
  num get totalPrice => qty * price;

  OrderQuotationProducts toOrderQuotationProducts() {
    return OrderQuotationProducts(
      qty: qty,
      price: price,
      discount: discount,
      discountPercent: discountPercent,
      discountUnit: discountUnit,
      note: note,
      productVariant: productVariant,
      measureUnit: measureUnit,
    );
  }

  CreateOrderInfoProd toCreateOrderInfoProds() {
    return CreateOrderInfoProd(
      qty: qty,
      price: price,
      discount: discount,
      discountPercent: discountPercent,
      discountUnit: discountUnit,
      note: note,
      productVariant: productVariant,
    );
  }
}
