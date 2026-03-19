import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';

class ValueCubit<T> extends BaseCubit<BaseValueChangedState<T>> {
  ValueCubit._internal(this._value)
      : super(ValueChangedInitializeState(_value));

  factory ValueCubit.value(T value) {
    return ValueCubit._internal(value);
  }

  late T _value;

  set value(T newValue) {
    _value = newValue;
    emit(ValueChangedState(_value));
  }

  T get value => _value;
}

abstract class BaseValueChangedState<T> extends Equatable {
  const BaseValueChangedState(this.value);

  final T value;

  @override
  List<Object?> get props => [];
}

class ValueChangedInitializeState<T> extends BaseValueChangedState<T> {
  const ValueChangedInitializeState(super.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'ValueChangedInitializeState { crUser: $value }';
}

class ValueChangedState<T> extends BaseValueChangedState<T> {
  const ValueChangedState(super.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'ValueChangedState { crUser: $value }';
}
