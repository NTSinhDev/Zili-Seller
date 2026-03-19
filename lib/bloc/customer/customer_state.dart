// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'customer_cubit.dart';

abstract class CustomerState extends Equatable {
  const CustomerState({this.event = ""});
  final String event;

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class WaitingCustomerState extends CustomerState {}

class MessageCustomerState extends CustomerState {
  final String message;
  const MessageCustomerState({required this.message});
}

class FailedCustomerState<T> extends CustomerState {
  final T? error;
  const FailedCustomerState({this.error});
}

class CustomerFilterLoadedState extends CustomerState {
  final int count;
  final List<Customer> customers;
  const CustomerFilterLoadedState({
    required this.count,
    required this.customers,
  });

  @override
  List<Object> get props => [count, customers];
}

class LoadingCustomerState extends CustomerState {
  const LoadingCustomerState({super.event = ""});
}

class LoadedCustomerState<T> extends CustomerState {
  final T? data;
  const LoadedCustomerState({this.data});
}

class ErrorCustomerState<T> extends CustomerState {
  const ErrorCustomerState({this.error});
  final T? error;
}
