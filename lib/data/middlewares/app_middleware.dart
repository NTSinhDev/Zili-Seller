import 'package:dio/dio.dart';

import 'package:zili_coffee/data/middlewares/base_middleware.dart';
// import 'package:zili_coffee/data/models/notification.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';

class AppMiddleware extends BaseMiddleware {
  Future<ResponseState> getNotifications() async {
    try {
      final response = await authDio.get<NWResponse>(
        NetworkUrl.notification,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        // final listMap = resultData.data['notifications'] as List<dynamic>;
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: null,
          // responseData: listMap
          //     .map((dataMap) => NotificationModel.fromMap(dataMap))
          //     .toList(),
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
