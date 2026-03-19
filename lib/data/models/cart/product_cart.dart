import 'dart:convert';

class ProductCart {
  final String? productID;
  final String? variantID;
  final String? name;
  final int? price;
  final String? img;
  final int? pricePromotion;
  final String? option1;
  final String? option2;
  final String? option3;
  final String? slug;
  final int qty;
  ProductCart({
    this.productID,
    this.variantID,
    this.name,
    this.price,
    this.img,
    this.pricePromotion,
    this.option2,
    this.option1,
    this.option3,
    this.slug,
    required this.qty,
  });

  ProductCart copyWith({
    String? productID,
    String? variantID,
    String? name,
    int? price,
    String? img,
    int? pricePromotion,
    String? option1,
    String? option2,
    String? option3,
    String? slug,
    int? qty,
    bool? isAvaiable,
  }) {
    return ProductCart(
      productID: productID ?? this.productID,
      variantID: variantID ?? this.variantID,
      name: name ?? this.name,
      price: price ?? this.price,
      img: img ?? this.img,
      pricePromotion: pricePromotion ?? this.pricePromotion,
      option1: option1 ?? this.option1,
      option2: option2 ?? this.option2,
      option3: option3 ?? this.option3,
      slug: slug ?? this.slug,
      qty: qty ?? this.qty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _ProductCartConstant.productID: productID,
      _ProductCartConstant.variantID: variantID,
      _ProductCartConstant.option1: option1,
      _ProductCartConstant.option2: option2,
      _ProductCartConstant.option3: option3,
      _ProductCartConstant.qty: qty,
    };
  }

  factory ProductCart.fromMapLocal(Map<String, dynamic> map) {
    return ProductCart(
      productID: map[_ProductCartConstant.productID] as String,
      variantID: map[_ProductCartConstant.variantID],
      option1: map[_ProductCartConstant.option1],
      option2: map[_ProductCartConstant.option2],
      option3: map[_ProductCartConstant.option3],
      qty: map[_ProductCartConstant.qty] as int,
    );
  }

  String toJson() => json.encode(toMap());
}

class _ProductCartConstant {
  static const String productID = 'product_id';
  static const String variantID = 'variant_id';
  // static const String name = 'name_display';
  // static const String price = 'price';
  // static const String img = 'image_base_url';
  // static const String pricePromotion = 'promotion_price';
  static const String option1 = 'option_1';
  static const String option2 = 'option_2';
  static const String option3 = 'option_3';
  static const String qty = 'product_qty';
}
