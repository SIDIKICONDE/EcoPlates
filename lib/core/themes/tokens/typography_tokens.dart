import 'package:flutter/material.dart';
import 'color_tokens.dart';

/// Système typographique pour EcoPlates
/// Basé sur Material Design 3 avec des adaptations responsive
class EcoTypography {
  EcoTypography._();

  // ===== FAMILLES DE POLICES =====
  static const String primaryFontFamily = 'Inter'; // Police principale moderne
  static const String headingFontFamily = 'Poppins'; // Police pour les titres
  static const String monoFontFamily = 'JetBrains Mono'; // Police monospace

  // ===== POIDS DE POLICE =====
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ===== TAILLES DE BASE =====
  // Display - Pour les très gros titres (Hero sections)
  static const double displayLarge = 57;
  static const double displayMedium = 45;
  static const double displaySmall = 36;

  // Headline - Pour les titres de sections
  static const double headlineLarge = 32;
  static const double headlineMedium = 28;
  static const double headlineSmall = 24;

  // Title - Pour les titres de cartes/composants
  static const double titleLarge = 22;
  static const double titleMedium = 16;
  static const double titleSmall = 14;

  // Label - Pour les boutons et labels
  static const double labelLarge = 14;
  static const double labelMedium = 12;
  static const double labelSmall = 11;

  // Body - Pour le texte courant
  static const double bodyLarge = 16;
  static const double bodyMedium = 14;
  static const double bodySmall = 12;

  // ===== HAUTEURS DE LIGNE =====
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;
  static const double lineHeightLoose = 1.8;

  // ===== STYLES DE TEXTE LIGHT THEME =====
  static const TextStyle displayLargeLight = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: displayLarge,
    fontWeight: extraBold,
    height: lineHeightTight,
    color: EcoColorTokens.neutral900,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMediumLight = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: displayMedium,
    fontWeight: bold,
    height: lineHeightTight,
    color: EcoColorTokens.neutral900,
    letterSpacing: 0,
  );

  static const TextStyle displaySmallLight = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: displaySmall,
    fontWeight: bold,
    height: lineHeightTight,
    color: EcoColorTokens.neutral900,
    letterSpacing: 0,
  );

  static const TextStyle headlineLargeLight = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: headlineLarge,
    fontWeight: bold,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral900,
    letterSpacing: 0,
  );

  static const TextStyle headlineMediumLight = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: headlineMedium,
    fontWeight: semiBold,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral900,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmallLight = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: headlineSmall,
    fontWeight: semiBold,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral900,
    letterSpacing: 0,
  );

  static const TextStyle titleLargeLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleLarge,
    fontWeight: semiBold,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral900,
    letterSpacing: 0,
  );

  static const TextStyle titleMediumLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleMedium,
    fontWeight: medium,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral800,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmallLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleSmall,
    fontWeight: medium,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral800,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyLargeLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyLarge,
    fontWeight: regular,
    height: lineHeightRelaxed,
    color: EcoColorTokens.neutral800,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMediumLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral700,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmallLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral600,
    letterSpacing: 0.4,
  );

  static const TextStyle labelLargeLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelLarge,
    fontWeight: medium,
    height: lineHeightTight,
    color: EcoColorTokens.neutral800,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMediumLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelMedium,
    fontWeight: medium,
    height: lineHeightTight,
    color: EcoColorTokens.neutral700,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmallLight = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelSmall,
    fontWeight: medium,
    height: lineHeightTight,
    color: EcoColorTokens.neutral600,
    letterSpacing: 0.5,
  );

  // ===== STYLES DE TEXTE DARK THEME =====
  static const TextStyle displayLargeDark = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: displayLarge,
    fontWeight: extraBold,
    height: lineHeightTight,
    color: EcoColorTokens.neutral0,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMediumDark = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: displayMedium,
    fontWeight: bold,
    height: lineHeightTight,
    color: EcoColorTokens.neutral0,
    letterSpacing: 0,
  );

  static const TextStyle displaySmallDark = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: displaySmall,
    fontWeight: bold,
    height: lineHeightTight,
    color: EcoColorTokens.neutral0,
    letterSpacing: 0,
  );

  static const TextStyle headlineLargeDark = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: headlineLarge,
    fontWeight: bold,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral0,
    letterSpacing: 0,
  );

  static const TextStyle headlineMediumDark = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: headlineMedium,
    fontWeight: semiBold,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral50,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmallDark = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: headlineSmall,
    fontWeight: semiBold,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral50,
    letterSpacing: 0,
  );

  static const TextStyle titleLargeDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleLarge,
    fontWeight: semiBold,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral0,
    letterSpacing: 0,
  );

  static const TextStyle titleMediumDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleMedium,
    fontWeight: medium,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral100,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmallDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: titleSmall,
    fontWeight: medium,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral100,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyLargeDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyLarge,
    fontWeight: regular,
    height: lineHeightRelaxed,
    color: EcoColorTokens.neutral100,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMediumDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral200,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmallDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: lineHeightNormal,
    color: EcoColorTokens.neutral300,
    letterSpacing: 0.4,
  );

  static const TextStyle labelLargeDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelLarge,
    fontWeight: medium,
    height: lineHeightTight,
    color: EcoColorTokens.neutral100,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMediumDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelMedium,
    fontWeight: medium,
    height: lineHeightTight,
    color: EcoColorTokens.neutral200,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmallDark = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: labelSmall,
    fontWeight: medium,
    height: lineHeightTight,
    color: EcoColorTokens.neutral300,
    letterSpacing: 0.5,
  );

  // ===== TEXT THEMES COMPLETS =====
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: displayLargeLight,
    displayMedium: displayMediumLight,
    displaySmall: displaySmallLight,
    headlineLarge: headlineLargeLight,
    headlineMedium: headlineMediumLight,
    headlineSmall: headlineSmallLight,
    titleLarge: titleLargeLight,
    titleMedium: titleMediumLight,
    titleSmall: titleSmallLight,
    bodyLarge: bodyLargeLight,
    bodyMedium: bodyMediumLight,
    bodySmall: bodySmallLight,
    labelLarge: labelLargeLight,
    labelMedium: labelMediumLight,
    labelSmall: labelSmallLight,
  );

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: displayLargeDark,
    displayMedium: displayMediumDark,
    displaySmall: displaySmallDark,
    headlineLarge: headlineLargeDark,
    headlineMedium: headlineMediumDark,
    headlineSmall: headlineSmallDark,
    titleLarge: titleLargeDark,
    titleMedium: titleMediumDark,
    titleSmall: titleSmallDark,
    bodyLarge: bodyLargeDark,
    bodyMedium: bodyMediumDark,
    bodySmall: bodySmallDark,
    labelLarge: labelLargeDark,
    labelMedium: labelMediumDark,
    labelSmall: labelSmallDark,
  );

  // ===== STYLES SPÉCIALISÉS ECOPLATES =====
  static TextStyle get ecoTitle => headlineMediumLight.copyWith(
    color: EcoColorTokens.primary,
    fontWeight: bold,
  );

  static TextStyle get priceText => titleLargeLight.copyWith(
    color: EcoColorTokens.primary,
    fontWeight: bold,
  );

  static TextStyle get discountText => labelMediumLight.copyWith(
    color: EcoColorTokens.error,
    fontWeight: bold,
  );

  static TextStyle get badgeText => labelSmallLight.copyWith(
    color: EcoColorTokens.neutral0,
    fontWeight: medium,
  );

  static TextStyle get captionText => bodySmallLight.copyWith(
    color: EcoColorTokens.neutral500,
    fontStyle: FontStyle.italic,
  );
}
