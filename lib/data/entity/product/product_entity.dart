// ignore_for_file: public_member_api_docs

import 'dart:convert';

/// Enum cho trạng thái sản phẩm
enum ProductStatus {
  draft, // bản nháp
  waitingConfirmAdmin, // đợi admin duyệt
  approvedWoltech, // admin woltech chấp thuận
  approved, // admin wolcg chấp thuận
  rejected, // admin từ chối
  outOfStock, // hết hàng
  paused, // tạm dừng
  suspend; // khóa tài khoản

  static ProductStatus fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'DRAFT':
        return ProductStatus.draft;
      case 'WAITING_CONFIRM_ADMIN':
        return ProductStatus.waitingConfirmAdmin;
      case 'APPROVED_WOLTECH':
        return ProductStatus.approvedWoltech;
      case 'APPROVED':
        return ProductStatus.approved;
      case 'REJECTED':
        return ProductStatus.rejected;
      case 'OUT_OF_STOCK':
        return ProductStatus.outOfStock;
      case 'PAUSED':
        return ProductStatus.paused;
      case 'SUSPEND':
        return ProductStatus.suspend;
      default:
        return ProductStatus.draft;
    }
  }

  String get value {
    switch (this) {
      case ProductStatus.draft:
        return 'DRAFT';
      case ProductStatus.waitingConfirmAdmin:
        return 'WAITING_CONFIRM_ADMIN';
      case ProductStatus.approvedWoltech:
        return 'APPROVED_WOLTECH';
      case ProductStatus.approved:
        return 'APPROVED';
      case ProductStatus.rejected:
        return 'REJECTED';
      case ProductStatus.outOfStock:
        return 'OUT_OF_STOCK';
      case ProductStatus.paused:
        return 'PAUSED';
      case ProductStatus.suspend:
        return 'SUSPEND';
    }
  }
}

/// Enum cho loại sản phẩm
enum ProductType {
  bestSeller,
  newArrival,
  lowToHighPrice,
  highlyRated;

  static ProductType? fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'BEST_SELLER':
        return ProductType.bestSeller;
      case 'NEW_ARRIVAL':
        return ProductType.newArrival;
      case 'LOW_TO_HIGH_PRICE':
        return ProductType.lowToHighPrice;
      case 'HIGHLY_RATED':
        return ProductType.highlyRated;
      default:
        return null;
    }
  }

  String get value {
    switch (this) {
      case ProductType.bestSeller:
        return 'BEST_SELLER';
      case ProductType.newArrival:
        return 'NEW_ARRIVAL';
      case ProductType.lowToHighPrice:
        return 'LOW_TO_HIGH_PRICE';
      case ProductType.highlyRated:
        return 'HIGHLY_RATED';
    }
  }
}

/// Enum cho wallet case back wallet
enum WalletCaseBackWallet {
  leaderCommission,
  directCommission,
  upLevel,
  reBack,
  amountUseLevel; // wallet use up level - reopen level

  static WalletCaseBackWallet? fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'LEADER_COMMISSION':
        return WalletCaseBackWallet.leaderCommission;
      case 'DIRECT_COMMISSION':
        return WalletCaseBackWallet.directCommission;
      case 'UP_LEVEL':
        return WalletCaseBackWallet.upLevel;
      case 'RE_BACK':
        return WalletCaseBackWallet.reBack;
      case 'AMOUNT_USE_LEVEL':
        return WalletCaseBackWallet.amountUseLevel;
      default:
        return null;
    }
  }

  String get value {
    switch (this) {
      case WalletCaseBackWallet.leaderCommission:
        return 'LEADER_COMMISSION';
      case WalletCaseBackWallet.directCommission:
        return 'DIRECT_COMMISSION';
      case WalletCaseBackWallet.upLevel:
        return 'UP_LEVEL';
      case WalletCaseBackWallet.reBack:
        return 'RE_BACK';
      case WalletCaseBackWallet.amountUseLevel:
        return 'AMOUNT_USE_LEVEL';
    }
  }
}

