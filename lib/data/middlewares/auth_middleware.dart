import 'package:dio/dio.dart';
import 'package:zili_coffee/data/middlewares/base_middleware.dart';
import 'package:zili_coffee/data/models/user/auth.dart';
import 'package:zili_coffee/data/models/user/staff.dart';
import 'package:zili_coffee/data/network/network_response_object.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/utils/enums.dart';

class AuthMiddleware extends BaseMiddleware {
  Future<ResponseState> deleteAccount() async {
    try {
      final response = await dio.delete<NWResponse>(
        NetworkUrl.customer.deleteAccount,
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data["status"] as bool,
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

  Future<ResponseState> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await authDio.post<NWResponse>(
        '/auth/seller/login',
        data: {'email': username, 'password': password},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: Auth.fromMap(resultData.data),
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

  Future<ResponseState> socialSignIn({
    required SignInType type,
    required String accessToken,
  }) async {
    try {
      final response = await authDio.post<NWResponse>(
        NetworkUrl.auth.socialSingIn,
        data: {'type': type.parseToStr(), 'code': accessToken},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: Auth.fromMap(resultData.data),
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

  Future<ResponseState> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await authDio.post<NWResponse>(
        NetworkUrl.auth.register,
        data: {'name': fullName, 'email': email, 'password': password},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: Auth.fromMap(resultData.data),
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

  Future<ResponseState> forgotPassword({required String email}) async {
    try {
      final response = await authDio.post<NWResponse>(
        '/auth/seller/forgot-password',
        data: {'email': email},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final status = resultData.data["status"];
        return ResponseSuccessState<bool>(
          statusCode: response.statusCode ?? -1,
          responseData: int.tryParse(status.toString()) == 1,
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

  Future<ResponseState> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await authDio.post<NWResponse>(
        NetworkUrl.auth.forgotCode,
        data: {'email': email, "code": code},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data['data'] as String?,
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

  Future<ResponseState> createNewPassword({
    required String newPassword,
    required String code,
  }) async {
    try {
      final response = await authDio.put<NWResponse>(
        NetworkUrl.auth.createNewPassword,
        data: {'password': newPassword, "session_id": code},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: resultData.data['status'] as bool,
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

  /// Logout seller
  ///
  /// API: POST /auth/seller/logout
  /// Body: { "ip": "<client_ip>", "deviceId": "<device_id>" }
  Future<ResponseState> logout({
    required String? ip,
    required String? deviceId,
  }) async {
    try {
      final response = await authDio.post<NWResponse>(
        "/auth/seller-app/logout",
        data: {'ip': ip, 'deviceId': deviceId},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        bool isSuccess = true;
        if (data is Map<String, dynamic>) {
          final status = data['status'];
          if (status is bool) {
            isSuccess = status;
          }
        } else if (data is bool) {
          isSuccess = data;
        }
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: isSuccess,
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

  /// Get active staff/user
  ///
  /// Lấy thông tin staff/user hiện tại đang active
  ///
  /// Parameters:
  /// - isMe: boolean (optional, default: true) - Lấy thông tin user hiện tại
  ///
  /// Returns:
  /// - ResponseSuccessState<Staff?> nếu thành công
  /// - ResponseFailedState nếu có lỗi
  Future<ResponseState> getActiveStaffs({bool? aboutMe}) async {
    try {
      final response = await authDio.get<NWResponse>(
        '/company/user/active',
        queryParameters: {'isMe': aboutMe},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess) {
        final data = resultData.data;
        List<Staff> staffs =
            data['listData'] != null && data['listData'] is List
            ? List<Staff>.from(
                data['listData'].map<Staff>(
                  (item) => Staff.fromMap(item as Map<String, dynamic>),
                ),
              )
            : [];

        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          responseData: staffs,
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

  Future<ResponseState> sendDeviceTokenToServer({
    required String deviceToken,
    required String deviceId,
    String? platform,
    String? brand,
    String? model,
    String? androidVersion,
    String? iosVersion,
    int? apiLevel,
  }) async {
    try {
      final response = await authDio.post<NWResponse>(
        "/auth/seller-app/device-token",
        data: {
          'deviceToken': deviceToken,
          'platform': platform,
          'brand': brand,
          'model': model,
          'deviceId': deviceId,
          'androidVersion': androidVersion,
          'iosVersion': iosVersion,
          'apiLevel': apiLevel,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
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
}
