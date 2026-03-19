// ignore_for_file: public_member_api_docs, sort_constructors_first

/// DTO for creating a new customer
class CreateCustomerInput {
  final String fullName;
  final String? email;
  final String? code;
  final String phone;
  final DateTime? birthday;
  final CreateCustomerAddressInput? address;
  final String? website;
  final String? taxCode;
  final String? faxCode;
  final String? note;
  final double totalSpending;
  final double currentDebt;
  final String advancedType; // "USER" or other types
  final double discount;
  final String? paymentMethod;
  final double? defaultPrice;

  CreateCustomerInput({
    required this.fullName,
    this.email,
    this.code,
    required this.phone,
    this.birthday,
    required this.address,
    this.website,
    this.taxCode,
    this.faxCode,
    this.note,
    this.totalSpending = 0,
    this.currentDebt = 0,
    this.advancedType = 'USER',
    this.discount = 0,
    this.paymentMethod,
    this.defaultPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (code != null && code!.isNotEmpty) 'code': code,
      'phone': phone,
      if (birthday != null) 'birthday': birthday?.toIso8601String(),
      'address': address?.toMap(),
      if (website != null && website!.isNotEmpty) 'website': website,
      if (taxCode != null && taxCode!.isNotEmpty) 'taxCode': taxCode,
      if (faxCode != null && faxCode!.isNotEmpty) 'faxCode': faxCode,
      if (note != null && note!.isNotEmpty) 'note': note,
      'totalSpending': totalSpending,
      'currentDebt': currentDebt,
      'advancedType': advancedType,
      'discount': discount,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
    };
  }
}

/// Nested address input for customer creation
class CreateCustomerAddressInput {
  final bool isDefault;
  final String? address;
  final String? provinceCode;
  final String? wardCode;

  CreateCustomerAddressInput({
    required this.isDefault,
    required this.address,
    required this.provinceCode,
    required this.wardCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'isDefault': isDefault,
      'address': address,
      'provinceCode': provinceCode,
      'wardCode': wardCode,
    };
  }
}
