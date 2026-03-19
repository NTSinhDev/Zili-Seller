import '../../../utils/enums.dart';
import '../order_packing_item.dart';
import '../product/product_variant.dart';
import '../user/created_by.dart';
import 'packing_slip.dart';
import '../../../utils/extension/extension.dart';

class PackingSlipItemMix extends OrderPackingItem {
  final double totalWeight;
  final bool isWeightBased;
  PackingSlipItemMix({
    required super.id,
    required this.totalWeight,
    required super.productId,
    required super.productNameVi,
    super.productNameEn,
    super.productImage,
    required super.variantId,
    super.variantName,
    super.variantImage,
    super.sku,
    super.measureUnit,
    super.options = const [],
    super.note,
    required super.quantity,
    required this.isWeightBased,
  });

  factory PackingSlipItemMix.fromMap(Map<String, dynamic> map) {
    final optionsData = map['options'] ?? [];
    final optionsList = optionsData is List
        ? optionsData
              .map(
                (e) => ProductVariantOption.fromMap(
                  e is Map<String, dynamic> ? e : {},
                ),
              )
              .toList()
        : <ProductVariantOption>[];

    return PackingSlipItemMix(
      id: (map['id'] ?? '').toString(),
      totalWeight: _toDouble(map['totalWeight'] ?? 0),
      productId: (map['productId'] ?? '').toString(),
      productNameVi: (map['productNameVi'] ?? '').toString(),
      productNameEn: map['productNameEn']?.toString(),
      productImage: map['productImage']?.toString(),
      variantId: map['variantId']?.toString() ?? "",
      variantName: map['variantName']?.toString(),
      variantImage: map['variantImage']?.toString(),
      sku: map['sku']?.toString(),
      measureUnit: map['measureUnit']?.toString(),
      options: optionsList,
      note: map['note']?.toString(),
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      isWeightBased: map['isWeightBased'] ?? false,
    );
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }
}

class PackingSlipItemPackaging extends OrderPackingItem {
  final double totalQuantity;

  PackingSlipItemPackaging({
    required super.id,
    required this.totalQuantity,
    required super.productId,
    required super.productNameVi,
    required super.variantId,
    super.productNameEn,
    super.productImage,
    super.variantName,
    super.variantImage,
    super.sku,
    super.measureUnit,
    super.options = const [],
    super.note,
    required super.quantity,
  });

  factory PackingSlipItemPackaging.fromMap(Map<String, dynamic> map) {
    final optionsData = map['options'] ?? [];
    final optionsList = optionsData is List
        ? optionsData
              .map(
                (e) => ProductVariantOption.fromMap(
                  e is Map<String, dynamic> ? e : {},
                ),
              )
              .toList()
        : <ProductVariantOption>[];

    return PackingSlipItemPackaging(
      id: (map['id'] ?? '').toString(),
      totalQuantity: _toDouble(map['totalQuantity'] ?? 0),
      productId: (map['productId'] ?? '').toString(),
      productNameVi: (map['productNameVi'] ?? '').toString(),
      productNameEn: map['productNameEn']?.toString(),
      productImage: map['productImage']?.toString(),
      variantId: map['variantId']?.toString() ?? "",
      variantName: map['variantName']?.toString(),
      variantImage: map['variantImage']?.toString(),
      sku: map['sku']?.toString(),
      measureUnit: map['measureUnit']?.toString(),
      options: optionsList,
      note: map['note']?.toString(),
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }
}

class PackingSlipDetailItem extends PackingSlip {
  final int quantity;
  final double actualQuantity;
  final int totalQuantityMix;
  final double? weight;
  final String productId;
  final String productNameVi;
  final String? productNameEn;
  final String? productImage;
  final String? variantId;
  final String? variantName;
  final String? variantImage;
  final String? sku;
  final String? measureUnit;
  final List<ProductVariantOption> options;
  final List<PackingSlipItemMix> itemMixes;
  final List<PackingSlipItemPackaging> itemPackaging;
  final String? confirmMixAt;
  final String? cancelledAt;
  final String? completedAt;
  final PackingSlip? packing;
  final CreatedBy? confirmMixBy;
  final CreatedBy? cancelledBy;
  final CreatedBy? completedBy;
  final String? packagingNote;
  final String? mixNote;
  final bool isWeightBased;
  final String? cancelReason;

