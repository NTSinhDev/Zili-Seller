class PaymentMethod {
  final int id;
  final String name;
  final String? url;
  String? paymentId;
  String? sapoName;
  String? status;
  String? tenantId;
  String? type;
  final String paymentEnum;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.url,
    this.paymentId,
    this.sapoName,
    this.status,
    this.tenantId,
    this.type,
    required this.paymentEnum,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> map) => PaymentMethod(
        id: map['id'],
        name: map['name'],
        url: map['url'],
        paymentId: map['payment_id'],
        sapoName: map['sapo_name'],
        status: map['status'],
        tenantId: map['tenant_id'],
        type: map['type'],
        paymentEnum: map[_Constant.paymentEnum] != null
            ? map[_Constant.paymentEnum] as String
            : '',
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[_Constant.methodID] = id;
    data[_Constant.methodName] = name;
    data[_Constant.paymentEnum] = paymentEnum;
    return data;
  }
}

class _Constant {
  static const String methodID = "method_id";
  static const String methodName = "method_name";
  static const String paymentEnum = "payment_enum";
}
