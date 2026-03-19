import 'dart:convert';

import 'package:zili_coffee/utils/enums.dart';

import '../../../utils/enums/address_enum.dart';

/// Region model for administrative regions (districts, wards)
/// Used for PRE_MERGER and POST_MERGER type regions
class Region {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final RegionDistrict? district;
  final RegionDistrict? province;
  final String type; // 'PRE_MERGER' or 'POST_MERGER'
  final String? ghnId;
  final String? vnpId;
  final String? vtpId;

  Region({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.district,
    this.province,
    required this.type,
    this.ghnId,
    this.vnpId,
    this.vtpId,
  });

  String get displayName {
    if (type == RegionType.postMerger.toConstant) {
      return name;
    } else {
      String result = "";
      if (province != null) {
        result += '${province?.name}';
      }
      if (district != null) {
        result += ', ${district?.name}';
      }
      result += ', $name';
      return result;
    }
  }

  factory Region.fromMap(Map<String, dynamic> map) {
    return Region(
      code: map['code'] as String? ?? '',
      name: map['name'] as String? ?? '',
      nameEn: map['name_en'] as String?,
      fullName: map['full_name'] as String?,
      fullNameEn: map['full_name_en'] as String?,
      codeName: map['code_name'] as String?,
      district: map['district'] != null
          ? RegionDistrict.fromMap(map['district'] as Map<String, dynamic>)
          : null,
      province: map['province'] != null
          ? RegionDistrict.fromMap(map['province'] as Map<String, dynamic>)
          : null,
      type: map['type'] as String? ?? 'PRE_MERGER',
      ghnId: map['ghnId'] as String?,
      vnpId: map['vnpId'] as String?,
      vtpId: map['vtpId'] as String?,
    );
  }

  factory Region.fromJson(String source) => Region.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'name_en': nameEn,
      'full_name': fullName,
      'full_name_en': fullNameEn,
      'code_name': codeName,
      'district': district?.toMap(),
      'province': province?.toMap(),
      'type': type,
      'ghnId': ghnId,
      'vnpId': vnpId,
      'vtpId': vtpId,
    };
  }

  String toJson() => json.encode(toMap());

  Region copyWith({
    String? code,
    String? name,
    String? nameEn,
    String? fullName,
    String? fullNameEn,
    String? codeName,
    RegionDistrict? district,
    RegionDistrict? province,
    String? type,
    String? ghnId,
    String? vnpId,
    String? vtpId,
  }) {
    return Region(
      code: code ?? this.code,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      fullName: fullName ?? this.fullName,
      fullNameEn: fullNameEn ?? this.fullNameEn,
      codeName: codeName ?? this.codeName,
      district: district ?? this.district,
      province: province ?? this.province,
      type: type ?? this.type,
      ghnId: ghnId ?? this.ghnId,
      vnpId: vnpId ?? this.vnpId,
      vtpId: vtpId ?? this.vtpId,
    );
  }

  @override
  String toString() {
    String toStr = code;
    if (name.isNotEmpty) {
      toStr += " $name";
    }
    if ((province?.name ?? "").isNotEmpty) {
      toStr += " $displayName";
    }
    if ((district?.name ?? "").isNotEmpty) {
      toStr += " ${district?.name}";
    }
    return toStr;
  }
}

/// Nested district/province model within Region
class RegionDistrict {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final String? type;
  final String? ghnId;
  final String? vnpId;
  final String? vtpId;

  RegionDistrict({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.type,
    this.ghnId,
    this.vnpId,
    this.vtpId,
  });

  factory RegionDistrict.fromMap(Map<String, dynamic> map) {
    return RegionDistrict(
      code: map['code'] as String? ?? '',
      name: map['name'] as String? ?? '',
      nameEn: map['name_en'] as String?,
      fullName: map['full_name'] as String?,
      fullNameEn: map['full_name_en'] as String?,
      codeName: map['code_name'] as String?,
      type: map['type'] as String?,
      ghnId: map['ghnId'] as String?,
      vnpId: map['vnpId'] as String?,
      vtpId: map['vtpId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'name_en': nameEn,
      'full_name': fullName,
      'full_name_en': fullNameEn,
      'code_name': codeName,
      'type': type,
      'ghnId': ghnId,
      'vnpId': vnpId,
      'vtpId': vtpId,
    };
  }

  RegionDistrict copyWith({
    String? code,
    String? name,
    String? nameEn,
    String? fullName,
    String? fullNameEn,
    String? codeName,
    String? type,
    String? ghnId,
    String? vnpId,
    String? vtpId,
  }) {
    return RegionDistrict(
      code: code ?? this.code,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      fullName: fullName ?? this.fullName,
      fullNameEn: fullNameEn ?? this.fullNameEn,
      codeName: codeName ?? this.codeName,
      type: type ?? this.type,
      ghnId: ghnId ?? this.ghnId,
      vnpId: vnpId ?? this.vnpId,
      vtpId: vtpId ?? this.vtpId,
    );
  }

  @override
  String toString() {
    return 'RegionDistrict(code: $code, name: $name)';
  }
}
