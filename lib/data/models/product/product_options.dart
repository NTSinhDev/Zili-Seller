import 'package:flutter/foundation.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';

import 'options.dart';

class ProductOptions {
  final List<Options> options;
  String? option1;
  String? option2;
  String? option3;
  String? opt1Name;
  String? opt2Name;
  String? opt3Name;
  ProductOptions({
    required this.options,
    this.option1,
    this.option2,
    this.option3,
    required this.opt1Name,
    required this.opt2Name,
    required this.opt3Name,
  });

  ProductVariant toProductVariant() {
    return ProductVariant(
      id: '',
      options: options.map((option) => ProductVariantOption(name: option.name, value: option.values.first)).toList(),
      price: 0,
      originalPrice: 0,
      costPrice: 0,
      wholesalePrice: 0,
      promotion: 0,
      inventory: 0,
      length: 0,
      weight: 0,
      height: 0,
      width: 0,
      deleteFlag: '',
      sku: '',
      barcode: '',
      slotBuy: '',
      transactionCount: '',
      inTransitCount: '',
      deliveryCount: '',
      availableQuantity: '',
      status: '',
      commission: 0,
      commissionWeight: 0,
      calculateByUnit: '',
    );
  }

  ProductOptions copyWith({
    List<Options>? options,
    String? option1,
    String? option2,
    String? option3,
    String? opt1Name,
    String? opt2Name,
    String? opt3Name,
  }) {
    return ProductOptions(
      options: options ?? this.options,
      option1: option1 ?? this.option1,
      option2: option2 ?? this.option2,
      option3: option3 ?? this.option3,
      opt1Name: opt1Name ?? this.opt1Name,
      opt2Name: opt2Name ?? this.opt2Name,
      opt3Name: opt3Name ?? this.opt3Name,
    );
  }

  factory ProductOptions.fromMap(Map<String, dynamic> map) {
    return ProductOptions(
      options: List<Options>.from(
        (map['product_options'] as List<dynamic>).map<Options>(
          (x) => Options.fromMap(x as Map<String, dynamic>),
        ),
      ),
      opt1Name: map["opt1"],
      opt2Name: map["opt2"],
      opt3Name: map["opt3"],
    );
  }

  @override
  bool operator ==(covariant ProductOptions other) {
    if (identical(this, other)) return true;

    return listEquals(other.options, options) &&
        other.option1 == option1 &&
        other.option2 == option2 &&
        other.option3 == option3;
  }

  @override
  int get hashCode {
    return options.hashCode ^
        option1.hashCode ^
        option2.hashCode ^
        option3.hashCode;
  }
}
