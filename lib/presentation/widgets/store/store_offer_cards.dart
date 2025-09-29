import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/eco_cached_image.dart';
import '../../../domain/entities/food_offer.dart';
import '../offer_card.dart';

/// Carte pour afficher une offre en mode grille
class StoreOfferGridCard extends ConsumerWidget {
  const StoreOfferGridCard({
    required this.offer,
    required this.onTap,
    super.key,
  });

  final FoodOffer offer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: ColorFiltered(
          colorFilter: !offer.isAvailable
              ? const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0, // Rouge
                  0.2126, 0.7152, 0.0722, 0, 0, // Vert
                  0.2126, 0.7152, 0.0722, 0, 0, // Bleu
                  0, 0, 0, 1, 0, // Alpha
                ])
              : const ColorFilter.matrix(<double>[
                  1, 0, 0, 0, 0, // Rouge
                  0, 1, 0, 0, 0, // Vert
                  0, 0, 1, 0, 0, // Bleu
                  0, 0, 0, 1, 0, // Alpha
                ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.0),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: EcoCachedImage(
                        imageUrl: offer.images.isNotEmpty
                            ? offer.images.first
                            : '',
                      ),
                    ),
                  ),
                  // Badges
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    right: 8.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!offer.isAvailable)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              ),
                            ),
                            child: Text(
                              'Inactif',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: theme.colorScheme.onErrorContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (offer.discountPercentage > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              ),
                            ),
                            child: Text(
                              '-${offer.discountPercentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: theme.colorScheme.onError,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              // Contenu
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      // Description courte
                      Text(
                        offer.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      // Horaires de collecte
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16.0,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              '${_formatTime(offer.pickupStartTime)} - ${_formatTime(offer.pickupEndTime)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Prix et stock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (offer.discountPercentage > 0)
                                Text(
                                  '${offer.originalPrice.toStringAsFixed(2)}€',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              Text(
                                '${offer.discountedPrice.toStringAsFixed(2)}€',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  offer.alertLevel == OfferAlertLevel.outOfStock
                                  ? theme.colorScheme.errorContainer
                                  : offer.alertLevel == OfferAlertLevel.low
                                  ? theme.colorScheme.tertiaryContainer
                                  : theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.inventory_2,
                                  size: 16.0,
                                  color:
                                      offer.alertLevel ==
                                          OfferAlertLevel.outOfStock
                                      ? theme.colorScheme.error
                                      : offer.alertLevel == OfferAlertLevel.low
                                      ? theme.colorScheme.tertiary
                                      : theme.colorScheme.primary,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  '${offer.quantity}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        offer.alertLevel ==
                                            OfferAlertLevel.outOfStock
                                        ? theme.colorScheme.onErrorContainer
                                        : offer.alertLevel ==
                                              OfferAlertLevel.low
                                        ? theme.colorScheme.onTertiaryContainer
                                        : theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Carte pour afficher une offre en mode liste utilisant OfferCard
class StoreOfferListCard extends ConsumerWidget {
  const StoreOfferListCard({
    required this.offer,
    required this.onTap,
    super.key,
  });

  final FoodOffer offer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OfferCard(
      offer: offer,
      onTap: onTap,
      compact: true, // Mode compact pour la liste
      showDistance: false, // Pas de distance pour les offres du marchand
    );
  }
}
