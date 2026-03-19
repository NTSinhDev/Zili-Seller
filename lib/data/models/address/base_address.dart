class BaseAddress {
  final String province;
  final String? district;
  final String ward;
  final String address;

  BaseAddress({
    required this.province,
    this.district,
    required this.ward,
    required this.address,
  });
}
