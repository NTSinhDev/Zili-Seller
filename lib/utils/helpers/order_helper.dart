import '../../data/dto/product_variant_form_dto.dart';
import '../../data/models/product/product_variant.dart';

double calculateTotalProductPrice(List<ProductVariant> products) {
  return products.fold<double>(
    0,
    (sum, variant) =>
        sum +
        (variant.totalPriceByDiscount ?? (variant.price * variant.quantity)),
  );
}

double calculateProductPrice(List<ProductVariantFormDto> products) {
  return products.fold<double>(
    0,
    (sum, variant) =>
        sum +
        (variant.totalAmount),
  );
}

num calculateTotalQuantity(List<ProductVariant> products) {
  return products.fold<num>(0, (sum, variant) => sum + variant.quantity);
}

/// Tính discount value của đơn hàng dựa trên discount unit
/// - Nếu discountUnit == '%': discountValue = totalProductPrice * (discount / 100)
/// - Nếu discountUnit == 'đ': discountValue = discount (giá trị tuyệt đối)
double calculateOrderDiscount(
  double totalProductPrice,
  double discount,
  String discountUnit,
) {
  if (discount <= 0) return 0.0;

  if (discountUnit == '%') return totalProductPrice * (discount / 100);

  return discount;
}

double calculateOrderTax(double totalProductPrice, double tax, String taxUnit) {
  if (tax <= 0) return 0.0;

  if (taxUnit == '%') return totalProductPrice * (tax / 100);

  return tax;
}
