import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/payment_middleware.dart';
import 'package:zili_coffee/data/models/order/payment_detail/seller_payment_method.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/payment_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'dart:developer';

part 'payment_state.dart';

class PaymentCubit extends BaseCubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  final PaymentRepository _paymentRepo = di<PaymentRepository>();
  final PaymentMiddleware _paymentMiddleware = di<PaymentMiddleware>();

  /// Get payment methods
  ///
  /// Parameters:
  /// - isActive: bool (optional, default: true) - Filter by active status
  /// - notMethods: List<String> (optional) - Exclude payment methods
  ///
  /// States:
  /// - PaymentLoadingState: Loading
  /// - PaymentLoadedState: Success
  /// - PaymentErrorState: Error
  Future<void> getPaymentMethods({
    bool? isActive,
    List<String>? notMethods,
  }) async {
    emit(const PaymentLoadingState());
    final result = await _paymentMiddleware.getPaymentMethods(
      isActive: isActive,
      notMethods: notMethods,
    );

    if (result is ResponseSuccessState<List<SellerPaymentMethod>>) {
      _paymentRepo.paymentMethods.sink.add(result.responseData);
      emit(const PaymentLoadedState());
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getPaymentMethods',
        error: result.errorMessage,
        name: 'PaymentCubit',
      );
      emit(PaymentErrorState(errorMessage: result.errorMessage));
    }
  }
}

