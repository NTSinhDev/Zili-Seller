import 'dart:convert';

import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/utils/enums.dart';

part 'address_extension.dart';

class CustomerAddress {
  String? id;
  String? customerId;
  String? name;
  String? phone;
  String? email;
  Location? province;
  Location? district;
  Location? ward;
  String? specificAddress;
  bool isDefaultAddress;

  CustomerAddress({
    this.id,
    this.customerId,
    this.name,
    this.phone,
    this.email,
    this.province,
    this.district,
    this.ward,
    this.specificAddress,
    this.isDefaultAddress = true,
  });

  CustomerAddress copyWith({
    String? id,
    String? customerId,
    String? name,
    String? phone,
    String? email,
    Location? province,
    Location? district,
    Location? ward,
    String? specificAddress,
    bool? isDefaultAddress,
  }) {
    return CustomerAddress(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      specificAddress: specificAddress ?? this.specificAddress,
      isDefaultAddress: isDefaultAddress ?? this.isDefaultAddress,
    );
  }

  factory CustomerAddress.fromMap(Map<String, dynamic> map) {
    return CustomerAddress(
      id: map[_Constant.id]?.toString(),
      customerId: map[_Constant.customerId],
      name: map[_Constant.name] != null
          ? map[_Constant.name] as String
          : map[_Constant.firstName] != null
              ? map[_Constant.firstName] as String
              : null,
      phone:
          map[_Constant.phone] != null ? map[_Constant.phone] as String : null,
      email:
          map[_Constant.email] != null ? map[_Constant.email] as String : null,
      province: map[_Constant.province] != null
          ? Location.fromMap(map[_Constant.province] as Map<String, dynamic>,
              level: LocationLevel.Province_City)
          : null,
      district: map[_Constant.district] != null
          ? Location.fromMap(map[_Constant.district] as Map<String, dynamic>,
              level: LocationLevel.District)
          : null,
      ward: map[_Constant.ward] != null
          ? Location.fromMap(map[_Constant.ward] as Map<String, dynamic>,
              level: LocationLevel.Ward_Town)
          : null,
      specificAddress: map[_Constant.specificAddress] != null
          ? map[_Constant.specificAddress] as String
          : map[_Constant.address1] != null
              ? map[_Constant.address1] as String
              : null,
      isDefaultAddress: map[_Constant.isDefaultAddress] ?? false,
    );
  }

  Map<String, dynamic> toMap({bool toCreateOrder = false}) {
    return <String, dynamic>{
      _Constant.id: id,
      _Constant.customerId: customerId,
      _Constant.name: name,
      _Constant.phone: phone,
      _Constant.email: email,
      _Constant.province: province?.toMap(),
      _Constant.district: district?.toMap(),
      _Constant.ward: ward?.toMap(),
      toCreateOrder ? _Constant.address1 : _Constant.specificAddress:
          specificAddress,
      _Constant.isDefaultAddress: isDefaultAddress,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CustomerAddress(id: $id, customerId: $customerId, name: $name, phone: $phone, email: $email, province: $province, district: $district, ward: $ward, specificAddress: $specificAddress, isDefaultAddress: $isDefaultAddress)';
  }
}

class _Constant {
  static const String id = 'id';
  static const String customerId = 'customerId';
  // static const String customerid = 'customerId';
  static const String firstName = 'first_name';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String province = 'province';
  static const String provinceId = 'provinceId';
  static const String district = 'district';
  static const String districtId = 'districtId';
  static const String ward = 'ward';
  static const String wardId = 'wardId';
  static const String specificAddress = 'address';
  static const String address1 = 'address1';
  // static const String address2 = 'address2';
  static const String isDefaultAddress = 'defaultValue';
}
