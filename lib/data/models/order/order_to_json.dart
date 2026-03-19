part of 'order.dart';

extension OrderToJson on Order {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{};
  }

  String toJson() => json.encode(toMap());
}
