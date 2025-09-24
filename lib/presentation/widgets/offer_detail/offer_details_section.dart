import 'package:flutter/material.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../core/utils/offer_formatters.dart';

/// Section des informations pratiques pour la récupération
class OfferDetailsSection extends StatelessWidget {
  final FoodOffer offer;

  const OfferDetailsSection({
    super.key,
    required this.offer,
  });

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
          Text(
            'Infos pratiques',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
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