class ProductEntity {
  final String id;
  final String? titleVi;
  final String? titleEn;
  final String? shortName;
  final String? avatar;
  final String? barcode;
  final String? sku;
  final String? measureUnit; // đơn vị tính
  final String? imageProduct;
  final List<String>? imageDetail;
  final String? video;
  final List<String>? imageDescriptionVi;
  final List<String>? imageDescriptionEn;
  final String? descriptionVi;
  final String? descriptionEn;
  final String? slugVi;
  final String? slugEn;
  final ProductStatus status;
  final ProductType? type;
  final double? price;
  final double originalPrice;
  final double costPrice;
  final double wholesalePrice;
  final double? slotBuy; // tồn kho
  final int slot; // tồn kho
  final int quantityPurchased;
  final String? qrCode;
  final bool? deleteFlag;
  final bool notificationFlag;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createById;
  final double? rejectReasonId;
  final bool? rejectStatus;
  final String? rejectDetails;
  final String? rejectNote;
  final DateTime? registerDate;
  final String? verifiedById;
  final int countReject;
  final String? categoryId;
  final double categoryAdvertiseFee;
  final String? categorySelectedId; // id của category parent hoặc category (sài ở website user)
  final String? categoryInternalId; // id của category parent hoặc category (sài ở seller)
  final String? companyId;
  final String? productCode;
  final bool qrcodeStatus;
  final List<int>? ratingSingleCounts;
  final int ratingCount;
  final double stars;
  final double detention;
  final double refundPercentage;
  final double cashbackAmount;
  final double advertiseFee;
  final WalletCaseBackWallet? wallet;
  final DateTime? deletedAt;
  final int advertiseFeePercent;
  final int cashbackPercent;
  final double length;
  final double width;
  final double height;
  final double weight;
  final List<String>? contracts;
  final String? productDetailId;
  final int? industryId;
  final bool isSaleAllowed;
  final String? brandId;
  final bool isInventoryManaged;
  final double availableQuantity;
  final bool isOnWebsite;
  final List<String> tags;
  final bool isCanPacking;

