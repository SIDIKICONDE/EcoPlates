import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';
import '../../../../core/services/image_cache_service.dart';
import '../../../../core/widgets/eco_cached_image.dart';
import '../../../../domain/entities/food_offer.dart';
import 'offer_quantity_badge.dart';
import 'offer_rating_badge.dart';

/// Widget spécialisé pour afficher l'image principale d'une carte d'offre
/// Inclut tous les badges informatifs (réduction, temps restant, quantité)
/// Utilise CachedNetworkImage pour optimiser les performances réseau
/// Respecte les standards EcoPlates avec une mise en page moderne et accessible
class OfferCardImage extends StatelessWidget {
  const OfferCardImage({
    required this.offer,
    super.key,
    this.compact = false,
    this.showInactiveBadge = false,
  });

  /// L'offre alimentaire dont on affiche l'image et les badges
  final FoodOffer offer;

  /// Mode compact pour réduire la hauteur de l'image
  final bool compact;

  /// Afficher le badge "Inactif" pour les offres désactivées
  final bool showInactiveBadge;

  /// Construit le widget avec une mise en page en stack pour superposer les badges
  /// Utilise un système de padding cohérent avec les autres composants de carte
  /// Optimise les performances avec CachedNetworkImage et gestion d'erreur
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    // En paysage, réduire encore la hauteur visuelle pour éviter overflow
    final bool isLandscape = orientation == Orientation.landscape;
    final double computedAspect = compact
        ? (isLandscape ? 16 / 7 : 2 / 1)
        : (isLandscape ? 16 / 7 : 16 / 9);
    final size = MediaQuery.of(context).size;
    final double maxImageHeight = isLandscape
        ? (compact ? size.height * 0.22 : size.height * 0.28)
        : (compact ? size.height * 0.26 : size.height * 0.34);
    return Padding(
      padding: EdgeInsets.all(
        compact ? context.scaleXXS_XS_SM_MD / 2 : context.scaleXXS_XS_SM_MD,
      ), // Réduit en mode compact
      child: Stack(
        children: [
          // Section image principale avec coins arrondis
          ClipRRect(
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.md,
            ),
            child: Stack(
              children: [
                // Image principale avec ratio adaptatif et limite de hauteur
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxImageHeight),
                  child: AspectRatio(
                    aspectRatio: computedAspect,
                    child: offer.images.isNotEmpty
                        ? EcoCachedImage(
                            imageUrl: offer.images.first,
                            size: compact ? ImageSize.small : ImageSize.medium,
                            priority: Priority
                                .high, // Haute priorité pour les images d'offres
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.md,
                            ),
                            // Placeholder optimisé inclus
                            errorWidget: _OfferPlaceholderImage(
                              type: offer.type,
                            ),
                          )
                        : _OfferPlaceholderImage(type: offer.type),
                  ),
                ),
                // Bordure interne subtile pour améliorer la définition visuelle
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        EcoPlatesDesignTokens.radius.md,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        ),
                        width: EcoPlatesDesignTokens.layout.cardBorderWidth / 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Badge nombre de produits restants en haut à gauche
          if (offer.quantity > 0)
            Positioned(
              top: context.scaleMD_LG_XL_XXL,
              left: context.scaleMD_LG_XL_XXL,
              child: OfferQuantityBadge(quantity: offer.quantity),
            ),

          // Coeur favoris flottant déplacé dans le contenu

          // Badge "Inactif" pour les offres désactivées (en haut au centre)
          if (showInactiveBadge && !offer.isAvailable)
            Positioned(
              top: context.scaleLG_XL_XXL_XXXL,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleMD_LG_XL_XXL,
                    vertical: context.scaleXS_SM_MD_LG,
                  ),
                  decoration: BoxDecoration(
                    color: EcoPlatesDesignTokens.colors.snackbarError
                        .withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        ),
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.lg,
                    ),
                  ),
                  child: Text(
                    'Inactif',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.text(context),
                      color: EcoPlatesDesignTokens.colors.snackbarError,
                      fontWeight: EcoPlatesDesignTokens.typography.bold,
                    ),
                  ),
                ),
              ),
            ),

          // Badge rating de l'enseigne en haut à droite
          Positioned(
            top: context.scaleMD_LG_XL_XXL,
            right: context.scaleMD_LG_XL_XXL,
            child: OfferRatingBadge(rating: _getMerchantRating()),
          ),

          // Logo de l'enseigne en bas à gauche
          Positioned(
            bottom: context.scaleMD_LG_XL_XXL,
            left: context.scaleMD_LG_XL_XXL,
            child: _buildMerchantLogo(context),
          ),
        ],
      ),
    );
  }

  /// Construit le logo de l'enseigne
  Widget _buildMerchantLogo(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    final double base = EcoPlatesDesignTokens.size.modalIcon(context);
    // Réduire sensiblement en horizontal, et encore plus en mode compact
    final double factor = isLandscape
        ? (compact ? 1.6 : 2.1)
        : (compact ? 2.1 : 3.0);
    final double logoSize = base * factor;
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: EcoPlatesDesignTokens.colors.textPrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: ClipOval(child: _getMerchantLogo(context)),
    );
  }

  /// Génère le logo selon le nom de l'enseigne
  Widget _getMerchantLogo(BuildContext context) {
    final merchantName = offer.merchantName.toLowerCase();

    // URLs des vrais logos des enseignes
    String? logoUrl;
    var backgroundColor = Colors.white;

    if (merchantName.contains('mcdonald')) {
      logoUrl =
          'https://logos-world.net/wp-content/uploads/2020/04/McDonalds-Logo.png';
      backgroundColor = EcoPlatesDesignTokens.colors.snackbarError.withValues(
        alpha: EcoPlatesDesignTokens.opacity.verySubtle,
      );
    } else if (merchantName.contains('carrefour')) {
      logoUrl =
          'https://logos-world.net/wp-content/uploads/2020/11/Carrefour-Logo.png';
      backgroundColor = Theme.of(context).colorScheme.primary.withValues(
        alpha: EcoPlatesDesignTokens.opacity.verySubtle,
      );
    } else if (merchantName.contains('starbucks')) {
      logoUrl =
          'https://logos-world.net/wp-content/uploads/2020/04/Starbucks-Logo.png';
      backgroundColor = EcoPlatesDesignTokens.colors.snackbarSuccess.withValues(
        alpha: EcoPlatesDesignTokens.opacity.verySubtle,
      );
    } else if (merchantName.contains('monoprix')) {
      logoUrl =
          'https://logos-world.net/wp-content/uploads/2020/12/Monoprix-Logo.png';
      backgroundColor = Theme.of(context).colorScheme.secondary.withValues(
        alpha: EcoPlatesDesignTokens.opacity.verySubtle,
      );
    } else if (merchantName.contains('paul')) {
      logoUrl =
          'https://upload.wikimedia.org/wikipedia/fr/thumb/3/3a/Logo_Paul.svg/1200px-Logo_Paul.svg.png';
      backgroundColor = Theme.of(context).colorScheme.tertiary.withValues(
        alpha: EcoPlatesDesignTokens.opacity.verySubtle,
      );
    }

    // Si on a une URL de logo, on l'affiche
    if (logoUrl != null) {
      return ColoredBox(
        color: backgroundColor,
        child: EcoCachedImage(
          imageUrl: logoUrl,
          size: ImageSize.medium,
          errorWidget: _getFallbackLogo(merchantName, context),
        ),
      );
    }

    // Fallback pour les enseignes inconnues
    return _getFallbackLogo(merchantName, context);
  }

  /// Logo de fallback avec la première lettre
  Widget _getFallbackLogo(String merchantName, BuildContext context) {
    final firstLetter = offer.merchantName.isNotEmpty
        ? offer.merchantName[0].toUpperCase()
        : '?';

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
            fontSize: EcoPlatesDesignTokens.typography.text(context),
            fontWeight: EcoPlatesDesignTokens.typography.bold,
          ),
        ),
      ),
    );
  }

  /// Génère un rating pour l'enseigne
  double _getMerchantRating() {
    final merchantName = offer.merchantName.toLowerCase();

    // Ratings simulés pour les enseignes connues
    if (merchantName.contains('mcdonald')) {
      return 4.2;
    } else if (merchantName.contains('carrefour')) {
      return 4.1;
    } else if (merchantName.contains('starbucks')) {
      return 4.5;
    } else if (merchantName.contains('monoprix')) {
      return 3.9;
    } else if (merchantName.contains('paul')) {
      return 4.3;
    }
    // Rating générique pour les autres enseignes
    else {
      return 4;
    }
  }
}

