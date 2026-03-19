import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:zili_coffee/bloc/app/app_cubit.dart';
import 'package:zili_coffee/bloc/auth/auth_state.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/models/user/auth.dart';
import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/data/models/client_models/message_notification.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
// import 'package:zili_coffee/services/authentication_services.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../../data/middlewares/middlewares.dart';
import '../../data/models/media_file.dart';
import '../../data/repositories/app_repository.dart';
import '../../services/local_storage_service.dart';
import '../../utils/extension/extension.dart';

class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit() : super(AuthNotReadyState());

  final _authMiddleware = di<AuthMiddleware>();
  final _customerMiddleware = di<CustomerMiddleware>();
  final _authRepo = di<AuthRepository>();
  final _appCubit = di<AppCubit>();
  final _uploadMiddleware = di<UploadMiddleware>();
  // final _authenticationServices = di<AuthenticationServices>();
  final AppRepository _appRepo = di<AppRepository>();
  final _localStoreService = di<LocalStoreService>();

  Future<bool> logout() async {
    if (_authRepo.ipNetwork.isNull) _authRepo.ipNetwork = await Ipify.ipv4();
    final deviceInfo =
        _appRepo.crDeviceInfo ?? await _appRepo.getDeviceInformation();

    final result = await _authMiddleware.logout(
      ip: _authRepo.ipNetwork,
      deviceId: deviceInfo?.id,
    );
    if (result is ResponseSuccessState<bool>) {
      return result.responseData;
    }
    return false;
  }

  Future<MessageNotification> deleteAccount() async {
    final authResult = await _authMiddleware.deleteAccount();
    if (authResult is ResponseSuccessState<bool>) {
      if (authResult.responseData) {
        return MessageNotification(
          message: "",
          type: MessageNotificationType.success,
        );
      } else {
        return MessageNotification(
          message: "Tài khoản đã bị xóa ở nơi khác!",
          type: MessageNotificationType.info,
        );
      }
    } else if (authResult is ResponseFailedState) {
      if (authResult.errorMessage ==
          "Cannot delete the account due to shipped orders") {
        return MessageNotification(
          message:
              "Không thể xóa tài khoản. Bạn đang có đơn hàng đang được xử lý!",
          type: MessageNotificationType.warning,
        );
      }
      return MessageNotification(
        message: authResult.errorMessage,
        type: MessageNotificationType.error,
      );
    }
    return MessageNotification(
      message: "Lỗi xảy ra trong quá trình thực hiện tác vụ này!",
      type: MessageNotificationType.error,
    );
  }

  Future login({required String username, required String password}) async {
    emit(AuthProcessingState());
    final authResult = await _authMiddleware.login(
      username: username,
      password: password,
    );
    if (authResult is ResponseSuccessState<Auth>) {
      _authRepo.setCurrentAuth(authResult.responseData);
      final userResult = await _customerMiddleware.getUserProfile();
      if (userResult is ResponseSuccessState<User?>) {
        _authRepo.setCurrentUser(userResult.responseData!);
        _appCubit.emit(
          AppReadyWithAuthenticationState(user: _authRepo.currentUser!),
        );
        emit(AuthReadyState(userResult.responseData!));
        _appCubit.sendDeviceTokenToServer();
        _localStoreService.lastUsername = username;
      } else if (userResult is ResponseFailedState) {
        emit(AuthFailedState(userResult));
      }
    } else if (authResult is ResponseFailedState) {
      emit(AuthFailedState(authResult));
    }
  }

  // Future googleSignIn() async {
  //   emit(AuthProcessingState());
  //   final accessToken = await _authenticationServices.signInWithGoogle();
  //   if (accessToken == null) {
  //     final failedState = ResponseFailedState(
  //       apiError: "",
  //       errorMessage: "",
  //       statusCode: -1,
  //     );
  //     return emit(AuthFailedState(failedState));
  //   }
  //   final authResult = await _authMiddleware.socialSignIn(
  //     type: SignInType.Google,
  //     accessToken: accessToken,
  //   );
  //   if (authResult is ResponseSuccessState<Auth>) {
  //     _authRepo.setCurrentAuth(authResult.responseData);
  //     final userResult = await _customerMiddleware.getUserProfile();
  //     if (userResult is ResponseSuccessState<User?>) {
  //       _authRepo.setCurrentUser(userResult.responseData!);
  //       _appCubit.emit(
  //         AppReadyWithAuthenticationState(user: _authRepo.currentUser!),
  //       );
  //       emit(AuthReadyState(userResult.responseData!));
  //     } else if (userResult is ResponseFailedState) {
  //       emit(AuthFailedState(userResult));
  //     }
  //   } else if (authResult is ResponseFailedState) {
  //     emit(AuthFailedState(authResult));
  //   }
  // }

  // Future facebookSignIn() async {
  //   final accessToken = await _authenticationServices.signInWithFacebook();
  //   if (accessToken == null) {
  //     final failedState = ResponseFailedState(
  //       apiError: "",
  //       errorMessage: "",
  //       statusCode: -1,
  //     );
  //     return emit(AuthFailedState(failedState));
  //   }
  //   emit(AuthProcessingState());
  //   final authResult = await _authMiddleware.socialSignIn(
  //     type: SignInType.Facebook,
  //     accessToken: accessToken,
  //   );
  //   if (authResult is ResponseSuccessState<Auth>) {
  //     _authRepo.setCurrentAuth(authResult.responseData);
  //     final userResult = await _customerMiddleware.getUserProfile();
  //     if (userResult is ResponseSuccessState<User?>) {
  //       _authRepo.setCurrentUser(userResult.responseData!);
  //       _appCubit.emit(
  //         AppReadyWithAuthenticationState(user: _authRepo.currentUser!),
  //       );
  //       emit(AuthReadyState(userResult.responseData!));
  //     } else if (userResult is ResponseFailedState) {
  //       emit(AuthFailedState(userResult));
  //     }
  //   } else if (authResult is ResponseFailedState) {
  //     emit(AuthFailedState(authResult));
  //   }
  // }

  Future register({
    required String fullname,
    required String email,
    required String password,
  }) async {
    //? Test code
    // emit(AuthProcessingState());
    // await Future.delayed(const Duration(seconds: 1));
    final customer = User(
      id: "12",
      name: "Sinh",
      email: "nts.sinhdo@gmail.com",
      phone: "0329934096",
    );
    // _appCubit.emit(AppReadyWithAuthenticationState(user: customer));
    emit(AuthReadyState(customer));
    /* 
    * Code of this function
    emit(AuthProcessingState());
    final authResult = await _authMiddleware.register(
      fullName: fullname,
      email: email,
      password: password,
    );
    if (authResult is ResponseSuccessState<Auth>) {
      _authRepo.setCurrentAuth(authResult.responseData);
      final userResult = await _customerMiddleware.getUserProfile();
      if (userResult is ResponseSuccessState<Customer?>) {
        _authRepo.setCurrentUser(userResult.responseData!);
        _appCubit.emit(
            AppReadyWithAuthenticationState(user: userResult.responseData!));
        emit(AuthReadyState(userResult.responseData!));
      } else if (userResult is ResponseFailedState) {
        emit(AuthFailedState(userResult));
      }
    } else if (authResult is ResponseFailedState) {
      emit(AuthFailedState(authResult));
    }
    */
  }

  Future forgotPassword({required String email}) async {
    emit(AuthProcessingState());
    final result = await _authMiddleware.forgotPassword(email: email);
    if (result is ResponseSuccessState<bool>) {
      if (result.responseData) {
        emit(ForgotPasswordState(step: .verifyCode, message: "Thành công!"));
      } else {
        emit(
          ForgotPasswordState(
            step: .error,
            message: "Không tìm thấy email trong hệ thống!",
          ),
        );
      }
    } else if (result is ResponseFailedState) {
      emit(AuthFailedState(result));
    }
  }

  Future verifyCode({required String email, required String code}) async {
    emit(AuthProcessingState());
    final result = await _authMiddleware.verifyCode(email: email, code: code);
    if (result is ResponseSuccessState<String?>) {
      if (result.responseData == null) {
        emit(
          const ForgotPasswordState(step: ForgotPasswordSteps.inputNewPassword),
        );
      } else {
        emit(
          ForgotPasswordState(
            step: ForgotPasswordSteps.error,
            message: result.responseData,
          ),
        );
      }
    } else if (result is ResponseFailedState) {
      emit(AuthFailedState(result));
    }
  }

  Future createNewPassword({
    required String newPassword,
    required String code,
  }) async {
    emit(AuthProcessingState());
    final result = await _authMiddleware.createNewPassword(
      newPassword: newPassword,
      code: code,
    );
    if (result is ResponseSuccessState<bool>) {
      if (result.responseData) {
        emit(HasBeenChangedPasswordState());
      } else {
        emit(
          const ForgotPasswordState(
            step: ForgotPasswordSteps.error,
            message: 'Không thể thực hiện tác vụ này!',
          ),
        );
      }
    } else if (result is ResponseFailedState) {
      emit(AuthFailedState(result));
    }
  }

  Future<(bool, String)> updateAvatar({required File file}) async {
    // Upload file to server to get URL
    final imageData = await _uploadMiddleware.uploadImage(imgFile: file);
    if (imageData is ResponseSuccessState<MediaFile?>) {
      if (imageData.responseData != null) {
        // Update avatar by this URL
        final result = await _customerMiddleware.updateUserAvatar(
          media: imageData.responseData!,
        );
        if (result is ResponseSuccessState<String?>) {
          if (result.responseData != null) {
            _authRepo.updateAvatar(result.responseData!);
            _appCubit.emit(
              AppReadyWithAuthenticationState(user: _authRepo.currentUser),
            );
            return (true, "Đã cập nhật ảnh đại diện!");
          } else {
            return (false, "Không thể cập nhật ảnh đại diện!");
          }
        } else if (result is ResponseFailedState) {
          return (false, "Không thể cập nhật ảnh đại diện!");
        }
      } else {
        return (false, "Không thể cập nhật ảnh đại diện!");
      }
    }

    return (false, "Không thể cập nhật ảnh đại diện!");
  }
}
