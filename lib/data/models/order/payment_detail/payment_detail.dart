import 'payment_method.dart';

class PaymentDetail {
  final String? id;
  final String? cardType;
  final dynamic transactionStatus;
  final dynamic responseCode;
  final String? bankCode;
  final String? payUrl;
  final int? amount;
  final dynamic amountReceiver;
  final dynamic resultCode;
  final dynamic message;
  final String? methodName;
  final int? methodId;
  final String? orderId;
  final String? gatewayId;
  final String? requestId;
  final PaymentMethod paymentMethod;

  PaymentDetail({
    this.id,
    this.cardType,
    this.transactionStatus,
    this.responseCode,
    this.bankCode,
    this.payUrl,
    this.amount,
    this.amountReceiver,
    this.resultCode,
    this.message,
    this.methodName,
    this.methodId,
    this.orderId,
    this.gatewayId,
    this.requestId,
    required this.paymentMethod,
  });

  factory PaymentDetail.fromMap(Map<String, dynamic> json) => PaymentDetail(
        id: json['id'],
        cardType: json['card_type'],
        transactionStatus: json['transaction_status'],
        responseCode: json['response_code'],
        bankCode: json[_Constant.bankCode],
        payUrl: json['pay_url'],
        amount: json['amount'],
        amountReceiver: json['amount_receiver'],
        resultCode: json['result_code'],
        message: json['message'],
        methodName: json['method_name'],
        methodId: json['method_id'],
        orderId: json['order_id'],
        gatewayId: json['gateway_id'],
        requestId: json['request_id'],
        paymentMethod: PaymentMethod.fromMap(json['payment_method']),
      );

  Map<String, dynamic> toMap() => {
        // _Constant.bankCode: 'VNPAYQR',
        _Constant.bankCode: '',
        ...paymentMethod.toMap(),
      };
}

class _Constant {
  static const String bankCode = 'bank_code';
}
