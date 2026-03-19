# FCMHandler Documentation

## Tổng quan

`FCMHandler` là class quản lý việc nhận và xử lý các thông báo push từ Firebase Cloud Messaging (FCM). Class này đảm bảo không mất thông báo bằng cách sử dụng queue mechanism và auto retry.

## Tính năng chính

### 1. Xử lý thông báo ở các trạng thái khác nhau của app

- **Terminated state**: Khi app đã đóng hoàn toàn và user tap vào notification
- **Foreground state**: Khi app đang mở và nhận được notification
- **Background state**: Khi app ở background và user tap vào notification

### 2. Queue Mechanism

- Lưu các message khi context chưa sẵn sàng
- Tự động retry khi context đã sẵn sàng
- Xóa các message quá cũ (hơn 30 giây)

### 3. Context Safety

- Kiểm tra `context.mounted` trước khi sử dụng
- Sử dụng `navigatorKey.currentContext` để lấy context an toàn
- Tránh lỗi "BuildContext used across async gaps"

## Cách sử dụng

### Khởi tạo

```dart
final fcmHandler = FCMHandler(
  notificationService: NotificationService(),
);
```

### Thiết lập listeners

```dart
fcmHandler.handleFirebaseMessagingStates(context);
```

**Lưu ý:** Chỉ nên gọi method này một lần trong lifecycle của app (thường là trong `initState` hoặc `builder` của MaterialApp).

### Cleanup

```dart
fcmHandler.dispose();
```

## Các methods chính

### `handleFirebaseMessagingStates(BuildContext context)`

Khởi tạo và thiết lập các listeners cho FCM notifications.

**Chức năng:**
1. Khởi tạo notification service
2. Thiết lập listener cho `getInitialMessage()` - xử lý notification khi app ở terminated state
3. Thiết lập listener cho `onMessage` - xử lý notification khi app ở foreground
4. Thiết lập listener cho `onMessageOpenedApp` - xử lý khi user tap notification ở background
5. Request permission để nhận notifications

**Lưu ý:** Method này sẽ tự động bỏ qua nếu đã được gọi trước đó.

### `_onMessage(BuildContext context, RemoteMessage message)`

Xử lý notification khi app đang ở foreground.

**Khi nào được gọi:**
- App đang mở (foreground)
- Nhận được notification từ FCM

**Xử lý:**
- Phân tích loại notification từ `message.data["type"]`
- Xử lý tương ứng với từng loại notification (WarehouseNotifications)

### `_onMessageOpenedApp(BuildContext context, RemoteMessage message)`

Xử lý khi user tap vào notification khi app ở background.

**Khi nào được gọi:**
- App đang ở background (không phải terminated)
- User tap vào notification trong notification tray

**Lưu ý:** Nếu user tap notification khi app ở terminated state, sẽ được xử lý bởi `_getInitialMessage()` thay vì method này.

### `_getInitialMessage(BuildContext context, RemoteMessage? message)`

Xử lý notification khi app được mở từ terminated state.

**Khi nào được gọi:**
- App đang ở terminated state (đã đóng hoàn toàn)
- User tap vào notification để mở app
- App khởi động và cần xử lý notification đã tap

**Khác biệt với `_onMessageOpenedApp`:**
- `_getInitialMessage`: App ở terminated → tap notification → mở app
- `_onMessageOpenedApp`: App ở background → tap notification → bring to foreground

## Cơ chế hoạt động nội bộ

### Queue và Retry Mechanism

1. **Khi nhận message:**
   - Kiểm tra context có sẵn sàng không
   - Nếu sẵn sàng: Xử lý ngay
   - Nếu chưa sẵn sàng: Lưu vào queue

2. **Retry tự động:**
   - Retry ngay sau 100ms
   - Timer định kỳ mỗi 500ms để kiểm tra và xử lý message pending

3. **Cleanup:**
   - Tự động xóa các message quá cũ (hơn 30 giây)

### Context Safety

- Sử dụng `AppWireFrame.navigatorKey.currentContext` thay vì context trực tiếp
- Kiểm tra `context.mounted` trước khi sử dụng
- Tránh lỗi "BuildContext used across async gaps"

## Ví dụ sử dụng trong app

```dart
class _MyAppState extends State<MyApp> {
  late final FCMHandler _fcmHandler;

  @override
  void initState() {
    super.initState();
    _fcmHandler = FCMHandler(
      notificationService: NotificationService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (childContext, child) {
        _fcmHandler.handleFirebaseMessagingStates(childContext);
        return child ?? const SizedBox();
      },
      // ... other config
    );
  }

  @override
  void dispose() {
    _fcmHandler.dispose();
    super.dispose();
  }
}
```

## Lưu ý quan trọng

1. **Chỉ khởi tạo một lần:** `handleFirebaseMessagingStates` chỉ nên được gọi một lần
2. **Cleanup:** Nên gọi `dispose()` khi không còn sử dụng
3. **Context safety:** Class tự động xử lý việc kiểm tra context, không cần lo lắng về async gaps
4. **Message queue:** Các message sẽ được lưu và xử lý tự động khi context sẵn sàng, không bị mất

## Troubleshooting

### Message không được xử lý

- Kiểm tra xem `handleFirebaseMessagingStates` đã được gọi chưa
- Kiểm tra permission notification đã được cấp chưa
- Kiểm tra log để xem message có được nhận không

### Context errors

- Class tự động xử lý context safety, nhưng nếu vẫn gặp lỗi, kiểm tra `navigatorKey` đã được set chưa

## Tài liệu liên quan

- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)

