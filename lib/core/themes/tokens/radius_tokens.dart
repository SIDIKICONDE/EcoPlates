import 'package:flutter/material.dart';

/// Tokens de rayon de bordure pour le design system EcoPlates
class EcoRadius {
  EcoRadius._();

  // ===== RAYONS DE BASE =====
  static const double none = 0;
  static const double xs = 2; // Très petit
  static const double sm = 4; // Petit
  static const double md = 8; // Moyen
  static const double lg = 12; // Grand
  static const double xl = 16; // Très grand
  static const double xxl = 20; // Extra grand
  static const double xxxl = 24; // Super grand
  static const double full = 9999; // Complètement arrondi (pill)

  // ===== BORDER RADIUS COMPOSITES =====
  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXXL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusXXXL = BorderRadius.all(
    Radius.circular(xxxl),
  );
  static const BorderRadius radiusFull = BorderRadius.all(
    Radius.circular(full),
  );

  // ===== RAYONS SPÉCIALISÉS PAR COMPOSANT =====

  // Buttons
  static const BorderRadius buttonRadius = radiusLG;
  static const BorderRadius iconButtonRadius = radiusMD;
  static const BorderRadius pillButtonRadius = radiusFull;

  // Cards
  static const BorderRadius cardRadius = radiusXL;
  static const BorderRadius cardSmallRadius = radiusLG;
  static const BorderRadius cardLargeRadius = radiusXXL;

  // Inputs
  static const BorderRadius inputRadius = radiusLG;
  static const BorderRadius inputSmallRadius = radiusMD;

  // Modals et Dialogs
  static const BorderRadius modalRadius = radiusXXL;
  static const BorderRadius dialogRadius = radiusXL;
  static const BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  // Navigation
  static const BorderRadius navBarRadius = radiusXL;
  static const BorderRadius tabRadius = radiusLG;

  // Badges et Chips
  static const BorderRadius badgeRadius = radiusFull;
  static const BorderRadius chipRadius = radiusFull;
  static const BorderRadius tagRadius = radiusSM;

  // Images
  static const BorderRadius imageRadius = radiusLG;
  static const BorderRadius avatarRadius = radiusFull;
  static const BorderRadius thumbnailRadius = radiusMD;

  // Containers spéciaux
  static const BorderRadius containerRadius = radiusXL;
  static const BorderRadius sectionRadius = radiusXXL;

  // ===== RAYONS PARTIELS =====

  // Top seulement
  static const BorderRadius topRadius = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  static const BorderRadius topLargeRadius = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  // Bottom seulement
  static const BorderRadius bottomRadius = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );

  static const BorderRadius bottomLargeRadius = BorderRadius.only(
    bottomLeft: Radius.circular(xxl),
    bottomRight: Radius.circular(xxl),
  );

  // Left seulement
  static const BorderRadius leftRadius = BorderRadius.only(
    topLeft: Radius.circular(lg),
    bottomLeft: Radius.circular(lg),
  );

  // Right seulement
  static const BorderRadius rightRadius = BorderRadius.only(
    topRight: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );

  // ===== HELPER METHODS =====

  /// Crée un BorderRadius avec toutes les corners identiques
  static BorderRadius all(double radius) => BorderRadius.circular(radius);

  /// Crée un BorderRadius avec des valeurs personnalisées
  static BorderRadius only({
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft),
    topRight: Radius.circular(topRight),
    bottomLeft: Radius.circular(bottomLeft),
    bottomRight: Radius.circular(bottomRight),
  );

  /// Crée un BorderRadius avec top/bottom identiques
  static BorderRadius vertical({
    double top = 0.0,
    double bottom = 0.0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(top),
    topRight: Radius.circular(top),
    bottomLeft: Radius.circular(bottom),
    bottomRight: Radius.circular(bottom),
  );

  /// Crée un BorderRadius avec left/right identiques
  static BorderRadius horizontal({
    double left = 0.0,
    double right = 0.0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(left),
    bottomLeft: Radius.circular(left),
    topRight: Radius.circular(right),
    bottomRight: Radius.circular(right),
  );
}
