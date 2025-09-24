import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/food_offer_extensions.dart';
import '../../../domain/entities/food_offer.dart';

/// Widget pour afficher l'image de fond d'une offre avec overlay
class OfferBackgroundImage extends StatelessWidget {
  const OfferBackgroundImage({
    required this.offer,
    super.key,
  });

  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image de fond
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: offer.images.isNotEmpty
                  ? offer.images.first
                  : offer.backgroundImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.fastfood,
                  size: 40,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),

        // Overlay gradient pour lisibilité
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.7),
                Colors.black.withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
