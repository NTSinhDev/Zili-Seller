import 'package:equatable/equatable.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';

enum PackingSlipAction {
  fetchCommodity,
  exportWarehouse,
  exportPackage,
  completePacking,
}

abstract class PackingSlipState extends Equatable {
  final PackingSlipAction action;
  const PackingSlipState({required this.action});

  @override
  List<Object?> get props => [action];
}

class PackingSlipInitial extends PackingSlipState {
  const PackingSlipInitial() : super(action: PackingSlipAction.exportWarehouse);
}

class PackingSlipLoading extends PackingSlipState {
  const PackingSlipLoading({required super.action});
}

class PackingSlipSuccess<T> extends PackingSlipState {
  final T data;
  const PackingSlipSuccess({
    required this.data,
    required super.action,
  });

  @override
  List<Object?> get props => [data, action];
}

class PackingSlipFailure extends PackingSlipState {
  final ResponseFailedState error;
  const PackingSlipFailure({
    required this.error,
    required super.action,
  });

  @override
  List<Object?> get props => [error, action];
}