  ProductEntity({
    required this.id,
    this.titleVi,
    this.titleEn,
    this.shortName,
    this.avatar,
    this.barcode,
    this.sku,
    this.measureUnit,
    this.imageProduct,
    this.imageDetail,
    this.video,
    this.imageDescriptionVi,
    this.imageDescriptionEn,
    this.descriptionVi,
    this.descriptionEn,
    this.slugVi,
    this.slugEn,
    required this.status,
    this.type,
    this.price,
    this.originalPrice = 0,
    this.costPrice = 0,
    this.wholesalePrice = 0,
    this.slotBuy,
    this.slot = 0,
    this.quantityPurchased = 0,
    this.qrCode,
    this.deleteFlag,
    this.notificationFlag = false,
    this.createdAt,
    this.updatedAt,
    this.createById,
    this.rejectReasonId,
    this.rejectStatus,
    this.rejectDetails,
    this.rejectNote,
    this.registerDate,
    this.verifiedById,
    this.countReject = 0,
    this.categoryId,
    this.categoryAdvertiseFee = 0,
    this.categorySelectedId,
    this.categoryInternalId,
    this.companyId,
    this.productCode,
    this.qrcodeStatus = false,
    this.ratingSingleCounts,
    this.ratingCount = 0,
    this.stars = 0,
    this.detention = 0,
    this.refundPercentage = 0,
    this.cashbackAmount = 0,
    this.advertiseFee = 0,
    this.wallet,
    this.deletedAt,
    this.advertiseFeePercent = 0,
    this.cashbackPercent = 0,
    this.length = 0,
    this.width = 0,
    this.height = 0,
    this.weight = 0,
    this.contracts,
    this.productDetailId,
    this.industryId,
    this.isSaleAllowed = true,
    this.brandId,
    this.isInventoryManaged = true,
    this.availableQuantity = 0,
    this.isOnWebsite = true,
    this.tags = const [],
    this.isCanPacking = false,
  });

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      id: map['id']?.toString() ?? '',
      titleVi: map['titleVi']?.toString(),
      titleEn: map['titleEn']?.toString(),
      shortName: map['shortName']?.toString(),
      avatar: map['avatar']?.toString(),
      barcode: map['barcode']?.toString(),
      sku: map['sku']?.toString(),
      measureUnit: map['measureUnit']?.toString(),
      imageProduct: map['imageProduct']?.toString(),
      imageDetail: map['imageDetail'] != null
          ? List<String>.from(map['imageDetail'])
          : null,
      video: map['video']?.toString(),
      imageDescriptionVi: map['imageDescriptionVi'] != null
          ? List<String>.from(map['imageDescriptionVi'])
          : null,
      imageDescriptionEn: map['imageDescriptionEn'] != null
          ? List<String>.from(map['imageDescriptionEn'])
          : null,
      descriptionVi: map['descriptionVi']?.toString(),
      descriptionEn: map['descriptionEn']?.toString(),
      slugVi: map['slugVi']?.toString(),
      slugEn: map['slugEn']?.toString(),
      status: ProductStatus.fromString(map['status']?.toString()),
      type: ProductType.fromString(map['type']?.toString()),
      price: map['price'] != null ? (map['price'] as num).toDouble() : null,
      originalPrice: map['originalPrice'] != null
          ? (map['originalPrice'] as num).toDouble()
          : 0,
      costPrice:
          map['costPrice'] != null ? (map['costPrice'] as num).toDouble() : 0,
      wholesalePrice: map['wholesalePrice'] != null
          ? (map['wholesalePrice'] as num).toDouble()
          : 0,
      slotBuy: map['slotBuy'] != null ? (map['slotBuy'] as num).toDouble() : null,
      slot: map['slot'] != null ? (map['slot'] as num).toInt() : 0,
      quantityPurchased: map['quantityPurchased'] != null
          ? (map['quantityPurchased'] as num).toInt()
          : 0,
      qrCode: map['qrCode']?.toString(),
      deleteFlag: map['deleteFlag'] as bool?,
      notificationFlag: map['notificationFlag'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      createById: map['createById']?.toString(),
      rejectReasonId: map['rejectReasonId'] != null
          ? (map['rejectReasonId'] as num).toDouble()
          : null,
      rejectStatus: map['rejectStatus'] as bool?,
      rejectDetails: map['rejectDetails']?.toString(),
      rejectNote: map['rejectNote']?.toString(),
      registerDate: map['registerDate'] != null
          ? DateTime.tryParse(map['registerDate'].toString())
          : null,
      verifiedById: map['verifiedById']?.toString(),
      countReject:
          map['countReject'] != null ? (map['countReject'] as num).toInt() : 0,
      categoryId: map['categoryId']?.toString() ??
          map['category']?['id']?.toString(),
      categoryAdvertiseFee: map['categoryAdvertiseFee'] != null
          ? (map['categoryAdvertiseFee'] as num).toDouble()
          : 0,
      categorySelectedId: map['categorySelectedId']?.toString(),
      categoryInternalId: map['categoryInternalId']?.toString(),
      companyId: map['companyId']?.toString(),
      productCode: map['productCode']?.toString(),
      qrcodeStatus: map['qrcodeStatus'] as bool? ?? false,
      ratingSingleCounts: map['ratingSingleCounts'] != null
          ? List<int>.from(map['ratingSingleCounts'])
          : null,
      ratingCount:
          map['ratingCount'] != null ? (map['ratingCount'] as num).toInt() : 0,
      stars: map['stars'] != null ? (map['stars'] as num).toDouble() : 0,
      detention:
          map['detention'] != null ? (map['detention'] as num).toDouble() : 0,
      refundPercentage: map['refundPercentage'] != null
          ? (map['refundPercentage'] as num).toDouble()
          : 0,
      cashbackAmount: map['cashbackAmount'] != null
          ? (map['cashbackAmount'] as num).toDouble()
          : 0,
      advertiseFee: map['advertiseFee'] != null
          ? (map['advertiseFee'] as num).toDouble()
          : 0,
      wallet: WalletCaseBackWallet.fromString(map['wallet']?.toString()),
      deletedAt: map['deletedAt'] != null
          ? DateTime.tryParse(map['deletedAt'].toString())
          : null,
      advertiseFeePercent: map['advertiseFeePercent'] != null
          ? (map['advertiseFeePercent'] as num).toInt()
          : 0,
      cashbackPercent: map['cashbackPercent'] != null
          ? (map['cashbackPercent'] as num).toInt()
          : 0,
      length: map['length'] != null ? (map['length'] as num).toDouble() : 0,
      width: map['width'] != null ? (map['width'] as num).toDouble() : 0,
      height: map['height'] != null ? (map['height'] as num).toDouble() : 0,
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : 0,
      contracts: map['contracts'] != null
          ? List<String>.from(map['contracts'])
          : null,
      productDetailId: map['productDetailId']?.toString() ??
          map['productDetail']?['id']?.toString(),
      industryId: map['industryId'] != null ? (map['industryId'] as num).toInt() : null,
      isSaleAllowed: map['isSaleAllowed'] as bool? ?? true,
      brandId: map['brandId']?.toString() ?? map['brand']?['id']?.toString(),
      isInventoryManaged: map['isInventoryManaged'] as bool? ?? true,
      availableQuantity: map['availableQuantity'] != null
          ? (map['availableQuantity'] as num).toDouble()
          : 0,
      isOnWebsite: map['isOnWebsite'] as bool? ?? true,
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      isCanPacking: map['isCanPacking'] as bool? ?? false,
    );
  }

  factory ProductEntity.fromJson(String source) =>
      ProductEntity.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleVi': titleVi,
      'titleEn': titleEn,
      'shortName': shortName,
      'avatar': avatar,
      'barcode': barcode,
      'sku': sku,
      'measureUnit': measureUnit,
      'imageProduct': imageProduct,
      'imageDetail': imageDetail,
      'video': video,
      'imageDescriptionVi': imageDescriptionVi,
      'imageDescriptionEn': imageDescriptionEn,
      'descriptionVi': descriptionVi,
      'descriptionEn': descriptionEn,
      'slugVi': slugVi,
      'slugEn': slugEn,
      'status': status.value,
      'type': type?.value,
      'price': price,
      'originalPrice': originalPrice,
      'costPrice': costPrice,
      'wholesalePrice': wholesalePrice,
      'slotBuy': slotBuy,
      'slot': slot,
      'quantityPurchased': quantityPurchased,
      'qrCode': qrCode,
      'deleteFlag': deleteFlag,
      'notificationFlag': notificationFlag,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createById': createById,
      'rejectReasonId': rejectReasonId,
      'rejectStatus': rejectStatus,
      'rejectDetails': rejectDetails,
      'rejectNote': rejectNote,
      'registerDate': registerDate?.toIso8601String(),
      'verifiedById': verifiedById,
      'countReject': countReject,
      'categoryId': categoryId,
      'categoryAdvertiseFee': categoryAdvertiseFee,
      'categorySelectedId': categorySelectedId,
      'categoryInternalId': categoryInternalId,
      'companyId': companyId,
      'productCode': productCode,
      'qrcodeStatus': qrcodeStatus,
      'ratingSingleCounts': ratingSingleCounts,
      'ratingCount': ratingCount,
      'stars': stars,
      'detention': detention,
      'refundPercentage': refundPercentage,
      'cashbackAmount': cashbackAmount,
      'advertiseFee': advertiseFee,
      'wallet': wallet?.value,
      'deletedAt': deletedAt?.toIso8601String(),
      'advertiseFeePercent': advertiseFeePercent,
      'cashbackPercent': cashbackPercent,
      'length': length,
      'width': width,
      'height': height,
      'weight': weight,
      'contracts': contracts,
      'productDetailId': productDetailId,
      'industryId': industryId,
      'isSaleAllowed': isSaleAllowed,
      'brandId': brandId,
      'isInventoryManaged': isInventoryManaged,
      'availableQuantity': availableQuantity,
      'isOnWebsite': isOnWebsite,
      'tags': tags,
      'isCanPacking': isCanPacking,
    };
  }

  String toJson() => json.encode(toMap());

  ProductEntity copyWith({
    String? id,
    String? titleVi,
    String? titleEn,
    String? shortName,
    String? avatar,
    String? barcode,
    String? sku,
    String? measureUnit,
    String? imageProduct,
    List<String>? imageDetail,
    String? video,
    List<String>? imageDescriptionVi,
    List<String>? imageDescriptionEn,
    String? descriptionVi,
    String? descriptionEn,
    String? slugVi,
    String? slugEn,
    ProductStatus? status,
    ProductType? type,
    double? price,
    double? originalPrice,
    double? costPrice,
    double? wholesalePrice,
    double? slotBuy,
    int? slot,
    int? quantityPurchased,
    String? qrCode,
    bool? deleteFlag,
    bool? notificationFlag,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createById,
    double? rejectReasonId,
    bool? rejectStatus,
    String? rejectDetails,
    String? rejectNote,
    DateTime? registerDate,
    String? verifiedById,
    int? countReject,
    String? categoryId,
    double? categoryAdvertiseFee,
    String? categorySelectedId,
    String? categoryInternalId,
    String? companyId,
    String? productCode,
    bool? qrcodeStatus,
    List<int>? ratingSingleCounts,
    int? ratingCount,
    double? stars,
    double? detention,
    double? refundPercentage,
    double? cashbackAmount,
    double? advertiseFee,
    WalletCaseBackWallet? wallet,
    DateTime? deletedAt,
    int? advertiseFeePercent,
    int? cashbackPercent,
    double? length,
    double? width,
    double? height,
    double? weight,
    List<String>? contracts,
    String? productDetailId,
    int? industryId,
    bool? isSaleAllowed,
    String? brandId,
    bool? isInventoryManaged,
    double? availableQuantity,
    bool? isOnWebsite,
    List<String>? tags,
    bool? isCanPacking,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      titleVi: titleVi ?? this.titleVi,
      titleEn: titleEn ?? this.titleEn,
      shortName: shortName ?? this.shortName,
      avatar: avatar ?? this.avatar,
      barcode: barcode ?? this.barcode,
      sku: sku ?? this.sku,
      measureUnit: measureUnit ?? this.measureUnit,
      imageProduct: imageProduct ?? this.imageProduct,
      imageDetail: imageDetail ?? this.imageDetail,
      video: video ?? this.video,
      imageDescriptionVi: imageDescriptionVi ?? this.imageDescriptionVi,
      imageDescriptionEn: imageDescriptionEn ?? this.imageDescriptionEn,
      descriptionVi: descriptionVi ?? this.descriptionVi,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      slugVi: slugVi ?? this.slugVi,
      slugEn: slugEn ?? this.slugEn,
      status: status ?? this.status,
      type: type ?? this.type,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      costPrice: costPrice ?? this.costPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      slotBuy: slotBuy ?? this.slotBuy,
      slot: slot ?? this.slot,
      quantityPurchased: quantityPurchased ?? this.quantityPurchased,
      qrCode: qrCode ?? this.qrCode,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      notificationFlag: notificationFlag ?? this.notificationFlag,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createById: createById ?? this.createById,
      rejectReasonId: rejectReasonId ?? this.rejectReasonId,
      rejectStatus: rejectStatus ?? this.rejectStatus,
      rejectDetails: rejectDetails ?? this.rejectDetails,
      rejectNote: rejectNote ?? this.rejectNote,
      registerDate: registerDate ?? this.registerDate,
      verifiedById: verifiedById ?? this.verifiedById,
      countReject: countReject ?? this.countReject,
      categoryId: categoryId ?? this.categoryId,
      categoryAdvertiseFee: categoryAdvertiseFee ?? this.categoryAdvertiseFee,
      categorySelectedId: categorySelectedId ?? this.categorySelectedId,
      categoryInternalId: categoryInternalId ?? this.categoryInternalId,
      companyId: companyId ?? this.companyId,
      productCode: productCode ?? this.productCode,
      qrcodeStatus: qrcodeStatus ?? this.qrcodeStatus,
      ratingSingleCounts: ratingSingleCounts ?? this.ratingSingleCounts,
      ratingCount: ratingCount ?? this.ratingCount,
      stars: stars ?? this.stars,
      detention: detention ?? this.detention,
      refundPercentage: refundPercentage ?? this.refundPercentage,
      cashbackAmount: cashbackAmount ?? this.cashbackAmount,
      advertiseFee: advertiseFee ?? this.advertiseFee,
      wallet: wallet ?? this.wallet,
      deletedAt: deletedAt ?? this.deletedAt,
      advertiseFeePercent: advertiseFeePercent ?? this.advertiseFeePercent,
      cashbackPercent: cashbackPercent ?? this.cashbackPercent,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      contracts: contracts ?? this.contracts,
      productDetailId: productDetailId ?? this.productDetailId,
      industryId: industryId ?? this.industryId,
      isSaleAllowed: isSaleAllowed ?? this.isSaleAllowed,
      brandId: brandId ?? this.brandId,
      isInventoryManaged: isInventoryManaged ?? this.isInventoryManaged,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      isOnWebsite: isOnWebsite ?? this.isOnWebsite,
      tags: tags ?? this.tags,
      isCanPacking: isCanPacking ?? this.isCanPacking,
    );
  }
}

