class Discount {
  final int id;
  final dynamic discountId;
  final int position;
  final String source;
  final dynamic rate;
  final int value;
  final dynamic amount;
  final String reason;
  final dynamic promotionRedemptionId;
  final dynamic promotionConditionItemId;
  final String lineItemId;
  final String status;
  final dynamic promotionId;

  Discount({
    required this.id,
    required this.discountId,
    required this.position,
    required this.source,
    required this.rate,
    required this.value,
    required this.amount,
    required this.reason,
    required this.promotionRedemptionId,
    required this.promotionConditionItemId,
    required this.lineItemId,
    required this.status,
    required this.promotionId,
  });

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map[_Constant.id] as int,
      discountId: map[_Constant.discountId] as dynamic,
      position: map[_Constant.position] as int,
      source: map[_Constant.source] as String,
      rate: map[_Constant.rate] as dynamic,
      value: map[_Constant.value] as int,
      amount: map[_Constant.amount] as dynamic,
      reason: map[_Constant.reason] as String,
      promotionRedemptionId: map[_Constant.promotionRedemptionId] as dynamic,
      promotionConditionItemId:
          map[_Constant.promotionConditionItemId] as dynamic,
      lineItemId: map[_Constant.lineItemId] as String,
      status: map[_Constant.status] as String,
      promotionId: map[_Constant.promotionId] as dynamic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _Constant.id: id,
      _Constant.discountId: discountId,
      _Constant.position: position,
      _Constant.source: source,
      _Constant.rate: rate,
      _Constant.value: value,
      _Constant.amount: amount,
      _Constant.reason: reason,
      _Constant.promotionRedemptionId: promotionRedemptionId,
      _Constant.promotionConditionItemId: promotionConditionItemId,
      _Constant.lineItemId: lineItemId,
      _Constant.status: status,
      _Constant.promotionId: promotionId,
    };
  }
}

class _Constant {
  static const String id = 'id';
  static const String discountId = 'discount_id';
  static const String position = 'position';
  static const String source = 'source';
  static const String rate = 'rate';
  static const String value = 'value';
  static const String amount = 'amount';
  static const String reason = 'reason';
  static const String promotionRedemptionId = 'promotion_redemption_id';
  static const String promotionConditionItemId = 'promotion_condition_item_id';
  static const String lineItemId = 'line_item_id';
  static const String status = 'status';
  static const String promotionId = 'promotion_id';
}
