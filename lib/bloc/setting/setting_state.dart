part of 'setting_cubit.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class LoadingSettingState extends SettingState {}

class LoadedSettingState extends SettingState {}

class ErrorSettingState<T> extends SettingState {
  final T? error;
  const ErrorSettingState({this.error});
}
