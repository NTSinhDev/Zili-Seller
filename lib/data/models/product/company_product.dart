import 'package:zili_coffee/res/constant/ui_constant.dart';
import 'package:zili_coffee/utils/extension/date_time.dart';

/// Product model for company products list API
/// API: GET /product/get-by-company
class CompanyProduct {
  final String id;
  final String? titleVi;
  final String? titleEn;
  final String? shortName;
  final String? imageProduct;
  final List<String> imageDetail;
  final String? video;
  final List<String> imageDescriptionVi;
  final List<String> imageDescriptionEn;
  final String? descriptionVi;
  final String? descriptionEn;
  final String status;
  final num price;
  final int originalPrice;
  final int slotBuy;
  final String createById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CompanyProductSeller? seller;
  final CompanyProductCategory? categoryInternal;
  final CompanyProductCategory? category;
  final int quantityPurchased;
  final bool qrcodeStatus;
  final dynamic ratingSingleCounts;
  final int stars;
  final int ratingCount;
  final int length;
  final int width;
  final int height;
  final int weight;
  final List<dynamic> deliverySettings;
  final List<CompanyProductVariant> productVariants;
  final List<dynamic> productOptions;
  final num costPrice;
  final num wholesalePrice;
  final bool isSaleAllowed;
  final String? avatar;
  final String? barcode;
  final String? sku;
  final String? measureUnit;
  final bool isInventoryManaged;
  final CompanyProductBrand? brand;
  final int availableQuantity;
  final bool isOnWebsite;
  final num commission;
  final String calculateByUnit;
  final int commissionWeight;
  final bool isCanPacking;

  CompanyProduct({
    required this.id,
    this.titleVi,
    this.titleEn,
    this.shortName,
    this.imageProduct,
    required this.imageDetail,
    this.video,
    required this.imageDescriptionVi,
    this.imageDescriptionEn = const [],
    this.descriptionVi,
    this.descriptionEn,
    required this.status,
    required this.price,
    required this.originalPrice,
    required this.slotBuy,
    required this.createById,
    required this.createdAt,
    this.seller,
    this.categoryInternal,
    required this.quantityPurchased,
    required this.qrcodeStatus,
    this.ratingSingleCounts,
    required this.stars,
    required this.ratingCount,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.deliverySettings,
    required this.productVariants,
    required this.productOptions,
    required this.costPrice,
    required this.wholesalePrice,
    required this.isSaleAllowed,
    this.category,
    this.avatar,
    this.barcode,
    this.sku,
    this.measureUnit,
    required this.isInventoryManaged,
    this.brand,
    required this.availableQuantity,
    required this.isOnWebsite,
    required this.commission,
    required this.calculateByUnit,
    required this.commissionWeight,
    required this.isCanPacking,
    required this.updatedAt,
  });

