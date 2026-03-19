import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/constant/data_constant.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/flash_sale_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

part 'flash_sale_state.dart';

class FlashSaleCubit extends BaseCubit<FlashSaleState> {
  FlashSaleCubit() : super(FlashSaleInitial());
  final _productMiddleware = di<ProductMiddleware>();
  final FlashSaleRepository _flashSaleRepository = di<FlashSaleRepository>();

  Future getProductsSale() async {
    final result1 = await _productMiddleware.getProducts(
      style: MiddlewareConstant.product.styleValue.shockingDeal,
    );
    _checkResult(result1);
    final result2 = await _productMiddleware.getProducts(
      style: MiddlewareConstant.product.styleValue.topDiscount,
    );
    _checkResult(result2);
    final result3 = await _productMiddleware.getProducts(
      style: MiddlewareConstant.product.styleValue.discount,
    );
    _checkResult(result3);
    final result4 = await _productMiddleware.getProducts(
      style: MiddlewareConstant.product.styleValue.discount,
      from: 1,
      to: 8,
    );
    _checkResult(result4);
  }

  void _checkResult(ResponseState result) {
    List<Product> previousProducts = [];
    if (result is ResponseSuccessState<List<Product>>) {
      if (_flashSaleRepository.productStreamData.hasValue) {
        previousProducts = _flashSaleRepository.productStreamData.value;
      }
      previousProducts.addAll(result.responseData);
      _flashSaleRepository.productStreamData.sink.add(previousProducts);
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getFeaturedProduct method',
        error: result.errorMessage,
        name: 'ProductCubit',
      );
    }
  }
}
