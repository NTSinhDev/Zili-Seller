import 'package:zili_coffee/utils/enums.dart';

import '../../../res/res.dart';
import '../../../utils/enums/warehouse_enum.dart';
import '../../../utils/extension/extension.dart';
import '../user/created_by.dart';
import 'slip_entity.dart';

class RoastingSlip extends SlipEntity {
  final double weight; // pickedWeight
  final double? roastedWeight;
  final String? creatorName;

  RoastingSlip({
    required this.weight,
    required super.id,
    required super.code,
    required super.status,
    required super.createdAt,
    super.referencePerson,
    super.updatedAt,
    super.note,
    this.roastedWeight,
    this.creatorName,
  });

  @override
  List<MapEntry<String, String>> get infoRows {
    return [
      MapEntry('Khối lượng rang (kg)', weight.toUSD),
      MapEntry('Người tạo', creator ?? AppConstant.strings.DEFAULT_EMPTY_VALUE),
      MapEntry(
        'Thời gian tạo',
        DateTime.tryParse(createdAt).formatWithTimezone(),
      ),
    ];
  }

  String? get creator => referencePerson?.fullName ?? creatorName;

  RoastingSlipStatus? get statusEnum {
    if (status.isEmpty) return null;
    try {
      return RoastingSlipStatus.values.firstWhere(
        (e) => e.toConstant == status,
      );
    } catch (e) {
      return null;
    }
  }

  factory RoastingSlip.fromMap(Map<String, dynamic> map) {
    final creatorMapData =
        map['creator'] ?? map['createdBy'] ?? map['userName'] ?? map['user'];
    return RoastingSlip(
      id: (map['id'] ?? '').toString(),
      code: (map['code'] ?? map['sku'] ?? map['productId'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      weight: _parseDouble(map['pickedWeight']),
      referencePerson: creatorMapData != null
          ? CreatedBy.fromMap(creatorMapData as Map<String, dynamic>)
          : null,
      createdAt: (map['createdAt'] ?? map['createTime'] ?? '').toString(),
      updatedAt: (map['updatedAt'] ?? map['updated_at'])?.toString(),
      note: map['note']?.toString(),
      roastedWeight: _parseDouble(map['roastedWeight']),
      creatorName: map['creatorName']?.toString(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
