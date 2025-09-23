import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/food_offer.dart';
import 'offer_discount_badge.dart';
import 'offer_time_badge.dart';
import 'offer_quantity_badge.dart';

/// Widget pour afficher l'image de l'offre avec ses badges
class OfferCardImage extends StatelessWidget {
  final FoodOffer offer;
  
  const OfferCardImage({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          // Image principale
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: offer.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: offer.images.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const _ImagePlaceholder(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              _OfferPlaceholderImage(type: offer.type),
                        )
                      : _OfferPlaceholderImage(type: offer.type),
                ),
                // Bordure interne
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 0.25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Badge de réduction en haut à gauche
          Positioned(
            top: 16,
            left: 16,
            child: OfferDiscountBadge(
              isFree: offer.isFree,
              discountBadge: offer.discountBadge,
            ),
          ),

          // Badge de temps restant en haut à droite
          if (offer.canPickup)
            Positioned(
              top: 16,
              right: 16,
              child: OfferTimeBadge(
                timeRemaining: offer.timeRemaining,
              ),
            ),

          // Quantité disponible
          if (offer.quantity > 0)
            Positioned(
              bottom: 16,
              right: 16,
              child: OfferQuantityBadge(
                quantity: offer.quantity,
              ),
            ),
        ],
      ),
    );
  }
}

/// Placeholder pour les images
class _ImagePlaceholder extends StatelessWidget {
  final Widget child;
  
  const _ImagePlaceholder({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(child: child),
    );
  }
}

/// Image par défaut selon le type d'offre
class _OfferPlaceholderImage extends StatelessWidget {
  final OfferType type;
  
  const _OfferPlaceholderImage({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          _getIconForType(type),
          size: 48,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  IconData _getIconForType(OfferType type) {
    switch (type) {
      case OfferType.panier:
        return Icons.shopping_basket;
      case OfferType.plat:
        return Icons.restaurant;
      case OfferType.boulangerie:
        return Icons.bakery_dining;
      case OfferType.fruits:
        return Icons.apple;
      case OfferType.epicerie:
        return Icons.storefront;
      default:
        return Icons.fastfood;
    }
  }
}