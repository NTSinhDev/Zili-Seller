import 'dart:convert';
part 'order_variant_to_json.dart';
part 'order_variant_constant.dart';

class OrderVariant {
  final String id;
  final String tenantId;
  final DateTime? createdOn;
  final DateTime modifiedOn;
  final String categoryId;
  final String brandId;
  final String productId;
  final bool composite;
  final int initPrice;
  final int initStock;
  final int variantRetailPrice;
  final int variantWholePrice;
  final String variantImportPrice;
  final int? promotionRetailPrice;
  final int? discountValueTmp;
  final dynamic promotionType;
  final dynamic promotionId;
  final dynamic conditionId;
  final String imageId;
  final dynamic description;
  final String name;
  final dynamic color;
  final dynamic size;
  final String? opt1;
  final String? opt2;
  final String? opt3;
  final String productName;
  final dynamic productStatus;
  final String status;
  final bool sellable;
  final String sku;
  final String barcode;
  final bool taxable;
  final String weightValue;
  final String weightUnit;
  final dynamic unit;
  final bool packsize;
  final dynamic packsizeQuantity;
  final dynamic packsizeRootId;
  final dynamic packsizeRootSku;
  final dynamic packsizeRootName;
  final String productType;
  final bool warranty;
  final dynamic warrantyTermId;
  final String imageUrl;
  final String thumbUrl;
  final dynamic imageBaseUrl;
  final dynamic imageBaseThumbUrl;
  final dynamic imageColorUrl;
  final dynamic imageColorThumb;
  final dynamic colorValue;
  final bool isActive;

  OrderVariant({
    required this.id,
    required this.tenantId,
    required this.createdOn,
    required this.modifiedOn,
    required this.categoryId,
    required this.brandId,
    required this.productId,
    required this.composite,
    required this.initPrice,
    required this.initStock,
    required this.variantRetailPrice,
    required this.variantWholePrice,
    required this.variantImportPrice,
    required this.promotionRetailPrice,
    required this.discountValueTmp,
    required this.promotionType,
    required this.promotionId,
    required this.conditionId,
    required this.imageId,
    required this.description,
    required this.name,
    required this.color,
    required this.size,
    required this.opt1,
    required this.opt2,
    required this.opt3,
    required this.productName,
    required this.productStatus,
    required this.status,
    required this.sellable,
    required this.sku,
    required this.barcode,
    required this.taxable,
    required this.weightValue,
    required this.weightUnit,
    required this.unit,
    required this.packsize,
    required this.packsizeQuantity,
    required this.packsizeRootId,
    required this.packsizeRootSku,
    required this.packsizeRootName,
    required this.productType,
    required this.warranty,
    required this.warrantyTermId,
    required this.imageUrl,
    required this.thumbUrl,
    required this.imageBaseUrl,
    required this.imageBaseThumbUrl,
    required this.imageColorUrl,
    required this.imageColorThumb,
    required this.colorValue,
    required this.isActive,
  });

  factory OrderVariant.fromMap(Map<String, dynamic> map) {
    return OrderVariant(
      id: map[_Constant.id] as String,
      tenantId: map[_Constant.tenantId] as String,
      createdOn: DateTime.parse(map[_Constant.createdOn] as String),
      modifiedOn: DateTime.parse(map[_Constant.modifiedOn] as String),
      categoryId: map[_Constant.categoryId] as String,
      brandId: map[_Constant.brandId] as String,
      productId: map[_Constant.productId] as String,
      composite: map[_Constant.composite] as bool,
      initPrice: map[_Constant.initPrice] as int,
      initStock: map[_Constant.initStock] as int,
      variantRetailPrice: map[_Constant.variantRetailPrice] as int,
      variantWholePrice: map[_Constant.variantWholePrice] as int,
      variantImportPrice: map[_Constant.variantImportPrice] as String,
      promotionRetailPrice: map[_Constant.promotionRetailPrice] != null
          ? map[_Constant.promotionRetailPrice] as int
          : null,
      discountValueTmp: map[_Constant.discountValueTmp] != null
          ? map[_Constant.discountValueTmp] as int
          : null,
      promotionType: map[_Constant.promotionType] as dynamic,
      promotionId: map[_Constant.promotionId] as dynamic,
      conditionId: map[_Constant.conditionId] as dynamic,
      imageId: map[_Constant.imageId] as String,
      description: map[_Constant.description] as dynamic,
      name: map[_Constant.name] as String,
      color: map[_Constant.color] as dynamic,
      size: map[_Constant.size] as dynamic,
      opt1: map[_Constant.opt1] != null ? map[_Constant.opt1] as String : null,
      opt2: map[_Constant.opt2] != null ? map[_Constant.opt2] as String : null,
      opt3: map[_Constant.opt3] != null ? map[_Constant.opt3] as String : null,
      productName: map[_Constant.productName] as String,
      productStatus: map[_Constant.productStatus] as dynamic,
      status: map[_Constant.status] as String,
      sellable: map[_Constant.sellable] as bool,
      sku: map[_Constant.sku] as String,
      barcode: map[_Constant.barcode] as String,
      taxable: map[_Constant.taxable] as bool,
      weightValue: map[_Constant.weightValue] as String,
      weightUnit: map[_Constant.weightUnit] as String,
      unit: map[_Constant.unit] as dynamic,
      packsize: map[_Constant.packsize] as bool,
      packsizeQuantity: map[_Constant.packsizeQuantity] as dynamic,
      packsizeRootId: map[_Constant.packsizeRootId] as dynamic,
      packsizeRootSku: map[_Constant.packsizeRootSku] as dynamic,
      packsizeRootName: map[_Constant.packsizeRootName] as dynamic,
      productType: map[_Constant.productType] as String,
      warranty: map[_Constant.warranty] as bool,
      warrantyTermId: map[_Constant.warrantyTermId] as dynamic,
      imageUrl: map[_Constant.imageUrl] as String,
      thumbUrl: map[_Constant.thumbUrl] as String,
      imageBaseUrl: map[_Constant.imageBaseUrl] as dynamic,
      imageBaseThumbUrl: map[_Constant.imageBaseThumbUrl] as dynamic,
      imageColorUrl: map[_Constant.imageColorUrl] as dynamic,
      imageColorThumb: map[_Constant.imageColorThumb] as dynamic,
      colorValue: map[_Constant.colorValue] as dynamic,
      isActive: map[_Constant.isActive] as bool,
    );
  }
}
