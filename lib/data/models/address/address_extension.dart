part of 'customer_address.dart';

extension AddressExt on CustomerAddress {
  void clearDistrict() {
    district = null;
  }

  void clearWard() {
    ward = null;
  }

  String mapToJson(Map<String, dynamic> map) => json.encode(map);

  Map<String, dynamic> toMapLitleData() {
    return <String, dynamic>{
      _Constant.id: id,
      _Constant.customerId: customerId,
      _Constant.name: name,
      _Constant.phone: phone,
      _Constant.email: email,
      _Constant.provinceId: province?.id,
      _Constant.districtId: district?.id,
      _Constant.wardId: ward?.id,
      _Constant.specificAddress: specificAddress,
      _Constant.isDefaultAddress: true,
    };
  }

  String address() {
    final wardStr = ward == null ? '' : ' ${ward!.level} ${ward!.name},';
    final districtStr =
        district == null ? '' : ' ${district!.level} ${district!.name},';
    final provinceStr = province == null
        ? ''
        : ' ${province!.level} ${province!.name.replaceAll("TP", "")}';
    final str = '$specificAddress,$wardStr$districtStr$provinceStr';
    return str;
  }

  bool checkData() {
    if (name == null ||
        phone == null ||
        province == null ||
        district == null ||
        ward == null ||
        specificAddress == null) {
      return false;
    }
    return true;
  }
}
