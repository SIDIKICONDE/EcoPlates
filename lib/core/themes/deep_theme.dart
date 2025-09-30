import 'package:flutter/material.dart';

import 'tokens/deep_color_tokens.dart';
import 'tokens/radius_tokens.dart';
import 'tokens/spacing_tokens.dart';
import 'tokens/typography_tokens.dart';

/// Thème profond et confiant pour Nyth
/// Un thème sophistiqué avec des couleurs profondes qui inspirent stabilité et professionnalisme
class DeepTheme {
  DeepTheme._();

  // ===== THÈMES COMPLETS =====

  /// Thème clair avec touches profondes
  static ThemeData get lightTheme {
    const isDark = false;

    return ThemeData(
      // Configuration de base
      useMaterial3: true,
      brightness: Brightness.light,

      // Schéma de couleurs
      colorScheme: _lightColorScheme,

      // Couleur de fond générale
      scaffoldBackgroundColor: DeepColorTokens.neutral50,

      // Couleur de surface par défaut
      canvasColor: DeepColorTokens.neutral0,

      // Couleur des dividers
      dividerColor: DeepColorTokens.neutral200,

      // Focus et interactions
      focusColor: DeepColorTokens.primary.withValues(alpha: 0.12),
      hoverColor: DeepColorTokens.primary.withValues(alpha: 0.08),
      highlightColor: DeepColorTokens.primary.withValues(alpha: 0.12),
      splashColor: DeepColorTokens.primary.withValues(alpha: 0.12),

      // Typographie
      textTheme: EcoTypography.lightTextTheme,
      primaryTextTheme: EcoTypography.lightTextTheme,

      // Thèmes de composants
      appBarTheme: _deepAppBarTheme(isDark: isDark),
      bottomNavigationBarTheme: _deepBottomNavigationBarTheme(isDark: isDark),
      navigationRailTheme: _deepNavigationRailTheme(isDark: isDark),
      drawerTheme: _deepDrawerTheme(isDark: isDark),
      tabBarTheme: _deepTabBarTheme(isDark: isDark),

      elevatedButtonTheme: _deepElevatedButtonTheme(isDark: isDark),
      outlinedButtonTheme: _deepOutlinedButtonTheme(isDark: isDark),
      textButtonTheme: _deepTextButtonTheme(isDark: isDark),
      iconButtonTheme: _deepIconButtonTheme(isDark: isDark),
      floatingActionButtonTheme: _deepFabTheme(isDark: isDark),

      cardTheme: _deepCardTheme(isDark: isDark),
      inputDecorationTheme: _deepInputDecorationTheme(isDark: isDark),

      // Autres composants
      chipTheme: _deepChipTheme(isDark),
      dialogTheme: _deepDialogTheme(isDark),
      bottomSheetTheme: _deepBottomSheetTheme(isDark),
      snackBarTheme: _deepSnackBarTheme(isDark),
      listTileTheme: _deepListTileTheme(isDark),
      switchTheme: _deepSwitchTheme(isDark),
      checkboxTheme: _deepCheckboxTheme(isDark),
      radioTheme: _deepRadioTheme(isDark),
      sliderTheme: _deepSliderTheme(isDark),
      progressIndicatorTheme: _deepProgressIndicatorTheme(isDark),

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Extensions Material 3
      extensions: const [
        _customDeepColors,
      ],
    );
  }

