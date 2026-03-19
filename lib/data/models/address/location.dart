// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:zili_coffee/utils/enums.dart';

class Location {
  final String id;
  final String name;
  final String level;
  final LocationLevel levelEnum;

  Location({
    required this.id,
    required this.name,
    required this.level,
    required this.levelEnum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'level': level};
  }

  factory Location.fromMap(Map<String, dynamic> map,
      {required LocationLevel level}) {
    return Location(
      id: map['id'] as String,
      name: map['name'] as String,
      level: map['level'] as String,
      levelEnum: level,
    );
  }

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.level == level &&
      other.levelEnum == levelEnum;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      level.hashCode ^
      levelEnum.hashCode;
  }
}
