# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

EcoPlates is a Flutter mobile application for managing recyclable plates in an ecological system. The app supports dual-mode architecture:
- **Consumer mode**: Browse, reserve and manage food offers
- **Merchant mode**: Create and manage food inventory, promotions and sales

The project follows **Clean Architecture** principles with strict layer separation:
- **Domain**: Business entities, repository interfaces, use cases
- **Data**: API clients, models, repository implementations  
- **Presentation**: UI screens, widgets, Riverpod providers

## Prerequisites

- **Flutter**: 3.35.4+ (currently using 3.35.4)
- **Dart**: 3.9.2+
- **IDE**: VS Code or Android Studio with Flutter/Dart extensions

## Environment Setup

The project uses multiple environments via dotenv files:

| Environment | File | Usage |
|------------|------|-------|
| Development | `environments/.env.dev` | Local development |
| Staging | `environments/.env.staging` | Testing deployment |
| Production | `environments/.env.prod` | Live deployment |

## Essential Commands

### Code Generation

The project uses multiple code generators. Always run after changing models, entities or providers:

```bash
# Watch mode (recommended during development)
dart run build_runner watch --delete-conflicting-outputs

# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Clean generated files first
dart run build_runner clean
```

**Generators used:**
- `freezed` - Immutable data classes
- `json_serializable` - JSON serialization
- `drift_dev` - Database ORM
- `retrofit_generator` - HTTP client
- `riverpod_generator` - State management
- `auto_route_generator` - Routing

### Running the Application

```bash
# Development environment
flutter run --dart-define=ENV=dev

# Staging environment  
flutter run --dart-define=ENV=staging

# Production environment
flutter run --dart-define=ENV=prod

# Specific platform
flutter run -d windows --dart-define=ENV=dev
flutter run -d chrome --dart-define=ENV=dev
```

### Building for Release

```bash
# Android APK
flutter build apk --release --obfuscate --split-debug-info=debug-symbols/

# Android App Bundle
flutter build appbundle --release --obfuscate --split-debug-info=debug-symbols/

# iOS
flutter build ios --release --obfuscate --split-debug-info=debug-symbols/

# Web
flutter build web --release
```

## Testing & Quality

### Running Tests

```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/

# With coverage
flutter test --coverage
```

### Code Analysis & Linting

The project uses `very_good_analysis` for enterprise-grade linting:

```bash
# Analyze code
flutter analyze

# Auto-fix issues where possible
dart fix --apply

# Format code
dart format .

# Check for outdated packages
flutter pub outdated
```

### Integration Testing

Uses `patrol` for comprehensive E2E testing:

```bash
# Run integration tests
patrol test integration_test/
```

## Architecture Deep Dive

### Directory Structure

```
lib/
├── core/                    # Shared utilities and configuration
│   ├── constants/          # App constants, environment config
│   ├── network/            # HTTP client configuration
│   ├── providers/          # Dependency injection providers
│   ├── router/             # GoRouter configuration
│   ├── services/           # Cross-cutting services
│   ├── themes/             # Material and Cupertino themes
│   └── widgets/            # Reusable UI components
├── data/                   # Data layer
│   ├── data_sources/       # API and local data sources
│   ├── models/             # DTOs and data models
│   └── repositories/       # Repository implementations
├── domain/                 # Business logic layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   ├── services/           # Domain services
│   └── use_cases/          # Business use cases
└── presentation/           # UI layer
    ├── controllers/        # UI state controllers
    ├── pages/              # Screen implementations
    ├── providers/          # Riverpod providers
    ├── screens/            # Main app screens
    └── widgets/            # Feature-specific widgets
```

### Key Architectural Patterns

#### State Management (Riverpod)
```dart
// Provider definition
final foodOfferProvider = FutureProvider<List<FoodOffer>>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return repository.getUrgentOffers();
});

// Usage in widgets
class OffersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(foodOfferProvider);
    return offers.when(
      data: (offers) => OffersList(offers: offers),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => ErrorWidget(error: err),
    );
  }
}
```

