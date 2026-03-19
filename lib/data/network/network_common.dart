import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:zili_coffee/bloc/app/app_cubit.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/utils/pretty_dio_logger.dart';

import '../../app/app_wireframe.dart';

class NetworkCommon {
  final _decoder = const JsonDecoder();

  Dio get dio {
    final dio = Dio();

    //Set default configs
    dio.options.baseUrl = NetworkUrl.baseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 180000);
    dio.options.receiveTimeout = const Duration(milliseconds: 180000);
    dio.options.headers["Connection"] = "Keep-Alive";

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {
          // log(obj.toString());
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handle) async {
          // final String currentTimeZone =
          //     await UtilsNativeChannel().getCityTimeZone();
          final auth = di<AuthRepository>().currentAuth;
          final accessToken = auth?.getToken ?? '';
          if (accessToken.isEmpty) {
            return handle.reject(DioException(requestOptions: options));
          }

          final headers = options.headers
            ..update(
              'Authorization',
              (_) => accessToken,
              ifAbsent: () => accessToken,
            );
          options.headers = headers;
          // log(headers)
          return handle.next(options); //continue
        },
        onResponse: (response, handle) async {
          response.data = decodeRespSuccess(response);
          return handle.next(response);
        },
        onError: (e, handle) async {
          if (e.response?.statusCode == 401) {
            /* try {
              final auth = di<AuthRepository>().currentAuth;
              final response = await dio.post(NetworkUrl.baseURL + NetworkUrl.refreshTokenURL, data: {'refresh_token': auth?.refreshToken});
              if (response.statusCode == 200 && response.data != null) {
                response.data['refresh_token'] = auth?.refreshToken;
                // di<AuthRepository>().setCurrentAuth(Auth.fromJson(response.data['data']));
              }
              return handle.next(e);
            } catch (err) {
              AppWireFrame.logout();
              return handle.next(e);
            }*/
            await di<AppCubit>().logout();
            handleDioError(e);
          }

          if (CancelToken.isCancel(e)) return handle.next(e);
          // handleDioError(e);
          handle.next(e);
        },
      ),
    );

    return dio;
  }

  Dio get authDio {
    final dio = Dio();

    // Set default configs
    // this.checkForCharlesProxy(dio);
    dio.options.baseUrl = NetworkUrl.authBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
    dio.options.receiveTimeout = const Duration(milliseconds: 10000);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {
          // log('message: $obj', name: "NetworkCommon - authDio");
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handle) async {
          final resolvedStatusCodeByLogout = [
            HttpStatus.badGateway,
            HttpStatus.serviceUnavailable,
            HttpStatus.unauthorized,
          ];
          if (resolvedStatusCodeByLogout.contains(e.response?.statusCode)) {
            di<AppCubit>().handleUnauthorized();
            AppWireFrame.logout();
            return;
          }

          if (CancelToken.isCancel(e)) return handle.next(e);
          // handleDioError(e);
          handle.next(e);
        },
        onRequest: (options, handle) async {
          final auth = di<AuthRepository>().currentAuth;
          final accessToken = auth?.getToken ?? '';
          final headers = options.headers
            ..update(
              'Authorization',
              (_) => accessToken,
              ifAbsent: () => accessToken,
            );
          options.headers = headers;
          return handle.next(options);
        },
        onResponse: (response, handle) async {
          response.data = decodeRespSuccess(response);
          return handle.next(response);
        },
      ),
    );

    return dio;
  }

  Dio get coreDio {
    final dio = Dio();

    // Set default configs
    dio.options.baseUrl = NetworkUrl.coreBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 180000);
    dio.options.receiveTimeout = const Duration(milliseconds: 180000);
    dio.options.headers["Connection"] = "Keep-Alive";

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {
          // log('message: $obj', name: "NetworkCommon - coreDio");
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handle) async {
          final auth = di<AuthRepository>().currentAuth;
          final accessToken = auth?.getToken ?? '';
          if (accessToken.isEmpty) {
            return handle.reject(DioException(requestOptions: options));
          }

          final headers = options.headers
            ..update(
              'Authorization',
              (_) => accessToken,
              ifAbsent: () => accessToken,
            );
          options.headers = headers;
          return handle.next(options);
        },
        onResponse: (response, handle) async {
          response.data = decodeRespSuccess(response);
          return handle.next(response);
        },
        onError: (e, handle) async {
          final resolvedStatusCodeByLogout = [
            HttpStatus.badGateway,
            HttpStatus.serviceUnavailable,
            HttpStatus.unauthorized,
          ];
          if (resolvedStatusCodeByLogout.contains(e.response?.statusCode)) {
            di<AppCubit>().handleUnauthorized();
            AppWireFrame.logout();
            return;
          }

          if (CancelToken.isCancel(e)) return handle.next(e);
          handle.next(e);
        },
      ),
    );

    return dio;
  }

  Dio get userDio {
    final dio = Dio();

    // Set default configs
    dio.options.baseUrl = NetworkUrl.userBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 180000);
    dio.options.receiveTimeout = const Duration(milliseconds: 180000);
    dio.options.headers["Connection"] = "Keep-Alive";

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {
          // log('message: $obj', name: "NetworkCommon - userDio");
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handle) async {
          final auth = di<AuthRepository>().currentAuth;
          final accessToken = auth?.getToken ?? '';
          if (accessToken.isEmpty) {
            return handle.reject(DioException(requestOptions: options));
          }

          final headers = options.headers
            ..update(
              'Authorization',
              (_) => accessToken,
              ifAbsent: () => accessToken,
            );
          options.headers = headers;
          return handle.next(options);
        },
        onResponse: (response, handle) async {
          response.data = decodeRespSuccess(response);
          return handle.next(response);
        },
        onError: (e, handle) async {
          final resolvedStatusCodeByLogout = [
            HttpStatus.badGateway,
            HttpStatus.serviceUnavailable,
            HttpStatus.unauthorized,
          ];
          if (resolvedStatusCodeByLogout.contains(e.response?.statusCode)) {
            di<AppCubit>().handleUnauthorized();
            AppWireFrame.logout();
            return;
          }

          if (CancelToken.isCancel(e)) return handle.next(e);
          handle.next(e);
        },
      ),
    );

    return dio;
  }

  Dio get systemDio {
    final dio = Dio();

    // Set default configs
    dio.options.baseUrl = NetworkUrl.systemBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 180000);
    dio.options.receiveTimeout = const Duration(milliseconds: 180000);
    dio.options.headers["Connection"] = "Keep-Alive";

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {
          // log('message: $obj', name: "NetworkCommon - systemDio");
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handle) async {
          final auth = di<AuthRepository>().currentAuth;
          final accessToken = auth?.getToken ?? '';
          if (accessToken.isEmpty) {
            return handle.reject(DioException(requestOptions: options));
          }

          final headers = options.headers
            ..update(
              'Authorization',
              (_) => accessToken,
              ifAbsent: () => accessToken,
            );
          options.headers = headers;
          return handle.next(options);
        },
        onResponse: (response, handle) async {
          response.data = decodeRespSuccess(response);
          return handle.next(response);
        },
        onError: (e, handle) async {
          final resolvedStatusCodeByLogout = [
            HttpStatus.badGateway,
            HttpStatus.serviceUnavailable,
            HttpStatus.unauthorized,
          ];
          if (resolvedStatusCodeByLogout.contains(e.response?.statusCode)) {
            di<AppCubit>().handleUnauthorized();
            AppWireFrame.logout();
            return;
          }

          if (CancelToken.isCancel(e)) return handle.next(e);
          handle.next(e);
        },
      ),
    );

    return dio;
  }

  NWResponse decodeRespSuccess(Response<dynamic> d) {
    final jsonBody = d.data;
    final statusCode = d.statusCode!;

    if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
      throw NWResponseFailed.invalidRequestError(statusCode: statusCode);
    }

    NWResponse parseJsonData(dynamic jsonData) {
      if (jsonData is Map) {
        return NWResponseSuccess<Map<String, dynamic>>(
          statusCode,
          jsonData as Map<String, dynamic>,
        );
      } else if (jsonData is List) {
        return NWResponseSuccess(statusCode, jsonData);
      } else {
        throw NWResponseFailed.decodeError(
          statusCode: statusCode,
          message: 'Cannot decode data',
        );
      }
    }

    if (jsonBody is String) {
      if (jsonBody.isEmpty && statusCode == 200) {
        return NWResponseSuccess(statusCode, {});
      }

      final dataDecoder = _decoder.convert(jsonBody);
      if (dataDecoder is List) {
        return NWResponseSuccess(statusCode, dataDecoder);
      } else if (dataDecoder is Map) {
        if (dataDecoder['data'] is Map) {
          return parseJsonData(dataDecoder['data']);
        } else {
          return parseJsonData(dataDecoder);
        }
      } else {
        throw NWResponseFailed.decodeError(
          statusCode: statusCode,
          message: 'Cannot decode data',
        );
      }
    } else if (jsonBody is Map) {
      if (jsonBody['data'] is Map) {
        return parseJsonData(jsonBody['data']);
      } else {
        return parseJsonData(jsonBody);
      }
    } else if (jsonBody is List) {
      return NWResponseSuccess(statusCode, jsonBody);
    } else {
      throw NWResponseFailed.decodeError(
        statusCode: statusCode,
        message: 'Cannot decode data',
      );
    }
  }

  NWResponseFailed handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        final jsonBody = e.response?.data;
        final statusCode = e.response?.statusCode;
        if (jsonBody is String) {
          if (jsonBody.isEmpty) {
            throw NWResponseFailed.invalidRequestError(
              statusCode: statusCode!,
              message: 'Response error is not found',
            );
          }

          throw NWResponseFailed.formJson(
            statusCode: statusCode ?? -1,
            json: _decoder.convert(jsonBody) as Map<String, dynamic>,
          );
        } else if (jsonBody is Map<String, dynamic>) {
          throw NWResponseFailed.formJson(
            statusCode: statusCode ?? -1,
            json: jsonBody,
          );
        } else {
          throw NWResponseFailed.decodeError(
            statusCode: statusCode!,
            message: 'Cannot decode data',
          );
        }
      default:
        throw e;
    }
  }

  // void checkForCharlesProxy(Dio dio) {
  //   const charlesIp = '';
  //   if (charlesIp.isEmpty) return;
  //   appPrint('#CharlesProxyEnabled');
  //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (client) {
  //     client.findProxy = (uri) => "PROXY $charlesIp:8888;";
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  //   };
  // }
}
