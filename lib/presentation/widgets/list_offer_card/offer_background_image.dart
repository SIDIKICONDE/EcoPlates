import 'package:flutter/material.dart';

import '../../../core/extensions/food_offer_extensions.dart';
import '../../../core/responsive/design_tokens.dart';
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
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.lg,
            ),
            child: EcoCachedImage(
              imageUrl: offer.images.isNotEmpty
                  ? offer.images.first
                  : offer.backgroundImageUrl,
              placeholder: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              errorWidget: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.lg,
                  ),
                ),
                child: Icon(
                  Icons.fastfood,
                  size: EcoPlatesDesignTokens.size.modalIcon(context),
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Overlay gradient pour lisibilité
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.lg,
            ),
            gradient: LinearGradient(
              colors: [
                EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
