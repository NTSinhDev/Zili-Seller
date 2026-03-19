import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/address_repository.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:equatable/equatable.dart';
import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../../data/repositories/app_repository.dart';

part 'app_state.dart';

class AppCubit extends BaseCubit<AppState> {
  /* Google login, Facebook login, etc. */
  /*
  import 'package:zili_coffee/services/authentication_services.dart';
  final AuthenticationServices _authenticationServices =
      di<AuthenticationServices>();
  */
  AppCubit() : super(AppInitialState());

  final CustomerMiddleware _customerMiddleware = di<CustomerMiddleware>();
  final AuthMiddleware _authMiddleware = di<AuthMiddleware>();
  final AuthRepository _authRepo = di<AuthRepository>();
  final AppRepository _appRepo = di<AppRepository>();

  Future<void> sendDeviceTokenToServer([String? deviceToken]) async {
    try {
      final String? currentDeviceToken =
          deviceToken ??
          _appRepo.crDeviceToken ??
          await _appRepo.getCurrentDeviceToken();
      final deviceInfo =
          _appRepo.crDeviceInfo ?? await _appRepo.getDeviceInformation();
      if ((currentDeviceToken ?? "").isEmpty ||
          (deviceInfo?.id ?? "").isEmpty) {
        log(
          'Device token or device id is empty: $currentDeviceToken, ${deviceInfo?.id}',
        );
        return;
      }

      await _authMiddleware.sendDeviceTokenToServer(
        deviceId: deviceInfo!.id,
        deviceToken: currentDeviceToken!,
        platform: deviceInfo.platform?.name,
        brand: deviceInfo.brand,
        model: deviceInfo.model,
        androidVersion: deviceInfo.androidVersion,
        iosVersion: deviceInfo.iosVersion,
      );
    } catch (e) {
      throw Exception(
        "Cannot send device token to server!",
      ); // => Lưu log ở firebase console
    }
  }

  Future<void> checkSession() async {
    final auth = _authRepo.getCurrentAuth();
    final token = auth?.getToken ?? '';
    if (token.isEmpty) {
      emit(const AppReadyState());
    } else {
      await getUserInformation();
    }
  }

  Future<void> getUserInformation({SignInType? signInType}) async {
    if (state is AppReadyWithAuthenticationState) emit(RefreshAppState());

    final customerData = await _customerMiddleware.getUserProfile();
    if (customerData is ResponseSuccessState<User?>) {
      if (customerData.responseData != null) {
        _authRepo.setCurrentUser(customerData.responseData!);
      }
      await sendDeviceTokenToServer();
      emit(AppReadyWithAuthenticationState(user: _authRepo.currentUser));
    } else {
      final deviceInfo =
          _appRepo.crDeviceInfo ?? await _appRepo.getDeviceInformation();
      await _authMiddleware.logout(
        ip: _authRepo.ipNetwork,
        deviceId: deviceInfo?.id,
      );
      emit(AppUnauthorizedState());
      _authRepo.clean();
    }
  }

  Future<void> logout() async {
    try {
      // clean data
      di<OrderRepository>().clean();
      di<AddressRepository>().clean();
      di<AuthRepository>().clean();

      emit(AppManualLogoutSuccessState());
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> handleUnauthorized() async {
    try {
      final deviceInfo =
          _appRepo.crDeviceInfo ?? await _appRepo.getDeviceInformation();
      await _authMiddleware.logout(
        ip: _authRepo.ipNetwork,
        deviceId: deviceInfo?.id,
      );

      // clean data
      di<OrderRepository>().clean();
      di<AddressRepository>().clean();
      di<AuthRepository>().clean();
      emit(AppUnauthorizedState());
      _authRepo.clean();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
