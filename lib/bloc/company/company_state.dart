// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'company_cubit.dart';

abstract class CompanyState extends Equatable {
  const CompanyState({this.event = ""});
  final String event;

  @override
  List<Object> get props => [];
}

class CompanyInitial extends CompanyState {}

class LoadingCompanyState extends CompanyState {
  const LoadingCompanyState({super.event = ""});
}

class LoadedCompanyState extends CompanyState {}

class MessageCompanyState extends CompanyState {
  final String message;
  const MessageCompanyState({required this.message});

  @override
  List<Object> get props => [message];
}

class FailedCompanyState extends CompanyState {
  final ResponseFailedState error;
  const FailedCompanyState({required this.error});

  @override
  List<Object> get props => [error];
}