  /// Thème sombre profond
  static ThemeData get darkTheme {
    const isDark = true;

    return ThemeData(
      // Configuration de base
      useMaterial3: true,
      brightness: Brightness.dark,

      // Schéma de couleurs
      colorScheme: _darkColorScheme,

      // Couleur de fond générale (très sombre)
      scaffoldBackgroundColor: DeepColorTokens.neutral950,

      // Couleur de surface par défaut
      canvasColor: DeepColorTokens.surface,

      // Couleur des dividers
      dividerColor: DeepColorTokens.neutral800,

      // Focus et interactions
      focusColor: DeepColorTokens.primaryLight.withValues(alpha: 0.15),
      hoverColor: DeepColorTokens.primaryLight.withValues(alpha: 0.10),
      highlightColor: DeepColorTokens.primaryLight.withValues(alpha: 0.15),
      splashColor: DeepColorTokens.primaryLight.withValues(alpha: 0.15),

      // Typographie
      textTheme: EcoTypography.darkTextTheme,
      primaryTextTheme: EcoTypography.darkTextTheme,

      // Thèmes de composants
      appBarTheme: _deepAppBarTheme(isDark: isDark),
      bottomNavigationBarTheme: _deepBottomNavigationBarTheme(isDark: isDark),
      navigationRailTheme: _deepNavigationRailTheme(isDark: isDark),
      drawerTheme: _deepDrawerTheme(isDark: isDark),
      tabBarTheme: _deepTabBarTheme(isDark: isDark),

      elevatedButtonTheme: _deepElevatedButtonTheme(isDark: isDark),
      outlinedButtonTheme: _deepOutlinedButtonTheme(isDark: isDark),
      textButtonTheme: _deepTextButtonTheme(isDark: isDark),
      iconButtonTheme: _deepIconButtonTheme(isDark: isDark),
      floatingActionButtonTheme: _deepFabTheme(isDark: isDark),

      cardTheme: _deepCardTheme(isDark: isDark),
      inputDecorationTheme: _deepInputDecorationTheme(isDark: isDark),

      // Autres composants
      chipTheme: _deepChipTheme(isDark),
      dialogTheme: _deepDialogTheme(isDark),
      bottomSheetTheme: _deepBottomSheetTheme(isDark),
      snackBarTheme: _deepSnackBarTheme(isDark),
      listTileTheme: _deepListTileTheme(isDark),
      switchTheme: _deepSwitchTheme(isDark),
      checkboxTheme: _deepCheckboxTheme(isDark),
      radioTheme: _deepRadioTheme(isDark),
      sliderTheme: _deepSliderTheme(isDark),
      progressIndicatorTheme: _deepProgressIndicatorTheme(isDark),

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Extensions Material 3
      extensions: const [
        _customDeepColors,
      ],
    );
  }