  factory CompanyProduct.fromMap(Map<String, dynamic> map) {
    return CompanyProduct(
      id: map['id']?.toString() ?? '',
      titleVi: map['titleVi']?.toString(),
      titleEn: map['titleEn']?.toString(),
      shortName: map['shortName']?.toString(),
      imageProduct: map['imageProduct']?.toString(),
      imageDetail: map['imageDetail'] is List
          ? (map['imageDetail'] as List).map((e) => e.toString()).toList()
          : [],
      video: map['video']?.toString(),
      imageDescriptionVi: map['imageDescriptionVi'] is List
          ? (map['imageDescriptionVi'] as List)
                .map((e) => e.toString())
                .toList()
          : <String>[],
      imageDescriptionEn: map['imageDescriptionEn'] is List
          ? (map['imageDescriptionEn'] as List)
                .map((e) => e.toString())
                .toList()
          : <String>[],
      descriptionVi: map['descriptionVi']?.toString(),
      descriptionEn: map['descriptionEn']?.toString(),
      status: map['status']?.toString() ?? '',
      price: (map['price'] as num?) ?? 0,
      originalPrice: (map['originalPrice'] as num?)?.toInt() ?? 0,
      slotBuy: (map['slotBuy'] as num?)?.toInt() ?? 0,
      createById: map['createById']?.toString() ?? '',
      createdAt:
          (map['createdAt']?.toString() ?? '').parseFromServerTimezone() ??
          DateTime.now(),
      updatedAt:
          (map['updatedAt']?.toString() ?? '').parseFromServerTimezone() ??
          DateTime.now(),
      seller: map['seller'] is Map<String, dynamic>
          ? CompanyProductSeller.fromMap(map['seller'] as Map<String, dynamic>)
          : null,
      categoryInternal: map['categoryInternal'] is Map<String, dynamic>
          ? CompanyProductCategory.fromMap(
              map['categoryInternal'] as Map<String, dynamic>,
            )
          : null,
      category: map['category'] is Map<String, dynamic>
          ? CompanyProductCategory.fromMap(
              map['category'] as Map<String, dynamic>,
            )
          : null,
      quantityPurchased: (map['quantityPurchased'] as num?)?.toInt() ?? 0,
      qrcodeStatus: map['qrcodeStatus'] == true,
      ratingSingleCounts: map['ratingSingleCounts'],
      stars: (map['stars'] as num?)?.toInt() ?? 0,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      length: (map['length'] as num?)?.toInt() ?? 0,
      width: (map['width'] as num?)?.toInt() ?? 0,
      height: (map['height'] as num?)?.toInt() ?? 0,
      weight: (map['weight'] as num?)?.toInt() ?? 0,
      deliverySettings: map['deliverySettings'] is List
          ? map['deliverySettings'] as List
          : [],
      productVariants: map['productVariants'] is List
          ? (map['productVariants'] as List)
                .map(
                  (e) => CompanyProductVariant.fromMap(
                    e as Map<String, dynamic>,
                    map['titleVi']?.toString() ??
                        map['titleEn']?.toString() ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  ),
                )
                .toList()
          : [],
      productOptions: map['productOptions'] is List
          ? map['productOptions'] as List
          : [],
      costPrice: (map['costPrice'] as num?) ?? 0,
      wholesalePrice: (map['wholesalePrice'] as num?) ?? 0,
      isSaleAllowed: map['isSaleAllowed'] == true,
      avatar: map['avatar']?.toString(),
      barcode: map['barcode']?.toString(),
      sku: map['sku']?.toString(),
      measureUnit: map['measureUnit']?.toString(),
      isInventoryManaged: map['isInventoryManaged'] == true,
      brand: map['brand'] is Map<String, dynamic>
          ? CompanyProductBrand.fromMap(map['brand'] as Map<String, dynamic>)
          : null,
      availableQuantity: (map['availableQuantity'] as num?)?.toInt() ?? 0,
      isOnWebsite: map['isOnWebsite'] == true,
      commission: (map['commission'] as num?) ?? 0,
      calculateByUnit: map['calculateByUnit']?.toString() ?? '',
      commissionWeight: (map['commissionWeight'] as num?)?.toInt() ?? 0,
      isCanPacking: map['isCanPacking'] == true,
    );
  }

  /// Get display name (prefer Vietnamese title)
  String get displayName => titleVi ?? titleEn ?? shortName ?? 'Sản phẩm';

  /// Get primary image
  String? get primaryImage =>
      avatar ??
      (imageDetail.isNotEmpty ? imageDetail.first : null) ??
      imageProduct;
}

/// Seller information in CompanyProduct
class CompanyProductSeller {
  final String id;
  final String? fullName;
  final String? username;
  final String? phone;
  final String? avatar;

  CompanyProductSeller({
    required this.id,
    this.fullName,
    this.username,
    this.phone,
    this.avatar,
  });

  factory CompanyProductSeller.fromMap(Map<String, dynamic> map) {
    return CompanyProductSeller(
      id: map['id']?.toString() ?? '',
      fullName: map['fullName']?.toString(),
      username: map['username']?.toString(),
      phone: map['phone']?.toString(),
      avatar: map['avatar']?.toString(),
    );
  }
}

/// Category information in CompanyProduct
class CompanyProductCategory {
  final String id;
  final String? nameVi;
  final String? nameEn;
  final String? imageUrl;
  final String? thumbnail;
  final String? status;
  final String? slugVi;
  final String? slugEn;
  final String? note;
  final String? code;
  final String? createById;
  final int advertiseFee;
  final dynamic industries;
  final String? createdAt;
  final int? countProduct;

  CompanyProductCategory({
    required this.id,
    this.nameVi,
    this.nameEn,
    this.imageUrl,
    this.thumbnail,
    this.status,
    this.slugVi,
    this.slugEn,
    this.note,
    this.code,
    this.createById,
    required this.advertiseFee,
    this.industries,
    this.createdAt,
    this.countProduct,
  });

