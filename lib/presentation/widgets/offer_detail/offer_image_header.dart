import 'package:flutter/material.dart';

import '../../../core/services/image_cache_service.dart';
import '../../../core/utils/offer_formatters.dart';
import '../../../core/widgets/eco_cached_image.dart';
import '../../../domain/entities/food_offer.dart';

/// Header de l'offre avec image et badges
class OfferImageHeader extends StatelessWidget {
  const OfferImageHeader({
    required this.offer,
    required this.onBackPressed,
    super.key,
  });
  final FoodOffer offer;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image principale
            if (offer.images.isNotEmpty)
              EcoCachedImage(
                imageUrl: offer.images.first,
                size: ImageSize.large,
                placeholder: ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: _buildPlaceholderImage(context),
              )
            else
              _buildPlaceholderImage(context),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),

            // Barre en bas avec tous les éléments alignés
            Positioned(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Côté gauche : Merchant et badge temps
                  Expanded(
                    child: Row(
                      children: [
                        // Nom du merchant
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            offer.merchantName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        // Badge temps restant
                        if (offer.canPickup)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14.0,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  OfferFormatters.formatTimeRemaining(
                                    offer.timeRemaining,
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Côté droit : Prix
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (!offer.isFree) ...[
                          Text(
                            '€${offer.originalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.0,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 8.0),
                        ],
                        Text(
                          offer.priceText,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            debugPrint('🔙 Bouton retour SliverAppBar pressé');
            onBackPressed();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 64.0,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
