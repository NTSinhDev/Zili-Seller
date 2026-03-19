import 'dart:convert';

/// Address status enum
enum AddressStatus {
  active('ACTIVE'),
  inactive('INACTIVE');

  final String value;
  const AddressStatus(this.value);

  static AddressStatus fromString(String? value) {
    if (value == null) return AddressStatus.active;
    switch (value.toUpperCase()) {
      case 'ACTIVE':
        return AddressStatus.active;
      case 'INACTIVE':
        return AddressStatus.inactive;
      default:
        return AddressStatus.active;
    }
  }
}

/// Address type enum
enum AddressType {
  office('OFFICE'),
  home('HOME');

  final String value;
  const AddressType(this.value);

  static AddressType? fromString(String? value) {
    if (value == null) return null;
    switch (value.toUpperCase()) {
      case 'OFFICE':
        return AddressType.office;
      case 'HOME':
        return AddressType.home;
      default:
        return null;
    }
  }
}

/// Address Entity - mapped from TypeORM Address entity
class AddressEntity {
  final String id;
  final String? name;
  final String? phone;
  final String? email;
  final String? postalCode;
  final String? district;
  final String? province;
  final String? ward;
  final String? districtCode;
  final String? provinceCode;
  final String? wardCode;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? deletedAt;
  final String? userId;
  final String? collaboratorId;
  final AddressStatus status;
  final AddressType? type;
  final String? address;
  final String? note;
  final bool isDefault;
  final String? createdById;
  final String? addressType;

  AddressEntity({
    required this.id,
    this.name,
    this.phone,
    this.email,
    this.postalCode,
    this.district,
    required this.province,
    required this.ward,
    this.districtCode,
    this.provinceCode,
    this.wardCode,
    this.updatedAt,
    this.createdAt,
    this.deletedAt,
    this.userId,
    this.collaboratorId,
    this.status = AddressStatus.active,
    this.type,
    this.address,
    this.note,
    this.isDefault = false,
    this.createdById,
    this.addressType,
  });

  factory AddressEntity.fromMap(Map<String, dynamic> map) {
    return AddressEntity(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString(),
      phone: map['phone']?.toString(),
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
          ? DateTime.tryParse(map['createdAt'].toString()) ??
              DateTime.now()
          : map['created_at'] != null
              ? DateTime.tryParse(map['created_at'].toString()) ??
                  DateTime.now()
              : DateTime.now(),
      deletedAt: map['deletedAt'] != null
          ? DateTime.tryParse(map['deletedAt'].toString())
          : map['deleted_at'] != null
              ? DateTime.tryParse(map['deleted_at'].toString())
              : null,
      userId: map['userId']?.toString() ?? map['user_id']?.toString(),
      collaboratorId:
          map['collaboratorId']?.toString() ?? map['collaborator_id']?.toString(),
      status: AddressStatus.fromString(
          map['status']?.toString() ?? AddressStatus.active.value),
      type: AddressType.fromString(map['type']?.toString()),
      address: map['address']?.toString(),
      note: map['note']?.toString(),
      isDefault: map['isDefault'] as bool? ??
          map['is_default'] as bool? ??
          false,
      createdById:
          map['createdById']?.toString() ?? map['created_by_id']?.toString(),
      addressType:
          map['addressType']?.toString() ?? map['address_type']?.toString(),
    );
  }

  factory AddressEntity.fromJson(String source) =>
      AddressEntity.fromMap(json.decode(source) as Map<String, dynamic>);

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

  String toJson() => json.encode(toMap());

  AddressEntity copyWith({
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
    return AddressEntity(
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
  String toString() {
    return 'AddressEntity(id: $id, name: $name, address: $address, province: $province, district: $district, ward: $ward, isDefault: $isDefault)';
  }
}

