import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/services/local_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zili_coffee/firebase_options.dart';

import 'app_flavor_config.dart';

class AppConfig {
  static Future<void> initConfig() async {
    setupDependencyInjection();
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await _tryLoadEnv();
    // Firebase handler ------------------------------------------------------------
    try {
      await Firebase.initializeApp(
        name: DefaultFirebaseOptions.appName,
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        /// Force disable Crashlytics collection while doing every day development.
        /// Temporarily toggle this to true if you want to test crash reporting in your app.
        ///
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          false,
        );
      }
      _tryToUseFirebaseMessaging();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    } catch (e, stackTrace) {
      // Firebase initialization failed
      log(
        "Warning: Firebase initialization failed. "
        "App sẽ tiếp tục chạy nhưng không có Firebase services. "
        "Error: $e",
      );
      if (kDebugMode) {
        log("Stack trace: $stackTrace");
      }
    }
    // -----------------------------------------------------------------------------
    await di<LocalStoreService>().config();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  static Future<void> _tryLoadEnv() async {
    try {
      await dotenv.load(fileName: FlavorConfig.instance.env.path);
    } catch (e) {
      // Nếu file .env không tồn tại, sử dụng giá trị mặc định
      // hoặc tạo file .env từ template
      log('Warning: Could not load .env file: $e');
      log(
        'Please create a .env file in the project root with required variables.',
      );
      await dotenv.load(fileName: '.env.example');
    }
  }

  static void _tryToUseFirebaseMessaging() {
    try {
      FirebaseMessaging.onBackgroundMessage(onBackground);
    } catch (e) {
      // Firebase Messaging không available (SERVICE_NOT_AVAILABLE)
      // Thường xảy ra khi Google Play Services không có hoặc không được cài đặt
      log(
        "Warning: Firebase Messaging không available. "
        "App sẽ tiếp tục chạy nhưng không có push notification. "
        "Error: $e",
      );
    }
  }

  static final locale = _Locale();
}

Future<void> onBackground(RemoteMessage message) async {}

class _Locale {
  final List<LocalizationsDelegate<Object>> delegates = const [
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  Locale? Function(Locale?, Iterable<Locale>)? resolutionCallback =
      (locale, supportedLocales) => locale;

  Iterable<Locale> supportedLocales = [
    Locale(AppConstant.strings.langCode, AppConstant.strings.countryCode),
  ];
}
