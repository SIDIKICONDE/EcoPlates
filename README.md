# 🌱 EcoPlates

*Application mobile pour la gestion écologique des assiettes recyclables*

---

## 🚀 Quick Start (with secrets)

**⚠️ IMPORTANT**: This app requires API keys to function. **Never commit secrets to git.**

### 1. Configure Secrets (First Time)

```bash
# Copy environment templates
cp .env.example environments/.env.dev
cp android/local.properties.example android/local.properties
cp ios/Config/Secrets.xcconfig.example ios/Config/Secrets.xcconfig

# Edit each file and add your actual API keys
# See docs/security_setup.md for detailed instructions
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

## 📖 Documentation

- **[🔐 Security Setup](docs/security_setup.md)** - How to configure API keys and secrets
- **[🏗️ Architecture Guide](docs/ARCHITECTURE_10_GUIDE.md)** - Project structure and patterns
- **[📱 Development Guide](Docs/)** - Additional development resources

## 🏗️ Architecture

EcoPlates follows clean architecture principles with:

- **Presentation Layer**: Riverpod state management, GoRouter navigation
- **Domain Layer**: Use cases and business entities  
- **Data Layer**: Repository pattern with Drift (SQLite) + API calls
- **Core**: Shared utilities, constants, and services

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod 3.x
- **Navigation**: GoRouter
- **Database**: Drift (SQLite)
- **HTTP**: Dio
- **Maps**: Google Maps
- **Storage**: Flutter Secure Storage
- **Testing**: flutter_test, Mockito, Patrol

## 📐 Responsive Design

Un système responsive unifié est disponible avec support des grilles adaptatives.

```dart
import 'package:ecoplates/core/responsive/responsive.dart';

// Type d'appareil
final type = context.deviceType; // DeviceType.mobile/tablet/desktop/desktopLarge

// Valeur selon device
final padding = context.responsiveValue(mobile: 12.0, tablet: 16.0, desktop: 20.0);

// UI spécifique par device
return ResponsiveLayout(
  mobile: (_) => MobileView(),
  tablet: (_) => TabletView(),
  desktop: (_) => DesktopView(),
  desktopLarge: (_) => DesktopLargeView(),
);

// Grille responsive auto-adaptative
return ResponsiveGrid(
  config: ResponsiveGridConfig(
    mobile: 1,        // 1 colonne mobile
    tablet: 2,        // 2 colonnes tablette
    desktop: 3,       // 3 colonnes desktop
    desktopLarge: 4,  // 4 colonnes grand desktop
    spacing: 12.0,
    aspectRatio: 1.0,
  ),
  children: itemList,
);

// Grille avec nombre fixe de colonnes
return itemList.toFixedGrid(
  crossAxisCount: 3,
  spacing: 8.0,
  aspectRatio: 1.2,
);
```

Astuce: utilisez `isMobileDevice`, `isTabletDevice`, `isDesktopDevice`, `isDesktopLargeDevice` pour des conditions rapides.

## 🔧 Development

### Prerequisites

- Flutter SDK 3.9.2+
- Dart 3.0+
- Android Studio / Xcode for platform development
- Google Maps API key (see security setup)

### Commands

```bash
# Generate code (Freezed, JSON, etc.)
flutter packages pub run build_runner build

# Run tests
flutter test

# Analyze code
flutter analyze

# Build for release
flutter build apk --release
flutter build ios --release
```

## 🚨 Security

- **Never commit API keys** - Use template files and gitignore
- **Rotate keys regularly** - Every 3-6 months  
- **Restrict API keys** - Package names, bundle IDs, IP restrictions
- See [Security Setup Guide](docs/security_setup.md) for details

## 🤝 Contributing

1. Create a feature branch from `master`
2. Configure your secrets (see security guide)
3. Make your changes following existing patterns
4. Run tests: `flutter test`
5. Submit a pull request

---

*For detailed setup instructions, see [docs/security_setup.md](docs/security_setup.md)*
