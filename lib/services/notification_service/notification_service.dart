import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import '../../app/app_wireframe.dart';
import '../../views/quote/details/quotation_details_screen.dart';
import '../../views/warehouse/packing_slip/packing_slip_details/packing_slip_details_screen.dart';
import '../../views/warehouse/roasting_slip/export.dart';
import 'components/constant.dart';
import 'components/notification_cancel_model.dart';

class NotificationService {
  final notificationCancel = BehaviorSubject<List<NotificationCancel>>();

  // Do not push data of FCM other than Chat FCM
  ReplaySubject<Map<String, dynamic>?> onClickChatNotification =
      ReplaySubject<Map<String, dynamic>?>();
  final onClickFriendRequestNotification =
      ReplaySubject<Map<String, dynamic>?>();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool?> requestPermission() async {
    if (Platform.isAndroid) {
      return await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void initNotification({BuildContext? context}) async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (context != null && context.mounted) {
          onDidReceiveNotificationResponse(details, context);
        }
      },
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> cancel({required int id, String? tag}) async {
    await flutterLocalNotificationsPlugin.cancel(id, tag: tag);
  }

  Future<void> showNotificationV2({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationDetails? notificationDetails,
  }) async {
    final notificationCancelData = NotificationCancel(
      id,
      notificationDetails?.android?.tag ?? "",
    );
    final listData = notificationCancel.valueOrNull ?? [];

    NotificationCancel? temp;
    for (var item in listData) {
      if (item.tag == notificationCancelData.tag) {
        temp = item;
        break;
      }
    }
    if (temp != null) {
      listData.remove(temp);
      cancel(id: temp.id, tag: temp.tag);
    }
    listData.add(notificationCancelData);
    notificationCancel.sink.add(listData);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      payload: payload,
      notificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? icon,
    String? payload,
    Uint8List? image,
    String? tag,
    String? channelId,
    String? subText,
    NotificationVisibility? visibility,
    String? groupKey,
    List<AndroidNotificationAction>? actions,
    AndroidNotificationCategory? category,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      payload: payload,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId ?? NotificationsConstantData.channelId,
          NotificationsConstantData.channelName,
          importance: Importance.max,
          priority: Priority.max,
          largeIcon: image != null ? ByteArrayAndroidBitmap(image) : null,
          icon: icon ?? NotificationsConstantData.skyIcon,
          channelDescription: NotificationsConstantData.channelDescription,
          audioAttributesUsage: AudioAttributesUsage.game,
          tag: tag,
          category: category,
          fullScreenIntent: actions != null,
          // subText: subText,
          // visibility: visibility,
          groupKey: groupKey,
          actions: actions,
        ),
        iOS: const DarwinNotificationDetails(
          sound: NotificationsConstantData.sound,
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> onDidReceiveNotificationResponse(
    NotificationResponse details,
    BuildContext context,
  ) async {
    Map<String, dynamic>? parsePayloadToData(String payload) {
      try {
        return json.decode(details.payload!);
      } catch (e) {
        return null;
      }
    }

    if (details.payload != null && details.payload!.isNotEmpty) {
      final data = parsePayloadToData(details.payload!);
      if (data != null) {
        final route = data["route"] as String?;

        if (route == RoastingSlipDetailScreen.routeName) {
          final slipCode = data["slipCode"] != null
              ? data["slipCode"] as String
              : null;
          if (slipCode != null) {
            AppWireFrame.pushNamed(
              RoastingSlipDetailScreen.routeName,
              arguments: slipCode,
            );
          }
        } else if (route == PackingSlipDetailsScreen.routeName) {
          final slipCode = data["slipCode"] != null
              ? data["slipCode"] as String
              : null;
          if (slipCode != null) {
            AppWireFrame.pushNamed(
              PackingSlipDetailsScreen.routeName,
              arguments: slipCode,
            );
          }
        } else if (route == QuotationDetailsScreen.routeName) {
          final quotationCode = data["quotationCode"] != null
              ? data["quotationCode"] as String
              : null;
          if (quotationCode != null) {
            AppWireFrame.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) =>
                    QuotationDetailsScreen(code: quotationCode),
              ),
            );
          }
        }
      }

      // final payloadDecode = jsonDecode(details.payload!);
      // final routePayload = payloadDecode["route"];
      // if (routePayload == TicketDetailsScreen.keyName) {
      //   final ticketId = payloadDecode["data"] != null
      //       ? payloadDecode["data"] as String
      //       : null;
      //   if (ticketId != null) {
      //     await onTapTicketNotification(ticketId);
      //   }
      // } else if (routePayload == ChatScreen.keyName) {
      //   if (details.id != null) {
      //     final notificationCancels = notificationCancel.value;
      //     final itemCancel =
      //         notificationCancels.where((e) => e.id == details.id);
      //     if (itemCancel.isNotEmpty) {
      //       await flutterLocalNotificationsPlugin.cancel(
      //         itemCancel.first.id,
      //         tag: itemCancel.first.tag,
      //       );
      //     }
      //   }

      //   await onTapMessageNotification(payloadDecode);
      // } else if (routePayload == AddContactScreen.friendRequestKey) {
      //   await onTapFriendRequestNotification(
      //     payloadDecode,
      //     notificationId: details.id,
      //     actionId: details.actionId,
      //   );
      // }
    }
  }
}
