import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Infos pratiques',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Horaire de récupération
          _buildCompactInfo(
            icon: Icons.access_time_filled,
            label: 'À récupérer',
            value: OfferFormatters.formatPickupTime(offer),
            iconColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
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