#### Navigation (GoRouter)
- Uses `ShellRoute` for unified consumer/merchant navigation
- Route constants defined in `core/router/routes/route_constants.dart`
- Adaptive navigation supporting both platforms

#### Error Handling
Uses `Either<Failure, Success>` pattern for error handling:
```dart
Future<Either<Failure, List<FoodOffer>>> getOffers() async {
  try {
    final offers = await remoteDataSource.getOffers();
    return Right(offers);
  } on ServerException {
    return Left(ServerFailure());
  }
}
```

## Dependency Management

### Key Dependencies

- **State Management**: `flutter_riverpod` 3.0.0
- **Navigation**: `go_router` 16.0.0  
- **HTTP Client**: `dio` 5.7.0, `retrofit` 4.4.1
- **Local Storage**: `drift` 2.20.3, `hive` 2.2.3
- **UI**: `flutter_screenutil` 5.9.3, `cached_network_image` 3.4.1
- **Platform**: `geolocator`, `google_maps_flutter`, `permission_handler`

### Updating Dependencies

```bash
# Check for updates
flutter pub outdated

# Update all to latest compatible versions
flutter pub upgrade

# Update specific package
flutter pub upgrade package_name
```

## Troubleshooting

### Common Issues

#### Code Generation Failures
```bash
# Clean and regenerate
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

#### Build Issues
```bash
# Clean everything
flutter clean
cd ios && pod install && cd ..           # iOS only
cd android && ./gradlew clean && cd ..   # Android only
flutter pub get
```

#### Environment Issues
- Ensure correct `.env` file exists in `environments/`
- Verify `ENV` dart-define parameter matches filename
- Check `EnvConfig.dart` for required environment variables

### Performance Optimization

- Use `const` constructors wherever possible
- Implement proper `dispose()` in controllers
- Use `CachedNetworkImage` for remote images
- Enable image caching via `CacheConfig`

## Development Workflow

### Branch Strategy
- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: Feature development
- `hotfix/*`: Critical fixes

### Code Standards
- Follow `very_good_analysis` linting rules
- Use single quotes for strings
- Prefer relative imports
- Add `const` constructors where possible
- Use `final` for immutable variables

### Commit Conventions
```bash
feat: add new feature
fix: bug fix
docs: documentation changes  
style: formatting, missing semi-colons, etc
refactor: code refactoring
test: adding tests
chore: maintenance tasks
```

## CI/CD Pipeline

The project supports automated builds with the following configuration:

```yaml
# Build matrix for multiple environments
strategy:
  matrix:
    environment: [dev, staging, prod]
    
steps:
  - run: flutter test
  - run: flutter analyze
  - run: flutter build apk --dart-define=ENV=${{ matrix.environment }}
```

Split debug info for release builds:
```bash
flutter build apk --release --obfuscate --split-debug-info=debug-symbols/
```

## Security & Best Practices

- **Never commit** `.env` files with real API keys
- Use `flutter_secure_storage` for sensitive data
- Enable obfuscation in release builds
- Follow RGPD compliance guidelines
- Implement proper error boundaries

## Multi-Platform Considerations

### Android
- Target API 33+
- Material 3 design system
- Gradle build configuration in `android/`

### iOS  
- Cupertino design elements
- CocoaPods dependencies
- iOS 12+ support

### Web
- Limited feature set (no native APIs)
- CORS configuration needed for API calls

### Desktop (Windows/macOS/Linux)
- Experimental support
- Limited plugin compatibility

## Monitoring & Analytics

- **Crash Reporting**: Sentry integration ready
- **Performance**: Custom logging service
- **Analytics**: Structured event tracking
- **Debug Logging**: Controlled by environment config

---

*This guide covers the essential commands and architecture for productive development with EcoPlates. For detailed feature implementation, see the `/Docs` directory.*