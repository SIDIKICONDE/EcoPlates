import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../core/utils/offer_formatters.dart';
import '../../../domain/entities/food_offer.dart';

/// Section des informations pratiques pour la récupération
class OfferDetailsSection extends StatelessWidget {
  const OfferDetailsSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.surfaceContainer,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: DeepColorTokens.neutral0.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Infos pratiques',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),

          // Horaire de récupération
          _buildCompactInfo(
            context: context,
            icon: Icons.access_time_filled,
            label: 'À récupérer',
            value: OfferFormatters.formatPickupTime(offer),
            iconColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12.0),

          // Quantité disponible
          _buildCompactInfo(
            context: context,
            icon: Icons.inventory_2,
            label: 'Quantité disponible',
            value: '${offer.quantity} portions',
            iconColor: theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfo({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20.0,
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  color: DeepColorTokens.neutral0.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
