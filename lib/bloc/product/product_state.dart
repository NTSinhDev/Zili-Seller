part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState({this.event = ""});
  final String? event;

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

// class GettingProductsState extends ProductState {}

class GotProductsState extends ProductState {}

class ProductLoadingState extends ProductState {
  const ProductLoadingState({super.event = ""});
}

class ProductLoadedState extends ProductState {}

class ProductErrorState<T> extends ProductState {
  final T? detail;
  final dynamic error;
  const ProductErrorState({this.detail, this.error});
}
