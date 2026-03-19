import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/order/payment_detail/seller_payment_method.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

import '../models/order/payment_detail/bank_info.dart';

class PaymentRepository extends BaseRepository {
  final BehaviorSubject<List<SellerPaymentMethod>> paymentMethods =
      BehaviorSubject();
  List<SellerPaymentMethod> get paymentMethodsValue =>
      paymentMethods.valueOrNull ?? [];

  final BehaviorSubject<List<BankInfo>> bankingMethods =
      BehaviorSubject();

  @override
  Future<void> clean() async {
    paymentMethods.drain(null);
    paymentMethods.sink.add([]);
  }
}
