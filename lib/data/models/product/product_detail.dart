import 'dart:convert';
import 'package:zili_coffee/data/models/media_file.dart';
import 'package:zili_coffee/data/models/product/product_options.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/models/review/rating.dart';

class ProductDetail {
  final List<MediaFile> medias;
  final String? imgDescription;
  final ProductOptions productOptions;
  final List<ProductVariant> variants;
  final Rating? rating;
  ProductDetail({
    this.medias = const [],
    this.imgDescription,
    required this.productOptions,
    this.variants = const [],
    this.rating,
  });

  factory ProductDetail.fromMap(Map<String, dynamic> map) {
    return ProductDetail(
      medias: List<MediaFile>.from(
        map[_Constant.medias].map((mediaData) => MediaFile.fromMap(mediaData)),
      ),
      imgDescription: map[_Constant.imgDescription] != null &&
              map[_Constant.imgDescription].isNotEmpty
          ? map[_Constant.imgDescription][0]['image_url']
          : null,
      variants: List<ProductVariant>.from(
        map[_Constant.variants].map(
          (variantData) => ProductVariant.fromMap(variantData),
        ),
      ),
      productOptions: ProductOptions.fromMap(map),
    );
  }

  factory ProductDetail.fromJson(String source) =>
      ProductDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  ProductDetail copyWith({List<MediaFile>? medias,Rating? rating, ProductOptions? productOptions}) {
    return ProductDetail(
      medias: medias ?? this.medias,
      imgDescription: imgDescription,
      variants: variants,
      rating: rating ?? this.rating,
      productOptions: productOptions ?? this.productOptions,
    );
  }
}

class _Constant {
  static const String medias = "product_media";
  static const String imgDescription = "product_image_details";
  static const String variants = "product_variants";
}
