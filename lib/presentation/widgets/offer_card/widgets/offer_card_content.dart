import 'package:flutter/material.dart';
import '../../../../domain/entities/food_offer.dart';
import 'offer_category_chip.dart';
import 'offer_diet_badge.dart';
import 'offer_price_info.dart';
import 'offer_location_info.dart';
import 'offer_eco_impact.dart';

/// Contenu de la carte d'offre (titre, description, prix, etc.)
class OfferCardContent extends StatelessWidget {
  final FoodOffer offer;
  final bool showDistance;
  final double? distance;

  const OfferCardContent({
    super.key,
    required this.offer,
    required this.showDistance,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nom du commerçant et catégorie
          _buildMerchantRow(theme),
          const SizedBox(height: 8),

          // Titre de l'offre
          _buildTitle(),
          const SizedBox(height: 6),

          // Description
          _buildDescription(),
          const SizedBox(height: 12),

          // Informations du bas
          _buildBottomInfo(theme),

          // Badges diététiques
          if (offer.isVegetarian || offer.isVegan || offer.isHalal)
            _buildDietaryBadges(),

          // Impact écologique
          if (offer.co2Saved > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OfferEcoImpact(co2Saved: offer.co2Saved),
            ),
        ],
      ),
    );
  }

  Widget _buildMerchantRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            offer.merchantName,
            style: TextStyle(
              fontSize: 14,
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        OfferCategoryChip(category: offer.category),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      offer.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      offer.description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBottomInfo(ThemeData theme) {
    return Row(
      children: [
        // Prix
        Expanded(
          child: OfferPriceInfo(
            isFree: offer.isFree,
            originalPrice: offer.originalPrice,
            priceText: offer.priceText,
            primaryColor: theme.primaryColor,
          ),
        ),

        // Distance et horaire
        OfferLocationInfo(
          showDistance: showDistance,
          distance: distance,
          pickupStartTime: offer.pickupStartTime,
          pickupEndTime: offer.pickupEndTime,
        ),
      ],
    );
  }

  Widget _buildDietaryBadges() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        children: [
          if (offer.isVegan)
            const OfferDietBadge(
              label: 'Vegan',
              color: Colors.green,
            ),
          if (offer.isVegetarian && !offer.isVegan)
            const OfferDietBadge(
              label: 'Végétarien',
              color: Colors.lightGreen,
            ),
          if (offer.isHalal)
            const OfferDietBadge(
              label: 'Halal',
              color: Colors.orange,
            ),
        ],
      ),
    );
  }
}