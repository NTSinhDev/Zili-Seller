import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/address_middleware.dart';
import 'package:zili_coffee/data/middlewares/payment_middleware.dart';
import 'package:zili_coffee/data/middlewares/product_middleware.dart';
import 'package:zili_coffee/data/models/cart/deliver_price.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/models/order/order_export.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/cart_repository.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
part 'cart_state.dart';

class CartCubit extends BaseCubit<CartState> {
  CartCubit() : super(CartInitial());
  final CartRepository _cartRepository = di<CartRepository>();
  final ProductRepository _productRepository = di<ProductRepository>();
  final ProductMiddleware _productMiddleware = di<ProductMiddleware>();
  final AddressMiddleware _addressMiddleware = di<AddressMiddleware>();
  final PaymentMiddleware _paymentMiddleware = di<PaymentMiddleware>();

  Future getDetailProduct(ProductCart productCart) async {
    final result =
        await _productMiddleware.getDetailProduct(slug: productCart.slug!);
    if (result is ResponseSuccessState<Product>) {
      _productRepository.productDetailStreamData.sink.add(result.responseData);
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getPaymentMethod method',
        error: result.errorMessage,
        name: 'CartCubit',
      );
    } 
  }

  Future getPaymentMethod() async {
    final result = await _paymentMiddleware.getPaymentMethods();
    if (result is ResponseSuccessState<List<PaymentMethod>>) {
      _cartRepository.paymenMethods = result.responseData;
      return;
    }
    if (result is ResponseFailedState) {
      log(
        'Error when call getPaymentMethod method',
        error: result.errorMessage,
        name: 'CartCubit',
      );
    }
  }

  Future getProductInformation(ProductCart product) async {
    emit(CheckingCartState());
    final result = await _productMiddleware.getProductCartByID(
      id: product.productID!,
    );
    if (result is ResponseSuccessState<Product>) {
      ProductCart productCart = product.copyWith(
        img: result.responseData.imageBaseUrl,
        name: result.responseData.nameDisplay,
        price: result.responseData.price,
        pricePromotion: result.responseData.promotionPrice,
        slug: result.responseData.slug,
      );
      _cartRepository.updateInfoProductCart(productCart);
      final variants = await _getProductVariant(result.responseData);
      productCart = _checkProductVariant(productCart, variants);
      _cartRepository.updateInfoProductCart(productCart);
      emit(CheckedCartState());
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getProductInformation method',
        error: result.toString(),
        name: 'CartCubit',
      );
      emit(FailedCheckCartState());
    }
  }

  ProductCart _checkProductVariant(
    ProductCart product,
    List<ProductVariant> variants,
  ) {
    if (variants.length == 1) return product.copyWith(isAvaiable: true);
    ProductVariant checkVariant = variants.first;
    for (var variant in variants) {
      if (checkVariant == variant && int.parse(variant.availableQuantity) > 0) {
        return product.copyWith(isAvaiable: true);
      }
    }

    return product.copyWith(isAvaiable: false);
  }

  Future<List<ProductVariant>> _getProductVariant(Product product) async {
    final result = await _productMiddleware.getDetailProduct(
      slug: product.slug,
    );
    if (result is ResponseSuccessState<Product>) {
      return result.responseData.detail!.variants;
    }

    log(
      'Error when call getProductVariant method',
      error: result.toString(),
      name: 'CartCubit',
    );
    return [];
  }

  Future getDeliverPrice(String provinceID, String districtID) async {
    final result = await _addressMiddleware.getDeliverPriceByLocation(
      provinceID: provinceID,
      districtID: districtID,
    );
    if (result is ResponseSuccessState<DeliverPrice>) {
      _cartRepository.behaviorDeliverPrice.sink.add(result.responseData);
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getDetailProduct method',
        error: result.errorMessage,
        name: 'CartCubit',
      );
    }
  }

  void updateQty(ProductCart productCart, int qty) {
    final newProd = productCart.copyWith(qty: qty);
    _cartRepository.updateQty(newProd);
  }
}
