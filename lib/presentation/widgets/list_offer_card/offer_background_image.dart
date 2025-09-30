import 'package:flutter/material.dart';

import '../../../core/widgets/eco_cached_image.dart';
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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image de fond
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: EcoCachedImage(
              imageUrl: offer.images.isNotEmpty ? offer.images.first : '',
              errorWidget: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.grey,
                  size: 40.0,
                ),
              ),
            ),
          ),
        ),

        // Overlay dégradé
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
