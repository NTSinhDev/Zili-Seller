part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CheckingCartState extends CartState{}
class CheckedCartState extends CartState{}
class FailedCheckCartState extends CartState{}
