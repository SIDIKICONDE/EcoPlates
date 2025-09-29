import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'eco_theme.dart';

/// Enumération des modes de thème disponibles
enum EcoThemeMode {
  light,
  dark,
  system,
}

/// État du thème de l'application
@immutable
class ThemeState {
  const ThemeState({
    this.themeMode = EcoThemeMode.system,
    this.isDark = false,
  });

  final EcoThemeMode themeMode;
  final bool isDark; // État calculé basé sur le système

  ThemeState copyWith({
    EcoThemeMode? themeMode,
    bool? isDark,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeState &&
        other.themeMode == themeMode &&
        other.isDark == isDark;
  }

  @override
  int get hashCode => Object.hash(themeMode, isDark);
}

/// Notifier pour la gestion du thème
class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    unawaited(_loadTheme());
    _listenToSystemTheme();
    return const ThemeState();
  }

  static const String _themeKey = 'theme_mode';
  SharedPreferences? _prefs;

  /// Charge le thème depuis les préférences
  Future<void> _loadTheme() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final themeModeIndex =
          _prefs?.getInt(_themeKey) ?? EcoThemeMode.system.index;
      final themeMode = EcoThemeMode.values[themeModeIndex];

      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final isDark = _calculateIsDark(themeMode, brightness);

      state = ThemeState(
        themeMode: themeMode,
        isDark: isDark,
      );
    } on Exception {
      // En cas d'erreur, utiliser le thème par défaut
      state = const ThemeState();
    }
  }

  /// Écoute les changements du thème système
  void _listenToSystemTheme() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
          final brightness =
              WidgetsBinding.instance.platformDispatcher.platformBrightness;
          final isDark = _calculateIsDark(state.themeMode, brightness);

          if (state.isDark != isDark) {
            state = state.copyWith(isDark: isDark);
            _updateSystemUI();
          }
        };
  }

  /// Calcule si le thème doit être sombre
  bool _calculateIsDark(EcoThemeMode themeMode, Brightness systemBrightness) {
    switch (themeMode) {
      case EcoThemeMode.light:
        return false;
      case EcoThemeMode.dark:
        return true;
      case EcoThemeMode.system:
        return systemBrightness == Brightness.dark;
    }
  }

  /// Change le mode de thème
  Future<void> setThemeMode(EcoThemeMode themeMode) async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = _calculateIsDark(themeMode, brightness);

    state = ThemeState(
      themeMode: themeMode,
      isDark: isDark,
    );

    await _saveTheme();
    _updateSystemUI();
  }

  /// Bascule entre thème clair et sombre
  Future<void> toggleTheme() async {
    final newThemeMode = state.isDark ? EcoThemeMode.light : EcoThemeMode.dark;
    await setThemeMode(newThemeMode);
  }

  /// Sauvegarde le thème dans les préférences
  Future<void> _saveTheme() async {
    try {
      await _prefs?.setInt(_themeKey, state.themeMode.index);
    } on Exception {
      // Ignore les erreurs de sauvegarde
    }
  }

  /// Met à jour l'UI système (status bar, navigation bar)
  void _updateSystemUI() {
    final isDark = state.isDark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark
            ? const Color(0xFF1C1B1F)
            : const Color(0xFFFFFBFE),
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  /// Force une mise à jour du thème système
  void refreshSystemTheme() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = _calculateIsDark(state.themeMode, brightness);

    if (state.isDark != isDark) {
      state = state.copyWith(isDark: isDark);
      _updateSystemUI();
    }
  }
}

/// Provider pour l'état du thème
final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(() {
  return ThemeNotifier();
});

/// Provider pour obtenir le thème clair
final lightThemeProvider = Provider<ThemeData>((ref) {
  return EcoTheme.lightTheme;
});

/// Provider pour obtenir le thème sombre
final darkThemeProvider = Provider<ThemeData>((ref) {
  return EcoTheme.darkTheme;
});

/// Provider pour obtenir le thème actuel
final currentThemeProvider = Provider<ThemeData>((ref) {
  final themeState = ref.watch<ThemeState>(themeProvider);
  return themeState.isDark ? EcoTheme.darkTheme : EcoTheme.lightTheme;
});

/// Provider pour déterminer si le thème est sombre
final isDarkThemeProvider = Provider<bool>((ref) {
  return ref.watch<ThemeState>(themeProvider).isDark;
});

/// Widget helper pour les thèmes adaptatifs
class ThemeBuilder extends ConsumerWidget {
  const ThemeBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(
    BuildContext context,
    ThemeData theme, {
    required bool isDark,
  })
  builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(currentThemeProvider);
    final isDark = ref.watch(isDarkThemeProvider);

    return builder(context, theme, isDark: isDark);
  }
}

/// Extension pour accéder facilement au thème depuis le contexte
extension BuildContextTheme on BuildContext {
  /// Vérifie si le thème est sombre
  bool get isThemeDark {
    return Theme.of(this).brightness == Brightness.dark;
  }
}

/// Widget de configuration du thème pour l'application
class EcoThemeConfig extends ConsumerWidget {
  const EcoThemeConfig({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final themeState = ref.watch<ThemeState>(themeProvider);

    return MaterialApp(
      title: 'EcoPlates',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _convertThemeMode(themeState.themeMode),
      home: child,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Configuration initiale de l'UI système
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read<ThemeNotifier>(themeProvider.notifier)._updateSystemUI();
        });
        return child ?? const SizedBox.shrink();
      },
    );
  }

  /// Convertit notre EcoThemeMode vers le ThemeMode de Material
  ThemeMode _convertThemeMode(EcoThemeMode mode) {
    switch (mode) {
      case EcoThemeMode.light:
        return ThemeMode.light;
      case EcoThemeMode.dark:
        return ThemeMode.dark;
      case EcoThemeMode.system:
        return ThemeMode.system;
    }
  }
}

/// Mixin pour widgets ayant besoin de réagir aux changements de thème
mixin ThemeMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool get isDark => ref.watch(isDarkThemeProvider);
  ThemeData get theme => ref.watch(currentThemeProvider);

  /// Méthode appelée quand le thème change
  void onThemeChanged({required bool isDark}) {}

  @override
  void initState() {
    super.initState();

    // Écouter les changements de thème
    ref.listen(isDarkThemeProvider, (previous, next) {
      if (previous != next) {
        onThemeChanged(isDark: next);
      }
    });
  }
}
