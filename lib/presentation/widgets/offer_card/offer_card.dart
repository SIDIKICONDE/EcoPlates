import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../../../domain/entities/food_offer.dart';
import 'widgets/offer_card_image.dart';
import 'widgets/offer_card_content.dart';

/// Widget de carte pour afficher une offre anti-gaspillage
/// Utilisable dans toutes les listes et grilles de l'application
class OfferCard extends StatelessWidget {
  final FoodOffer offer;
  final VoidCallback? onTap;
  final bool showDistance;
  final double? distance; // en km

  const OfferCard({
    super.key,
    required this.offer,
    this.onTap,
    this.showDistance = true,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: _buildSemanticLabel(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image avec badges
                OfferCardImage(offer: offer),
                
                // Contenu de la carte
                OfferCardContent(
                  offer: offer,
                  showDistance: showDistance,
                  distance: distance,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildSemanticLabel() {
    final buffer = StringBuffer();
    buffer.write('${offer.title} chez ${offer.merchantName}. ');
    buffer.write('Prix: ${offer.priceText}. ');
    
    if (offer.isFree) {
      buffer.write('Offre gratuite. ');
    } else {
      buffer.write('Réduction de ${offer.discountPercentage.toStringAsFixed(0)}%. ');
    }
    
    if (showDistance && distance != null) {
      buffer.write('À ${distance!.toStringAsFixed(1)} kilomètres. ');
    }
    
    if (offer.canPickup) {
      buffer.write('Collecte disponible. ');
    }
    
    return buffer.toString();
  }
}