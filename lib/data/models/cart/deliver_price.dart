class DeliverPrice {
  final int? id;
  final String provinceID;
  final String districtID;
  final int? price;
  DeliverPrice({
    this.id,
    required this.provinceID,
    required this.districtID,
    this.price,
  });

  DeliverPrice copyWith({
    int? id,
    int? price,
  }) {
    return DeliverPrice(
      id: id ?? this.id,
      districtID: districtID,
      provinceID: provinceID,
      price: price ?? this.price,
    );
  }

  factory DeliverPrice.fromMap(Map<String, dynamic> map) {
    return DeliverPrice(
      id: map['id'] as int,
      provinceID: map['province_id'] as String,
      districtID: map['district_id'] as String,
      price: map['deliver_price'] as int,
    );
  }
}
