import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';

import '../entity/system/reason.dart';

class ReasonMiddleware extends BaseMiddleware {
  /// Get reasons
  ///
  /// API: GET /setting/reason
  ///
  /// Parameters:
  /// - type: String
  Future<ResponseState> getReasons({String? type}) async {
    try {
      final response = await systemDio.get<NWResponse>(
        "/setting/reason",
        queryParameters: {"type": type},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<ReasonEntity> reasons = [];

        if (data is List) {
          // Nếu response là array trực tiếp
          reasons = data
              .map<ReasonEntity>(
                (item) => ReasonEntity.fromMap(item),
              )
              .toList();
        } else if (data is Map<String, dynamic>) {
          // Nếu response là object có key 'data' hoặc 'listData'
          final items = data['data'] ?? data['listData'] ?? data;
          if (items is List) {
            reasons = items
                .map<ReasonEntity>(
                  (item) => ReasonEntity.fromMap(item),
                )
                .toList();
          }
        }

        return ResponseSuccessState<List<ReasonEntity>>(
          statusCode: response.statusCode ?? -1,
          responseData: reasons,
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
