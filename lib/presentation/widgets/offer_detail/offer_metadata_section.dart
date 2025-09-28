import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/utils/offer_formatters.dart';
import '../../../domain/entities/food_offer.dart';

/// Section des métadonnées de l'offre (type, catégorie, date, statut)
class OfferMetadataSection extends StatelessWidget {
  const OfferMetadataSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
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
              SizedBox(width: context.scaleMD_LG_XL_XXL),
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
          SizedBox(height: context.scaleMD_LG_XL_XXL),

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
              SizedBox(width: context.scaleMD_LG_XL_XXL),
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
      padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: EcoPlatesDesignTokens.opacity.verySubtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        border: Border.all(
          color: color.withValues(alpha: EcoPlatesDesignTokens.opacity.subtle),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: EcoPlatesDesignTokens.size.indicator(context),
                color: color,
              ),
              SizedBox(width: context.scaleXXS_XS_SM_MD),
              Text(
                title,
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: color,
                  fontWeight: EcoPlatesDesignTokens.typography.medium,
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleXXS_XS_SM_MD),
          Text(
            content,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
              fontWeight: EcoPlatesDesignTokens.typography.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