// Bouton favoris flottant déplacé dans OfferCardContent

/// Widget d'image par défaut contextuel selon le type d'offre alimentaire
/// Affiche une icône représentative du type de nourriture pour améliorer l'identification
/// Utilisé quand l'image réseau n'est pas disponible ou en cas d'erreur de chargement
/// Respecte le design system avec des icônes Material Design cohérentes
class _OfferPlaceholderImage extends StatelessWidget {
  const _OfferPlaceholderImage({required this.type});

  /// Le type d'offre pour déterminer l'icône appropriée
  final OfferType type;

  /// Construit un container avec icône centrée et stylisée
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          _getIconForType(type),
          size: EcoPlatesDesignTokens.size.modalIcon(context),
          color: Theme.of(context).colorScheme.onSurface.withValues(
            alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
          ),
        ),
      ),
    );
  }

  /// Sélectionne l'icône Material Design appropriée selon le type d'offre
  /// Utilise des icônes évocatrices pour faciliter la reconnaissance visuelle
  /// Retourne une icône par défaut si le type n'est pas reconnu
  IconData _getIconForType(OfferType type) {
    switch (type) {
      case OfferType.panier:
        return Icons.shopping_basket; // Panier complet
      case OfferType.plat:
        return Icons.restaurant; // Repas préparé
      case OfferType.boulangerie:
        return Icons.bakery_dining; // Produits de boulangerie
      case OfferType.fruits:
        return Icons.apple; // Fruits et légumes
      case OfferType.epicerie:
        return Icons.storefront; // Épicerie générale
      case OfferType.autre:
        return Icons.fastfood; // Nourriture générique par défaut
    }
  }
}
