// ignore_for_file: public_member_api_docs, sort_constructors_first

/// DTO for creating a new customer group
class CreateCustomerGroupInput {
  final String? defaultPrice; // "RETAIL_PRICE", "WHOLESALE_PRICE"
  final String nameVi; // Required
  final String? code;
  final String? descriptionVi;
  final int? discount;
  final String? paymentMethod;
  final String type; // "FIXED", "AUTOMATIC" - Required

  CreateCustomerGroupInput({
    this.defaultPrice,
    required this.nameVi,
    this.code,
    this.descriptionVi,
    this.discount,
    this.paymentMethod,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nameVi': nameVi,
      'type': type,
    };

    if (defaultPrice != null && defaultPrice!.isNotEmpty) {
      map['defaultPrice'] = defaultPrice;
    }
    if (code != null && code!.isNotEmpty) {
      map['code'] = code;
    }
    if (descriptionVi != null && descriptionVi!.isNotEmpty) {
      map['descriptionVi'] = descriptionVi;
    }
    if (discount != null) {
      map['discount'] = discount;
    }
    if (paymentMethod != null && paymentMethod!.isNotEmpty) {
      map['paymentMethod'] = paymentMethod;
    }

    return map;
  }

  String toJson() {
    return toMap().toString();
  }

  @override
  String toString() {
    return 'CreateCustomerGroupInput(defaultPrice: $defaultPrice, nameVi: $nameVi, code: $code, descriptionVi: $descriptionVi, discount: $discount, paymentMethod: $paymentMethod, type: $type)';
  }
}
