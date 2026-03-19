import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:zili_coffee/data/constant/data_constant.dart';
import 'package:zili_coffee/data/network/network_common.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

abstract class BaseMiddleware {
  // Constants
  final orderConstant = MiddlewareConstant.order;
  final productConstant = MiddlewareConstant.product;
  final addressConstant = MiddlewareConstant.adress;
  final reviewConstant = MiddlewareConstant.review;
  final appConstant = MiddlewareConstant.app;

  final CancelToken cancelToken = CancelToken();
  Dio get dio => di<NetworkCommon>().dio;
  Dio get authDio => di<NetworkCommon>().authDio;
  Dio get coreDio => di<NetworkCommon>().coreDio;
  Dio get userDio => di<NetworkCommon>().userDio;
  Dio get systemDio => di<NetworkCommon>().systemDio;

  void close() {
    cancelToken.cancel();
    log('${toString()} closed');
  }

  ResponseFailedState handleResponseFailedState(DioException e) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        return ResponseFailedState.fromNWResponse(
          NWResponseFailed.formJson(
            statusCode: e.response!.statusCode!,
            json: e.response!.data,
          ),
        );
      case DioExceptionType.unknown:
        if (e.error is NWResponseFailed) {
          return ResponseFailedState.fromNWResponse(
            e.error as NWResponseFailed,
          );
        } else {
          return ResponseFailedState.fromDioError(e);
        }
      default:
        return ResponseFailedState.fromDioError(e);
    }
  }
}
