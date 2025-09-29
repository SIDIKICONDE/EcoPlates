import 'package:flutter/material.dart';

import '../../../core/utils/offer_formatters.dart';
import '../../../domain/entities/food_offer.dart';

/// Section des métadonnées de l'offre (type, catégorie, date, statut)
class OfferMetadataSection extends StatelessWidget {
  const OfferMetadataSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Type d'offre et catégorie
          Row(
            children: [
              Expanded(
                child: _buildInfoSection(
                  context,
                  icon: Icons.category,
                  title: "Type d'offre",
                  content: OfferFormatters.formatOfferType(offer.type),
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: _buildInfoSection(
                  context,
                  icon: Icons.restaurant_menu,
                  title: 'Catégorie',
                  content: OfferFormatters.formatFoodCategory(offer.category),
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          // Date de création et statut
          Row(
            children: [
              Expanded(
                child: _buildInfoSection(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Publié',
                  content: OfferFormatters.formatCreatedDate(offer.createdAt),
                  color: Colors.purple,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: _buildInfoSection(
                  context,
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

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16.0,
                color: color,
              ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
