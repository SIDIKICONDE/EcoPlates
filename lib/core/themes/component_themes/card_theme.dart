import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../tokens/elevation_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/spacing_tokens.dart';

/// Thème des cartes pour EcoPlates
class EcoCardTheme {
  EcoCardTheme._();

  // ===== CARD THEME PRINCIPAL =====
  static CardThemeData cardTheme({required bool isDark}) {
    return CardThemeData(
      // Couleurs
      color: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral0,
      shadowColor: DeepColorTokens.shadowMedium,
      surfaceTintColor: const Color(0x00000000),

      // Élévation
      elevation: EcoElevation.cardElevation,

      // Forme
      shape: const RoundedRectangleBorder(
        borderRadius: EcoRadius.cardRadius,
      ),

      // Marges par défaut
      margin: EcoSpacing.cardMargin,

      // Clip behavior
      clipBehavior: Clip.hardEdge,
    );
  }

  // ===== STYLES DE CARTES PRÉDÉFINIES =====

  /// Carte standard EcoPlates
  static Widget standardCard({
    required Widget child,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return Card(
      color: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral0,
      elevation: EcoElevation.cardElevation,
      shadowColor: DeepColorTokens.shadowLight,
      shape: const RoundedRectangleBorder(
        borderRadius: EcoRadius.cardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: EcoRadius.cardRadius,
        child: Padding(
          padding: EcoSpacing.cardPadding,
          child: child,
        ),
      ),
    );
  }

  /// Carte avec élévation au hover (pour desktop)
  static Widget hoverCard({
    required Widget child,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return MouseRegion(
      cursor: onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral0,
          borderRadius: EcoRadius.cardRadius,
          boxShadow: EcoElevation.cardShadow,
        ),
        child: Material(
          color: const Color(0x00000000),
          child: InkWell(
            onTap: onTap,
            borderRadius: EcoRadius.cardRadius,
            onHover: (isHovered) {
              // Animation d'élévation gérée via AnimatedContainer
            },
            child: Padding(
              padding: EcoSpacing.cardPadding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// Carte avec bordure colorée (pour catégories)
  static Widget borderedCard({
    required Widget child,
    required Color borderColor,
    VoidCallback? onTap,
    bool isDark = false,
    double borderWidth = 2.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral0,
        borderRadius: EcoRadius.cardRadius,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: EcoElevation.cardShadow,
      ),
      child: Material(
        color: const Color(0x00000000),
        child: InkWell(
          onTap: onTap,
          borderRadius: EcoRadius.cardRadius,
          child: Padding(
            padding: EcoSpacing.cardPadding,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Carte avec gradient de fond
  static Widget gradientCard({
    required Widget child,
    required Gradient gradient,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: EcoRadius.cardRadius,
        boxShadow: EcoElevation.cardShadow,
      ),
      child: Material(
        color: const Color(0x00000000),
        child: InkWell(
          onTap: onTap,
          borderRadius: EcoRadius.cardRadius,
          child: Padding(
            padding: EcoSpacing.cardPadding,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Carte d'offre food (style spécialisé EcoPlates)
  static Widget offerCard({
    required Widget child,
    VoidCallback? onTap,
    bool isUrgent = false,
    bool isFavorite = false,
    bool isDark = false,
  }) {
    Color? borderColor;
    if (isUrgent) borderColor = DeepColorTokens.urgent;
    if (isFavorite) borderColor = DeepColorTokens.error;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral0,
        borderRadius: EcoRadius.cardRadius,
        border: borderColor != null
            ? Border.all(color: borderColor, width: 2)
            : null,
        boxShadow: isUrgent || isFavorite
            ? EcoElevation.cardHoverShadow
            : EcoElevation.cardShadow,
      ),
      child: Material(
        color: const Color(0x00000000),
        child: InkWell(
          onTap: onTap,
          borderRadius: EcoRadius.cardRadius,
          child: child, // Pas de padding ici, géré dans le contenu
        ),
      ),
    );
  }

  /// Carte compacte (pour listes denses)
  static Widget compactCard({
    required Widget child,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return Card(
      color: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral0,
      elevation: EcoElevation.level1,
      margin: EcoSpacing.marginSM,
      shape: const RoundedRectangleBorder(
        borderRadius: EcoRadius.cardSmallRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: EcoRadius.cardSmallRadius,
        child: Padding(
          padding: EcoSpacing.paddingMD,
          child: child,
        ),
      ),
    );
  }

  /// Carte hero (pour contenus mis en avant)
  static Widget heroCard({
    required Widget child,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return Container(
      decoration: const BoxDecoration(
        gradient: DeepColorTokens.primaryGradient,
        borderRadius: EcoRadius.cardLargeRadius,
        boxShadow: EcoElevation.floatingShadow,
      ),
      child: Material(
        color: const Color(0x00000000),
        child: InkWell(
          onTap: onTap,
          borderRadius: EcoRadius.cardLargeRadius,
          child: Padding(
            padding: EcoSpacing.paddingXXL,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Carte statistique (pour dashboards)
  static Widget statCard({
    required Widget child,
    Color? accentColor,
    bool isDark = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? DeepColorTokens.neutral800 : DeepColorTokens.neutral0,
        borderRadius: EcoRadius.cardRadius,
        boxShadow: EcoElevation.cardShadow,
        border: accentColor != null
            ? Border(
                left: BorderSide(
                  color: accentColor,
                  width: 4,
                ),
              )
            : null,
      ),
      padding: EcoSpacing.cardPadding,
      child: child,
    );
  }

  /// Carte d'action (avec call-to-action proéminent)
  static Widget actionCard({
    required Widget child,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? DeepColorTokens.neutral700
            : DeepColorTokens.primaryContainer,
        borderRadius: EcoRadius.cardRadius,
        boxShadow: EcoElevation.cardShadow,
        border: Border.all(
          color: DeepColorTokens.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: const Color(0x00000000),
        child: InkWell(
          onTap: onTap,
          borderRadius: EcoRadius.cardRadius,
          splashColor: DeepColorTokens.primary.withValues(alpha: 0.1),
          highlightColor: DeepColorTokens.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: EcoSpacing.cardPadding,
            child: child,
          ),
        ),
      ),
    );
  }

  // ===== HELPER METHODS =====

  /// Créer une carte personnalisée avec tous les paramètres
  static Widget customCard({
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    EdgeInsets? padding,
    EdgeInsets? margin,
    VoidCallback? onTap,
    Gradient? gradient,
  }) {
    final decoration = BoxDecoration(
      color: gradient == null ? backgroundColor : null,
      gradient: gradient,
      borderRadius: borderRadius ?? EcoRadius.cardRadius,
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
      boxShadow: boxShadow ?? EcoElevation.cardShadow,
    );

    final Widget card = Container(
      decoration: decoration,
      margin: margin,
      child: Material(
        color: const Color(0x00000000),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? EcoRadius.cardRadius,
          child: Padding(
            padding: padding ?? EcoSpacing.cardPadding,
            child: child,
          ),
        ),
      ),
    );

    return card;
  }
}
