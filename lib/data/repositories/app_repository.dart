import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../services/firebase_cloud_messaging/firebase_cloud_messaging_services.dart';
import '../../utils/enums.dart';
import 'base_repository.dart';

class DeviceModel {
  final String id;
  final String? brand;
  final String? model;
  final String? sdk;
  DeviceModel({
    required this.id,
    this.brand,
    this.sdk,
    this.model,
    String? version,
  }) : _version = version;
  late final String? _version;

  CurrentPlatform? get platform {
    if (Platform.isAndroid) return CurrentPlatform.android;
    if (Platform.isIOS) return CurrentPlatform.ios;
    return null;
  }

  String? get iosVersion => Platform.isIOS ? _version : null;

  String? get androidVersion => Platform.isAndroid ? _version : null;
}

class AppRepository extends BaseRepository {
  // FCM
  String? _deviceToken;
  AndroidDeviceInfo? _androidDeviceInfo;
  IosDeviceInfo? _iosDeviceInfo;
  FCMHandler? fcmHandler;

  String? get crDeviceToken => _deviceToken;
  DeviceModel? get crDeviceInfo {
    if (Platform.isAndroid) {
      if (_androidDeviceInfo != null) {
        return DeviceModel(
          id: _androidDeviceInfo?.id ?? "",
          brand: _androidDeviceInfo?.brand,
          sdk: _androidDeviceInfo?.version.release,
          model: _androidDeviceInfo?.model,
          version: _androidDeviceInfo?.version.sdkInt.toString(),
        );
      }
      return null;
    }
    if (Platform.isIOS) {
      if (_iosDeviceInfo != null) {
        return DeviceModel(
          id: _iosDeviceInfo?.identifierForVendor ?? "",
          brand: _iosDeviceInfo?.name,
          model: _iosDeviceInfo?.modelName,
          version: _iosDeviceInfo?.systemVersion.toString(),
        );
      }
      return null;
    }
    return null;
  }

  Future<DeviceModel?> getDeviceInformation() async {
    if (Platform.isAndroid) {
      _androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      return DeviceModel(
        id: _androidDeviceInfo?.id ?? "",
        brand: _androidDeviceInfo?.brand,
        sdk: _androidDeviceInfo?.version.release,
        model: _androidDeviceInfo?.model,
        version: _androidDeviceInfo?.version.sdkInt.toString(),
      );
    }
    if (Platform.isIOS) {
      _iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      return DeviceModel(
        id: _iosDeviceInfo?.identifierForVendor ?? _iosDeviceInfo?.model ?? "",
        brand: _iosDeviceInfo?.name,
        model: _iosDeviceInfo?.modelName,
        version: _iosDeviceInfo?.systemVersion.toString(),
      );
    }
    return null;
  }

  Future<String?> getCurrentDeviceToken() async {
    try {
      final isSupported = await FirebaseMessaging.instance.isSupported();
      if (!isSupported) {
        log('Firebase Messaging is not supported');
        return null;
      }
      _deviceToken = await FirebaseMessaging.instance.getToken();
      log("_deviceToken: $_deviceToken");
      return _deviceToken;
    } catch (e) {
      log('Error getting current device token: $e');
      return null;
    }
  }

  @override
  void clean() {}
}
