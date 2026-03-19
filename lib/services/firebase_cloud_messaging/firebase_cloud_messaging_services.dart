import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zili_coffee/utils/helpers/crash_logger.dart';

import '../../app/app_wireframe.dart';
import '../../views/quote/details/quotation_details_screen.dart';
import '../../views/warehouse/packing_slip/packing_slip_details/packing_slip_details_screen.dart';
import '../../views/warehouse/roasting_slip/export.dart';
import '../notification_service/notification_service.dart';
import 'firebase_enum.dart';
import 'on_message_in_app/on_message_in_app.dart';

/// Handler cho Firebase Cloud Messaging (FCM) notifications.
///
/// Class này quản lý việc nhận và xử lý các thông báo push từ Firebase:
/// - Xử lý thông báo khi app ở trạng thái terminated (đã đóng hoàn toàn)
/// - Xử lý thông báo khi app ở foreground (đang mở)
/// - Xử lý thông báo khi app ở background và user tap vào notification
///
/// **Tính năng đặc biệt:**
/// - Queue mechanism: Lưu các message khi context chưa sẵn sàng để tránh mất thông báo
/// - Auto retry: Tự động retry xử lý message khi context đã sẵn sàng
/// - Context safety: Kiểm tra `context.mounted` trước khi sử dụng để tránh lỗi
///
/// **Ví dụ sử dụng:**
/// ```dart
/// final fcmHandler = FCMHandler(notificationService: NotificationService());
/// fcmHandler.handleFirebaseMessagingStates(context);
/// ```
///
/// **Lưu ý:**
/// - Chỉ nên gọi `handleFirebaseMessagingStates` một lần trong lifecycle của app
/// - Nên gọi `dispose()` khi không còn sử dụng để cleanup resources
class FCMHandler {
  /// Service để quản lý local notifications
  final NotificationService notificationService;

  /// Queue chứa các message đang chờ xử lý khi context chưa sẵn sàng
  final List<_PendingMessage> _pendingMessages = [];

  /// Flag để đảm bảo chỉ khởi tạo listeners một lần
  bool _isInitialized = false;

  /// Timer để tự động retry xử lý các message pending
  Timer? _retryTimer;

  /// Tạo instance của FCMHandler
  ///
  /// [notificationService] - Service để quản lý local notifications
  ///
  /// Tự động khởi động retry timer để xử lý các message pending
  FCMHandler({required this.notificationService}) {
    // Bắt đầu timer để retry các message pending
    // _startRetryTimer();
  }

