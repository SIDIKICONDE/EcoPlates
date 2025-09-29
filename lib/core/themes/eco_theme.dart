import 'package:flutter/material.dart';

import 'component_themes/button_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/input_theme.dart';
import 'component_themes/navigation_theme.dart';
import 'tokens/color_tokens.dart';
import 'tokens/elevation_tokens.dart';
import 'tokens/radius_tokens.dart';
import 'tokens/spacing_tokens.dart';
import 'tokens/typography_tokens.dart';

/// Thème unifié pour EcoPlates
/// Combine tous les tokens et thèmes de composants
class EcoTheme {
  EcoTheme._();

  // ===== THÈMES COMPLETS =====

  /// Thème clair EcoPlates
  static ThemeData get lightTheme {
    const isDark = false;

    return ThemeData(
      // Configuration de base
      useMaterial3: true,
      brightness: Brightness.light,

      // Schéma de couleurs
      colorScheme: _lightColorScheme,

      // Couleur de fond générale
      scaffoldBackgroundColor: EcoColorTokens.neutral50,

      // Couleur de surface par défaut
      canvasColor: EcoColorTokens.neutral0,

      // Couleur des dividers
      dividerColor: EcoColorTokens.neutral200,

      // Focus
      focusColor: EcoColorTokens.primary.withValues(alpha: 0.12),
      hoverColor: EcoColorTokens.primary.withValues(alpha: 0.08),
      highlightColor: EcoColorTokens.primary.withValues(alpha: 0.12),
      splashColor: EcoColorTokens.primary.withValues(alpha: 0.12),

      // Typographie
      textTheme: EcoTypography.lightTextTheme,
      primaryTextTheme: EcoTypography.lightTextTheme,

      // Thèmes de composants
      appBarTheme: EcoNavigationTheme.appBarTheme(isDark: isDark),
      bottomNavigationBarTheme: EcoNavigationTheme.bottomNavigationBarTheme(
        isDark: isDark,
      ),
      navigationRailTheme: EcoNavigationTheme.navigationRailTheme(
        isDark: isDark,
      ),
      drawerTheme: EcoNavigationTheme.drawerTheme(isDark: isDark),
      tabBarTheme: EcoNavigationTheme.tabBarTheme(isDark: isDark),

      elevatedButtonTheme: EcoButtonTheme.elevatedButtonTheme(isDark: isDark),
      outlinedButtonTheme: EcoButtonTheme.outlinedButtonTheme(isDark: isDark),
      textButtonTheme: EcoButtonTheme.textButtonTheme(isDark: isDark),
      iconButtonTheme: EcoButtonTheme.iconButtonTheme(isDark: isDark),
      floatingActionButtonTheme: EcoButtonTheme.fabTheme(isDark: isDark),

      cardTheme: EcoCardTheme.cardTheme(isDark: isDark),
      inputDecorationTheme: EcoInputTheme.inputDecorationTheme(isDark: isDark),

      // Autres composants
      chipTheme: _chipTheme(isDark),
      dialogTheme: _dialogTheme(isDark),
      bottomSheetTheme: _bottomSheetTheme(isDark),
      snackBarTheme: _snackBarTheme(isDark),
      listTileTheme: _listTileTheme(isDark),
      switchTheme: _switchTheme(isDark),
      checkboxTheme: _checkboxTheme(isDark),
      radioTheme: _radioTheme(isDark),
      sliderTheme: _sliderTheme(isDark),
      progressIndicatorTheme: _progressIndicatorTheme(isDark),

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Extensions Material 3
      extensions: const [
        _customColors,
      ],
    );
  }

