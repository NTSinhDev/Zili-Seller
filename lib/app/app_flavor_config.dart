import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor { dev, qc, stg, production }

class FlavorConfig {
  FlavorConfig._internal(this.env);

  final Flavor env;

  static late FlavorConfig _instance;
  static FlavorConfig get instance {
    return _instance;
  }

  bool get isProduction => env == Flavor.production;

  factory FlavorConfig({required Flavor env}) {
    return _instance = FlavorConfig._internal(env);
  }
}

extension FlavorExt on Flavor {
  String get appName => dotenv.env['APP_NAME'] ?? "";
  // String get appVersion => dotenv.env['APP_VERSION'] ?? "";

  String get path {
    switch (this) {
      case Flavor.dev:
      case Flavor.qc:
      case Flavor.stg:
      case Flavor.production:
        return '.env';
    }
  }

  String get domainUrl => dotenv.env['DOMAIN_URL'] ?? "";
  String get baseUrl => dotenv.env['BASE_URL'] ?? "";
  String get coreUrl => dotenv.env['CORE_URL'] ?? baseUrl;
  String get userUrl => dotenv.env['USER_URL'] ?? baseUrl;
  String get authUrl => dotenv.env['AUTH_URL'] ?? baseUrl;
  String get systemUrl => dotenv.env['SYSTEM_URL'] ?? baseUrl;
  String get ziliCoffeeWebsiteUrl => dotenv.env['ZILI_COFFEE_WEBSITE_URL'] ?? "";
}
