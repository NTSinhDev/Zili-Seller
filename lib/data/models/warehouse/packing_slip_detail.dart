import '../user/created_by.dart';
import 'packing_slip.dart';
import 'packing_slip_item.dart';

class PackingSlipDetail extends PackingSlip {
  final String creatorName;
  final String? warehouseName;
  final int packingSlipCount;
  final List<PackingSlipDetailItem> items;

  PackingSlipDetail({
    required super.id,
    required super.code,
    required super.status,
    required super.createdAt,
    required this.creatorName,
    this.warehouseName,
    required super.totalWeight,
    required this.packingSlipCount,
    super.referencePerson,
    super.note,
    this.items = const [],
  });

  factory PackingSlipDetail.fromMap(Map<String, dynamic> map) {
    final itemsData = map['items'] ?? map['listData'] ?? [];
    final itemsList = itemsData is List
        ? itemsData
              .map(
                (e) => PackingSlipDetailItem.fromMap(
                  e is Map<String, dynamic> ? e : {},
                ),
              )
              .toList()
        : <PackingSlipDetailItem>[];

    final count = map['packingSlipCount'] ?? map['count'] ?? itemsList.length;
    final packingCount = count is int
        ? count
        : count is num
        ? count.toInt()
        : itemsList.length;
    final referencePersonData = map['createdBy'] ?? map['createdBy'];
    final referencePerson = referencePersonData is Map<String, dynamic>
        ? CreatedBy.fromMap(referencePersonData)
        : null;

    return PackingSlipDetail(
      id: (map['id'] ?? '').toString(),
      code: (map['code'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      createdAt: (map['createdAt'] ?? '').toString(),
      creatorName: (map['createdBy']?['fullName'] ?? '').toString(),
      warehouseName:
          map['branch']?['name']?.toString() ??
          map['warehouseName']?.toString(),
      totalWeight: _toDouble(map['totalWeight'] ?? map['weight'] ?? 0),
      packingSlipCount: packingCount,
      note: map['note']?.toString(),
      items: itemsList,
      referencePerson: referencePerson,
    );
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }
}
