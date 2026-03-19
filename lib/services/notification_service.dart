// import 'dart:async';

// class NotificationName {
//   static const reloadSomethingAtAnywhere = 'reloadSomethingAtAnywhere';
//   static const newMessage = 'newMessage';
//   static const needToReloadMessageUnread = 'needToReloadMessageUnread';
//   static const needToReloadCountMessageUnread =
//       'needToReloadCountMessageUnread';
// }

// class NotificationService {
//   factory NotificationService() {
//     return _shared;
//   }

//   NotificationService._internal();

//   static final NotificationService _shared = NotificationService._internal();

//   final StreamController<NotificationServiceObject> _controller =
//       StreamController<NotificationServiceObject>.broadcast();

//   void add(String name, {dynamic value}) {
//     _controller.add(
//       NotificationServiceObject(
//         name,
//         value: value,
//       ),
//     );
//   }

//   StreamSubscription<NotificationServiceObject> listen(
//     void Function(NotificationServiceObject) event,
//   ) {
//     return _controller.stream.listen(event);
//   }
// }

// class NotificationServiceObject {
//   NotificationServiceObject(
//     this.name, {
//     required this.value,
//   });

//   final String name;
//   final dynamic value;
// }
