// ignore_for_file: non_constant_identifier_names

class TransactionStatus {
  final String vnp_TxnRef;
  final String vnp_ResponseCode;
  final String vnp_TransactionStatus;
  TransactionStatus({
    required this.vnp_TxnRef,
    required this.vnp_ResponseCode,
    required this.vnp_TransactionStatus,
  });
}
