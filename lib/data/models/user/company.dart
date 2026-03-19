import 'dart:convert';

/// Company Model - DTO for API responses
/// 
/// Model này chứa thông tin về công ty/doanh nghiệp
class Company {
  final String id;
  final String? businessType;
  final String? businessAbbreviation;
  final String? ward;
  final String? wardCode;
  final String? slug;
  final String? address;
  final String? businessName;
  final String? cardId;
  final String? taxId;
  final String? selectedIndustry;
  final String? businessPermit;
  final String? backCard;
  final String? frontCard;
  final String? province;
  final String? provinceCode;
  final DateTime? registerDate;
  final String? status;
  final String? fullName;
  final int countReject;
  final int countRejectOrder;
  final String? image;
  final String? logo;
  final List<BannerItem>? bannerTop;
  final List<BannerItem>? bannerLeft;
  final List<BannerItem>? bannerRight;
  final List<BannerItem>? bannerBottom;
  final String? district;
  final int countProduct;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double rating;
  final double? advancePayment;
  final double? advancePaymentVn;
  final int ratingCount;
  final double? remainingAdvancePayment;
  final String? districtCode;
  final List<String>? actualImages;
  final String? listWalletCashBack;
  final int? industryId;
  final Map<String, dynamic>? industry;
  final List<dynamic>? sideHustles;
  final List<dynamic>? socialMedia;
  final String? descriptionEn;
  final String? descriptionVi;
  final Map<String, dynamic>? objectDistrict;
  final Map<String, dynamic>? objectProvince;
  final Map<String, dynamic>? objectWard;
  final String? companyPhone;
  final String? companyEmail;
  final String? companyAddress;
  final String? contractImage;
  final String? contractCode;
  final double minimumAdvertisedFee;
  final String? trademark;
  final String? bankAccount;
  final String? accountName;
  final int? bankId;
  final int? bankBranchId;
  final List<String>? legalDocuments;
  final String? coverImage;
  final List<String>? highlightedProductIds;
  final double totalRevenue;
  final String? linkToCSKH;
  final String? businessRegistrationCertificate;
  final List<dynamic>? categories;
  final bool categoryOthers;
  final String? contactEmail;