  /// Thème sombre EcoPlates
  static ThemeData get darkTheme {
    const isDark = true;

    return ThemeData(
      // Configuration de base
      useMaterial3: true,
      brightness: Brightness.dark,

      // Schéma de couleurs
      colorScheme: _darkColorScheme,

      // Couleur de fond générale
      scaffoldBackgroundColor: EcoColorTokens.neutral900,

      // Couleur de surface par défaut
      canvasColor: EcoColorTokens.neutral800,

      // Couleur des dividers
      dividerColor: EcoColorTokens.neutral700,

      // Focus
      focusColor: EcoColorTokens.primary.withValues(alpha: 0.12),
      hoverColor: EcoColorTokens.primary.withValues(alpha: 0.08),
      highlightColor: EcoColorTokens.primary.withValues(alpha: 0.12),
      splashColor: EcoColorTokens.primary.withValues(alpha: 0.12),

      // Typographie
      textTheme: EcoTypography.darkTextTheme,
      primaryTextTheme: EcoTypography.darkTextTheme,

      // Thèmes de composants
      appBarTheme: EcoNavigationTheme.appBarTheme(isDark: isDark),
      bottomNavigationBarTheme: EcoNavigationTheme.bottomNavigationBarTheme(
        isDark: isDark,
      ),
      navigationRailTheme: EcoNavigationTheme.navigationRailTheme(
        isDark: isDark,
      ),
      drawerTheme: EcoNavigationTheme.drawerTheme(isDark: isDark),
      tabBarTheme: EcoNavigationTheme.tabBarTheme(isDark: isDark),

      elevatedButtonTheme: EcoButtonTheme.elevatedButtonTheme(isDark: isDark),
      outlinedButtonTheme: EcoButtonTheme.outlinedButtonTheme(isDark: isDark),
      textButtonTheme: EcoButtonTheme.textButtonTheme(isDark: isDark),
      iconButtonTheme: EcoButtonTheme.iconButtonTheme(isDark: isDark),
      floatingActionButtonTheme: EcoButtonTheme.fabTheme(isDark: isDark),

      cardTheme: EcoCardTheme.cardTheme(isDark: isDark),
      inputDecorationTheme: EcoInputTheme.inputDecorationTheme(isDark: isDark),

      // Autres composants
      chipTheme: _chipTheme(isDark),
      dialogTheme: _dialogTheme(isDark),
      bottomSheetTheme: _bottomSheetTheme(isDark),
      snackBarTheme: _snackBarTheme(isDark),
      listTileTheme: _listTileTheme(isDark),
      switchTheme: _switchTheme(isDark),
      checkboxTheme: _checkboxTheme(isDark),
      radioTheme: _radioTheme(isDark),
      sliderTheme: _sliderTheme(isDark),
      progressIndicatorTheme: _progressIndicatorTheme(isDark),

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Extensions Material 3
      extensions: const [
        _customColors,
      ],
    );
  }

