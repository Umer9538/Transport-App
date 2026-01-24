# RideSync - Private Transportation Subscription App

A comprehensive Flutter-based private transportation subscription application that enables users to subscribe to daily commute plans with assigned drivers, manage schedules, track trips in real-time, and handle payments seamlessly.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Testing](#testing)
- [Localization](#localization)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

RideSync is a subscription-based private transportation platform designed for daily commuters. Unlike traditional ride-hailing apps, RideSync focuses on scheduled, recurring trips with dedicated drivers, providing a reliable and predictable commute experience.

### Key Value Propositions

- **Subscription-based model** - Fixed monthly plans for predictable commute costs
- **Dedicated drivers** - Consistent driver assignments for familiarity and trust
- **Smart scheduling** - Automated daily trip scheduling with easy modifications
- **Real-time tracking** - Live GPS tracking of assigned drivers
- **Multi-language support** - English and Arabic localization
- **Dark mode** - Full dark theme support for comfortable viewing

---

## Features

### User-Facing Features

| Feature | Description |
|---------|-------------|
| **Onboarding** | Guided app introduction with smooth animations |
| **Phone Authentication** | Firebase phone/OTP verification |
| **Subscription Plans** | Browse and subscribe to commute plans (Basic, Standard, Premium, VIP) |
| **Schedule Management** | View, modify, and cancel scheduled trips |
| **Real-time Tracking** | Live driver location on Google Maps |
| **Trip History** | Complete trip records with receipts |
| **Driver Rating** | Rate and review drivers after trips |
| **Profile Management** | Personal info, saved addresses, payment methods |
| **Notifications** | Push notifications for trip updates |
| **Live Chat Support** | In-app messaging with support team |
| **Referral Program** | Invite friends and earn credits |
| **Promo Offers** | Redeem promotional codes for discounts |
| **Dark Theme** | System, light, and dark theme options |
| **Localization** | English and Arabic language support |

### Admin Panel

| Feature | Description |
|---------|-------------|
| **Dashboard** | Overview stats, revenue, and recent activity |
| **Trip Management** | Create, assign, and manage trips |
| **User Management** | Search, filter, and manage registered users |
| **Driver Management** | Monitor driver status and assignments |
| **Analytics** | Revenue charts, trip volume, popular routes, driver performance |

---

## Architecture

The project follows a **clean architecture** pattern with clear separation of concerns:

```
lib/
├── config/          # App configuration (routes, constants)
├── core/            # Core utilities and shared logic
│   ├── animations/  # Custom page transitions and animations
│   ├── enums/       # App-wide enumerations
│   ├── errors/      # Exception hierarchy and retry logic
│   ├── localization/# Locale provider and language management
│   └── theme/       # Theme data, colors, and theme provider
├── data/            # Data layer
│   ├── models/      # Data models (Trip, User, Plan, Subscription, Address)
│   ├── providers/   # Riverpod state providers
│   └── services/    # Cache, connectivity, and data services
├── l10n/            # Localization ARB files and generated classes
└── presentation/    # UI layer
    ├── screens/     # Feature-based screen organization
    └── widgets/     # Reusable widget components
```

### State Management

- **Riverpod** - Reactive state management with `StateNotifier` and `StateNotifierProvider`
- Providers for authentication, user data, trips, subscriptions, theme, and locale

### Navigation

- Named route navigation with `onGenerateRoute`
- Custom page transitions (Fade, Slide, Scale)
- Deep linking support

### Error Handling

- Custom exception hierarchy (`AppException` with typed subclasses)
- `RetryHelper` with exponential backoff and jitter
- Reusable error UI widgets (`ErrorView`, `ErrorBanner`, `OfflineBanner`)

### Offline Support

- `CacheService` with TTL-based expiration
- `ConnectivityService` for network state detection
- Graceful offline/online transitions

---

## Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter (Dart) |
| **State Management** | Riverpod |
| **Backend** | Firebase (Auth, Firestore, Storage, Messaging) |
| **Maps** | Google Maps Flutter |
| **Local Storage** | SharedPreferences |
| **HTTP Client** | url_launcher |
| **Animations** | Custom implicit & explicit animations |
| **Localization** | Flutter Intl (ARB-based) |
| **Testing** | flutter_test |

### Dependencies

```yaml
firebase_core, firebase_auth, cloud_firestore, firebase_storage, firebase_messaging
flutter_riverpod, riverpod_annotation
google_maps_flutter, geolocator, geocoding
shared_preferences, intl, url_launcher
flutter_localizations
```

---

## Project Structure

```
driverapp/
├── android/                 # Android platform files
├── ios/                     # iOS platform files
├── web/                     # Web platform files
├── assets/
│   ├── icon/                # App icon assets
│   └── splash/              # Splash screen assets
├── lib/
│   ├── config/
│   │   └── routes.dart      # Route definitions and generation
│   ├── core/
│   │   ├── animations/      # FadeAnimation, StaggeredAnimation, PageTransitions
│   │   ├── enums/           # TripStatus, PlanType, DriverGender, AddressType
│   │   ├── errors/          # AppExceptions, RetryHelper
│   │   ├── localization/    # LocaleNotifier provider
│   │   └── theme/           # AppTheme, AppColors, ThemeNotifier
│   ├── data/
│   │   ├── models/          # TripModel, UserModel, PlanModel, etc.
│   │   ├── providers/       # Riverpod providers
│   │   └── services/        # CacheService, ConnectivityService
│   ├── l10n/
│   │   ├── app_en.arb       # English translations
│   │   ├── app_ar.arb       # Arabic translations
│   │   └── generated/       # Auto-generated localization classes
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── admin/       # Admin dashboard, analytics, management
│   │   │   ├── auth/        # Login, OTP, profile setup
│   │   │   ├── common/      # Location picker
│   │   │   ├── history/     # Trip history, details, receipt
│   │   │   ├── home/        # Home screen
│   │   │   ├── notifications/
│   │   │   ├── offers/      # Promo offers
│   │   │   ├── onboarding/  # App introduction
│   │   │   ├── profile/     # Profile, personal info, addresses, payments
│   │   │   ├── rating/      # Driver rating
│   │   │   ├── referral/    # Referral program
│   │   │   ├── schedule/    # Trip schedule management
│   │   │   ├── settings/    # Settings, login history, terms, privacy
│   │   │   ├── splash/      # Splash screen
│   │   │   ├── subscription/# Plans, setup, payment, my subscription
│   │   │   ├── support/     # Help, live chat
│   │   │   └── tracking/    # Real-time trip tracking
│   │   └── widgets/         # Reusable components
│   ├── firebase_options.dart
│   └── main.dart            # App entry point
├── test/
│   ├── core/                # Provider unit tests
│   ├── models/              # Model unit tests
│   └── widget_test.dart     # Widget smoke test
├── l10n.yaml                # Localization configuration
└── pubspec.yaml             # Dependencies and project config
```

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.9.0`
- Dart SDK `^3.9.0`
- Firebase project configured
- Google Maps API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/driverapp.git
   cd driverapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Phone provider)
   - Enable Cloud Firestore
   - Enable Cloud Storage
   - Enable Cloud Messaging
   - Download and place config files:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`

4. **Configure Google Maps**
   - Get an API key from [Google Cloud Console](https://console.cloud.google.com)
   - Add to `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="YOUR_API_KEY"/>
     ```
   - Add to `ios/Runner/AppDelegate.swift`:
     ```swift
     GMSServices.provideAPIKey("YOUR_API_KEY")
     ```

5. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

6. **Generate app icons and splash screen**
   ```bash
   dart run flutter_launcher_icons
   dart run flutter_native_splash:create
   ```

7. **Run the app**
   ```bash
   flutter run
   ```

---

## Configuration

### Environment Variables

| Variable | Description |
|----------|-------------|
| Google Maps API Key | Required for map features |
| Firebase Config | Auto-generated via FlutterFire CLI |

### Theme Configuration

Theme can be switched at runtime via Settings. Options:
- **System Default** - Follows device theme
- **Light** - Light color scheme
- **Dark** - Dark color scheme

Theme preference is persisted via SharedPreferences.

### Localization

Language can be switched at runtime via Settings. Supported:
- **English (US)** - Default language
- **Arabic** - Full RTL support

---

## Testing

Run all tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

### Test Coverage

| Module | Tests | Coverage |
|--------|-------|----------|
| TripModel | 17 | Status helpers, getters, copyWith, serialization |
| ThemeNotifier | 5 | State management, persistence |
| LocaleNotifier | 5 | Locale switching, persistence |
| Widget Smoke | 1 | App initialization |

---

## Localization

Translation files are located in `lib/l10n/`:

- `app_en.arb` - English (source)
- `app_ar.arb` - Arabic

### Adding a New Language

1. Create `lib/l10n/app_<code>.arb` (e.g., `app_fr.arb`)
2. Add all translation keys from `app_en.arb`
3. Update `LocaleNotifier.supportedLocales` in `lib/core/localization/locale_provider.dart`
4. Run `flutter gen-l10n`

---

## Build

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

---

## Code Quality

```bash
# Static analysis
flutter analyze

# Format code
dart format lib/ test/
```

---

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Coding Standards

- Follow [Effective Dart](https://dart.dev/effective-dart) guidelines
- Use meaningful commit messages
- Write tests for new features
- Ensure `flutter analyze` passes with zero issues

---

## License

This project is proprietary and confidential. Unauthorized copying, distribution, or modification is strictly prohibited.

---

## Contact

**Muhammad Umer**
- Email: muhammadumer9538@gmail.com

---

<p align="center">Built with Flutter</p>
