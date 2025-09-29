import 'package:flutter/material.dart';

/// Configurations centralisées pour les cartes d'offres
/// Permet d'appliquer des styles cohérents selon les pages
class OfferCardConfigs {
  /// Configuration pour les pages d'offres urgentes (all_urgent_offers_screen)
  static const urgentPage = OfferCardPageConfig(
    aspectRatio: 1.8,
    imageBorderRadius: BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
    ),
  );

  /// Configuration par défaut pour toutes les autres pages
  static const defaultConfig = OfferCardPageConfig(
    
  );
}

/// Configuration pour une page spécifique utilisant des cartes d'offres
class OfferCardPageConfig {
  const OfferCardPageConfig({
    this.aspectRatio,
    this.imageBorderRadius,
  });

  /// Rapport largeur/hauteur pour la grille (null = utilise la fonction responsive)
  final double? aspectRatio;

  /// Rayon des coins arrondis pour l'image (null = arrondi complet par défaut)
  final BorderRadius? imageBorderRadius;
}