  factory CompanyProductCategory.fromMap(Map<String, dynamic> map) {
    return CompanyProductCategory(
      id: map['id']?.toString() ?? '',
      nameVi: map['nameVi']?.toString(),
      nameEn: map['nameEn']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      thumbnail: map['thumbnail']?.toString(),
      status: map['status']?.toString(),
      slugVi: map['slugVi']?.toString(),
      slugEn: map['slugEn']?.toString(),
      note: map['note']?.toString(),
      code: map['code']?.toString(),
      createById: map['createById']?.toString(),
      advertiseFee: (map['advertiseFee'] as num?)?.toInt() ?? 0,
      industries: map['industries'],
      createdAt: map['createdAt']?.toString(),
      countProduct: (map['countProduct'] as num?)?.toInt(),
    );
  }

  /// Get display name (prefer Vietnamese name)
  String? get displayName => nameVi ?? nameEn;
}

/// Product variant in CompanyProduct
class CompanyProductVariant {
  final String id;
  final List<dynamic> options;
  final String? imageVariant;
  final num price;
  final num originalPrice;
  final num costPrice;
  final num wholesalePrice;
  final dynamic promotion;
  final num inventory;
  final num length;
  final num weight;
  final num height;
  final num width;
  final String? deleteFlag;
  final String? sku;
  final String? barcode;
  final num slotBuy;
  final num transactionCount;
  final num inTransitCount;
  final num deliveryCount;
  final num availableQuantity;
  final String status;
  final num commission;
  final num commissionWeight;
  final String? calculateByUnit;
  final String? measureUnit;
  final String productName;
  final num? itemsPerUnit;

  CompanyProductVariant({
    required this.id,
    required this.options,
    this.imageVariant,
    required this.price,
    required this.originalPrice,
    required this.costPrice,
    required this.wholesalePrice,
    this.promotion,
    required this.inventory,
    required this.length,
    required this.weight,
    required this.height,
    required this.width,
    this.deleteFlag,
    this.sku,
    this.barcode,
    required this.slotBuy,
    required this.transactionCount,
    required this.inTransitCount,
    required this.deliveryCount,
    required this.availableQuantity,
    required this.status,
    required this.commission,
    required this.commissionWeight,
    required this.calculateByUnit,
    required this.measureUnit,
    required this.productName,
    required this.itemsPerUnit,
  });

  String get displayName => options.isEmpty
      ? productName
      : '${options.map((e) => e["value"]).join(' - ')} - $productName';

  String? get displayOptions =>
      options.isEmpty ? null : options.map((e) => e["value"]).join(' - ');

  factory CompanyProductVariant.fromMap(
    Map<String, dynamic> map,
    String productName,
  ) {
    return CompanyProductVariant(
      id: map['id']?.toString() ?? '',
      options: map['options'] is List ? map['options'] as List : [],
      imageVariant: map['imageVariant']?.toString(),
      price: (map['price'] as num?) ?? 0,
      originalPrice: (map['originalPrice'] as num?) ?? 0,
      costPrice: (map['costPrice'] as num?) ?? 0,
      wholesalePrice: (map['wholesalePrice'] as num?) ?? 0,
      promotion: map['promotion'],
      inventory: (map['inventory'] as num?) ?? 0,
      length: (map['length'] as num?) ?? 0,
      weight: (map['weight'] as num?) ?? 0,
      height: (map['height'] as num?) ?? 0,
      width: (map['width'] as num?) ?? 0,
      deleteFlag: map['deleteFlag']?.toString(),
      sku: map['sku']?.toString(),
      barcode: map['barcode']?.toString(),
      slotBuy: (map['slotBuy'] as num?) ?? 0,
      transactionCount: (map['transactionCount'] as num?) ?? 0,
      inTransitCount: (map['inTransitCount'] as num?) ?? 0,
      deliveryCount: (map['deliveryCount'] as num?) ?? 0,
      availableQuantity: (map['availableQuantity'] as num?) ?? 0,
      status: map['status']?.toString() ?? '',
      commission: (map['commission'] as num?) ?? 0,
      commissionWeight: (map['commissionWeight'] as num?) ?? 0,
      calculateByUnit: map['calculateByUnit']?.toString(),
      measureUnit: map['measureUnit']?.toString(),
      productName: productName,
      itemsPerUnit: (map['itemsPerUnit'] as num?) ?? 0,
    );
  }
}

/// Brand information in CompanyProduct
class CompanyProductBrand {
  final String id;
  final String? name;

  CompanyProductBrand({required this.id, this.name});

  factory CompanyProductBrand.fromMap(Map<String, dynamic> map) {
    return CompanyProductBrand(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString(),
    );
  }
}

/// Result model for company products list with pagination
class CompanyProductsResult {
  final List<CompanyProduct> items;
  final int total;

  CompanyProductsResult({required this.items, required this.total});
}
