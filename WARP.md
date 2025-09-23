# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Project overview
- Type: Flutter application (Dart)
- Platforms detected: Windows (windows/runner), Web (web/), iOS (ios/). No Android folder was found.
- Lints: analysis_options.yaml includes flutter_lints
- README: standard Flutter boilerplate

Required tooling
- Flutter SDK set up and on PATH. Verify with:
```powershell path=null start=null
flutter --version
flutter doctor
```

Install dependencies
```powershell path=null start=null
flutter pub get
```

Common commands
- Analyze (static checks):
```powershell path=null start=null
flutter analyze
```
- Format code (Dart formatter):
```powershell path=null start=null
dart format .
```
- Run app (choose a target as needed):
```powershell path=null start=null
# Windows desktop
flutter run -d windows

# Web (Chrome)
flutter run -d chrome
```
- Tests:
```powershell path=null start=null
# All tests
flutter test

# Single file
flutter test test/widget_test.dart

# Filter by test name (substring match)
flutter test --name "Counter increments"

# Coverage
flutter test --coverage
```
- Builds:
```powershell path=null start=null
# Windows release build (requires Windows desktop support enabled)
flutter build windows

# Web release build (outputs to build/web)
flutter build web

# iOS build (requires macOS + Xcode)
flutter build ios
```

High-level architecture
- Entry point: lib/main.dart defines a MaterialApp (MyApp) and a stateful home page (MyHomePage).
  - Theme uses ColorScheme.fromSeed with a green seed color.
  - State is managed locally via setState in _MyHomePageState with a single integer counter.
  - UI: AppBar + body Column; a FloatingActionButton increments the counter. Note: the FAB uses Icons.eco.
- Tests: test/widget_test.dart contains a basic widget smoke test that builds MyApp and verifies counter behavior. It taps an icon using find.byIcon(Icons.add). Be aware this may not match the current FAB icon (Icons.eco) in main.dart when running tests.
- Configuration:
  - pubspec.yaml: app metadata, Dart SDK constraint ^3.9.2, dependencies include cupertino_icons, dev_dependencies include flutter_test and flutter_lints; uses-material-design: true.
  - analysis_options.yaml: enables flutter_lints; customizable rules section is present but mostly default.
- Platforms: Scaffolding for Windows and Web is present. iOS project files exist; Android folder was not detected.

Notes
- No project-specific agent rules (Claude/Cursor/Copilot) were found.
- No Makefile/Taskfile/melos configuration detected; use the Flutter CLI directly.
