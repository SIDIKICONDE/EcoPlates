import 'package:flutter/material.dart';

import '../../../../domain/entities/food_offer.dart';

/// Widget spécialisé pour afficher les informations de prix
/// Gère les prix barrés, les prix actuels et les offres gratuites
class OfferCardPriceDisplay extends StatelessWidget {
  const OfferCardPriceDisplay({
    required this.offer,
    this.compact = false,
    super.key,
  });

  final FoodOffer offer;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!offer.isFree) ...[
          Text(
            '€${offer.originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: compact ? 10.0 : 11.0, // Valeurs fixes
              decoration: TextDecoration.lineThrough,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 4.0), // Valeur fixe
        ],
        Text(
          offer.priceText,
          style: TextStyle(
            fontSize: compact ? 14.0 : 16.0, // Valeurs fixes
            fontWeight: FontWeight.bold,
            color: offer.isFree ? Colors.green : theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
