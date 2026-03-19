# Project Overview

## Name
Zili Coffee - E-commerce App

## Description
An e-commerce Flutter application for selling coffee online, providing a fast and convenient shopping experience. The app follows Clean Architecture principles with clear separation between data, domain, and presentation layers.

## Key Features
- Product browsing and search
- Shopping cart management
- Order creation and tracking
- User authentication
- Address management
- Payment processing
- Product reviews and ratings
- Blog/Content management
- Flash sales
- Notifications

## Technology Stack
- **Framework**: Flutter 3.38.1 (SDK >=3.0.2 <4.0.0)
- **Dart**: 3.10.0
- **Version Management**: FVM (Flutter Version Management)
- **State Management**: flutter_bloc (BLoC pattern)
- **Dependency Injection**: GetIt
- **Networking**: Dio
- **Architecture**: Clean Architecture (Data, Domain, Presentation layers)
- **Local Storage**: SharedPreferences
- **Image Loading**: cached_network_image
- **UI**: flutter_screenutil, Material Design

## Repository Structure
```
lib/
├── app/              # App configuration and entry point
├── bloc/             # State management (BLoC/Cubit)
├── data/             # Data layer
│   ├── entity/       # Domain entities
│   ├── models/       # Data models
│   ├── middlewares/  # API integration layer
│   ├── repositories/ # Repository implementations
│   ├── use_cases/    # Business logic use cases
│   └── network/      # Network configuration
├── di/               # Dependency injection setup
├── res/              # Resources (colors, strings, themes)
├── services/         # App services (auth, storage, etc.)
├── utils/            # Utilities and helpers
└── views/            # UI screens and widgets
```

## Getting Started
1. Install FVM (Flutter Version Management)
2. Run `fvm install` to install Flutter SDK 3.38.1
3. Run `fvm flutter pub get` to install dependencies
4. Configure environment variables in `app_flavor_config.dart`
5. Run `fvm flutter run` to start the app

