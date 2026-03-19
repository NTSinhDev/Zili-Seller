import '../../../utils/functions/order_function.dart';
import '../../../utils/helpers/parser.dart';
import '../product/product_variant.dart';

class OrderLineItem implements MeasureUnitAndWeight {
  final String id;
  final ProductVariant productVariant;
  final String quantity;
  final String? unitName;
  final String? unitValue;
  final String price;
  final String? discount;
  final double? discountPercent;
  final String totalAmount;
  final bool isService;
  final String? note;
  final List<num>? priceList;

  OrderLineItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.productVariant,
    required this.totalAmount,
    this.discount,
    this.discountPercent,
    this.unitName,
    this.unitValue,
    this.isService = false,
    this.note,
    this.priceList,
  });

  double get doubleDiscount => double.tryParse(discount ?? "0") ?? 0.0;

  double get calculateTotalAmount {
    final intQuantity = num.tryParse(quantity) ?? 0;
    final doublePrice = double.tryParse(price) ?? 0.0;

    if (intQuantity == 0 || doublePrice == 0.0) return 0.0;

    return intQuantity * (doublePrice - doubleDiscount);
  }

  /// Gets measure unit from [unitName] or falls back to [productVariant.measureUnit].
  ///
  /// Implements [MeasureUnitAndWeight] mixin contract.
  @override
  String? get measureUnit => unitName ?? productVariant.measureUnit;

  /// Gets weight from [unitValue] (parsed as num) or falls back to [productVariant.weight].
  ///
  /// Implements [MeasureUnitAndWeight] mixin contract.
  @override
  num? get weight {
    if (unitValue != null) {
      return num.tryParse(unitValue!);
    }
    return productVariant.weight;
  }

  factory OrderLineItem.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel<OrderLineItem>(() {
      final productVariant =
          map['type'] == "PRODUCT" && map['productVariant'] != null
          ? ProductVariant.fromOrderLineItem(map)
          : ProductVariant.fromServiceVariant(map);
      return OrderLineItem(
        id: map[_Constant.id]?.toString() ?? '',
        isService: map['type'] == "SERVICE",
        productVariant: productVariant,
        quantity: map[_Constant.quantity]?.toString() ?? '0',
        price: map[_Constant.price]?.toString() ?? '0',
        totalAmount: map[_Constant.amount]?.toString() ?? '0',
        discount: map[_Constant.discount]?.toString(),
        discountPercent: double.tryParse(
          map[_Constant.discountPercent]?.toString() ?? "0",
        ),
        unitName: map[_Constant.measureUnit]?.toString(),
        unitValue:
            map[_Constant.weight]?.toString() ??
            productVariant.weight.toString(),
        note: map["note"]?.toString(),
        priceList: map["priceArr"] != null
            ? List<num>.from(
                map["priceArr"].map((x) => num.tryParse(x.toString()) ?? 0),
              )
            : null,
      );
    }, map);
  }
}

class _Constant {
  static const String id = 'id';
  static const String quantity = 'quantity';
  static const String price = 'price';
  static const String amount = 'amount';
  static const String discount = 'discount';
  static const String discountPercent = 'discountPercent';
  static const String measureUnit = 'measureUnit';
  static const String weight = 'weight';
}
