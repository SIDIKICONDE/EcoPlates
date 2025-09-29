import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/color_tokens.dart';
import '../tokens/elevation_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/spacing_tokens.dart';
import '../tokens/typography_tokens.dart';

/// Thème des boutons pour EcoPlates
class EcoButtonTheme {
  EcoButtonTheme._();

  // ===== RESPONSIVE THEMES =====

  /// Thème ElevatedButton responsive utilisant les design tokens
  static ElevatedButtonThemeData responsiveElevatedButtonTheme(
    BuildContext context, {
    required bool isDark,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    double? elevation,
    double? pressedElevation,
    double? hoverElevation,
  }) {
    final baseColor =
        backgroundColor ??
        (isDark ? EcoColorTokens.neutral800 : EcoColorTokens.primary);
    final onBaseColor =
        foregroundColor ??
        (isDark ? EcoColorTokens.neutral50 : EcoColorTokens.neutral0);

    return ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            // Couleurs
            foregroundColor: onBaseColor,
            backgroundColor: baseColor,
            disabledForegroundColor: isDark
                ? EcoColorTokens.neutral500
                : EcoColorTokens.neutral500,
            disabledBackgroundColor: isDark
                ? EcoColorTokens.neutral700
                : EcoColorTokens.neutral300,

            // Élévation - valeur simple au lieu de WidgetStateProperty
            elevation: EcoElevation.buttonElevation,
            shadowColor: Colors.black26,

            // Forme et bordures RESPONSIVE
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),

