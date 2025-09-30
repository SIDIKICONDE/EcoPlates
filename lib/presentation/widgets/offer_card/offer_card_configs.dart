import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_utils.dart';

/// Configurations centralisées pour les cartes d'offres
/// Permet d'appliquer des styles cohérents selon les pages
class OfferCardConfigs {
  /// Configuration pour les pages d'offres urgentes (all_urgent_offers_screen)
  static OfferCardPageConfig urgentPage(BuildContext context) =>
      OfferCardPageConfig(
        aspectRatio: ResponsiveUtils.responsiveValue(
          context,
          mobile: 1.8, // Plus équilibré sur mobile pour le contenu texte
          tablet:
              0.7, // Hauteur augmentée sur tablette pour plus d'impact visuel
          tabletLarge: 1.1, // Légèrement large sur tablette large
          desktop: 1.3, // Plus large sur desktop pour utiliser l'espace
          desktopLarge: 1.4, // Encore plus large sur grand écran
        ),
        imageBorderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      );

  /// Configuration pour les sections d'accueil (urgent, nearby, recommended, meals)
  static final homeSections = OfferCardPageConfig(
    imageBorderRadius: BorderRadius.circular(
      8.0,
    ), // Coins complètement arrondis pour les sections
  );

  /// Configuration par défaut pour toutes les autres pages
  static const defaultConfig = OfferCardPageConfig(
    imageBorderRadius: BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
    ), // Coins du bas non arrondis pour les autres pages
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
