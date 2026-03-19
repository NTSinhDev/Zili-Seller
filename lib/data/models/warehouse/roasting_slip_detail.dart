import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/utils/enums/warehouse_enum.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../../utils/enums.dart';

class RoastingSlipDetail {
  final String id;
  final String code;
  final String status;
  final double pickedWeight;
  final double roastedWeight;
  final double roastedEstimateWeight;
  final String createdAt;
  final String? cancelledAt;
  final String? confirmExportAt;
  final String? completedAt;
  final String creatorName;
  final String? verifiedName;
  final ProductVariant? roastedVariant;
  final ProductVariant? greenVariant;
  final String? warehouseName;
  final String? exportWarehouseName;
  final String? exportedNote;
  final String? completedNote;
  final String? cancelledReason;

  const RoastingSlipDetail({
    required this.id,
    required this.code,
    required this.status,
    required this.pickedWeight,
    required this.roastedWeight,
    required this.roastedEstimateWeight,
    required this.createdAt,
    required this.creatorName,
    this.cancelledAt,
    this.confirmExportAt,
    this.completedAt,
    this.verifiedName,
    this.roastedVariant,
    this.greenVariant,
    this.warehouseName,
    this.exportWarehouseName,
    this.exportedNote,
    this.completedNote,
    this.cancelledReason,
  });

  RoastingSlipStatus? get statusEnum {
    return (RoastingSlipStatus.values as List<RoastingSlipStatus?>).firstWhere(
      (e) => e?.toConstant == status,
    );
  }

  double get lossWeight =>
      pickedWeight.operate(.subtract, roastedWeight).toDouble();
  double get lossPercent =>
      (pickedWeight > 0 ? (lossWeight / pickedWeight) * 100 : 0)
          .floorToDouble();

  factory RoastingSlipDetail.fromMap(Map<String, dynamic> map) {
    return RoastingSlipDetail(
      id: (map['id'] ?? '').toString(),
      code: (map['code'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      pickedWeight: _toDouble(map['pickedWeight']),
      roastedWeight: _toDouble(map['roastedWeight']),
      roastedEstimateWeight: _toDouble(map['roastedEstimateWeight']),
      createdAt: (map['createdAt'] ?? '').toString(),
      confirmExportAt: map['confirmExportAt']?.toString(),
      completedAt: map['completedAt']?.toString(),
      cancelledAt: map['cancelledAt']?.toString(),
      creatorName: (map['creatorName'] ?? map['createdByName'] ?? '')
          .toString(),
      verifiedName:
          map['verifiedBy']?['fullName']?.toString() ??
          map['verifiedByName']?.toString(),
      roastedVariant: map['variant'] is Map<String, dynamic>
          ? ProductVariant.fromMap(map['variant'] as Map<String, dynamic>)
          : null,
      greenVariant: map['variantGreenBean'] is Map<String, dynamic>
          ? ProductVariant.fromMap(
              map['variantGreenBean'] as Map<String, dynamic>,
            )
          : null,
      warehouseName: map['warehouseImport']?['name']?.toString(),
      exportWarehouseName:
          map['warehouse']?['name']?.toString() ??
          map['warehouseName']?.toString(),
      exportedNote: map['exportedNote']?.toString(),
      completedNote: map['completedNote']?.toString(),
      cancelledReason: map['cancelledReason']?.toString(),
    );
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }
}
