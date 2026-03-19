import '../notification_service.dart';

extension HandleOnTapNotification on NotificationService {
  Future<void> onTapTicketNotification(String ticketId) async {
    // di<SupportTicketRepository>().ticket.sink.add(null);
    // di<SupportTicketCubit>()
    //   ..getSupportTicketDetails(ticketId: ticketId)
    //   ..getCommentsOfTicket(ticketId: ticketId);
    // AppWireFrame.gotoTicketDetails(ticketId);
  }

  Future<void> onTapFriendRequestNotification(
    Map<String, dynamic> payload, {
    int? notificationId,
    String? actionId,
  }) async {
    // // Cancel current notification to prevent spam tap on action button
    // if (notificationId != null) {
    //   final notificationCancels = notificationCancel.value;
    //   final itemCancel =
    //       notificationCancels.where((e) => e.id == notificationId);
    //   if (itemCancel.isNotEmpty) {
    //     await flutterLocalNotificationsPlugin.cancel(
    //       itemCancel.first.id,
    //       tag: itemCancel.first.tag,
    //     );
    //   }
    // }

    // final friendId = payload["friendId"];
    // if (friendId != null && friendId is String && actionId != null) {
    //   if (actionId == FriendRequestActionId.accept.name) {
    //     di<ContactCubit>().acceptFriendRequest(friendId);
    //   } else {
    //     di<ContactCubit>().denyFriendRequest(friendId);
    //   }
    // }
  }

  Future<void> onTapMessageNotification(Map<String, dynamic> payload) async {
    // // Get all data from map & check it is available.
    // final conversationId =
    //     payload["data"] != null ? payload["data"] as String : null;
    // final friend =
    //     payload["sender"] != null ? Friend.fromMap(payload["sender"]) : null;
    // if (conversationId.isNull || friend.isNull) return;

    // // Find conversation
    // final conversations =
    //     di<ConversationRepository>().conversations.valueOrNull?.conversations ??
    //         [];
    // final conversationsById =
    //     conversations.where((con) => con.id == conversationId).toList();
    // final conversation =
    //     conversationsById.isEmpty ? null : conversationsById.first;

    // // Handle push screen by current route
    // final currentRoute = AppWireFrame.getNamePath();
    // final containChatScreenRoute =
    //     currentRoute?.split(":").first == ChatScreen.keyName;
    // if (containChatScreenRoute) {
    //   // currentRoute will not null if containChatScreenRoute is true
    //   final willPopScreen = currentRoute!.split("/").last;
    //   final popScreens = [
    //     CustomizeChatRoomScreen.keyName,
    //     GalleryScreen.keyName,
    //   ];
    //   if (popScreens.contains(willPopScreen)) AppWireFrame.popScreen();

    //   // Replace current chat screen if conversation id it not true
    //   final notInChatScreen =
    //       currentRoute != ChatScreen.screenRoute(conversationId);
    //   if (notInChatScreen) {
    //     await AppWireFrame.replaceChatScreen(
    //       conversationId!,
    //       friend: friend!,
    //       conversation: conversation,
    //     );
    //   }
    // } else {
    //   await AppWireFrame.pushChatScreen(
    //     conversationId!,
    //     friend: friend!,
    //     conversation: conversation,
    //   );
    // }
  }
}