  Company({
    required this.id,
    this.businessType,
    this.businessAbbreviation,
    this.ward,
    this.wardCode,
    this.slug,
    this.address,
    this.businessName,
    this.cardId,
    this.taxId,
    this.selectedIndustry,
    this.businessPermit,
    this.backCard,
    this.frontCard,
    this.province,
    this.provinceCode,
    this.registerDate,
    this.status,
    this.fullName,
    this.countReject = 0,
    this.countRejectOrder = 0,
    this.image,
    this.logo,
    this.bannerTop,
    this.bannerLeft,
    this.bannerRight,
    this.bannerBottom,
    this.district,
    this.countProduct = 0,
    this.createdAt,
    this.updatedAt,
    this.rating = 0.0,
    this.advancePayment,
    this.advancePaymentVn,
    this.ratingCount = 0,
    this.remainingAdvancePayment,
    this.districtCode,
    this.actualImages,
    this.listWalletCashBack,
    this.industryId,
    this.industry,
    this.sideHustles,
    this.socialMedia,
    this.descriptionEn,
    this.descriptionVi,
    this.objectDistrict,
    this.objectProvince,
    this.objectWard,
    this.companyPhone,
    this.companyEmail,
    this.companyAddress,
    this.contractImage,
    this.contractCode,
    this.minimumAdvertisedFee = 0.0,
    this.trademark,
    this.bankAccount,
    this.accountName,
    this.bankId,
    this.bankBranchId,
    this.legalDocuments,
    this.coverImage,
    this.highlightedProductIds,
    this.totalRevenue = 0.0,
    this.linkToCSKH,
    this.businessRegistrationCertificate,
    this.categories,
    this.categoryOthers = false,
    this.contactEmail,
  });

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id']?.toString() ?? '',
      businessType: map['businessType']?.toString(),
      businessAbbreviation: map['businessAbbreviation']?.toString(),
      ward: map['ward']?.toString(),
      wardCode: map['wardCode']?.toString(),
      slug: map['slug']?.toString(),
      address: map['address']?.toString(),
      businessName: map['businessName']?.toString(),
      cardId: map['cardId']?.toString(),
      taxId: map['taxId']?.toString(),
      selectedIndustry: map['selectedIndustry']?.toString(),
      businessPermit: map['businessPermit']?.toString(),
      backCard: map['backCard']?.toString(),
      frontCard: map['frontCard']?.toString(),
      province: map['province']?.toString(),
      provinceCode: map['provinceCode']?.toString(),
      registerDate: map['registerDate'] != null
          ? DateTime.tryParse(map['registerDate'].toString())
          : null,
      status: map['status']?.toString(),
      fullName: map['fullName']?.toString(),
      countReject: (map['countReject'] as num?)?.toInt() ?? 0,
      countRejectOrder: (map['countRejectOrder'] as num?)?.toInt() ?? 0,
      image: map['image']?.toString(),
      logo: map['logo']?.toString(),
      bannerTop: map['bannerTop'] != null
          ? List<BannerItem>.from(
              (map['bannerTop'] as List<dynamic>).map<BannerItem>(
                (x) => BannerItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      bannerLeft: map['bannerLeft'] != null
          ? List<BannerItem>.from(
              (map['bannerLeft'] as List<dynamic>).map<BannerItem>(
                (x) => BannerItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      bannerRight: map['bannerRight'] != null
          ? List<BannerItem>.from(
              (map['bannerRight'] as List<dynamic>).map<BannerItem>(
                (x) => BannerItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      bannerBottom: map['bannerBottom'] != null
          ? List<BannerItem>.from(
              (map['bannerBottom'] as List<dynamic>).map<BannerItem>(
                (x) => BannerItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      district: map['district']?.toString(),
      countProduct: (map['countProduct'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      advancePayment: (map['advancePayment'] as num?)?.toDouble(),
      advancePaymentVn: (map['advancePaymentVn'] as num?)?.toDouble(),
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      remainingAdvancePayment:
          (map['remainingAdvancePayment'] as num?)?.toDouble(),
      districtCode: map['districtCode']?.toString(),
      actualImages: map['actualImages'] != null
          ? List<String>.from(map['actualImages'] as List<dynamic>)
          : null,
      listWalletCashBack: map['listWalletCashBack']?.toString(),
      industryId: (map['industryId'] as num?)?.toInt(),
      industry: map['industry'] != null
          ? Map<String, dynamic>.from(map['industry'] as Map)
          : null,
      sideHustles: map['sideHustles'] as List<dynamic>?,
      socialMedia: map['socialMedia'] as List<dynamic>?,
      descriptionEn: map['descriptionEn']?.toString(),
      descriptionVi: map['descriptionVi']?.toString(),
      objectDistrict: map['objectDistrict'] != null
          ? Map<String, dynamic>.from(map['objectDistrict'] as Map)
          : null,
      objectProvince: map['objectProvince'] != null
          ? Map<String, dynamic>.from(map['objectProvince'] as Map)
          : null,
      objectWard: map['objectWard'] != null
          ? Map<String, dynamic>.from(map['objectWard'] as Map)
          : null,
      companyPhone: map['companyPhone']?.toString(),
      companyEmail: map['companyEmail']?.toString(),
      companyAddress: map['companyAddress']?.toString(),
      contractImage: map['contractImage']?.toString(),
      contractCode: map['contractCode']?.toString(),
      minimumAdvertisedFee:
          (map['minimumAdvertisedFee'] as num?)?.toDouble() ?? 0.0,
      trademark: map['trademark']?.toString(),
      bankAccount: map['bankAccount']?.toString(),
      accountName: map['accountName']?.toString(),
      bankId: (map['bankId'] as num?)?.toInt(),
      bankBranchId: (map['bankBranchId'] as num?)?.toInt(),
      legalDocuments: map['legalDocuments'] != null
          ? List<String>.from(map['legalDocuments'] as List<dynamic>)
          : null,
      coverImage: map['coverImage']?.toString(),
      highlightedProductIds: map['highlightedProductIds'] != null
          ? List<String>.from(map['highlightedProductIds'] as List<dynamic>)
          : null,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      linkToCSKH: map['linkToCSKH']?.toString(),
      businessRegistrationCertificate:
          map['businessRegistrationCertificate']?.toString(),
      categories: map['categories'] as List<dynamic>?,
      categoryOthers: map['categoryOthers'] as bool? ?? false,
      contactEmail: map['contactEmail']?.toString(),
    );
  }

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (businessType != null) 'businessType': businessType,
      if (businessAbbreviation != null) 'businessAbbreviation': businessAbbreviation,
      if (ward != null) 'ward': ward,
      if (wardCode != null) 'wardCode': wardCode,
      if (slug != null) 'slug': slug,
      if (address != null) 'address': address,
      if (businessName != null) 'businessName': businessName,
      if (cardId != null) 'cardId': cardId,
      if (taxId != null) 'taxId': taxId,
      if (logo != null) 'logo': logo,
      if (taxId != null) 'taxId': taxId,
    };
  }

  String toJson() => json.encode(toMap());
}

/// Banner Item Model
class BannerItem {
  final String url;
  final int position;

  BannerItem({
    required this.url,
    required this.position,
  });

  factory BannerItem.fromMap(Map<String, dynamic> map) {
    return BannerItem(
      url: map['url']?.toString() ?? '',
      position: (map['position'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'position': position,
    };
  }
}

