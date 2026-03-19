import 'package:zili_coffee/utils/helpers/parser.dart';

class ReasonEntity {
  final int id;
  final String type;
  final int position;
  final String? valueEn;
  final String? valueVi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReasonEntity({
    required this.id,
    required this.type,
    required this.position,
    this.valueEn,
    this.valueVi,
    this.createdAt,
    this.updatedAt,
  });

  factory ReasonEntity.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel(
      () => ReasonEntity(
        id: map['id'] as int,
        type: map['type'] as String,
        position: map['position'] ?? 0,
        valueEn: map['valueEn']?.toString(),
        valueVi: map['valueVi']?.toString(),
        // createdAt: map['createdAt'] != null
        //     ? DateTime.parse(map['createdAt'])
        //     : null,
        // updatedAt: map['updatedAt'] != null
        //     ? DateTime.parse(map['updatedAt'])
        //     : null,
      ),
      map,
    );
  }
}
