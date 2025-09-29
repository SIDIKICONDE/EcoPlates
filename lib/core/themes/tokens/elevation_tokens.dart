import 'package:flutter/material.dart';

/// Tokens d'élévation pour le design system EcoPlates
/// Basé sur Material Design 3 avec des adaptations
class EcoElevation {
  EcoElevation._();

  // ===== NIVEAUX D'ÉLÉVATION =====
  static const double level0 = 0; // Aucune élévation
  static const double level1 = 1; // Très léger
  static const double level2 = 3; // Léger
  static const double level3 = 6; // Modéré
  static const double level4 = 8; // Fort
  static const double level5 = 12; // Très fort

  // ===== ÉLÉVATIONS PAR COMPOSANT =====

  // Cards
  static const double cardElevation = level1;
  static const double cardHoverElevation = level2;
  static const double cardPressedElevation = level0;

  // Buttons
  static const double buttonElevation = level1;
  static const double buttonHoverElevation = level2;
  static const double buttonPressedElevation = level0;
  static const double fabElevation = level3;

  // Navigation
  static const double appBarElevation = level0;
  static const double navBarElevation = level2;
  static const double drawerElevation = level4;

  // Overlays
  static const double modalElevation = level5;
  static const double dialogElevation = level5;
  static const double menuElevation = level3;
  static const double tooltipElevation = level4;

  // Lists et contenus
  static const double listElevation = level0;
  static const double chipElevation = level0;
  static const double switchElevation = level1;

  // ===== SHADOWS PERSONNALISÉES =====

  // Shadow légère pour cards normales
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D000000), // 5% d'opacité
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: Color(0x1A000000), // 10% d'opacité
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  // Shadow pour cards au hover
  static const List<BoxShadow> cardHoverShadow = [
    BoxShadow(
      color: Color(0x1A000000), // 10% d'opacité
      offset: Offset(0, 3),
      blurRadius: 6,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% d'opacité
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  // Shadow pour éléments flottants (FAB, dialogs)
  static const List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color(0x33000000), // 20% d'opacité
      offset: Offset(0, 6),
      blurRadius: 10,
    ),
    BoxShadow(
      color: Color(0x1A000000), // 10% d'opacité
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  // Shadow pour navigation (bottom nav, app bar avec scroll)
  static const List<BoxShadow> navigationShadow = [
    BoxShadow(
      color: Color(0x1A000000), // 10% d'opacité
      offset: Offset(0, -1),
      blurRadius: 4,
    ),
  ];

  // Shadow subtile pour les éléments légèrement surélevés
  static const List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Color(0x0D000000), // 5% d'opacité
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  // Shadow prononcée pour les overlays
  static const List<BoxShadow> overlayShadow = [
    BoxShadow(
      color: Color(0x4D000000), // 30% d'opacité
      offset: Offset(0, 10),
      blurRadius: 20,
    ),
    BoxShadow(
      color: Color(0x1A000000), // 10% d'opacité
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  // ===== SHADOWS AVEC COULEURS PERSONNALISÉES =====

  // Shadow verte pour les éléments eco
  static const List<BoxShadow> ecoShadow = [
    BoxShadow(
      color: Color(0x1A4CAF50), // Vert avec 10% d'opacité
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  // Shadow orange pour les éléments d'action
  static const List<BoxShadow> actionShadow = [
    BoxShadow(
      color: Color(0x1AFF9800), // Orange avec 10% d'opacité
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  // Shadow rouge pour les éléments d'urgence/erreur
  static const List<BoxShadow> errorShadow = [
    BoxShadow(
      color: Color(0x1AE53935), // Rouge avec 10% d'opacité
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  // ===== HELPER METHODS =====

  /// Crée une BoxShadow personnalisée
  static BoxShadow createShadow({
    required Color color,
    required Offset offset,
    required double blurRadius,
    double spreadRadius = 0.0,
  }) => BoxShadow(
    color: color,
    offset: offset,
    blurRadius: blurRadius,
    spreadRadius: spreadRadius,
  );

  /// Crée une shadow avec opacité sur le noir
  static BoxShadow createBlackShadow({
    required double opacity,
    required Offset offset,
    required double blurRadius,
    double spreadRadius = 0.0,
  }) => BoxShadow(
    color: Color((0xFF000000 * opacity).round()),
    offset: offset,
    blurRadius: blurRadius,
    spreadRadius: spreadRadius,
  );

  /// Obtient l'élévation selon l'état interactif
  static double getInteractiveElevation({
    required double baseElevation,
    required bool isHovered,
    required bool isPressed,
  }) {
    if (isPressed) return baseElevation * 0.5;
    if (isHovered) return baseElevation * 1.5;
    return baseElevation;
  }
}
