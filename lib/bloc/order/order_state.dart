part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState({this.event = ""});
  final String? event;
  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class CreatingOrderState extends OrderState {}

class CreatedOrderState extends OrderState {}

class CreateFailedOrderState extends OrderState {
  const CreateFailedOrderState(this.error);
  final ResponseFailedState error;
}

class UpdatingOrderState extends OrderState {}

class UpdatedOrderState extends OrderState {}

class UpdateFailedOrderState extends OrderState {
  const UpdateFailedOrderState(this.error);
  final ResponseFailedState error;
}

class OnlinePaymentState extends OrderState {
  final String url;
  const OnlinePaymentState({required this.url});
}

class OrderLoadingState extends OrderState {
  const OrderLoadingState({super.event = ""});
}

class OrderLoadedState extends OrderState {}

class OrderErrorState<T> extends OrderState {
  final T? detail;
  final dynamic error;
  const OrderErrorState({this.detail, this.error});
}

class LoadingOrderState extends OrderState {}

class LoadedOrderState<T> extends OrderState {
  final T? data;
  const LoadedOrderState({this.data});
}

class ErrorOrderState<T> extends OrderState {
  final T? detail;
  final dynamic error;
  const ErrorOrderState({this.detail, this.error});
}

class SelectDeliveryMethodState extends OrderState {}

class ValidateOrderState extends OrderState {}

class InvalidOrderState extends OrderState {
  final String message;
  const InvalidOrderState({required this.message});
}
