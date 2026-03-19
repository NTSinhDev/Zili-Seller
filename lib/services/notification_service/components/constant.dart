import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _androidInitializationSettings = AndroidInitializationSettings(
  NotificationsConstantData.defaultIcon,
);
const _iosInitializationSettings = DarwinInitializationSettings(
  requestAlertPermission: false,
  requestBadgePermission: false,
  requestSoundPermission: false,
);
const initializationSettings = InitializationSettings(
  android: _androidInitializationSettings,
  iOS: _iosInitializationSettings,
);

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  NotificationsConstantData.channelId,
  NotificationsConstantData.channelName,
  description: NotificationsConstantData.channelDescription,
  importance: Importance.max,
);

class NotificationsConstantData {
  static const String defaultIcon = '@mipmap/ic_launcher';
  static const String skyIcon = defaultIcon;
  static const String channelId = 'com.zili_coffee.seller';
  static const String channelName = 'seller';
  static const String channelDescription = "Seller Channel Notification";
  static const String sound = 'default.wav';
}
