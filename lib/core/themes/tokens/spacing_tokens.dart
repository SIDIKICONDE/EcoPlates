import 'package:flutter/widgets.dart';

/// Tokens d'espacement pour le design system EcoPlates
/// Basé sur un système de grille de 4px
class EcoSpacing {
  EcoSpacing._();

  // ===== ESPACEMENTS DE BASE (système 4px) =====
  static const double xs = 4; // Extra small
  static const double sm = 8; // Small
  static const double md = 12; // Medium
  static const double lg = 16; // Large
  static const double xl = 20; // Extra large
  static const double xxl = 24; // 2X large
  static const double xxxl = 32; // 3X large
  static const double huge = 40; // Huge
  static const double massive = 48; // Massive

  // ===== ESPACEMENTS SPÉCIALISÉS =====
  static const double none = 0;
  static const double micro = 2; // Pour les détails très fins
  static const double section = 32; // Entre sections
  static const double page = 24; // Marges de page
  static const double gutter = 16; // Gouttières

  // ===== PADDING COMPOSITES =====
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXXXL = EdgeInsets.all(xxxl);

  // Padding horizontal seulement
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(
    horizontal: xs,
  );
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: xl,
  );
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(
    horizontal: xxl,
  );

  // Padding vertical seulement
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(
    vertical: xs,
  );
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: xl,
  );
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(
    vertical: xxl,
  );

  // ===== MARGES COMPOSITES =====
  static const EdgeInsets marginXS = EdgeInsets.all(xs);
  static const EdgeInsets marginSM = EdgeInsets.all(sm);
  static const EdgeInsets marginMD = EdgeInsets.all(md);
  static const EdgeInsets marginLG = EdgeInsets.all(lg);
  static const EdgeInsets marginXL = EdgeInsets.all(xl);
  static const EdgeInsets marginXXL = EdgeInsets.all(xxl);

  // ===== ESPACEMENTS POUR COMPOSANTS SPÉCIFIQUES =====

  // Cards
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardMargin = EdgeInsets.all(sm);
  static const double cardSpacing = md;

  // Buttons
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: md,
  );
  static const EdgeInsets iconButtonPadding = EdgeInsets.all(sm);
  static const double buttonSpacing = md;

  // Lists
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
  static const double listItemSpacing = xs;

  // Forms
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
  static const double inputSpacing = lg;
  static const double formSectionSpacing = xxl;

  // Navigation
  static const EdgeInsets navPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );
  static const double navItemSpacing = sm;

  // Sections
  static const EdgeInsets sectionPadding = EdgeInsets.all(xxl);
  static const double sectionSpacing = xxxl;

  // ===== HELPER METHODS =====

  /// Crée un EdgeInsets symétrique avec la même valeur
  static EdgeInsets symmetric(double value) =>
      EdgeInsets.symmetric(horizontal: value, vertical: value);

  /// Crée un EdgeInsets avec valeurs personnalisées
  static EdgeInsets only({
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    double left = 0.0,
  }) => EdgeInsets.only(
    top: top,
    right: right,
    bottom: bottom,
    left: left,
  );

  /// Crée un EdgeInsets avec padding horizontal/vertical différents
  static EdgeInsets asymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) => EdgeInsets.symmetric(
    horizontal: horizontal,
    vertical: vertical,
  );
}
