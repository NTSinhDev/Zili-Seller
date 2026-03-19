import 'dart:convert';

import 'package:zili_coffee/utils/helpers/parser.dart';

import '../../../res/res.dart';
import '../../entity/address/address_entity.dart';

/// Address Model - DTO for API responses
/// Extends AddressEntity and adds helper methods for UI
class Address extends AddressEntity {
  Address({
    required super.id,
    super.name,
    super.phone,
    super.email,
    super.postalCode,
    super.district,
    required super.province,
    required super.ward,
    super.districtCode,
    super.provinceCode,
    super.wardCode,
    super.updatedAt,
    super.createdAt,
    super.deletedAt,
    super.userId,
    super.collaboratorId,
    super.status = AddressStatus.active,
    super.type,
    super.address,
    super.note,
    super.isDefault = false,
    super.createdById,
    super.addressType,
  });

  /// Parse từ API response
  factory Address.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel(
      () => Address(
        id: map['id']?.toString() ?? map['addressUserId']?.toString() ?? '',
        name: map['name']?.toString() ?? map['recipientName']?.toString(),
        phone: map['phone']?.toString() ?? map['phoneNumber']?.toString(),
        email: map['email']?.toString(),
        postalCode:
            map['postalCode']?.toString() ?? map['postal_code']?.toString(),
        district: map['district']?.toString(),
        province: map['province']?.toString() ?? '',
        ward: map['ward']?.toString() ?? '',
        districtCode:
            map['districtCode']?.toString() ?? map['district_code']?.toString(),
        provinceCode:
            map['provinceCode']?.toString() ?? map['province_code']?.toString(),
        wardCode: map['wardCode']?.toString() ?? map['ward_code']?.toString(),
        updatedAt: map['updatedAt'] != null
            ? DateTime.tryParse(map['updatedAt'].toString())
            : map['updated_at'] != null
            ? DateTime.tryParse(map['updated_at'].toString())
            : null,
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
            : map['created_at'] != null
            ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
            : DateTime.now(),
        deletedAt: map['deletedAt'] != null
            ? DateTime.tryParse(map['deletedAt'].toString())
            : map['deleted_at'] != null
            ? DateTime.tryParse(map['deleted_at'].toString())
            : null,
        userId: map['userId']?.toString() ?? map['user_id']?.toString(),
        collaboratorId:
            map['collaboratorId']?.toString() ??
            map['collaborator_id']?.toString(),
        status: AddressStatus.fromString(
          map['status']?.toString() ?? AddressStatus.active.value,
        ),
        type: AddressType.fromString(map['type']?.toString()),
        address: map['address']?.toString(),
        note: map['note']?.toString(),
        isDefault:
            map['isDefault'] as bool? ?? map['is_default'] as bool? ?? false,
        createdById:
            map['createdById']?.toString() ?? map['created_by_id']?.toString(),
        addressType:
            map['addressType']?.toString() ?? map['address_type']?.toString(),
      ),
      map,
    );
  }

  /// Parse từ JSON string
  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Convert từ AddressEntity
  factory Address.fromEntity(AddressEntity entity) {
    return Address(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      postalCode: entity.postalCode,
      district: entity.district,
      province: entity.province,
      ward: entity.ward,
      districtCode: entity.districtCode,
      provinceCode: entity.provinceCode,
      wardCode: entity.wardCode,
      updatedAt: entity.updatedAt,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      userId: entity.userId,
      collaboratorId: entity.collaboratorId,
      status: entity.status,
      type: entity.type,
      address: entity.address,
      note: entity.note,
      isDefault: entity.isDefault,
      createdById: entity.createdById,
      addressType: entity.addressType,
    );
  }

  /// Helper method: Get full address string
  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) {
      parts.add(address!);
    }
    if ((ward ?? "").isNotEmpty) {
      parts.add(ward ?? "");
    }
    if (district != null && district!.isNotEmpty) {
      parts.add(district!);
    }
    if ((province ?? "").isNotEmpty) {
      parts.add(province ?? "");
    }
    return parts.join(', ');
  }

  /// Helper method: Get display name (name or AppConstant.strings.DEFAULT_EMPTY_VALUE)
  String get displayName {
    return name?.trim().isNotEmpty == true
        ? name!
        : AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  @override
  Address copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? postalCode,
    String? district,
    String? province,
    String? ward,
    String? districtCode,
    String? provinceCode,
    String? wardCode,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deletedAt,
    String? userId,
    String? collaboratorId,
    AddressStatus? status,
    AddressType? type,
    String? address,
    String? note,
    bool? isDefault,
    String? createdById,
    String? addressType,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      postalCode: postalCode ?? this.postalCode,
      district: district ?? this.district,
      province: province ?? this.province,
      ward: ward ?? this.ward,
      districtCode: districtCode ?? this.districtCode,
      provinceCode: provinceCode ?? this.provinceCode,
      wardCode: wardCode ?? this.wardCode,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      userId: userId ?? this.userId,
      collaboratorId: collaboratorId ?? this.collaboratorId,
      status: status ?? this.status,
      type: type ?? this.type,
      address: address ?? this.address,
      note: note ?? this.note,
      isDefault: isDefault ?? this.isDefault,
      createdById: createdById ?? this.createdById,
      addressType: addressType ?? this.addressType,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'postalCode': postalCode,
      'district': district,
      'province': province,
      'ward': ward,
      'districtCode': districtCode,
      'provinceCode': provinceCode,
      'wardCode': wardCode,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'userId': userId,
      'collaboratorId': collaboratorId,
      'status': status.value,
      'type': type?.value,
      'address': address,
      'note': note,
      'isDefault': isDefault,
      'createdById': createdById,
      'addressType': addressType,
    };
  }

  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Address(id: $id, name: $name, address: $address, province: $province, district: $district, ward: $ward, isDefault: $isDefault)';
  }
}
