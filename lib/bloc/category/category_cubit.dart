import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/repositories/category_repository.dart';
import 'package:zili_coffee/data/models/category.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

part 'category_state.dart';

class CategoryCubit extends BaseCubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final CategoryMiddleware _categoryMiddleware = di<CategoryMiddleware>();
  final ProductMiddleware _productMiddleware = di<ProductMiddleware>();
  final CategoryRepository categoryRepo = di<CategoryRepository>();
  final ProductRepository productRepo = di<ProductRepository>();

  Future getAllCategories() async {
    final result = await _categoryMiddleware.getAllCategories();
    if (result is ResponseSuccessState<List<Category>>) {
      categoryRepo.categories.sink.add(result.responseData);
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getFeaturedProduct method',
        error: result.errorMessage,
        name: 'ProductCubit',
      );
    }
  }

  Future getProducts({bool loadMore = false}) async {
    int from() {
      if (productRepo.behaviorFilterProducts.hasValue) {
        return productRepo.behaviorFilterProducts.value.length ~/ 8;
      }
      return 0;
    }

    emit(GettingProductsState());
    String type = '';
    final categories = categoryRepo.behaviorSelected.hasValue
        ? categoryRepo.behaviorSelected.value
        : [];
    for (int i = 0; i < categories.length; i++) {
      if (i == 0) {
        type += categories[i].category!;
      } else {
        type += ',${categories[i].category!}';
      }
    }
    final result = await _productMiddleware.filterProducts(
      from: loadMore ? from() : null,
      type: type,
      priceFrom: categoryRepo.behaviorMinPrice.hasValue
          ? categoryRepo.behaviorMinPrice.value
          : null,
      priceTo: categoryRepo.behaviorMinPrice.hasValue
          ? categoryRepo.behaviorMaxPrice.value
          : null,
    );
    if (result is ResponseSuccessState<Map<String, dynamic>>) {
      if (loadMore && productRepo.behaviorFilterProducts.hasValue) {
        List<Product> products =
            List.from(productRepo.behaviorFilterProducts.value)
              ..addAll(result.responseData["products"]);
        productRepo.behaviorFilterProducts.sink.add(products);
      } else {
        productRepo.behaviorFilterProducts.sink.add(
          result.responseData["products"],
        );
      }
      productRepo.behaviorFilterTotalRecord.sink.add(
        result.responseData["totalRecords"],
      );
      emit(GotProductsState());
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getProducts method',
        error: result.errorMessage,
        name: 'CategoryCubit',
      );
      emit(FailedGetProductsState());
    }
  }

  Future<List<Product>> getProductsByCategory({
    required Category category,
  }) async {
    final result = await _productMiddleware.getProducts(
      type: category.category,
    );
    if (result is ResponseSuccessState<List<Product>>) {
      return result.responseData;
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getProductsByCategory method',
        error: result.errorMessage,
        name: 'CategoryCubit',
      );
    }
    return [];
  }
}
