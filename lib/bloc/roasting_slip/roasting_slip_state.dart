import 'package:equatable/equatable.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';

enum RoastingSlipAction {
  fetchGreenBeanDefault,
  fetchRoastedBeanDetailsByBranch,
  create,
}

abstract class RoastingSlipState extends Equatable {
  final RoastingSlipAction action;
  const RoastingSlipState({required this.action});

  @override
  List<Object?> get props => [action];
}

class RoastingSlipInitial extends RoastingSlipState {
  const RoastingSlipInitial() : super(action: RoastingSlipAction.create);
}

class RoastingSlipLoading extends RoastingSlipState {
  const RoastingSlipLoading({required super.action});
}

class RoastingSlipSuccess<T> extends RoastingSlipState {
  final T data;
  const RoastingSlipSuccess({
    required this.data,
    required super.action,
  });

  @override
  List<Object?> get props => [data, action];
}

class RoastingSlipFailure extends RoastingSlipState {
  final ResponseFailedState error;
  const RoastingSlipFailure({
    required this.error,
    required super.action,
  });

  @override
  List<Object?> get props => [error, action];
}
