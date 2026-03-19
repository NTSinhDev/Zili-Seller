import 'package:dio/dio.dart';

import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/payment/collaborator.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';

class CollaboratorMiddleware extends BaseMiddleware {
  /// Lấy danh sách cộng tác viên
  ///
  /// API: GET /user/api/v1/company/collaborator/all
  /// Query: status[] (tùy chọn, mặc định ['COMPLETED'])
  Future<ResponseState> getCollaborators({
    List<String>? status,
  }) async {
    try {
      final response = await userDio.get<NWResponse>(
        NetworkUrl.collaborator.all(
          status: status ?? const ['COMPLETED'],
        ),
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<Collaborator> collaborators = [];

        if (data is List) {
          collaborators = data
              .map<Collaborator>((item) => Collaborator.fromMap(item))
              .toList();
        } else if (data is Map<String, dynamic>) {
          final items = data['data'] ??
              data['listData'] ??
              data['items'] ??
              data.values.firstWhere(
                (v) => v is List,
                orElse: () => [],
              );
          if (items is List) {
            collaborators = items
                .map<Collaborator>((item) => Collaborator.fromMap(item))
                .toList();
          }
        }

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: collaborators,
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

