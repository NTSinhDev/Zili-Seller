import 'dart:convert';

/// Order Invoice Model - DTO for API responses
/// 
/// Model này chứa thông tin hóa đơn của đơn hàng
class OrderInvoice {
  final String? name;
  final String? address;
  final String? email;
  final String? type;
  final String? taxCode;
  final String? invoiceFileUrl;
  final String? addressUserId;
  final String? province;
  final String? provinceCode;
  final String? district;
  final String? districtCode;
  final String? ward;
  final String? wardCode;
  final double? lat;
  final double? long;
  final String? phoneNumber;

  OrderInvoice({
    this.name,
    this.address,
    this.email,
    this.type,
    this.taxCode,
    this.invoiceFileUrl,
    this.addressUserId,
    this.province,
    this.provinceCode,
    this.district,
    this.districtCode,
    this.ward,
    this.wardCode,
    this.lat,
    this.long,
    this.phoneNumber,
  });

  factory OrderInvoice.fromMap(Map<String, dynamic> map) {
    return OrderInvoice(
      name: map['name'] as String?,
      address: map['address'] as String?,
      email: map['email'] as String?,
      type: map['type'] as String?,
      taxCode: map['taxCode'] as String?,
      invoiceFileUrl: map['invoiceFileUrl'] as String?,
      addressUserId: map['addressUserId'] as String?,
      province: map['province'] as String?,
      provinceCode: map['provinceCode'] as String?,
      district: map['district'] as String?,
      districtCode: map['districtCode'] as String?,
      ward: map['ward'] as String?,
      wardCode: map['wardCode'] as String?,
      lat: (map['lat'] as num?)?.toDouble(),
      long: (map['long'] as num?)?.toDouble(),
      phoneNumber: map['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'email': email,
      'type': type,
      'taxCode': taxCode,
      'invoiceFileUrl': invoiceFileUrl,
      'addressUserId': addressUserId,
      'province': province,
      'provinceCode': provinceCode,
      'district': district,
      'districtCode': districtCode,
      'ward': ward,
      'wardCode': wardCode,
      'lat': lat,
      'long': long,
      'phoneNumber': phoneNumber,
    };
  }

  String toJson() => json.encode(toMap());
}

