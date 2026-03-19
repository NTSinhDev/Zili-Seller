import 'package:zili_coffee/data/models/product/product_detail.dart';

class Product  {
  String id;
  String brand;
  String nameDisplay;
  String? nameMobileDisplay;
  int price;
  int? promotionPrice;
  int? promotion;
  String? promotionType;
  String imageBaseUrl;
  String? imageBaseUrlThumb;
  String slug;
  ProductDetail? detail;

  Product({
    required this.id,
    required this.brand,
    required this.nameDisplay,
    this.nameMobileDisplay,
    required this.price,
    this.promotionPrice,
    this.promotion,
    this.promotionType,
    required this.imageBaseUrl,
    this.imageBaseUrlThumb,
    required this.slug,
    this.detail,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map[_Constant.id] as String,
      brand: map[_Constant.brand] as String,
      nameDisplay: map[_Constant.nameDisplay] as String,
      nameMobileDisplay: map[_Constant.nameMobileDisplay] != null
          ? map[_Constant.nameMobileDisplay] as String
          : null,
      price: map[_Constant.price] as int,
      promotionPrice: map[_Constant.promotionPrice] != null
          ? map[_Constant.promotionPrice] as int
          : null,
      promotion: map[_Constant.promotion] != null
          ? map[_Constant.promotion] as int
          : null,
      promotionType: map[_Constant.promotionType] != null
          ? map[_Constant.promotionType] as String
          : null,
      imageBaseUrl: map[_Constant.imageBaseUrl] as String,
      imageBaseUrlThumb: map[_Constant.imageBaseUrlThumb] != null
          ? map[_Constant.imageBaseUrlThumb] as String
          : null,
      slug: map[_Constant.slug] as String,
      detail: map[_Constant.detail] != null
          ? ProductDetail.fromMap(map)
          : null,
    );
  }

  Product copyWith({
    String? id,
    String? tenantId,
    String? brandId,
    String? brand,
    String? nameDisplay,
    String? nameMobileDisplay,
    String? categoryId,
    int? price,
    int? promotionPrice,
    int? promotion,
    String? promotionType,
    String? imageBaseUrl,
    String? imageBaseUrlThumb,
    String? slug,
    ProductDetail? detail,
  }) {
    return Product(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      nameDisplay: nameDisplay ?? this.nameDisplay,
      nameMobileDisplay: nameMobileDisplay ?? this.nameMobileDisplay,
      price: price ?? this.price,
      promotionPrice: promotionPrice ?? this.promotionPrice,
      promotion: promotion ?? this.promotion,
      promotionType: promotionType ?? this.promotionType,
      imageBaseUrl: imageBaseUrl ?? this.imageBaseUrl,
      imageBaseUrlThumb: imageBaseUrlThumb ?? this.imageBaseUrlThumb,
      slug: slug ?? this.slug,
      detail: detail ?? this.detail,
    );
  }
}

class _Constant {
  static const String id = 'id';
  static const String brand = 'brand';
  static const String nameDisplay = 'name_display';
  static const String nameMobileDisplay = 'name_display_mobile';
  static const String price = 'price';
  static const String promotionPrice = 'promotion_price';
  static const String promotion = 'promotion';
  static const String promotionType = 'promotion_type';
  static const String imageBaseUrl = 'image_base_url';
  static const String imageBaseUrlThumb = 'image_base_url_thumb';
  static const String slug = 'product_slug';
  static const String detail = 'product_image_details';
}
