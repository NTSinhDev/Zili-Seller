import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';

class Cart {
  final List<ProductCart> products;
  final int totalPrice;
  Cart({required this.products, required this.totalPrice});

  Cart copyWith({List<ProductCart>? products, int? totalPrice}) {
    return Cart(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      products: List<ProductCart>.from(
        (map['products']).map<ProductCart>(
          (x) => ProductCart.fromMapLocal(x as Map<String, dynamic>),
        ),
      ),
      totalPrice: map['totalPrice'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Cart(products: $products, totalPrice: $totalPrice)';

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return listEquals(other.products, products) &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode => products.hashCode ^ totalPrice.hashCode;
}
