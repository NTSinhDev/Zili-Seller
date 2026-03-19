import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:zili_coffee/app/app_config.dart';
import 'package:zili_coffee/app/app_entry.dart';
import 'package:zili_coffee/app/app_flavor_config.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      FlavorConfig(env: .dev);
      HttpOverrides.global = MyHttpOverrides();
      await AppConfig.initConfig();
      runApp(const ZiliSellerApp());
    },
    (Object error, StackTrace stackTrace) {
      try {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      } catch (e) {
        // Firebase Crashlytics không available, chỉ log error
        log("Error: $error");
        log("Stack trace: $stackTrace");
      }
      log("Error: $error");
    },
  );
}

// To resolve Flutter CERTIFICATE_VERIFY_FAILED error while performing a POST request
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
