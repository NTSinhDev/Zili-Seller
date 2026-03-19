// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'branch_cubit.dart';

abstract class BranchState extends Equatable {
  const BranchState({this.event = ""});
  final String event;

  @override
  List<Object?> get props => [];
}

class BranchInitial extends BranchState {}

class LoadingBranchState extends BranchState {
  const LoadingBranchState({super.event = ""});
}

class LoadedBranchState extends BranchState {
  const LoadedBranchState({super.event = ""});
}

class FailedLoadBranchState<T> extends BranchState {
  final ResponseFailedState? response;
  final T? error;
  const FailedLoadBranchState({this.error, this.response, super.event = ""});

  @override
  List<Object?> get props => [error, response];
}
