import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../firebase_cloud_messaging_services.dart';

extension OnTapFCM on FCMHandler {
  Future openTicket(BuildContext context, RemoteMessage message) async {
    final ticketId = message.data["ticketId"] != null
        ? message.data["ticketId"] as String
        : null;
    if (ticketId != null && ticketId != "") {
      // AppWireFrame.gotoTicketDetails(ticketId);
    }
  }

   Future openMyTicket(BuildContext context, RemoteMessage message) async {
    final ticketId = message.data["ticketId"] != null
        ? message.data["ticketId"] as String
        : null;
    if (ticketId != null && ticketId != "") {
      // AppWireFrame.gotoMyTicketDetails(ticketId!);
    }
  }
}
