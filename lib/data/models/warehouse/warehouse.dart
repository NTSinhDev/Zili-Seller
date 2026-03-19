import '../address/base_address.dart';

class Warehouse {
  final String id;
  final String name;
  final String? code;
  final String? address;
  final bool? isDefault;
  final String? phone;
  final String? email;
  final bool isActive;
  final BaseAddress baseAddress;

  Warehouse({
    required this.id,
    required this.name,
    this.isActive = false,
    this.code,
    this.address,
    this.isDefault,
    this.phone,
    this.email,
    required this.baseAddress,
  });

  factory Warehouse.fromMap(Map<String, dynamic> map) {
    return Warehouse(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      code: map['code']?.toString(),
      address: map['address']?.toString(),
      isDefault: map['type'] != null ? map['type'] == "DEFAULT" : false,
      phone: map['phone']?.toString(),
      email: map['email']?.toString(),
      baseAddress: BaseAddress(
        province: map['province']?.toString() ?? '',
        district: map['district']?.toString(),
        ward: map['ward']?.toString() ?? '',
        address: map['address']?.toString() ?? '',
      ),
      isActive: map['status'] != null ? map['status'] == "ACTIVE" : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'isDefault': isDefault,
      'phone': phone,
      'email': email,
      'province': baseAddress.province,
      'district': baseAddress.district,
      'ward': baseAddress.ward,
      'status': isActive ? "ACTIVE" : "INACTIVE",
    };
  }

  Warehouse copyWith({
    String? id,
    String? name,
    String? code,
    String? address,
    bool? isDefault,
    String? phone,
    String? email,
    String? provinceName,
    BaseAddress? baseAddress,
    bool? isActive,
  }) {
    return Warehouse(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      baseAddress: baseAddress ?? this.baseAddress,
      isActive: isActive ?? this.isActive,
    );
  }
}
