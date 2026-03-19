import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../app_logger.dart';

class CrashLogger {
  static Future<void> tryToRecordError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    if (kDebugMode) {
      log("CrashLogger - message: $message");
      if (error != null) {
        AppLogger.e(message, error);
      }
      if (stackTrace != null) {
        log("CrashLogger - stackTrace: ${stackTrace.toString()}");
      }
    } else {
      try {
        final isEnabled =
            FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
        if (!isEnabled) return;
        await FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          information: [message],
        );
      } catch (e) {
        // Firebase Crashlytics không available, chỉ log error
        log("Error: $error");
        log("Stack trace: $stackTrace");
      }
    }
  }
}