  PackingSlipDetailItem({
    required super.id,
    required this.quantity,
    required this.actualQuantity,
    required super.totalWeight,
    required this.totalQuantityMix,
    required this.weight,
    required super.code,
    required this.productId,
    required this.productNameVi,
    this.productNameEn,
    this.productImage,
    this.variantId,
    this.variantName,
    this.variantImage,
    this.sku,
    this.measureUnit,
    this.options = const [],
    super.note,
    required super.status,
    this.itemMixes = const [],
    this.itemPackaging = const [],
    required super.createdAt,
    super.updatedAt,
    super.totalWeightMix,
    this.confirmMixAt,
    this.cancelledAt,
    this.completedAt,
    this.packing,
    this.confirmMixBy,
    this.cancelledBy,
    this.completedBy,
    this.packagingNote,
    this.mixNote,
    required this.isWeightBased,
    this.cancelReason,
  });

  factory PackingSlipDetailItem.fromMap(Map<String, dynamic> map) {
    final optionsData = map['options'] ?? [];
    final optionsList = optionsData is List
        ? optionsData
              .map(
                (e) => ProductVariantOption.fromMap(
                  e is Map<String, dynamic> ? e : {},
                ),
              )
              .toList()
        : <ProductVariantOption>[];

    final itemMixesData = map['itemMixes'] ?? [];
    final itemMixesList = itemMixesData is List
        ? itemMixesData
              .map(
                (e) => PackingSlipItemMix.fromMap(
                  e is Map<String, dynamic> ? e : {},
                ),
              )
              .toList()
        : <PackingSlipItemMix>[];

    final itemPackagingData = map['itemPackaging'] ?? [];
    final itemPackagingList = itemPackagingData is List
        ? itemPackagingData
              .map(
                (e) => PackingSlipItemPackaging.fromMap(
                  e is Map<String, dynamic> ? e : {},
                ),
              )
              .toList()
        : <PackingSlipItemPackaging>[];

    return PackingSlipDetailItem(
      id: (map['id'] ?? '').toString(),
      quantity: _toInt(map['quantity'] ?? 0),
      actualQuantity: _toDouble(map['actualQuantity']) ?? 0,
      totalWeight: _toDouble(map['totalWeight'] ?? 0) ?? 0,
      totalWeightMix: _toDouble(map['totalWeightMix']) ?? 0,
      totalQuantityMix: _toInt(map['totalQuantityMix'] ?? 0),
      weight: map['weight'] != null ? _toDouble(map['weight'] ?? 0) : null,
      code: (map['code'] ?? '').toString(),
      productId: (map['productId'] ?? '').toString(),
      productNameVi: (map['productNameVi'] ?? '').toString(),
      productNameEn: map['productNameEn']?.toString(),
      productImage: map['productImage']?.toString(),
      variantId: map['variantId']?.toString(),
      variantName: map['variantName']?.toString(),
      variantImage: map['variantImage']?.toString(),
      sku: map['sku']?.toString(),
      measureUnit: map['measureUnit']?.toString(),
      options: optionsList,
      note: map['note']?.toString(),
      status: (map['status'] ?? '').toString(),
      itemMixes: itemMixesList,
      itemPackaging: itemPackagingList,
      createdAt:
          ((map['createdAt']?.toString() ?? '').parseFromServerTimezone() ??
                  DateTime.now())
              .csToString(TimeFormat.hhmmddMMyyyy.value),
      updatedAt: map['updatedAt']?.toString(),
      confirmMixAt: map['confirmMixAt']?.toString(),
      cancelledAt:
          ((map['cancelledAt']?.toString() ?? '').parseFromServerTimezone())
              ?.csToString(TimeFormat.hhmmddMMyyyy.value),
      completedAt: map['completedAt']?.toString(),
      packing: map['packing'] is Map<String, dynamic>
          ? PackingSlip.fromMap(map['packing'] as Map<String, dynamic>)
          : null,
      confirmMixBy: map['confirmMixBy'] is Map<String, dynamic>
          ? CreatedBy.fromMap(map['confirmMixBy'] as Map<String, dynamic>)
          : null,
      cancelledBy: map['cancelledBy'] is Map<String, dynamic>
          ? CreatedBy.fromMap(map['cancelledBy'] as Map<String, dynamic>)
          : null,
      completedBy: map['completedBy'] is Map<String, dynamic>
          ? CreatedBy.fromMap(map['completedBy'] as Map<String, dynamic>)
          : null,
      packagingNote: map['packagingNote']?.toString(),
      mixNote: map['mixNote']?.toString(),
      isWeightBased: map['isWeightBased'] ?? false,
      cancelReason: map['cancelReason']?.toString(),
    );
  }

  static double? _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
