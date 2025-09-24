import 'package:flutter/material.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../core/utils/offer_formatters.dart';

/// Section des métadonnées de l'offre (type, catégorie, date, statut)
class OfferMetadataSection extends StatelessWidget {
  final FoodOffer offer;

  const OfferMetadataSection({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Type d'offre et catégorie
          Row(
            children: [
              Expanded(
                child: _buildInfoSection(
                  icon: Icons.category,
                  title: 'Type d\'offre',
                  content: OfferFormatters.formatOfferType(offer.type),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoSection(
                  icon: Icons.restaurant_menu,
                  title: 'Catégorie',
                  content: OfferFormatters.formatFoodCategory(offer.category),
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date de création et statut
          Row(
            children: [
              Expanded(
                child: _buildInfoSection(
                  icon: Icons.calendar_today,
                  title: 'Publié',
                  content: OfferFormatters.formatCreatedDate(offer.createdAt),
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoSection(
                  icon: Icons.info_outline,
                  title: 'Statut',
                  content: OfferFormatters.formatOfferStatus(offer.status),
                  color: OfferFormatters.getStatusColor(offer.status),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
