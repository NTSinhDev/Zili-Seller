// Middleware Template - Copy và customize cho feature mới
// 
// Hướng dẫn sử dụng:
// 1. Copy file này và đổi tên thành [feature]_middleware.dart
// 2. Thay thế ProductVariantExample bằng Model class của bạn
// 3. Thay thế ProductVariantExampleMiddleware bằng tên Middleware của bạn
// 4. Thay thế product_variant bằng feature name trong NetworkUrl
// 5. Thay thế 'variants' bằng key trong API response (ví dụ: products, items)
// 6. Thay thế import path để trỏ đến Model của bạn

import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart'; // TODO: Thay bằng Model của bạn
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart'; // TODO: Sử dụng NetworkUrl thay vì hardcode URL

// TODO: Đổi tên class này thành [Feature]Middleware
class ProductVariantExampleMiddleware extends BaseMiddleware {
  /// [MÔ TẢ METHOD] - List API
  /// 
  /// Gọi REST API và trả về List<Model> nếu thành công
  /// 
  /// Parameters:
  /// - limit: Số lượng items mỗi trang (default: 20)
  /// - offset: Pagination offset (default: 0)
  /// - keyword: Từ khóa tìm kiếm (optional)
  /// 
  /// Returns:
  /// - ResponseState chứa Map với 'count' và 'variants': List<ProductVariant>
  // TODO: Đổi tên method và Model type
  Future<ResponseState> getProductVariants({
    int limit = 20,
    int offset = 0,
    String? keyword,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        // TODO: Thay bằng NetworkUrl.[feature].filter() của bạn
        'company/product/variant/filter',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int count = 0;
        List<ProductVariant> models = []; // TODO: Thay ProductVariant bằng Model của bạn

        if (data is Map<String, dynamic>) {
          count = data['count'] ?? 0;
          // TODO: Thay 'variants' bằng key trong API response của bạn
          final itemsData = data['variants'] as List<dynamic>?;
          if (itemsData != null) {
            models = itemsData
                .map((item) => ProductVariant.fromMap(item as Map<String, dynamic>)) // TODO: Thay ProductVariant
                .toList();
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: {
            'count': count,
            'variants': models, // TODO: Thay 'variants' bằng key của bạn
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

  /// [MÔ TẢ METHOD] - Get by ID
  /// 
  /// Gọi REST API và trả về Model nếu thành công
  // TODO: Đổi tên method và Model type
  Future<ResponseState> getProductVariantById({
    required String id,
  }) async {
    try {
      final response = await coreDio.get<NWResponse>(
        // TODO: Thay bằng NetworkUrl.[feature].get(id: id) của bạn
        'company/product/variant/$id',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        final model = ProductVariant.fromMap(data as Map<String, dynamic>); // TODO: Thay ProductVariant

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: model,
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

  /// [MÔ TẢ METHOD] - Create
  /// 
  /// Gọi REST API POST và trả về Model nếu thành công
  // TODO: Đổi tên method và Model type
  Future<ResponseState> createProductVariant({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await coreDio.post<NWResponse>(
        // TODO: Thay bằng NetworkUrl.[feature].create của bạn
        'company/product/variant',
        data: data,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final responseData = resultData.data;
        final model = ProductVariant.fromMap(responseData as Map<String, dynamic>); // TODO: Thay ProductVariant

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: model,
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

  /// [MÔ TẢ METHOD] - Update
  // TODO: Đổi tên method và Model type
  Future<ResponseState> updateProductVariant({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await coreDio.put<NWResponse>(
        // TODO: Thay bằng NetworkUrl.[feature].update(id: id) của bạn
        'company/product/variant/$id',
        data: data,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final responseData = resultData.data;
        final model = ProductVariant.fromMap(responseData as Map<String, dynamic>); // TODO: Thay ProductVariant

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: model,
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

  /// [MÔ TẢ METHOD] - Delete
  // TODO: Đổi tên method
  Future<ResponseState> deleteProductVariant({
    required String id,
  }) async {
    try {
      final response = await coreDio.delete<NWResponse>(
        // TODO: Thay bằng NetworkUrl.[feature].delete(id: id) của bạn
        'company/product/variant/$id',
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: {'success': true},
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