  // ===== SCHÉMAS DE COULEURS =====

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: EcoColorTokens.primary,
    onPrimary: EcoColorTokens.neutral0,
    primaryContainer: EcoColorTokens.primaryContainer,
    onPrimaryContainer: EcoColorTokens.primaryDark,
    secondary: EcoColorTokens.secondary,
    onSecondary: EcoColorTokens.neutral0,
    secondaryContainer: EcoColorTokens.secondaryContainer,
    onSecondaryContainer: EcoColorTokens.secondaryDark,
    tertiary: EcoColorTokens.tertiary,
    onTertiary: EcoColorTokens.neutral0,
    tertiaryContainer: EcoColorTokens.tertiaryContainer,
    onTertiaryContainer: EcoColorTokens.tertiaryDark,
    error: EcoColorTokens.error,
    onError: EcoColorTokens.neutral0,
    errorContainer: EcoColorTokens.errorContainer,
    onErrorContainer: EcoColorTokens.errorDark,
    surface: EcoColorTokens.neutral0,
    onSurface: EcoColorTokens.neutral800,
    surfaceContainerHighest: EcoColorTokens.neutral100,
    onSurfaceVariant: EcoColorTokens.neutral600,
    outline: EcoColorTokens.neutral300,
    outlineVariant: EcoColorTokens.neutral200,
    shadow: EcoColorTokens.neutral1000,
    scrim: EcoColorTokens.neutral1000,
    inverseSurface: EcoColorTokens.neutral800,
    onInverseSurface: EcoColorTokens.neutral100,
    inversePrimary: EcoColorTokens.primaryLight,
    surfaceTint: EcoColorTokens.primary,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: EcoColorTokens.primaryLight,
    onPrimary: EcoColorTokens.neutral900,
    primaryContainer: EcoColorTokens.primaryDark,
    onPrimaryContainer: EcoColorTokens.primaryLight,
    secondary: EcoColorTokens.secondaryLight,
    onSecondary: EcoColorTokens.neutral900,
    secondaryContainer: EcoColorTokens.secondaryDark,
    onSecondaryContainer: EcoColorTokens.secondaryLight,
    tertiary: EcoColorTokens.tertiaryLight,
    onTertiary: EcoColorTokens.neutral900,
    tertiaryContainer: EcoColorTokens.tertiaryDark,
    onTertiaryContainer: EcoColorTokens.tertiaryLight,
    error: EcoColorTokens.errorLight,
    onError: EcoColorTokens.neutral900,
    errorContainer: EcoColorTokens.errorDark,
    onErrorContainer: EcoColorTokens.errorLight,
    surface: EcoColorTokens.neutral900,
    onSurface: EcoColorTokens.neutral100,
    surfaceContainerHighest: EcoColorTokens.neutral800,
    onSurfaceVariant: EcoColorTokens.neutral400,
    outline: EcoColorTokens.neutral600,
    outlineVariant: EcoColorTokens.neutral700,
    shadow: EcoColorTokens.neutral1000,
    scrim: EcoColorTokens.neutral1000,
    inverseSurface: EcoColorTokens.neutral100,
    onInverseSurface: EcoColorTokens.neutral800,
    inversePrimary: EcoColorTokens.primary,
    surfaceTint: EcoColorTokens.primaryLight,
  );

  // ===== THÈMES DE COMPOSANTS ADDITIONNELS =====

  static ChipThemeData _chipTheme(bool isDark) {
    return ChipThemeData(
      backgroundColor: isDark
          ? EcoColorTokens.neutral800
          : EcoColorTokens.neutral100,
      deleteIconColor: isDark
          ? EcoColorTokens.neutral400
          : EcoColorTokens.neutral500,
      disabledColor: isDark
          ? EcoColorTokens.neutral700
          : EcoColorTokens.neutral200,
      selectedColor: EcoColorTokens.primaryContainer,
      secondarySelectedColor: EcoColorTokens.secondaryContainer,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.transparent,
      selectedShadowColor: Colors.black12,
      showCheckmark: true,
      checkmarkColor: EcoColorTokens.primary,
      labelPadding: EcoSpacing.asymmetric(horizontal: EcoSpacing.sm),
      padding: EcoSpacing.asymmetric(
        horizontal: EcoSpacing.md,
        vertical: EcoSpacing.xs,
      ),
      side: BorderSide(
        color: isDark ? EcoColorTokens.neutral600 : EcoColorTokens.neutral200,
      ),
      shape: const RoundedRectangleBorder(borderRadius: EcoRadius.chipRadius),
      labelStyle: EcoTypography.labelMediumLight,
      secondaryLabelStyle: EcoTypography.labelMediumLight,
      brightness: isDark ? Brightness.dark : Brightness.light,
      elevation: EcoElevation.chipElevation,
      pressElevation: EcoElevation.level1,
    );
  }

  static DialogThemeData _dialogTheme(bool isDark) {
    return DialogThemeData(
      backgroundColor: isDark
          ? EcoColorTokens.neutral800
          : EcoColorTokens.neutral0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black26,
      elevation: EcoElevation.dialogElevation,
      shape: const RoundedRectangleBorder(borderRadius: EcoRadius.dialogRadius),
      alignment: Alignment.center,
      titleTextStyle: EcoTypography.headlineSmallLight.copyWith(
        color: isDark ? EcoColorTokens.neutral100 : EcoColorTokens.neutral800,
      ),
      contentTextStyle: EcoTypography.bodyLargeLight.copyWith(
        color: isDark ? EcoColorTokens.neutral200 : EcoColorTokens.neutral700,
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(bool isDark) {
    return BottomSheetThemeData(
      backgroundColor: isDark
          ? EcoColorTokens.neutral800
          : EcoColorTokens.neutral0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black26,
      elevation: EcoElevation.modalElevation,
      shape: const RoundedRectangleBorder(
        borderRadius: EcoRadius.bottomSheetRadius,
      ),
      clipBehavior: Clip.hardEdge,
      constraints: const BoxConstraints(maxWidth: 640),
    );
  }

  static SnackBarThemeData _snackBarTheme(bool isDark) {
    return SnackBarThemeData(
      backgroundColor: isDark
          ? EcoColorTokens.neutral200
          : EcoColorTokens.neutral800,
      contentTextStyle: EcoTypography.bodyMediumLight.copyWith(
        color: isDark ? EcoColorTokens.neutral800 : EcoColorTokens.neutral100,
      ),
      actionTextColor: EcoColorTokens.primary,
      disabledActionTextColor: EcoColorTokens.neutral400,
      elevation: EcoElevation.level3,
      shape: const RoundedRectangleBorder(borderRadius: EcoRadius.radiusMD),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: isDark
          ? EcoColorTokens.neutral600
          : EcoColorTokens.neutral400,
    );
  }

  static ListTileThemeData _listTileTheme(bool isDark) {
    return ListTileThemeData(
      contentPadding: EcoSpacing.listItemPadding,
      titleTextStyle: EcoTypography.bodyLargeLight.copyWith(
        color: isDark ? EcoColorTokens.neutral100 : EcoColorTokens.neutral800,
      ),
      subtitleTextStyle: EcoTypography.bodyMediumLight.copyWith(
        color: isDark ? EcoColorTokens.neutral300 : EcoColorTokens.neutral600,
      ),
      leadingAndTrailingTextStyle: EcoTypography.labelMediumLight.copyWith(
        color: isDark ? EcoColorTokens.neutral400 : EcoColorTokens.neutral500,
      ),
      iconColor: isDark ? EcoColorTokens.neutral400 : EcoColorTokens.neutral500,
      textColor: isDark ? EcoColorTokens.neutral100 : EcoColorTokens.neutral800,
      tileColor: Colors.transparent,
      selectedTileColor: EcoColorTokens.primary.withValues(alpha: 0.08),
      shape: const RoundedRectangleBorder(borderRadius: EcoRadius.radiusMD),
      visualDensity: VisualDensity.standard,
      minVerticalPadding: EcoSpacing.sm,
      minLeadingWidth: 40,
    );
  }

  static SwitchThemeData _switchTheme(bool isDark) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return EcoColorTokens.primary;
        }
        return isDark ? EcoColorTokens.neutral400 : EcoColorTokens.neutral300;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return EcoColorTokens.primary.withValues(alpha: 0.5);
        }
        return isDark ? EcoColorTokens.neutral700 : EcoColorTokens.neutral200;
      }),
    );
  }

  static CheckboxThemeData _checkboxTheme(bool isDark) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return EcoColorTokens.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(EcoColorTokens.neutral0),
      overlayColor: WidgetStateProperty.all(
        EcoColorTokens.primary.withValues(alpha: 0.08),
      ),
      shape: const RoundedRectangleBorder(borderRadius: EcoRadius.radiusXS),
    );
  }

  static RadioThemeData _radioTheme(bool isDark) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return EcoColorTokens.primary;
        }
        return isDark ? EcoColorTokens.neutral600 : EcoColorTokens.neutral400;
      }),
      overlayColor: WidgetStateProperty.all(
        EcoColorTokens.primary.withValues(alpha: 0.08),
      ),
    );
  }

  static SliderThemeData _sliderTheme(bool isDark) {
    return SliderThemeData(
      activeTrackColor: EcoColorTokens.primary,
      inactiveTrackColor: isDark
          ? EcoColorTokens.neutral700
          : EcoColorTokens.neutral200,
      thumbColor: EcoColorTokens.primary,
      overlayColor: EcoColorTokens.primary.withValues(alpha: 0.12),
      valueIndicatorColor: EcoColorTokens.primary,
      valueIndicatorTextStyle: EcoTypography.labelSmallLight.copyWith(
        color: EcoColorTokens.neutral0,
      ),
    );
  }

  static ProgressIndicatorThemeData _progressIndicatorTheme(bool isDark) {
    return ProgressIndicatorThemeData(
      color: EcoColorTokens.primary,
      linearTrackColor: isDark
          ? EcoColorTokens.neutral700
          : EcoColorTokens.neutral200,
      circularTrackColor: isDark
          ? EcoColorTokens.neutral700
          : EcoColorTokens.neutral200,
    );
  }

  // ===== COULEURS PERSONNALISÉES =====

  static const _customColors = EcoCustomColors();
}

