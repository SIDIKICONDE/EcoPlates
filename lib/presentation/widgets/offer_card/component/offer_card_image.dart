import 'package:flutter/material.dart';

import '../../../../core/services/image_cache_service.dart';
import '../../../../core/widgets/eco_cached_image.dart';
import '../../../../domain/entities/food_offer.dart';
import 'offer_quantity_badge.dart';

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
    final isLandscape = orientation == Orientation.landscape;
    final computedAspect = compact
        ? (isLandscape ? 16 / 7 : 2 / 1)
        : (isLandscape ? 16 / 7 : 16 / 9);
    return Padding(
      padding: EdgeInsets.all(
        compact ? 8.0 : 12.0,
      ), // Réduit en mode compact
      child: Stack(
        children: [
          // Section image principale avec coins arrondis
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: AspectRatio(
              aspectRatio: computedAspect,
              child: offer.images.isNotEmpty
                  ? EcoCachedImage(
                      imageUrl: offer.images.first,
                      size: compact ? ImageSize.small : ImageSize.medium,
                      priority: Priority
                          .high, // Haute priorité pour les images d'offres
                      borderRadius: BorderRadius.circular(16.0),
                    )
                  : _OfferPlaceholderImage(type: offer.type),
            ),
          ),

          // Bordure interne subtile pour améliorer la définition visuelle
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.0,
                ),
              ),
            ),
          ),

          // Badge quantité en haut à gauche
          Positioned(
            top: 12.0,
            left: 12.0,
            child: OfferQuantityBadge(quantity: offer.quantity),
          ),

          // Coeur favoris flottant déplacé dans le contenu

          // Badge "Inactif" pour les offres désactivées (en haut au centre)
          if (showInactiveBadge && !offer.isAvailable)
            Positioned(
              top: 8.0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'INACTIF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          // Logo de l'enseigne en bas à gauche
          Positioned(
            bottom: 12.0,
            left: 12.0,
            child: getFallbackLogo(offer.merchantName, context),
          ),
        ],
      ),
    );
  }

  /// Logo de fallback avec la première lettre
  Widget getFallbackLogo(String merchantName, BuildContext context) {
    final firstLetter = offer.merchantName.isNotEmpty
        ? offer.merchantName[0].toUpperCase()
        : '?';

    return ColoredBox(
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          _getIconForType(type),
          size: 48.0,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

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