  /// Khởi động timer định kỳ để retry xử lý các message pending
  ///
  /// Timer chạy mỗi 500ms để kiểm tra và xử lý các message trong queue
  void _startRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_pendingMessages.isNotEmpty) {
        _processPendingMessages();
      }
    });
  }

  /// Cleanup resources khi không còn sử dụng
  ///
  /// Hủy timer và xóa tất cả message pending
  void dispose() {
    _retryTimer?.cancel();
    _pendingMessages.clear();
  }

  /// Khởi tạo và thiết lập các listeners cho FCM notifications
  ///
  /// Method này sẽ:
  /// 1. Khởi tạo notification service
  /// 2. Thiết lập listener cho `getInitialMessage()` - xử lý notification khi app ở terminated state
  /// 3. Thiết lập listener cho `onMessage` - xử lý notification khi app ở foreground
  /// 4. Thiết lập listener cho `onMessageOpenedApp` - xử lý khi user tap notification ở background
  /// 5. Request permission để nhận notifications
  ///
  /// **Lưu ý:**
  /// - Chỉ nên gọi method này một lần trong lifecycle của app
  /// - Method này sẽ tự động bỏ qua nếu đã được gọi trước đó (`_isInitialized`)
  ///
  /// [context] - BuildContext để khởi tạo notification service
  void handleFirebaseMessagingStates(BuildContext context) {
    if (_isInitialized) return;
    _isInitialized = true;

    notificationService.initNotification(context: context);

    // Nhận data khi người dùng ấn vào thông báo khi app ở terminal
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      _processMessageWithRetry(
        message: message,
        handler: (ctx) => _getInitialMessage(ctx, message),
      );
    });

    // Nhận data khi app đã mở và không có push notification từ FCM
    FirebaseMessaging.onMessage.listen((message) {
      log('FCM ${DateTime.now().toString()}: ${message.data.toString()}');
      _processMessageWithRetry(
        message: message,
        handler: (ctx) => _onMessage(ctx, message),
      );
    });

    // Nhận data khi người dùng ấn vào thông báo khi app ở background.
    // Nếu ấn vào thông báo ở terminal sẽ được xử lý ở getInitialMessage
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _processMessageWithRetry(
        message: message,
        handler: (ctx) => _onMessageOpenedApp(ctx, message),
      );
    });
    FirebaseMessaging.instance.requestPermission();
  }

  /// Xử lý message với cơ chế retry tự động
  ///
  /// Nếu context đã sẵn sàng, xử lý message ngay lập tức.
  /// Nếu context chưa sẵn sàng, lưu message vào queue và retry sau.
  ///
  /// **Cơ chế hoạt động:**
  /// 1. Kiểm tra `navigatorKey.currentContext` có sẵn sàng không
  /// 2. Nếu sẵn sàng: Gọi handler ngay và xử lý các message pending
  /// 3. Nếu chưa sẵn sàng: Lưu vào queue và retry sau 100ms
  ///
  /// [message] - RemoteMessage từ FCM (có thể null)
  /// [handler] - Function để xử lý message với context
  void _processMessageWithRetry({
    required RemoteMessage? message,
    required void Function(BuildContext) handler,
  }) {
    final context = AppWireFrame.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      handler(context);
      _processPendingMessages();
    } else {
      // Lưu message để xử lý sau
      _pendingMessages.add(
        _PendingMessage(
          message: message,
          handler: handler,
          timestamp: DateTime.now(),
        ),
      );
      // Retry ngay lập tức và sau đó timer sẽ tiếp tục retry
      Future.delayed(const Duration(milliseconds: 100), () {
        _processPendingMessages();
      });
    }
  }

  /// Xử lý tất cả các message đang chờ trong queue
  ///
  /// Method này sẽ:
  /// 1. Kiểm tra context có sẵn sàng không
  /// 2. Xóa các message quá cũ (hơn 30 giây)
  /// 3. Xử lý từng message trong queue
  /// 4. Nếu context vẫn chưa sẵn sàng, thêm lại vào queue để retry sau
  ///
  /// Được gọi tự động bởi:
  /// - Retry timer (mỗi 500ms)
  /// - Khi có message mới được xử lý thành công
  void _processPendingMessages() {
    final context = AppWireFrame.navigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    // Xóa các message quá cũ (hơn 30 giây)
    final now = DateTime.now();
    _pendingMessages.removeWhere(
      (pending) => now.difference(pending.timestamp).inSeconds > 30,
    );

    if (_pendingMessages.isEmpty) return;

    final messagesToProcess = List<_PendingMessage>.from(_pendingMessages);
    _pendingMessages.clear();

    for (final pending in messagesToProcess) {
      final currentContext = AppWireFrame.navigatorKey.currentContext;
      if (currentContext != null && currentContext.mounted) {
        pending.handler(currentContext);
      } else {
        // Nếu context vẫn chưa sẵn sàng, thêm lại vào queue
        _pendingMessages.add(pending);
      }
    }
  }

  /// Xử lý notification khi app đang ở foreground
  ///
  /// Method này được gọi khi app đang mở và nhận được notification từ FCM.
  /// Phân tích loại notification từ `message.data["type"]` và xử lý tương ứng.
  ///
  /// **Các loại notification được hỗ trợ:**
  /// - WarehouseNotifications: Các thông báo liên quan đến warehouse
  ///
  /// [context] - BuildContext để navigate hoặc show dialog
  /// [message] - RemoteMessage từ FCM chứa data và notification payload
  void _onMessage(BuildContext context, RemoteMessage message) async {
    FirebaseMessagingType? fcmType = message.data["type"] != null
        ? FirebaseMessagingType.tryParse(message.data["type"] as String?)
        : FirebaseMessagingType.tryParse(
            message.data["documentType"]
                as String?, // This line is try to parse other type field from the message data
          );
    log('FCM data: ${message.data.toString()}');

    switch (fcmType) {
      case FirebaseMessagingType.newRoastingSlip:
        await newRoastingSlip(context, data: message.data);
        break;
      case FirebaseMessagingType.completedRoastingSlip:
        await completedRoastingSlip(context, data: message.data);
        break;
      case FirebaseMessagingType.cancelledRoastingSlip:
        await cancelledRoastingSlip(context, data: message.data);
        break;
      case FirebaseMessagingType.newPackingSlip:
        await newPackingSlip(context, data: message.data);
        break;
      case FirebaseMessagingType.completedPackingSlip:
        await newPackingSlip(context, data: message.data);
        break;
      case FirebaseMessagingType.cancelledPackingSlip:
        await newPackingSlip(context, data: message.data);
        break;
      case FirebaseMessagingType.exportedMaterialPackingSlip:
        await exportedMaterialPackingSlip(context, data: message.data);
        break;
      case FirebaseMessagingType.createQuotation:
        await createQuotation(context, data: message.data);
        break;
      case FirebaseMessagingType.approveQuotation:
        await approveQuotation(context, data: message.data);
        break;
      case FirebaseMessagingType.rejectQuotation:
        await rejectQuotation(context, data: message.data);
        break;
      default:
        if (kDebugMode) {
          await notificationService.showNotification(
            id: 1,
            title: "Thông báo mới",
            body: "Không thể hiển thị thông báo với type: $fcmType",
          );
        } else {
          CrashLogger.tryToRecordError(
            "Không thể hiển thị thông báo với type: $fcmType",
            error: message.data,
            stackTrace: .current,
          );
        }
    }
  }

  /// Xử lý khi user tap vào notification khi app ở background
  ///
  /// Method này được gọi khi:
  /// - App đang ở background (không phải terminated)
  /// - User tap vào notification trong notification tray
  ///
  /// **Lưu ý:** Nếu user tap notification khi app ở terminated state,
  /// sẽ được xử lý bởi `_getInitialMessage()` thay vì method này.
  ///
  /// [context] - BuildContext để navigate đến màn hình tương ứng
  /// [message] - RemoteMessage từ FCM chứa data của notification
  void _onMessageOpenedApp(BuildContext context, RemoteMessage message) async {
    final fcmType = message.data["type"] != null
        ? FirebaseMessagingType.tryParse(message.data["type"] as String)
        : null;
    switch (fcmType) {
      case FirebaseMessagingType.newRoastingSlip:
      case FirebaseMessagingType.completedRoastingSlip:
      case FirebaseMessagingType.cancelledRoastingSlip:
        final slipCode = message.data["slipCode"] != null
            ? message.data["slipCode"] as String?
            : null;
        AppWireFrame.pushNamed(
          RoastingSlipDetailScreen.routeName,
          arguments: slipCode,
        );
      case FirebaseMessagingType.newPackingSlip:
      case FirebaseMessagingType.completedPackingSlip:
      case FirebaseMessagingType.cancelledPackingSlip:
      case FirebaseMessagingType.exportedMaterialPackingSlip:
        final slipCode = message.data["slipCode"] != null
            ? message.data["slipCode"] as String?
            : null;
        AppWireFrame.pushNamed(
          PackingSlipDetailsScreen.routeName,
          arguments: slipCode,
        );
      case FirebaseMessagingType.createQuotation:
      case FirebaseMessagingType.approveQuotation:
      case FirebaseMessagingType.rejectQuotation:
        AppWireFrame.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => QuotationDetailsScreen(
              code: message.data["quotationCode"] as String? ?? "",
            ),
          ),
        );
        break;
      default:
        if (kDebugMode) {
          log(
            "Kiểu thông báo nhưng chưa xử lý sự kiện ấn vào.\n ${fcmType?.name}",
          );
        }
    }
  }

  /// Xử lý notification khi app được mở từ terminated state
  ///
  /// Method này được gọi khi:
  /// - App đang ở terminated state (đã đóng hoàn toàn)
  /// - User tap vào notification để mở app
  /// - App khởi động và cần xử lý notification đã tap
  ///
  /// **Khác biệt với `_onMessageOpenedApp`:**
  /// - `_getInitialMessage`: App ở terminated → tap notification → mở app
  /// - `_onMessageOpenedApp`: App ở background → tap notification → bring to foreground
  ///
  /// [context] - BuildContext để navigate đến màn hình tương ứng
  /// [message] - RemoteMessage từ FCM (có thể null nếu không có notification)
  void _getInitialMessage(BuildContext context, RemoteMessage? message) async {
    if (message != null) {
      final fcmType = message.data["type"] != null
          ? FirebaseMessagingType.tryParse(message.data["type"] as String)
          : null;
      switch (fcmType) {
        case FirebaseMessagingType.newRoastingSlip:
        case FirebaseMessagingType.completedRoastingSlip:
        case FirebaseMessagingType.cancelledRoastingSlip:
          final slipCode = message.data["slipCode"] != null
              ? message.data["slipCode"] as String?
              : null;
          AppWireFrame.pushNamed(
            RoastingSlipDetailScreen.routeName,
            arguments: slipCode,
          );
        case FirebaseMessagingType.newPackingSlip:
        case FirebaseMessagingType.completedPackingSlip:
        case FirebaseMessagingType.cancelledPackingSlip:
        case FirebaseMessagingType.exportedMaterialPackingSlip:
          final slipCode = message.data["slipCode"] != null
              ? message.data["slipCode"] as String?
              : null;
          AppWireFrame.pushNamed(
            PackingSlipDetailsScreen.routeName,
            arguments: slipCode,
          );
          break;
        case FirebaseMessagingType.createQuotation:
        case FirebaseMessagingType.approveQuotation:
        case FirebaseMessagingType.rejectQuotation:
          AppWireFrame.navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => QuotationDetailsScreen(
                code: message.data["quotationCode"] as String? ?? "",
              ),
            ),
          );
          break;
        default:
          if (kDebugMode) {
            log(
              "Kiểu thông báo nhưng chưa xử lý sự kiện ấn vào.\n ${fcmType?.name}",
            );
          }
      }
    }
  }
}

/// Internal class để lưu trữ message đang chờ xử lý
///
/// Sử dụng khi context chưa sẵn sàng để xử lý message ngay lập tức.
/// Message sẽ được retry tự động khi context đã sẵn sàng.
class _PendingMessage {
  /// RemoteMessage từ FCM (có thể null)
  final RemoteMessage? message;

  /// Handler function để xử lý message với context
  final void Function(BuildContext) handler;

  /// Timestamp khi message được thêm vào queue
  /// Dùng để xóa các message quá cũ (hơn 30 giây)
  final DateTime timestamp;

  _PendingMessage({
    required this.message,
    required this.handler,
    required this.timestamp,
  });
}