  // ===== SCHÉMAS DE COULEURS =====

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: DeepColorTokens.primary,
    onPrimary: DeepColorTokens.neutral0,
    primaryContainer: DeepColorTokens.primaryContainer,
    onPrimaryContainer: DeepColorTokens.primaryDark,
    secondary: DeepColorTokens.secondary,
    onSecondary: DeepColorTokens.neutral0,
    secondaryContainer: DeepColorTokens.secondaryContainer,
    onSecondaryContainer: DeepColorTokens.secondaryDark,
    tertiary: DeepColorTokens.tertiary,
    onTertiary: DeepColorTokens.neutral0,
    tertiaryContainer: DeepColorTokens.tertiaryContainer,
    onTertiaryContainer: DeepColorTokens.tertiaryDark,
    error: DeepColorTokens.error,
    onError: DeepColorTokens.neutral0,
    errorContainer: DeepColorTokens.errorContainer,
    onErrorContainer: DeepColorTokens.errorDark,
    surface: DeepColorTokens.neutral0,
    onSurface: DeepColorTokens.neutral900,
    surfaceContainerHighest: DeepColorTokens.neutral100,
    onSurfaceVariant: DeepColorTokens.neutral700,
    outline: DeepColorTokens.neutral400,
    outlineVariant: DeepColorTokens.neutral300,
    shadow: DeepColorTokens.neutral1000,
    scrim: DeepColorTokens.neutral1000,
    inverseSurface: DeepColorTokens.neutral900,
    onInverseSurface: DeepColorTokens.neutral100,
    inversePrimary: DeepColorTokens.primaryLight,
    surfaceTint: DeepColorTokens.primary,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: DeepColorTokens.primaryLight,
    onPrimary: DeepColorTokens.primaryDark,
    primaryContainer: DeepColorTokens.primaryDark,
    onPrimaryContainer: DeepColorTokens.primaryContainer,
    secondary: DeepColorTokens.secondaryLight,
    onSecondary: DeepColorTokens.secondaryDark,
    secondaryContainer: DeepColorTokens.secondaryDark,
    onSecondaryContainer: DeepColorTokens.secondaryContainer,
    tertiary: DeepColorTokens.tertiaryLight,
    onTertiary: DeepColorTokens.tertiaryDark,
    tertiaryContainer: DeepColorTokens.tertiaryDark,
    onTertiaryContainer: DeepColorTokens.tertiaryContainer,
    error: DeepColorTokens.errorLight,
    onError: DeepColorTokens.errorDark,
    errorContainer: DeepColorTokens.errorDark,
    onErrorContainer: DeepColorTokens.errorContainer,
    surface: DeepColorTokens.surface,
    onSurface: DeepColorTokens.neutral100,
    surfaceContainerHighest: DeepColorTokens.surfaceContainer,
    onSurfaceVariant: DeepColorTokens.neutral400,
    outline: DeepColorTokens.neutral600,
    outlineVariant: DeepColorTokens.neutral700,
    shadow: DeepColorTokens.neutral1000,
    scrim: DeepColorTokens.neutral1000,
    inverseSurface: DeepColorTokens.neutral100,
    onInverseSurface: DeepColorTokens.neutral900,
    inversePrimary: DeepColorTokens.primaryDark,
    surfaceTint: DeepColorTokens.primaryLight,
  );

  // ===== THÈMES DE COMPOSANTS PERSONNALISÉS =====

  static AppBarTheme _deepAppBarTheme({required bool isDark}) {
    return AppBarTheme(
      backgroundColor: isDark ? DeepColorTokens.surface : DeepColorTokens.primary,
      foregroundColor: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral0,
      elevation: isDark ? 0 : 2,
      shadowColor: DeepColorTokens.shadowMedium,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral0,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static BottomNavigationBarThemeData _deepBottomNavigationBarTheme({required bool isDark}) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? DeepColorTokens.surfaceElevated : DeepColorTokens.neutral0,
      selectedItemColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
      unselectedItemColor: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
      selectedIconTheme: IconThemeData(
        color: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
        size: 28,
      ),
      unselectedIconTheme: IconThemeData(
        color: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
        size: 24,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  static NavigationRailThemeData _deepNavigationRailTheme({required bool isDark}) {
    return NavigationRailThemeData(
      backgroundColor: isDark ? DeepColorTokens.surface : DeepColorTokens.neutral50,
      selectedIconTheme: IconThemeData(
        color: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
        size: 28,
      ),
      unselectedIconTheme: IconThemeData(
        color: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
        size: 24,
      ),
      selectedLabelTextStyle: TextStyle(
        color: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
      ),
    );
  }

  static DrawerThemeData _deepDrawerTheme({required bool isDark}) {
    return DrawerThemeData(
      backgroundColor: isDark ? DeepColorTokens.surface : DeepColorTokens.neutral0,
      scrimColor: DeepColorTokens.overlayMedium,
      elevation: 16,
      shadowColor: DeepColorTokens.shadowDeep,
    );
  }

  static TabBarThemeData _deepTabBarTheme({required bool isDark}) {
    return TabBarThemeData(
      labelColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
      unselectedLabelColor: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
      indicatorColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }

  static ElevatedButtonThemeData _deepElevatedButtonTheme({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: DeepColorTokens.neutral0,
        backgroundColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
        disabledForegroundColor: isDark ? DeepColorTokens.neutral600 : DeepColorTokens.neutral400,
        disabledBackgroundColor: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral200,
        elevation: 2,
        shadowColor: DeepColorTokens.shadowMedium,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(64, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoRadius.lg),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _deepOutlinedButtonTheme({required bool isDark}) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
        disabledForegroundColor: isDark ? DeepColorTokens.neutral600 : DeepColorTokens.neutral400,
        side: BorderSide(
          color: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(64, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoRadius.lg),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData _deepTextButtonTheme({required bool isDark}) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
        disabledForegroundColor: isDark ? DeepColorTokens.neutral600 : DeepColorTokens.neutral400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(64, 36),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static IconButtonThemeData _deepIconButtonTheme({required bool isDark}) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
        disabledForegroundColor: isDark ? DeepColorTokens.neutral600 : DeepColorTokens.neutral400,
        highlightColor: DeepColorTokens.primary.withValues(alpha: 0.1),
        iconSize: 24,
      ),
    );
  }

  static FloatingActionButtonThemeData _deepFabTheme({required bool isDark}) {
    return FloatingActionButtonThemeData(
      backgroundColor: isDark ? DeepColorTokens.accent : DeepColorTokens.primary,
      foregroundColor: DeepColorTokens.neutral0,
      elevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EcoRadius.xl),
      ),
    );
  }

  static CardThemeData _deepCardTheme({required bool isDark}) {
    return CardThemeData(
      color: isDark ? DeepColorTokens.surfaceElevated : DeepColorTokens.neutral0,
      shadowColor: DeepColorTokens.shadowMedium,
      elevation: isDark ? 0 : 2,
      margin: const EdgeInsets.all(EcoSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EcoRadius.xl),
        side: BorderSide(
          color: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral200,
          width: isDark ? 1 : 0,
        ),
      ),
    );
  }

  static InputDecorationTheme _deepInputDecorationTheme({required bool isDark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? DeepColorTokens.surfaceContainer : DeepColorTokens.neutral50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EcoRadius.lg),
        borderSide: BorderSide(
          color: isDark ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EcoRadius.lg),
        borderSide: BorderSide(
          color: isDark ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EcoRadius.lg),
        borderSide: BorderSide(
          color: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EcoRadius.lg),
        borderSide: BorderSide(
          color: isDark ? DeepColorTokens.errorLight : DeepColorTokens.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EcoRadius.lg),
        borderSide: BorderSide(
          color: isDark ? DeepColorTokens.errorLight : DeepColorTokens.error,
          width: 2,
        ),
      ),
      labelStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral400 : DeepColorTokens.neutral700,
      ),
      hintStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral600 : DeepColorTokens.neutral500,
      ),
      prefixIconColor: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
      suffixIconColor: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
    );
  }

  // Autres thèmes de composants
  static ChipThemeData _deepChipTheme(bool isDark) {
    return ChipThemeData(
      backgroundColor: isDark ? DeepColorTokens.surfaceContainer : DeepColorTokens.neutral100,
      deleteIconColor: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral600,
      disabledColor: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral200,
      selectedColor: isDark ? DeepColorTokens.primaryDark : DeepColorTokens.primaryLight,
      secondarySelectedColor: isDark ? DeepColorTokens.secondaryDark : DeepColorTokens.secondaryLight,
      labelStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
      ),
      secondaryLabelStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
      ),
      brightness: isDark ? Brightness.dark : Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EcoRadius.sm),
        side: BorderSide(
          color: isDark ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
        ),
      ),
    );
  }

  static DialogThemeData _deepDialogTheme(bool isDark) {
    return DialogThemeData(
      backgroundColor: isDark ? DeepColorTokens.surface : DeepColorTokens.neutral0,
      elevation: 24,
      shadowColor: DeepColorTokens.shadowDeep,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EcoRadius.xxl),
      ),
      titleTextStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral200 : DeepColorTokens.neutral800,
        fontSize: 16,
      ),
    );
  }

  static BottomSheetThemeData _deepBottomSheetTheme(bool isDark) {
    return BottomSheetThemeData(
      backgroundColor: isDark ? DeepColorTokens.surface : DeepColorTokens.neutral0,
      elevation: 16,
      shadowColor: DeepColorTokens.shadowDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EcoRadius.xxl),
        ),
      ),
      modalBackgroundColor: isDark ? DeepColorTokens.surface : DeepColorTokens.neutral0,
      modalElevation: 16,
    );
  }

  static SnackBarThemeData _deepSnackBarTheme(bool isDark) {
    return SnackBarThemeData(
      backgroundColor: isDark ? DeepColorTokens.surfaceElevated : DeepColorTokens.neutral900,
      contentTextStyle: TextStyle(
        color: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral0,
        fontSize: 14,
      ),
      actionTextColor: isDark ? DeepColorTokens.accentLight : DeepColorTokens.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EcoRadius.lg),
      ),
    );
  }

  static ListTileThemeData _deepListTileTheme(bool isDark) {
    return ListTileThemeData(
      textColor: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral900,
      iconColor: isDark ? DeepColorTokens.neutral400 : DeepColorTokens.neutral600,
      tileColor: Colors.transparent,
      selectedTileColor: (isDark ? DeepColorTokens.primary : DeepColorTokens.primaryLight).withValues(alpha: 0.1),
      selectedColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
    );
  }

  static SwitchThemeData _deepSwitchTheme(bool isDark) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary;
        }
        return isDark ? DeepColorTokens.neutral600 : DeepColorTokens.neutral400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return (isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary).withValues(alpha: 0.5);
        }
        return isDark ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300;
      }),
    );
  }

  static CheckboxThemeData _deepCheckboxTheme(bool isDark) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(DeepColorTokens.neutral0),
      side: BorderSide(
        color: isDark ? DeepColorTokens.neutral600 : DeepColorTokens.neutral400,
        width: 2,
      ),
    );
  }

  static RadioThemeData _deepRadioTheme(bool isDark) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary;
        }
        return isDark ? DeepColorTokens.neutral600 : DeepColorTokens.neutral400;
      }),
    );
  }

  static SliderThemeData _deepSliderTheme(bool isDark) {
    return SliderThemeData(
      activeTrackColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
      inactiveTrackColor: isDark ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
      thumbColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
      overlayColor: (isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary).withValues(alpha: 0.2),
      valueIndicatorColor: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
      valueIndicatorTextStyle: const TextStyle(
        color: DeepColorTokens.neutral0,
      ),
    );
  }

  static ProgressIndicatorThemeData _deepProgressIndicatorTheme(bool isDark) {
    return ProgressIndicatorThemeData(
      color: isDark ? DeepColorTokens.primaryLight : DeepColorTokens.primary,
      linearTrackColor: isDark ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
      circularTrackColor: isDark ? DeepColorTokens.neutral700 : DeepColorTokens.neutral300,
    );
  }

  // Extension pour couleurs personnalisées
  static const DeepCustomColors _customDeepColors = DeepCustomColors(
    premium: DeepColorTokens.premium,
    premiumLight: DeepColorTokens.premiumLight,
    premiumDark: DeepColorTokens.premiumDark,
    confidence: DeepColorTokens.confidence,
    trust: DeepColorTokens.trust,
    stability: DeepColorTokens.stability,
    professional: DeepColorTokens.professional,
    accent: DeepColorTokens.accent,
    accentLight: DeepColorTokens.accentLight,
    accentDark: DeepColorTokens.accentDark,
    urgent: DeepColorTokens.urgent,
    special: DeepColorTokens.special,
    exclusive: DeepColorTokens.exclusive,
  );
}

