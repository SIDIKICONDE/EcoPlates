import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_utils.dart';

/// Configuration responsive pour les cartes dans les sections slider
class ResponsiveCardConfig {
  ResponsiveCardConfig._();

  /// Calcule la largeur optimale pour les cartes dans un carousel/slider horizontal
  static double getSliderCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Utiliser la logique responsive au lieu du switch sur DeviceType
    // pour mieux gérer les tablettes larges (905-1239px)
    if (ResponsiveUtils.isMobile(context)) {
      // Sur mobile, la carte prend presque toute la largeur
      if (isLandscape) {
        return screenWidth * 0.45; // 2 cartes visibles en paysage mobile
      }
      return screenWidth * 0.85; // 85% de l'écran en portrait
    } else if (ResponsiveUtils.isTabletLarge(context)) {
      // Sur tablette large (905-1239px), montrer 2-3 cartes avec largeur augmentée
      if (isLandscape) {
        return (screenWidth - 80) /
            2.5; // ~2.5 cartes avec padding pour largeur augmentée
      }
      return (screenWidth - 60) /
          1.5; // ~1.5 cartes avec padding pour largeur augmentée
    } else if (ResponsiveUtils.isTablet(context)) {
      // Sur tablette standard (600-904px), montrer 1-2 cartes avec largeur augmentée
      if (isLandscape) {
        return (screenWidth - 80) /
            2; // 2 cartes avec padding pour largeur augmentée
      }
      return (screenWidth - 60) /
          1.3; // ~1.3 cartes avec padding pour largeur augmentée
    } else {
      // Sur desktop (>=1240px), montrer 4 cartes visibles
      const padding = 64.0; // padding horizontal total (32 * 2)
      const spacing = 48.0; // espacement entre 4 cartes (16 * 3)
      final availableWidth = screenWidth - padding - spacing;

      // Diviser par 4 pour avoir exactement 4 cartes visibles
      return availableWidth / 4;
    }
  }

  /// Calcule le padding horizontal pour les sliders
  static EdgeInsets getSliderPadding(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 12.0),
      tablet: const EdgeInsets.symmetric(horizontal: 20.0),
      tabletLarge: const EdgeInsets.symmetric(horizontal: 24.0),
      desktop: const EdgeInsets.symmetric(horizontal: 32.0),
      desktopLarge: const EdgeInsets.symmetric(horizontal: 40.0),
    );
  }

  /// Calcule l'espacement entre les cartes
  static double getCardSpacing(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: 8.0,
      tablet: 12.0,
      tabletLarge: 14.0,
      desktop: 16.0,
      desktopLarge: 20.0,
    );
  }

  /// Calcule la hauteur optimale pour le conteneur du slider
  /// Désormais calculée dynamiquement en fonction de la largeur de carte et de l'aspect
  /// afin d'éviter les chevauchements quand le contenu textuel est plus grand.
  static double getSliderHeight(BuildContext context) {
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;

    // Largeur effective d'une carte dans le slider
    final cardWidth = getSliderCardWidth(context);

    // Aspect des images utilisées dans les sliders (cartes compactes)
    final bool isMobile = ResponsiveUtils.isMobile(context);
    final double imageAspect = isMobile
        ? (isLandscape ? 16 / 7 : 2 / 1) // compact portrait: 2:1
        : (isLandscape ? 16 / 7 : 16 / 9);

    final double imageHeight = cardWidth / imageAspect;

    // Hauteur de contenu estimée (zone texte + prix en mode compact)
    final double contentBase = ResponsiveUtils.responsiveValue(
      context,
      mobile: 80.0,
      tablet: 96.0,
      tabletLarge: 104.0,
      desktop: 120.0, // Augmenté pour desktop avec images plus grandes
      desktopLarge:
          140.0, // Augmenté pour desktop large avec images plus grandes
    );

    // Espacements verticaux/paddings cumulés
    final double spacing = ResponsiveUtils.getVerticalSpacing(context) * 0.5;

    // Hauteur dynamique totale
    double dynamicHeight = imageHeight + contentBase + spacing;

    // Contraintes minimales et maximales par plateforme pour éviter les extrêmes
    final double minH = ResponsiveUtils.responsiveValue(
      context,
      mobile: 220.0, // Réduit pour mobile plus compact
      tablet: 280.0,
      tabletLarge: 300.0,
      desktop: 340.0, // Augmenté pour accommoder les images plus grandes
      desktopLarge: 380.0, // Augmenté pour accommoder les images plus grandes
    );
    final double maxH = ResponsiveUtils.responsiveValue(
      context,
      mobile: 320.0, // Réduit pour mobile plus compact
      tablet: 420.0,
      tabletLarge: 440.0,
      desktop: 480.0, // Augmenté pour accommoder les images plus grandes
      desktopLarge: 520.0, // Augmenté pour accommoder les images plus grandes
    );

    return dynamicHeight.clamp(minH, maxH);
  }

  /// Calcule la taille de police pour les titres de section
  static double getSectionTitleFontSize(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: 18.0,
      tablet: 20.0,
      tabletLarge: 22.0,
      desktop: 24.0,
      desktopLarge: 26.0,
    );
  }

  /// Calcule la largeur pour les cartes en mode grille
  static double getGridCardWidth(BuildContext context, {int columnsCount = 2}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = getSliderPadding(context);
    final spacing = getCardSpacing(context);

    final availableWidth = screenWidth - padding.horizontal;
    final totalSpacing = spacing * (columnsCount - 1);

    return (availableWidth - totalSpacing) / columnsCount;
  }

  /// Retourne le nombre de colonnes optimal pour une grille
  static int getOptimalGridColumns(BuildContext context) {
    return ResponsiveUtils.getResponsiveColumns(
      context,
      tabletColumns: 2,
      tabletLargeColumns: 3,
      desktopColumns: 4,
      desktopLargeColumns: 5,
    );
  }

  /// Vérifie si on doit afficher en mode carousel ou grille
  static bool shouldUseCarousel(BuildContext context) {
    // Sur mobile, toujours carousel
    // Sur tablette et plus, possibilité de grille
    return ResponsiveUtils.isMobile(context);
  }

  /// Calcule le viewport fraction pour PageView (si utilisé)
  static double getViewportFraction(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: 0.92,
      tablet: 0.5, // 2 cartes visibles
      tabletLarge: 0.33, // 3 cartes visibles
      desktop: 0.25, // 4 cartes visibles
      desktopLarge: 0.25, // 4 cartes visibles
    );
  }
}
