import 'dart:convert';

import 'package:zili_coffee/utils/helpers/parser.dart';

import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/functions/base_functions.dart';

class EmployeeRole {
  final int id;
  final String key;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  EmployeeRole({
    required this.id,
    required this.key,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Method này được render từ file `seller-constant.js` của website
  // Phiên bản git: `9fa20acf7a5941db67bc6cc801073b518b46a331`
  String get roleName {
    if (key == Role.guest.toConstant) {
      return "Nhân viên";
    } else if (key == Role.manager.toConstant) {
      return "Quản lý";
    } else if (key == Role.chiefAccountant.toConstant) {
      return "Kế toán trưởng";
    } else if (key == Role.accountant.toConstant) {
      return "Kế toán";
    } else if (key == Role.saleManager.toConstant) {
      return "Trưởng phòng Kinh doanh";
    } else if (key == Role.saleStaff.toConstant) {
      return "NV Kinh Doanh";
    } else if (key == Role.technicalManager.toConstant) {
      return "Trưởng phòng Kỹ thuật";
    } else if (key == Role.technicalStaff.toConstant) {
      return "NV Kỹ thuật";
    } else if (key == Role.packingManager.toConstant) {
      return "Trưởng phòng Đóng gói";
    } else if (key == Role.packingStaff.toConstant) {
      return "NV Đóng gói";
    }
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'key': key,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory EmployeeRole.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel(
      () => EmployeeRole(
        id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
        key: map['key']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        description: map['description']?.toString(),
        createdAt: parseServerTimeZoneDateTime(map['createdAt']),
        updatedAt: parseServerTimeZoneDateTime(map['updatedAt']),
      ),
      map,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeRole.fromJson(String source) =>
      EmployeeRole.fromMap(json.decode(source) as Map<String, dynamic>);
}
