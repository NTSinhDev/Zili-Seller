import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/models/product/purchase_order_product.dart';
import 'package:zili_coffee/data/models/product/company_product.dart';
import 'package:zili_coffee/data/models/product/product_warehouse_inventory.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';

class ProductMiddleware extends BaseMiddleware {
  Future<ResponseState> getProductCartByID({required String id}) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.product.byID(id),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: Product.fromMap(resultData.data),
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> getDetailProduct({required String slug}) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.product.detail(slug: slug),
        cancelToken: cancelToken,
      );
      final result = response.data;

      // Check result statement is error
      if (result is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(result);
      }
      if (result is! NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseFailedState.unknownError();
      }

      final Product product = Product.fromMap(result.data["product"]);
      product.detail!.medias.sort((a, b) => a.position!.compareTo(b.position!));
      return ResponseSuccessState(
        statusCode: response.statusCode ?? -1,
        responseData: product,
      );
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> getProducts({
    int? priceFrom,
    int? priceTo,
    int? from,
    int? to,
    String? filter,
    String? style,
    String? type,
    String? brand,
  }) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.product.search,
        queryParameters: {
          productConstant.priceFrom: priceFrom ?? 0,
          productConstant.priceTo: priceTo,
          productConstant.from: from ?? 0,
          productConstant.to: to ?? 8,
          productConstant.filter: filter,
          productConstant.style: style,
          productConstant.type: type,
          productConstant.brand: brand ?? productConstant.ziliCoffee,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final listMap = resultData.data["products"] as List<dynamic>;
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: listMap
              .map((dataMap) => Product.fromMap(dataMap))
              .toList(),
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> filterProducts({
    int? priceFrom,
    int? priceTo,
    int? from,
    int? to,
    String? filter,
    String? style,
    String? type,
    String? brand,
  }) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.product.search,
        queryParameters: {
          productConstant.priceFrom: priceFrom ?? 0,
          productConstant.priceTo: priceTo,
          productConstant.from: from ?? 0,
          productConstant.to: to ?? 8,
          productConstant.filter: filter,
          productConstant.style: style,
          productConstant.type: type,
          productConstant.brand: brand ?? productConstant.ziliCoffee,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final listMap = resultData.data["products"] as List<dynamic>;
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: {
            "products": listMap
                .map((dataMap) => Product.fromMap(dataMap))
                .toList(),
            "totalRecords": resultData.data["totalRecords"],
          },
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Filter purchase-order products
  ///
  /// API: GET /company/product/purchase-order/filter
  /// Service: Core
  ///
  /// Query params:
  /// - limit (default 10)
  /// - offset (default 0)
  /// - branchId (required)
  /// - categoryCodes[] (optional, list)
  ///
  /// Returns:
  /// - ResponseSuccessState<PurchaseOrderProductsResult> on success
  /// - ResponseFailedState on error
  Future<ResponseState> filterPurchaseOrderProducts({
    String? branchId,
    String? keyword,
    int limit = 10,
    int offset = 0,
    String? status,
    bool? isAvailable,
    List<String>? categoryCodes,
    List<String>? variantsId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'limit': limit,
        'offset': offset,
        if (status != null && status.isNotEmpty) 'status': status,
        if (branchId != null && branchId.isNotEmpty) 'branchId': branchId,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        if (isAvailable != null) 'isAvailable': isAvailable,
        if (categoryCodes != null && categoryCodes.isNotEmpty)
          'categoryCodes[]': categoryCodes,
        if (variantsId != null && variantsId.isNotEmpty)
          'variantsId[]': variantsId,
      };

      final response = await coreDio.get<NWResponse>(
        NetworkUrl.purchaseOrderProduct.filter,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<dynamic> itemsRaw = [];
        int total = 0;

        if (data is Map<String, dynamic>) {
          final dynamic rawItems =
              data['listData'] ??
              data['items'] ??
              data['products'] ??
              data['data'];
          if (rawItems is List) {
            itemsRaw = rawItems;
          } else if (rawItems is Map<String, dynamic>) {
            itemsRaw = [rawItems];
          }
          final totalValue =
              data['total'] ?? data['count'] ?? data['totalRecords'];
          total = totalValue is int
              ? totalValue
              : int.tryParse(totalValue?.toString() ?? '') ?? itemsRaw.length;
        } else if (data is List) {
          itemsRaw = data;
          total = data.length;
        }

        final items = itemsRaw
            .whereType<Map<String, dynamic>>()
            .map(PurchaseOrderProduct.fromMap)
            .toList();

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: PurchaseOrderProductsResult(items: items, total: total),
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get green bean default detail by id
  ///
  /// API: GET /coffee-variant/green-bean/default/{id}
  /// Service: Core
  ///
  /// Returns:
  /// - ResponseSuccessState<ProductVariant> on success
  /// - ResponseFailedState on error
  Future<ResponseState> getGreenBeanDefault({required String id}) async {
    try {
      final response = await coreDio.get<NWResponse>(
        NetworkUrl.greenBean.defaultById(id),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        Map<String, dynamic>? map;
        if (data is Map<String, dynamic>) {
          map = data['data'] is Map<String, dynamic>
              ? data['data'] as Map<String, dynamic>
              : data;
        }
        if (map != null) {
          if (map["message"] != null) {
            return ResponseSuccessState<ProductVariant?>(
              statusCode: response.statusCode ?? -1,
              responseData: null,
            );
          }

          return ResponseSuccessState<ProductVariant?>(
            statusCode: response.statusCode ?? -1,
            responseData: ProductVariant.fromMap(map),
          );
        }
        return ResponseFailedState.unknownError();
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Create roasting slip
  ///
  /// API: POST /coffee-variant/roasting-slip/create
  /// Service: Core
  ///
  /// Body:
  /// - weight (double)
  /// - variantId
  /// - variantGreenBeanId
  /// - warehouseImportId
  /// - warehouseId
  Future<ResponseState> createRoastingSlip({
    required double weight,
    required String variantId,
    required String variantGreenBeanId,
    required String warehouseImportId,
    required String warehouseId,
  }) async {
    try {
      final response = await coreDio.post<NWResponse>(
        '/coffee-variant/roasting-slip/create',
        data: {
          'weight': weight,
          'variantId': variantId,
          'variantGreenBeanId': variantGreenBeanId,
          'warehouseImportId': warehouseImportId,
          'warehouseId': warehouseId,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data,
        );
      }
      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }
      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get products by company
  ///
  /// API: GET /product/get-by-company
  /// Service: Core
  ///
  /// Query params:
  /// - limit (default 20)
  /// - offset (default 0)
  ///
  /// Returns:
  /// - ResponseSuccessState<CompanyProductsResult> on success
  /// - ResponseFailedState on error
  Future<ResponseState> getProductsByCompany({
    int limit = 20,
    int offset = 0,
    String? keyword,
    String? status,
    String? createdAtFrom,
    String? createdAtTo,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        NetworkUrl.product.getByCompany,
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (createdAtFrom != null && createdAtFrom.isNotEmpty) 'createdAtFrom': createdAtFrom,
          if (createdAtTo != null && createdAtTo.isNotEmpty) 'createdAtTo': createdAtTo,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<dynamic> itemsRaw = [];
        int total = 0;

        if (data is Map<String, dynamic>) {
          // Response có key "products" chứa list sản phẩm
          final dynamic rawItems = data['products'];
          if (rawItems is List) {
            itemsRaw = rawItems;
          } else if (rawItems is Map<String, dynamic>) {
            itemsRaw = [rawItems];
          }

          // Response có "count" hoặc "totalProducts" cho tổng số
          final totalValue =
              data['count'] ?? data['totalProducts'] ?? data['total'];
          total = totalValue is int
              ? totalValue
              : int.tryParse(totalValue?.toString() ?? '') ?? itemsRaw.length;
        } else if (data is List) {
          itemsRaw = data;
          total = data.length;
        }

        final items = itemsRaw
            .whereType<Map<String, dynamic>>()
            .map(CompanyProduct.fromMap)
            .toList();

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: CompanyProductsResult(items: items, total: total),
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  /// Get company product detail by ID
  ///
  /// API: GET /company/product/detail/{productId}
  /// Service: Core
  ///
  /// Parameters:
  /// - productId: Product ID
  ///
  /// Returns:
  /// - ResponseSuccessState<CompanyProduct> on success
  /// - ResponseFailedState on error
  Future<ResponseState> getCompanyProductDetail({
    required String productId,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        NetworkUrl.product.companyProductDetail(productId),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;

        // Response có key "data" chứa product information
        Map<String, dynamic>? productMap;
        if (data is Map<String, dynamic>) {
          if (data['data'] != null && data['data'] is Map<String, dynamic>) {
            productMap = data['data'] as Map<String, dynamic>;
          } else {
            productMap = data;
          }
        }

        if (productMap != null) {
          final product = CompanyProduct.fromMap(productMap);
          return ResponseSuccessState(
            statusCode: response.statusCode ?? -1,
            responseData: product,
          );
        }

        return ResponseFailedState.unknownError();
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
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
  /// Returns:
  /// - ResponseSuccessState<ProductWarehouseInventoryResult> on success
  /// - ResponseFailedState on error
  Future<ResponseState> getProductWarehouseInventory({
    required String productId,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        '/company/product/warehouse/$productId',
        queryParameters: {'limit': limit, 'offset': offset},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;

        // Parse response structure
        // Expected: { "listData": [...], "total": number } or { "data": [...], "total": number }
        List<dynamic> itemsRaw = [];
        int total = 0;

        if (data is Map<String, dynamic>) {
          // Try different possible keys
          if (data['listData'] != null && data['listData'] is List) {
            itemsRaw = data['listData'] as List;
          } else if (data['data'] != null && data['data'] is List) {
            itemsRaw = data['data'] as List;
          } else if (data['items'] != null && data['items'] is List) {
            itemsRaw = data['items'] as List;
          }

          total =
              (data['total'] as num?)?.toInt() ??
              (data['totalRecord'] as num?)?.toInt() ??
              itemsRaw.length;
        } else if (data is List) {
          itemsRaw = data;
          total = data.length;
        }

        final items = itemsRaw
            .whereType<Map<String, dynamic>>()
            .map(ProductWarehouseInventory.fromMap)
            .toList();

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: ProductWarehouseInventoryResult(
            items: items,
            total: total,
          ),
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }
}
