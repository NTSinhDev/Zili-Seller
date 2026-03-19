# Zili Coffee Seller App

A sales management application supporting revenue analytics, multi-channel order management (Website, Facebook, Shopee), customer management, product quotation, inventory management, and production warehouse operations.

## Release notes / Changelog
See `CHANGELOG.md` for the full release history and upcoming changes.
Release process guide: `documents/RELEASE.md`.

## Requirements
- Flutter SDK: 3.38.3
- Dart SDK: >=3.10.0 <4.0.0
- Android Studio or Xcode (for device/emulator)

## Setup
1. Install Flutter dependencies: `flutter pub get`
2. Create a `.env` file based on the environment you need (sample keys are referenced in code)
3. Run code generation if required by your changes

## Run
- Android: `flutter run`
- iOS: `flutter run -d ios`
- Web: `flutter run -d chrome`

## Build
- Android APK: `flutter build apk`
- Android App Bundle: `flutter build appbundle`
- iOS (release): `flutter build ios --release`
- iOS IPA (release): `flutter build ipa --release`

## Testing
- Unit tests: `flutter test`

## Project structure
- `lib/` application source
- `assets/` images, icons, animations
- `scripts/` developer scripts
- `tools/` developer tools generate
