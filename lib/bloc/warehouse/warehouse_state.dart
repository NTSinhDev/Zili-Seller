import 'package:equatable/equatable.dart';

import '../base_cubit.dart';

abstract class WarehouseState extends Equatable {
  const WarehouseState({this.event});
  final BaseEvent? event;

  @override
  List<Object?> get props => [];
}

class WarehouseInitial extends WarehouseState {}

class WarehouseLoading extends WarehouseState {
  final bool isLoadMore;
  const WarehouseLoading({this.isLoadMore = false, super.event});

  @override
  List<Object?> get props => [isLoadMore];
}

class WarehouseLoaded extends WarehouseState {
  final List<dynamic>? items;
  final int? total;
  final String? type; // 'green_bean' | 'roasting_slip'
  const WarehouseLoaded({this.items, this.total, this.type, super.event});

  @override
  List<Object?> get props => [items, total, type];
}

class WarehouseSucceed extends WarehouseState {}

class ExportWarehouseSucceed extends WarehouseSucceed {}

class CancelWarehouseSucceed extends WarehouseSucceed {}

class CompleteWarehouseSucceed extends WarehouseSucceed {}

class WarehouseFailed extends WarehouseState {}

class ExportWarehouseFailed extends WarehouseFailed {}

class CancelWarehouseFailed extends WarehouseFailed {}

class CompleteWarehouseFailed extends WarehouseFailed {}

class WarehouseError<T> extends WarehouseState {
  final T? error;
  const WarehouseError([this.error]);

  @override
  List<Object?> get props => [error];
}
