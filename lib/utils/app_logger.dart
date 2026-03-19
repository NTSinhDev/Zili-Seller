import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// =============================================================
/// APP LOGGER – SINGLE SOURCE OF TRUTH
/// =============================================================
///
/// Usage:
///   AppLogger.d("debug");
///   AppLogger.i("info");
///   AppLogger.w("warning");
///   AppLogger.e("error", error, stackTrace);
///   AppLogger.f("fatal", error, stackTrace);
///
class AppLogger {
  AppLogger._();

  /// -------------------------------------------------------------
  /// Logger core (console)
  /// -------------------------------------------------------------
  static final Logger _logger = Logger(
    level: kDebugMode ? Level.verbose : Level.info,
    printer: PrettyPrinter(
      methodCount: kDebugMode ? 2 : 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: kDebugMode,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: _ConsoleOutput(),
  );

  /// -------------------------------------------------------------
  /// Public APIs
  /// -------------------------------------------------------------
  static void d(String message, {Object? extra}) {
    if (!kDebugMode) return;
    _logger.d(_format(message, extra));
  }

  static void i(String message, {Object? extra}) {
    _logger.i(_format(message, extra));
  }

  static void w(String message, {Object? extra}) {
    _logger.w(_format(message, extra));
  }

  static void e(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  ]) {
    _logger.e(_format(message, extra), time: DateTime.now(), error: error, stackTrace: stackTrace);
    _reportToCrashlytics(
      message: message,
      error: error,
      stackTrace: stackTrace,
      fatal: false,
      extra: extra,
    );
  }

  static void f(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  ]) {
    _logger.f(_format(message, extra), time: DateTime.now(), error: error, stackTrace: stackTrace);
    _reportToCrashlytics(
      message: message,
      error: error,
      stackTrace: stackTrace,
      fatal: true,
      extra: extra,
    );
  }

  /// -------------------------------------------------------------
  /// Firebase Crashlytics
  /// -------------------------------------------------------------
  static Future<void> _reportToCrashlytics({
    required String message,
    Object? error,
    StackTrace? stackTrace,
    required bool fatal,
    Map<String, dynamic>? extra,
  }) async {
    if (kDebugMode) return;

    try {
      if (extra != null) {
        for (final entry in extra.entries) {
          await FirebaseCrashlytics.instance.setCustomKey(
            entry.key,
            entry.value.toString(),
          );
        }
      }

      await FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace,
        reason: message,
        fatal: fatal,
      );
    } catch (_) {
      // absolutely do nothing
    }
  }

  /// -------------------------------------------------------------
  /// Utils
  /// -------------------------------------------------------------
  static String _format(String message, Object? extra) {
    if (extra == null) return message;
    return '$message | extra: $extra';
  }
}

/// =============================================================
/// Custom console output
/// =============================================================
class _ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      dev.log(line, name: 'APP_LOG');
    }
  }
}
