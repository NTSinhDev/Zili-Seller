enum ShippingFeeType { free, fee, config }

enum PaymentStatus {
  pending,
  completed,
  unpaid,
  newRequest,
  failed,
  waitingConfirmAdmin,
  paid,
  cancelled,
  expired,
  waitingPayment,
  waitingConfirm,
}

enum OrderPaymentStatus { unpaid, partiallyPaid, fullyPaid }