/// Extension pour les couleurs personnalisées EcoPlates
class EcoCustomColors extends ThemeExtension<EcoCustomColors> {
  const EcoCustomColors();

  // Couleurs sémantiques
  Color get success => EcoColorTokens.success;
  Color get successLight => EcoColorTokens.successLight;
  Color get successDark => EcoColorTokens.successDark;
  Color get successContainer => EcoColorTokens.successContainer;

  Color get warning => EcoColorTokens.warning;
  Color get warningLight => EcoColorTokens.warningLight;
  Color get warningDark => EcoColorTokens.warningDark;
  Color get warningContainer => EcoColorTokens.warningContainer;

  Color get info => EcoColorTokens.info;
  Color get infoLight => EcoColorTokens.infoLight;
  Color get infoDark => EcoColorTokens.infoDark;
  Color get infoContainer => EcoColorTokens.infoContainer;

  // Couleurs spécialisées EcoPlates
  Color get eco => EcoColorTokens.eco;
  Color get ecoLight => EcoColorTokens.ecoLight;
  Color get ecoDark => EcoColorTokens.ecoDark;
  Color get ecoAccent => EcoColorTokens.ecoAccent;

  Color get discount => EcoColorTokens.discount;
  Color get urgent => EcoColorTokens.urgent;
  Color get new_ => EcoColorTokens.new_;
  Color get premium => EcoColorTokens.premium;

  Color get veggie => EcoColorTokens.veggie;
  Color get vegan => EcoColorTokens.vegan;
  Color get organic => EcoColorTokens.organic;
  Color get local => EcoColorTokens.local;

  @override
  ThemeExtension<EcoCustomColors> copyWith() => const EcoCustomColors();

  @override
  ThemeExtension<EcoCustomColors> lerp(
    covariant ThemeExtension<EcoCustomColors>? other,
    double t,
  ) => const EcoCustomColors();
}

/// Extension pour accéder facilement aux couleurs personnalisées
extension EcoColorsExtension on BuildContext {
  EcoCustomColors get ecoColors => Theme.of(this).extension<EcoCustomColors>()!;
}