// Extension pour accéder aux couleurs personnalisées
class DeepCustomColors extends ThemeExtension<DeepCustomColors> {

  const DeepCustomColors({
    required this.premium,
    required this.premiumLight,
    required this.premiumDark,
    required this.confidence,
    required this.trust,
    required this.stability,
    required this.professional,
    required this.accent,
    required this.accentLight,
    required this.accentDark,
    required this.urgent,
    required this.special,
    required this.exclusive,
  });
  final Color premium;
  final Color premiumLight;
  final Color premiumDark;
  final Color confidence;
  final Color trust;
  final Color stability;
  final Color professional;
  final Color accent;
  final Color accentLight;
  final Color accentDark;
  final Color urgent;
  final Color special;
  final Color exclusive;

  @override
  DeepCustomColors copyWith({
    Color? premium,
    Color? premiumLight,
    Color? premiumDark,
    Color? confidence,
    Color? trust,
    Color? stability,
    Color? professional,
    Color? accent,
    Color? accentLight,
    Color? accentDark,
    Color? urgent,
    Color? special,
    Color? exclusive,
  }) {
    return DeepCustomColors(
      premium: premium ?? this.premium,
      premiumLight: premiumLight ?? this.premiumLight,
      premiumDark: premiumDark ?? this.premiumDark,
      confidence: confidence ?? this.confidence,
      trust: trust ?? this.trust,
      stability: stability ?? this.stability,
      professional: professional ?? this.professional,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      accentDark: accentDark ?? this.accentDark,
      urgent: urgent ?? this.urgent,
      special: special ?? this.special,
      exclusive: exclusive ?? this.exclusive,
    );
  }

  @override
  DeepCustomColors lerp(DeepCustomColors? other, double t) {
    if (other is! DeepCustomColors) {
      return this;
    }
    return DeepCustomColors(
      premium: Color.lerp(premium, other.premium, t)!,
      premiumLight: Color.lerp(premiumLight, other.premiumLight, t)!,
      premiumDark: Color.lerp(premiumDark, other.premiumDark, t)!,
      confidence: Color.lerp(confidence, other.confidence, t)!,
      trust: Color.lerp(trust, other.trust, t)!,
      stability: Color.lerp(stability, other.stability, t)!,
      professional: Color.lerp(professional, other.professional, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      accentDark: Color.lerp(accentDark, other.accentDark, t)!,
      urgent: Color.lerp(urgent, other.urgent, t)!,
      special: Color.lerp(special, other.special, t)!,
      exclusive: Color.lerp(exclusive, other.exclusive, t)!,
    );
  }
}

// Helper pour accéder facilement aux couleurs personnalisées
extension DeepThemeExtension on ThemeData {
  DeepCustomColors? get deepColors => extension<DeepCustomColors>();
}