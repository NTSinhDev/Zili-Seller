import 'package:dio/dio.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';

abstract class ResponseState {
  ResponseState({required this.statusCode});
  final int statusCode;
}

class ResponseSuccessState<T> extends ResponseState {
  ResponseSuccessState({required super.statusCode, required this.responseData});

  final T responseData;

  ResponseSuccessState<T> copyWith({
    required int statusCode,
    required T responseData,
  }) {
    return ResponseSuccessState<T>(
      statusCode: statusCode,
      responseData: responseData ?? this.responseData,
    );
  }
}

class ResponseSuccessListState<T> extends ResponseSuccessState<T> {
  final int total;
  ResponseSuccessListState({
    required super.statusCode,
    required super.responseData,
    required this.total,
  });
}

class ResponseFailedState extends ResponseState {
  ResponseFailedState({
    required super.statusCode,
    required this.errorMessage,
    required this.apiError,
  });

  factory ResponseFailedState.fromDioError(DioException e) {
    // var dataError = e.error;
    // if (dataError is NWErrorEnum) {
    //   return ResponseFailedState(
    //     statusCode: e.response.statusCode,
    //     errorMessage: dataError.errorMessage,
    //     apiError: dataError,
    //   );
    // } else if (dataError is SocketException) {
    //   var osError = dataError.osError;
    //   if (osError.errorCode == 101 || osError.errorCode == 51) {
    //     return ResponseFailedState(
    //       statusCode: osError.errorCode,
    //       errorMessage: osError.message,
    //     );
    //   }
    // }

    return ResponseFailedState(
      statusCode: e.response?.statusCode ?? -1,
      errorMessage: 'An error occurred. Please try again.',
      apiError: '',
    );
  }

  factory ResponseFailedState.unknownError() {
    return ResponseFailedState(
      statusCode: -1,
      errorMessage: 'An error occurred. Please try again.',
      apiError: 'unknown_error',
    );
  }

  factory ResponseFailedState.fromNWResponse(NWResponseFailed response) {
    return ResponseFailedState(
      statusCode: response.statusCode,
      errorMessage: response.errorMessage ?? '',
      apiError: response.errorType ?? '',
    );
  }

  final String apiError;
  final String errorMessage;
}
