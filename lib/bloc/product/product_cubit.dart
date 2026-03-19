import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';

import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/models/product/company_product.dart';
import 'package:zili_coffee/data/models/product/product_warehouse_inventory.dart';
// import 'package:zili_coffee/data/models/product/product_options.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

import '../../data/models/product/product_variant.dart';
import '../../data/models/product/purchase_order_product.dart';
import '../../utils/enums.dart';
import '../../utils/enums/product_enum.dart';

part 'product_state.dart';

class ProductCubit extends BaseCubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final AppMiddleware _appMiddleware = di<AppMiddleware>();
  final ProductMiddleware _productMiddleware = di<ProductMiddleware>();
  final WarehouseMiddleware _warehouseMiddleware = di<WarehouseMiddleware>();
  final ProductRepository _productRepository = di<ProductRepository>();

  void changeState({required ProductState state}) => emit(state);

  Future getDetailProduct({required Product prod}) async {
    final result = await _productMiddleware.getDetailProduct(slug: prod.slug);
    if (result is ResponseSuccessState<Product>) {
      Product product = result.responseData;

      // Check avaiable product variant to set default data for product option
      for (var variant in product.detail!.variants) {
        if (int.parse(variant.availableQuantity) < 1) continue;
        product = product.copyWith(
          detail: product.detail!.copyWith(
            productOptions: product.detail!.productOptions.copyWith(
              option1: variant.options.first.value,
              option2: variant.options.first.value,
              option3: variant.options.last.value,
            ),
          ),
        );
        break;
      }

      // Set default data for product option
      _productRepository.setProductStreamData(product);
      _productRepository.setVariantStreamData();
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getDetailProduct method',
        error: result.errorMessage,
        name: 'ProductCubit',
      );
    }
  }

  Future getFeaturedProduct() async {
    _productRepository.featuredProducts = [];
    emit(GotProductsState());
  }

  Future getProductsScreenData() async {
    _productRepository.productsScreenStreamData.sink.add({});
  }

  Future<void> filterPurchaseOrderProducts({
    required String branchId,
    bool? isAvailable,
    int limit = 10,
    int offset = 0,
    List<CoffeeVariantType> categoryCodes = const [],
    variantId = const <String>[],
    String? keyword,
  }) async {
    final result = await _productMiddleware.filterPurchaseOrderProducts(
      branchId: branchId,
      limit: limit,
      offset: offset,
      categoryCodes: categoryCodes.map((e) => e.toConstant).toList(),
      keyword: keyword,
      isAvailable: isAvailable,
      variantsId: variantId,
    );

    if (result is ResponseSuccessState<PurchaseOrderProductsResult>) {
      final products = result.responseData;
      _productRepository.purchaseOrderProductSubject.sink.add(products);
    }
  }

  Future<void> loadMorePurchaseOrderProducts({
    required String branchId,
    bool? isAvailable,
    int limit = 10,
    int offset = 0,
    List<CoffeeVariantType> categoryCodes = const [],
    variantId = const <String>[],
    String? keyword,
  }) async {
    final result = await _productMiddleware.filterPurchaseOrderProducts(
      branchId: branchId,
      limit: limit,
      offset: offset,
      categoryCodes: categoryCodes.map((e) => e.toConstant).toList(),
      keyword: keyword,
      isAvailable: isAvailable,
      variantsId: variantId,
    );

    if (result is ResponseSuccessState<PurchaseOrderProductsResult>) {
      final products = result.responseData;
      _productRepository.appendPurchaseOrderProducts(products);
    }
  }

  Future<void> filterRoastedBeans({
    required String branchId,
    int limit = 10,
    int offset = 0,
  }) async {
    final result = await _productMiddleware.filterPurchaseOrderProducts(
      branchId: branchId,
      limit: limit,
      offset: offset,
      categoryCodes: [CoffeeVariantType.commodity.toConstant],
    );

    if (result is ResponseSuccessState<PurchaseOrderProductsResult>) {
      final products = result.responseData;
      _productRepository.purchaseOrderProductSubject.sink.add(products);
    }
  }

  Future<void> filterMaterialVariants({
    String? keyword,
    int limit = 10,
    int offset = 0,
  }) async {
    final result = await _productMiddleware.filterPurchaseOrderProducts(
      keyword: keyword,
      limit: limit,
      offset: offset,
      status: 'APPROVED',
      categoryCodes: [CoffeeVariantType.commodity.toConstant],
    );

    if (result is ResponseSuccessState<PurchaseOrderProductsResult>) {
      final products = result.responseData;
      _productRepository.purchaseOrderProductSubject.sink.add(products);
    }
  }

  Future<void> loadMoreMaterialVariants({
    String? keyword,
    int limit = 10,
    int offset = 0,
  }) async {
    final result = await _productMiddleware.filterPurchaseOrderProducts(
      keyword: keyword,
      limit: limit,
      offset: offset,
      status: 'APPROVED',
      categoryCodes: [CoffeeVariantType.commodity.toConstant],
    );

    if (result is ResponseSuccessState<PurchaseOrderProductsResult>) {
      final data = result.responseData;
      _productRepository.appendPurchaseOrderProducts(data);
    }
  }

  Future<void> filterPackageVariants({
    String? keyword,
    int limit = 10,
    int offset = 0,
  }) async {
    final result = await _productMiddleware.filterPurchaseOrderProducts(
      keyword: keyword,
      limit: limit,
      offset: offset,
      status: 'APPROVED',
      categoryCodes: [CoffeeVariantType.packaging.toConstant],
    );

    if (result is ResponseSuccessState<PurchaseOrderProductsResult>) {
      final products = result.responseData;
      _productRepository.purchaseOrderProductSubject.sink.add(products);
    }
  }

  Future<void> loadMorePackageVariants({
    String? keyword,
    int limit = 10,
    int offset = 0,
  }) async {
    final result = await _productMiddleware.filterPurchaseOrderProducts(
      keyword: keyword,
      limit: limit,
      offset: offset,
      status: 'APPROVED',
      categoryCodes: [CoffeeVariantType.packaging.toConstant],
    );

    if (result is ResponseSuccessState<PurchaseOrderProductsResult>) {
      final data = result.responseData;
      _productRepository.appendPurchaseOrderProducts(data);
    }
  }

  /// Get products by company
  ///
  /// API: GET /product/get-by-company
  /// Service: Core
  ///
  /// Parameters:
  /// - limit: Number of items per page (default: 20)
  /// - offset: Pagination offset (default: 0)
  ///
  /// States:
  /// - ProductInitial: Initial
  /// - GotProductsState: Success
  Future<void> getProducts({
    int limit = 20,
    int offset = 0,
    String? keyword,
    String? event,
    String? status,
    String? createdAtFrom,
    String? createdAtTo,
  }) async {
    emit(ProductLoadingState(event: event));
    final result = await _productMiddleware.getProductsByCompany(
      limit: limit,
      offset: offset,
      keyword: keyword,
      status: status,
      createdAtFrom: createdAtFrom,
      createdAtTo: createdAtTo,
    );

    if (result is ResponseSuccessState<CompanyProductsResult>) {
      final products = result.responseData;
      _productRepository.setProductsByCompany(products.items, products.total);
      emit(ProductLoadedState());
    } else if (result is ResponseFailedState) {
      log(
        'Error when call getProducts method',
        error: result.errorMessage,
        name: 'ProductCubit',
      );
      emit(ProductErrorState(error: result.errorMessage));
    }
  }

  /// Load more products by company (pagination)
  ///
  /// API: GET /product/get-by-company
  /// Service: Core
  ///
  /// Parameters:
  /// - limit: Number of items per page (default: 20)
  ///
  /// States:
  /// - ProductInitial: Initial
  /// - GotProductsState: Success
  Future<void> loadMoreProducts({
    int limit = 20,
    int offset = 0,
    String? keyword,
  }) async {
    final result = await _productMiddleware.getProductsByCompany(
      limit: limit,
      offset: offset,
      keyword: keyword,
    );

    if (result is ResponseSuccessState<CompanyProductsResult>) {
      final products = result.responseData;
      _productRepository.appendProductsByCompany(
        products.items,
        products.total,
      );
      emit(GotProductsState());
    } else if (result is ResponseFailedState) {
      log(
        'Error when call loadMoreProducts method',
        error: result.errorMessage,
        name: 'ProductCubit',
      );
    }
  }

  /// Fetch company product detail by ID
  ///
  /// API: GET /company/product/detail/{productId}
  /// Service: Core
  ///
  /// Parameters:
  /// - productId: Product ID
  ///
  /// States:
  /// - ProductInitial: Initial
  /// - GotProductsState: Success
  Future<void> fetchCompanyProductDetail({required String productId}) async {
    emit(ProductInitial());
    final result = await _productMiddleware.getCompanyProductDetail(
      productId: productId,
    );

    if (result is ResponseSuccessState<CompanyProduct>) {
      final product = result.responseData;
      _productRepository.companyProductDetailStreamData.sink.add(product);
      emit(GotProductsState());
    } else if (result is ResponseFailedState) {
      log(
        'Error when call fetchCompanyProductDetail method',
        error: result.errorMessage,
        name: 'ProductCubit',
      );
      _productRepository.companyProductDetailStreamData.sink.add(null);
    }
  }

  /// Get product warehouse inventory
  ///
  /// API: GET /company/product/warehouse/{productId}
  /// Service: Core
  ///
  /// Parameters:
  /// - productId: Product ID
  /// - limit: Number of items per page (default: 20)
  /// - offset: Pagination offset (default: 0)
  ///
  /// States:
  /// - ProductInitial: Initial
  /// - GotProductsState: Success
  Future<void> getProductWarehouseInventory({required String productId}) async {
    final result = await _productMiddleware.getProductWarehouseInventory(
      productId: productId,
    );

    if (result is ResponseSuccessState<ProductWarehouseInventoryResult>) {
      final inventory = result.responseData;
      _productRepository.setProductWarehouseInventory(inventory);
    }
  }

  Future<void> getRawProducts({
    required int type,
    int limit = 20,
    int offset = 0,
    String? keyword,
    String? event,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    emit(ProductLoadingState(event: event));

    ResponseState? result;
    switch (type) {
      case 0:
        result = await _warehouseMiddleware.filterWarehouseVariants(
          limit: limit,
          offset: offset,
          keyword: keyword,
          createdAtFrom: createdAtFrom,
          createdAtTo: createdAtTo,
        );
        break;
      case 1:
        result = await _warehouseMiddleware.filterRoastedBeans(
          limit: limit,
          offset: offset,
          keyword: keyword,
          createdAtFrom: createdAtFrom,
          createdAtTo: createdAtTo,
        );
        break;
      case 2:
        result = await _warehouseMiddleware.filterVariantSpecial(
          limit: limit,
          offset: offset,
          keyword: keyword,

          createdAtFrom: createdAtFrom,
          createdAtTo: createdAtTo,
        );
        break;
      default:
        result = null;
        break;
    }

    if (result is ResponseSuccessListState<List<ProductVariant>>) {
      _productRepository.productsSubject.sink.add(result.responseData);
      _productRepository.totalProducts = result.total;
      emit(ProductLoadedState());
    } else {
      _productRepository.productsSubject.sink.add([]);
      _productRepository.totalProducts = 0;
      emit(ProductErrorState());
    }
  }

  Future<void> loadMoreRawProducts({
    required int type,
    int limit = 20,
    int offset = 0,
    String? keyword,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
  }) async {
    ResponseState? result;
    switch (type) {
      case 0:
        result = await _warehouseMiddleware.filterWarehouseVariants(
          limit: limit,
          offset: offset,
          keyword: keyword,
          createdAtFrom: createdAtFrom,
          createdAtTo: createdAtTo,
        );
        break;
      case 1:
        result = await _warehouseMiddleware.filterRoastedBeans(
          limit: limit,
          offset: offset,
          keyword: keyword,
          createdAtFrom: createdAtFrom,
          createdAtTo: createdAtTo,
        );
        break;
      case 2:
        result = await _warehouseMiddleware.filterVariantSpecial(
          limit: limit,
          offset: offset,
          keyword: keyword,

          createdAtFrom: createdAtFrom,
          createdAtTo: createdAtTo,
        );
        break;
      default:
        result = null;
        break;
    }

    if (result is ResponseSuccessListState<List<ProductVariant>>) {
      final current = _productRepository.productsSubject.valueOrNull ?? [];
      _productRepository.productsSubject.sink.add([
        ...current,
        ...result.responseData,
      ]);
      _productRepository.totalProducts = result.total;
      emit(ProductLoadedState());
    } else {
      _productRepository.productsSubject.sink.add([]);
      _productRepository.totalProducts = 0;
      emit(ProductErrorState());
    }
  }
}
