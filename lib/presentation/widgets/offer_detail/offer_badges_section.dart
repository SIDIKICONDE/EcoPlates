import 'package:flutter/material.dart';

import '../../../domain/entities/food_offer.dart';

/// Section des allergènes avec slider moderne
class OfferBadgesSection extends StatelessWidget {
  const OfferBadgesSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    // N'afficher que s'il y a des allergènes
    if (offer.allergens.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec icône moderne
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 16.0,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              'Allergènes présents',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),

        // Slider horizontal des allergènes
        SizedBox(
          height: 40.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offer.allergens.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8.0),
            itemBuilder: (context, index) {
              final allergen = offer.allergens[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  allergen,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
