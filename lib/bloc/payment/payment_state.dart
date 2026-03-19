part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoadingState extends PaymentState {
  const PaymentLoadingState();
}

class PaymentLoadedState extends PaymentState {
  const PaymentLoadedState();
}

class PaymentErrorState extends PaymentState {
  final String errorMessage;
  const PaymentErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