            // Padding responsif
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),

            // Style de texte responsif
            textStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: onBaseColor,
            ),
          ).copyWith(
            // États interactifs
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return onBaseColor.withValues(alpha: 0.12);
              }
              if (states.contains(WidgetState.hovered)) {
                return onBaseColor.withValues(alpha: 0.08);
              }
              if (states.contains(WidgetState.focused)) {
                return onBaseColor.withValues(alpha: 0.12);
              }
              return null;
            }),

            // Élévation selon l'état
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return EcoElevation.buttonPressedElevation;
              }
              if (states.contains(WidgetState.hovered)) {
                return EcoElevation.buttonHoverElevation;
              }
              return EcoElevation.buttonElevation;
            }),
          ),
    );
  }

  /// Thème OutlinedButton responsive utilisant les design tokens
  static OutlinedButtonThemeData responsiveOutlinedButtonTheme(
    BuildContext context, {
    required bool isDark,
    Color? foregroundColor,
    Color? borderColor,
    Color? disabledForegroundColor,
    double? borderWidth,
  }) {
    final textColor =
        foregroundColor ??
        (isDark ? EcoColorTokens.neutral100 : EcoColorTokens.primary);

    return OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            // Couleurs
            foregroundColor: textColor,
            backgroundColor: Colors.transparent,
            disabledForegroundColor: isDark
                ? EcoColorTokens.neutral600
                : EcoColorTokens.neutral400,

            // Bordure
            side: BorderSide(
              color:
                  borderColor ??
                  (isDark ? EcoColorTokens.neutral600 : EcoColorTokens.primary),
              width: 1.5,
            ),

            // Forme RESPONSIVE
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),

            // Padding responsif
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),

            // Style de texte responsif
            textStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ).copyWith(
            // États interactifs
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return textColor.withValues(alpha: 0.12);
              }
              if (states.contains(WidgetState.hovered)) {
                return textColor.withValues(alpha: 0.08);
              }
              return null;
            }),

            // Bordure selon l'état
            // Bordure selon l'état
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(
                  color: isDark
                      ? EcoColorTokens.neutral700
                      : EcoColorTokens.neutral300,
                  width: 1.5,
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return BorderSide(
                  color:
                      borderColor ??
                      (isDark
                          ? EcoColorTokens.neutral600
                          : EcoColorTokens.primary),
                  width: (borderWidth ?? 1.5) + 0.5,
                );
              }
              return BorderSide(
                color:
                    borderColor ??
                    (isDark
                        ? EcoColorTokens.neutral600
                        : EcoColorTokens.primary),
                width: borderWidth ?? 1.5,
              );
            }),
          ),
    );
  }

  // ===== ELEVATED BUTTON =====
  static ElevatedButtonThemeData elevatedButtonTheme({required bool isDark}) {
    final baseColor = isDark
        ? EcoColorTokens.neutral800
        : EcoColorTokens.primary;
    final onBaseColor = isDark
        ? EcoColorTokens.neutral50
        : EcoColorTokens.neutral0;
    return ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            // Couleurs
            foregroundColor: onBaseColor,
            backgroundColor: baseColor,
            disabledForegroundColor: isDark
                ? EcoColorTokens.neutral500
                : EcoColorTokens.neutral500,
            disabledBackgroundColor: isDark
                ? EcoColorTokens.neutral700
                : EcoColorTokens.neutral300,

            // Élévation - valeur simple au lieu de WidgetStateProperty
            elevation: EcoElevation.buttonElevation,
            shadowColor: Colors.black26,

            // Forme et bordures
            shape: const RoundedRectangleBorder(
              borderRadius: EcoRadius.buttonRadius,
            ),

            // Padding
            padding: EcoSpacing.buttonPadding,

            // Style de texte
            textStyle: EcoTypography.labelLargeLight.copyWith(
              color: onBaseColor,
            ),
          ).copyWith(
            // États interactifs avec WidgetStateProperty
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return onBaseColor.withValues(alpha: 0.12);
              }
              if (states.contains(WidgetState.hovered)) {
                return onBaseColor.withValues(alpha: 0.08);
              }
              if (states.contains(WidgetState.focused)) {
                return onBaseColor.withValues(alpha: 0.12);
              }
              return null;
            }),

            // Élévation selon l'état
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return EcoElevation.buttonPressedElevation;
              }
              if (states.contains(WidgetState.hovered)) {
                return EcoElevation.buttonHoverElevation;
              }
              return EcoElevation.buttonElevation;
            }),
          ),
    );
  }

  // ===== OUTLINED BUTTON =====
  static OutlinedButtonThemeData outlinedButtonTheme({required bool isDark}) {
    final borderColor = isDark
        ? EcoColorTokens.neutral600
        : EcoColorTokens.primary;
    final textColor = isDark
        ? EcoColorTokens.neutral100
        : EcoColorTokens.primary;

    return OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            // Couleurs
            foregroundColor: textColor,
            backgroundColor: Colors.transparent,
            disabledForegroundColor: isDark
                ? EcoColorTokens.neutral600
                : EcoColorTokens.neutral400,

            // Bordure
            side: BorderSide(
              color: borderColor,
              width: 1.5,
            ),

            // Forme
            shape: const RoundedRectangleBorder(
              borderRadius: EcoRadius.buttonRadius,
            ),

            // Padding
            padding: EcoSpacing.buttonPadding,

            // Style de texte
            textStyle: EcoTypography.labelLargeLight.copyWith(
              color: textColor,
            ),
          ).copyWith(
            // États interactifs
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return textColor.withValues(alpha: 0.12);
              }
              if (states.contains(WidgetState.hovered)) {
                return textColor.withValues(alpha: 0.08);
              }
              return null;
            }),

            // Bordure selon l'état
            // Bordure selon l'état
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(
                  color: isDark
                      ? EcoColorTokens.neutral700
                      : EcoColorTokens.neutral300,
                  width: 1.5,
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return BorderSide(
                  color: borderColor,
                  width: 2,
                );
              }
              return BorderSide(
                color: borderColor,
                width: 1.5,
              );
            }),
          ),
    );
  }

  // ===== TEXT BUTTON =====
  static TextButtonThemeData textButtonTheme({required bool isDark}) {
    final textColor = isDark
        ? EcoColorTokens.neutral100
        : EcoColorTokens.primary;

    return TextButtonThemeData(
      style:
          TextButton.styleFrom(
            // Couleurs
            foregroundColor: textColor,
            disabledForegroundColor: isDark
                ? EcoColorTokens.neutral600
                : EcoColorTokens.neutral400,

            // Forme
            shape: const RoundedRectangleBorder(
              borderRadius: EcoRadius.buttonRadius,
            ),

            // Padding
            padding: EcoSpacing.asymmetric(
              horizontal: EcoSpacing.lg,
              vertical: EcoSpacing.md,
            ),

            // Taille minimum

            // Style de texte
            textStyle: EcoTypography.labelLargeLight.copyWith(
              color: textColor,
            ),
          ).copyWith(
            // États interactifs
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return textColor.withValues(alpha: 0.12);
              }
              if (states.contains(WidgetState.hovered)) {
                return textColor.withValues(alpha: 0.08);
              }
              return null;
            }),
          ),
    );
  }

  // ===== ICON BUTTON =====
  static IconButtonThemeData iconButtonTheme({required bool isDark}) {
    final iconColor = isDark
        ? EcoColorTokens.neutral200
        : EcoColorTokens.neutral700;

    return IconButtonThemeData(
      style:
          IconButton.styleFrom(
            // Couleurs
            foregroundColor: iconColor,
            disabledForegroundColor: isDark
                ? EcoColorTokens.neutral600
                : EcoColorTokens.neutral400,

            // Forme
            shape: const RoundedRectangleBorder(
              borderRadius: EcoRadius.iconButtonRadius,
            ),

            // Padding
            padding: EcoSpacing.iconButtonPadding,

            // Taille
          ).copyWith(
            // États interactifs
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return iconColor.withValues(alpha: 0.12);
              }
              if (states.contains(WidgetState.hovered)) {
                return iconColor.withValues(alpha: 0.08);
              }
              return null;
            }),
          ),
    );
  }

  // ===== FLOATING ACTION BUTTON =====
  static FloatingActionButtonThemeData fabTheme({required bool isDark}) {
    return const FloatingActionButtonThemeData(
      // Couleurs
      backgroundColor: EcoColorTokens.secondary,
      foregroundColor: EcoColorTokens.neutral0,
      disabledElevation: 0,

      // Élévation
      elevation: EcoElevation.fabElevation,
      highlightElevation: EcoElevation.fabElevation + 2,

      // Forme
      shape: RoundedRectangleBorder(
        borderRadius: EcoRadius.radiusFull,
      ),

      // Taille
      sizeConstraints: BoxConstraints.tightFor(
        width: 56,
        height: 56,
      ),

      // Taille large
      largeSizeConstraints: BoxConstraints.tightFor(
        width: 96,
        height: 96,
      ),

      // Taille small
      smallSizeConstraints: BoxConstraints.tightFor(
        width: 40,
        height: 40,
      ),
    );
  }

  // ===== STYLES PRÉDÉFINIS ECOPLATES =====

  /// Bouton principal vert EcoPlates
  static ButtonStyle get primaryEcoStyle => ElevatedButton.styleFrom(
    backgroundColor: EcoColorTokens.primary,
    foregroundColor: EcoColorTokens.neutral0,
    padding: EcoSpacing.buttonPadding,
    shape: const RoundedRectangleBorder(borderRadius: EcoRadius.buttonRadius),
    textStyle: EcoTypography.labelLargeLight.copyWith(
      fontWeight: EcoTypography.semiBold,
    ),
  );

  /// Bouton secondaire orange
  static ButtonStyle get secondaryEcoStyle => ElevatedButton.styleFrom(
    backgroundColor: EcoColorTokens.secondary,
    foregroundColor: EcoColorTokens.neutral0,
    padding: EcoSpacing.buttonPadding,
    shape: const RoundedRectangleBorder(borderRadius: EcoRadius.buttonRadius),
    textStyle: EcoTypography.labelLargeLight,
  );

  /// Bouton d'urgence rouge
  static ButtonStyle get urgentStyle => ElevatedButton.styleFrom(
    backgroundColor: EcoColorTokens.urgent,
    foregroundColor: EcoColorTokens.neutral0,
    padding: EcoSpacing.buttonPadding,
    shape: const RoundedRectangleBorder(borderRadius: EcoRadius.buttonRadius),
    textStyle: EcoTypography.labelLargeLight.copyWith(
      fontWeight: EcoTypography.semiBold,
    ),
  );

  /// Bouton pill (complètement arrondi)
  static ButtonStyle get pillStyle => ElevatedButton.styleFrom(
    backgroundColor: EcoColorTokens.primary,
    foregroundColor: EcoColorTokens.neutral0,
    padding: EcoSpacing.asymmetric(
      horizontal: EcoSpacing.xxl,
      vertical: EcoSpacing.sm,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: EcoRadius.pillButtonRadius,
    ),
    textStyle: EcoTypography.labelMediumLight,
  );

  /// Bouton ghost (transparent avec bordure)
  static ButtonStyle get ghostStyle => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: EcoColorTokens.primary,
    side: const BorderSide(color: EcoColorTokens.primary, width: 1.5),
    padding: EcoSpacing.buttonPadding,
    shape: const RoundedRectangleBorder(borderRadius: EcoRadius.buttonRadius),
    textStyle: EcoTypography.labelLargeLight,
  );

  // ===== STYLES RESPONSIVES PRÉDÉFINIS =====

  /// Méthode helper pour créer des styles de boutons responsives
  static ButtonStyle _createResponsiveElevatedButton({
    required BuildContext context,
    required Color backgroundColor,
    required Color foregroundColor,
    double? horizontalPadding,
    double? verticalPadding,
    double? borderRadius,
  }) => ElevatedButton.styleFrom(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding ?? 16.0,
      vertical: verticalPadding ?? 12.0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        borderRadius ?? 12.0,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
  );

  /// Méthode helper pour créer des styles outlined responsives
  static ButtonStyle _createResponsiveOutlinedButton({
    required BuildContext context,
    required Color foregroundColor,
    Color? borderColor,
    double? horizontalPadding,
    double? verticalPadding,
    double? borderRadius,
    double borderWidth = 1.5,
  }) => OutlinedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    side: BorderSide(
      color: borderColor ?? foregroundColor,
      width: borderWidth,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding ?? 16.0,
      vertical: verticalPadding ?? 12.0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        borderRadius ?? 12.0,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
  );

  /// Bouton principal responsive utilisant les design tokens
  static ButtonStyle responsivePrimaryEcoStyle(BuildContext context) =>
      _createResponsiveElevatedButton(
        context: context,
        backgroundColor: EcoColorTokens.primary,
        foregroundColor: EcoColorTokens.neutral0,
      );

  /// Bouton secondaire responsive
  static ButtonStyle responsiveSecondaryEcoStyle(BuildContext context) =>
      _createResponsiveElevatedButton(
        context: context,
        backgroundColor: EcoColorTokens.secondary,
        foregroundColor: EcoColorTokens.neutral0,
      );

  /// Bouton d'urgence responsive
  static ButtonStyle responsiveUrgentStyle(BuildContext context) =>
      _createResponsiveElevatedButton(
        context: context,
        backgroundColor: EcoColorTokens.urgent,
        foregroundColor: EcoColorTokens.neutral0,
      );

  /// Bouton pill responsive (complètement arrondi)
  static ButtonStyle responsivePillStyle(BuildContext context) =>
      _createResponsiveElevatedButton(
        context: context,
        backgroundColor: EcoColorTokens.primary,
        foregroundColor: EcoColorTokens.neutral0,
        horizontalPadding: 24.0,
        verticalPadding: 8.0,
        borderRadius: 20.0,
      );

  /// Bouton ghost responsive (transparent avec bordure)
  static ButtonStyle responsiveGhostStyle(BuildContext context) =>
      _createResponsiveOutlinedButton(
        context: context,
        foregroundColor: EcoColorTokens.primary,
      );

  /// Bouton personnalisé responsive avec paramètres flexibles
  static ButtonStyle responsiveCustomElevatedButton({
    required BuildContext context,
    required Color backgroundColor,
    required Color foregroundColor,
    double? horizontalPadding,
    double? verticalPadding,
    double? borderRadius,
    FontWeight? fontWeight,
    double? fontSize,
  }) =>
      _createResponsiveElevatedButton(
        context: context,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        borderRadius: borderRadius,
      ).copyWith(
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: fontSize ?? 14.0,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
      );

  /// Bouton outlined personnalisé responsive
  static ButtonStyle responsiveCustomOutlinedButton({
    required BuildContext context,
    required Color foregroundColor,
    Color? borderColor,
    double? horizontalPadding,
    double? verticalPadding,
    double? borderRadius,
    double borderWidth = 1.5,
    FontWeight? fontWeight,
    double? fontSize,
  }) =>
      _createResponsiveOutlinedButton(
        context: context,
        foregroundColor: foregroundColor,
        borderColor: borderColor,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
      ).copyWith(
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: fontSize ?? 14.0,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
      );
}
