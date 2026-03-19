// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/utils/enums.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitializeState extends AuthState {}

class AuthProcessingState extends AuthState {}

class AuthNotReadyState extends AuthState {}

class AuthReadyState extends AuthState {
  const AuthReadyState(this.crUser);

  final User crUser;

  @override
  List<Object?> get props => [crUser];

  @override
  String toString() => 'AuthReadyState { crUser: $crUser }';
}

class AuthFailedState extends AuthState {
  const AuthFailedState(this.error);

  final ResponseFailedState error;
}

class ForgotPasswordState extends AuthState {
  final ForgotPasswordSteps step;
  final String? message;
  const ForgotPasswordState({
    required this.step,
    this.message,
  });
}

class HasBeenChangedPasswordState extends AuthState{}
