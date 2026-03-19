// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'address_cubit.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class GettingAddressState extends AddressState {}

class GotAddressState extends AddressState {}

class GotFailedAddressState extends AddressState {
  final ResponseFailedState error;
  const GotFailedAddressState({required this.error});
}

class CreatingAddressState extends AddressState {
  final String label;
  const CreatingAddressState({required this.label});
}

class CreatedAddressState extends AddressState {
  final CustomerAddress? address;
  const CreatedAddressState({this.address});
}

class CreatedFailedAddressState extends AddressState {
  final ResponseFailedState error;
  const CreatedFailedAddressState({required this.error});
}

class DeletedFailedAddressState extends AddressState {}
