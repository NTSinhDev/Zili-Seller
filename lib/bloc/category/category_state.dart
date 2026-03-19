part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class GotCategoriesState extends CategoryState {}

class GettingProductsState extends CategoryState {}

class GotProductsState extends CategoryState {}

class FailedGetProductsState extends CategoryState {}
