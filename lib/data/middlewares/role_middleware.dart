import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/seller/role.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';

class RoleMiddleware extends BaseMiddleware {
  /// Get seller roles - List API
  /// 
  /// Gọi REST API và trả về List<Role> nếu thành công
  /// 
  /// API: GET /auth/api/v1/seller/role
  /// 
  /// Parameters:
  /// - limit: Số lượng items mỗi trang (default: 8)
  /// - offset: Pagination offset (default: 0)
  /// 
  /// Returns:
  /// - ResponseState chứa Map với 'count' và 'items': List<Role>
  Future<ResponseState> getSellerRoles({
    int limit = 8,
    int offset = 0,
  }) async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.seller.role,
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        int count = 0;
        List<Role> roles = [];

        if (data is Map<String, dynamic>) {
          // API trả về với key 'listData'
          final rolesData = data['listData'] as List<dynamic>?;
          if (rolesData != null) {
            roles = rolesData
                .map((item) => Role.fromMap(item as Map<String, dynamic>))
                .toList();
            count = roles.length;
          }
        } else if (data is List) {
          // If response is directly a list
          roles = data
              .map((item) => Role.fromMap(item as Map<String, dynamic>))
              .toList();
          count = roles.length;
        }

        return ResponseSuccessListState<List<Role>>(
          statusCode: response.statusCode ?? -1,
          total: count,
          responseData: roles,
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

