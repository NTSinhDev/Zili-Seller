import 'package:zili_coffee/utils/functions/base_functions.dart';

import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/enums/warehouse_enum.dart';
import '../../../utils/extension/extension.dart';
import '../user/created_by.dart';
import 'slip_entity.dart';

class PackingSlip extends SlipEntity {
  final double totalWeight;
  final double totalWeightMix;
  int totalProcessingSlip;
  final DateTime? recordedDate;
  PackingSlip({
    required this.totalWeight,
    this.totalWeightMix = 0,
    this.totalProcessingSlip = 0,
    required super.id,
    required super.code,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.note,
    super.referencePerson,
    this.recordedDate,
  });

  @override
  List<MapEntry<String, String>> get infoRows {
    return [
      MapEntry('Tổng số lượng', totalWeight.toUSD),
      MapEntry('Số lượng thực tế', totalWeightMix.toUSD),
      MapEntry(
        'Người tạo',
        packedBy ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      ),
      MapEntry(
        'Thời gian tạo',
        DateTime.tryParse(createdAt).formatWithTimezone(),
      ),
    ];
  }

  String? get packedBy => referencePerson?.fullName;

  PackingSlipStatus? get statusEnum {
    if (status.isEmpty) return null;
    return PackingSlipStatus.values.firstWhere((e) => e.toConstant == status);
  }

  factory PackingSlip.fromMap(Map<String, dynamic> map) {
    final packedByMapData =
        map['packedBy'] ?? map['creator'] ?? map['createdBy'] ?? map['user'];
    int totalProcessingSlip = 0;
    final slips = map['items'] ?? [];
    if (slips is List) {
      totalProcessingSlip = slips
          .where(
            (e) => !([
              PackingSlipStatus.cancelled.toConstant,
              PackingSlipStatus.completed.toConstant,
            ].contains(e["status"])),
          )
          .length;
    }

    return PackingSlip(
      id: (map['id'] ?? '').toString(),
      code: (map['code'] ?? map['packingCode'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      totalProcessingSlip: totalProcessingSlip,
      totalWeight: _parseDouble(map['totalWeight']),
      totalWeightMix: _parseDouble(map['totalWeightMix']),
      createdAt:
          (map['createdAt'] ?? map['createTime'] ?? map['created_at'] ?? '')
              .toString(),
      updatedAt: (map['updatedAt'] ?? map['updated_at'])?.toString(),
      note: map['note']?.toString(),
      referencePerson: packedByMapData != null
          ? CreatedBy.fromMap(packedByMapData as Map<String, dynamic>)
          : null,
      recordedDate: parseServerTimeZoneDateTime(map['recordedDate']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
