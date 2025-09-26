import 'dart:ui';

/// Constantes utilisées dans les graphiques d'analyses
/// Centralisation des valeurs pour maintenir la cohérence visuelle

class ChartConstants {
  // === DIMENSIONS ===

  /// Hauteur du conteneur principal du graphique
  static const double chartContainerHeight = 200;

  /// Largeur d'une barre dans le graphique
  static const double barWidth = 32;

  /// Largeur d'un label sous les barres (doit correspondre à barWidth)
  static const double labelWidth = 32;

  /// Espacement entre les barres
  static const double barSpacing = 8;

  /// Hauteur maximale des barres (en pixels)
  static const double maxBarHeight = 120;

  /// Hauteur minimale des barres (pour éviter les barres invisibles)
  static const double minBarHeight = 4;

  // === PADDING ET MARGES ===

  /// Padding horizontal du graphique
  static const double chartHorizontalPadding = 16;

  /// Padding vertical du graphique
  static const double chartVerticalPadding = 16;

  /// Padding du conteneur du header
  static const double headerPadding = 16;

  /// Espacement vertical dans le header
  static const double headerVerticalSpacing = 16;

  /// Padding interne des éléments du header
  static const double headerElementPadding = 8;

  // === RAYONS DE BORDURE ===

  /// Rayon des bordures arrondies générales
  static const double defaultBorderRadius = 8;

  /// Rayon des bordures du conteneur de graphique
  static const double chartBorderRadius = 16;

  /// Rayon des bordures des barres
  static const double barBorderRadius = 6;

  // === TAILLES DE POLICE ===

  /// Taille de police du titre principal
  static const double titleFontSize = 14;

  /// Taille de police du compteur (ex: "25 cmd")
  static const double counterFontSize = 10;

  /// Taille de police des labels sous les barres
  static const double labelFontSize = 10;

  /// Taille de police des valeurs au-dessus des barres
  static const double valueFontSize = 9;

  // === EPAISSEURS DE BORDURE ===

  /// Epaisseur des bordures principales
  static const double defaultBorderWidth = 1;

  /// Epaisseur de la bordure du conteneur de graphique
  static const double chartBorderWidth = 1.5;

  /// Epaisseur des lignes de grille majeures
  static const double majorGridStrokeWidth = 1.5;

  /// Epaisseur des lignes de grille mineures
  static const double minorGridStrokeWidth = 0.8;

  // === VALEURS ALPHA (TRANSPARENCE) ===

  /// Transparence des éléments de surface
  static const double surfaceAlpha = 0.15;

  /// Transparence des éléments de surface haute
  static const double surfaceHighAlpha = 0.08;

  /// Transparence des contours
  static const double outlineAlpha = 0.25;

  /// Transparence des ombres
  static const double shadowAlpha = 0.1;

  /// Transparence des bordures secondaires
  static const double secondaryBorderAlpha = 0.2;

  /// Transparence des éléments tertiaires
  static const double tertiaryAlpha = 0.05;

  // === OMBRES ===

  /// Rayon de flou des ombres principales
  static const double shadowBlurRadius = 12;

  /// Décalage vertical des ombres principales
  static const Offset shadowOffset = Offset(
    0,
    6,
  );

  /// Rayon de flou des ombres secondaires
  static const double secondaryShadowBlurRadius = 6;

  /// Décalage vertical des ombres secondaires
  static const Offset secondaryShadowOffset = Offset(
    0,
    3,
  );

  /// Rayon de flou des ombres des barres
  static const double barShadowBlurRadius = 6;

  /// Décalage des ombres des barres
  static const Offset barShadowOffset = Offset(
    0,
    3,
  );

  // === PALETTE DE COULEURS FIXES ===

  /// Couleurs fixes pour les barres (au-delà du thème)
  static const List<int> barColorsHex = [
    0xFF4CAF50, // Vert
    0xFFFF9800, // Orange
    0xFF9C27B0, // Violet
    0xFF00BCD4, // Cyan
    0xFF8BC34A, // Vert clair
    0xFF2196F3, // Bleu
    0xFFFF5722, // Rouge-orange
  ];

  // === GRILLE ===

  /// Nombre de lignes horizontales principales dans la grille
  static const int majorGridLines = 4;

  /// Rayon des points décoratifs de la grille
  static const double gridDotRadius = 1;

  /// Positions des stops pour les dégradés
  static const List<double> gradientStops = [0, 0.6, 1];

  // === CALCULS UTILITAIRES ===

  /// Calcule la largeur totale d'un graphique avec n points
  static double calculateTotalWidth(int pointCount) {
    return (pointCount * barWidth) + (pointCount - 1) * barSpacing;
  }

  /// Hauteur de l'espace entre la grille et les labels
  static const double gridToLabelsSpacing = 8;

  /// Espacement entre les valeurs et les barres
  static const double valueToBarSpacing = 4;
}
