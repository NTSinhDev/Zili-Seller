// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'role_cubit.dart';

abstract class RoleState extends Equatable {
  const RoleState({this.event = ""});
  final String event;

  @override
  List<Object> get props => [];
}

class RoleInitial extends RoleState {}

class LoadingRoleState extends RoleState {
  const LoadingRoleState({super.event = ""});
}

class LoadedRoleState extends RoleState {}

class RoleLoadedState extends RoleState {
  final Role role;
  const RoleLoadedState({required this.role});

  @override
  List<Object> get props => [role];
}

class MessageRoleState extends RoleState {
  final String message;
  const MessageRoleState({required this.message});

  @override
  List<Object> get props => [message];
}

class FailedRoleState extends RoleState {
  final ResponseFailedState error;
  const FailedRoleState({required this.error});

  @override
  List<Object> get props => [error];
}

