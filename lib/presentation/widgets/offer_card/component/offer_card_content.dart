import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../common/offer_card_favorite_button.dart';
import 'offer_card_description.dart';
import 'offer_card_merchant_name.dart';
import 'offer_card_pickup_info.dart';
import 'offer_card_price_display.dart';

/// Widget affichant le contenu textuel d'une carte d'offre
/// Inclut le nom du commerçant, la description, les horaires de récupération et le prix
/// Respecte les standards EcoPlates avec une mise en page optimisée
class OfferCardContent extends StatelessWidget {
  const OfferCardContent({
    required this.offer,
    required this.showDistance,
    super.key,
    this.distance,
    this.compact = false,
  });

  /// L'offre alimentaire à afficher
  final FoodOffer offer;

  /// Indique si la distance doit être affichée
  final bool showDistance;

  /// Distance calculée depuis la position utilisateur
  final double? distance;

  /// Mode compact pour réduire l'espacement
  final bool compact;

  /// Construit le widget avec la mise en page du contenu
  /// Utilise une colonne avec espacement optimisé pour l'UX
  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactContent(context);
    }
    return _buildNormalContent(context);
  }

  Widget _buildCompactContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0, // Valeur fixe
        vertical: 4.0, // Valeur fixe
      ),
      child: Stack(
        children: [
          // Section contenu principale
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom du marchand
              Row(
                children: [
                  Expanded(
                    child: OfferCardMerchantName(
                      merchantName: offer.merchantName,
                      compact: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2.0), // Valeur fixe
              // Description
              OfferCardDescription(
                description: offer.description,
                compact: true,
              ),

              const SizedBox(height: 2.0), // Valeur fixe
              // Informations de récupération
              OfferCardPickupInfo(
                offer: offer,
                showDistance: showDistance,
                distance: distance,
                compact: true,
              ),

              const SizedBox(height: 3.0), // Valeur fixe
              // Ligne de séparation
              Container(
                height: 0.5,
                color: DeepColorTokens.neutral500.withValues(alpha: 0.3),
              ),

              const SizedBox(height: 3.0), // Valeur fixe
              // Prix
              OfferCardPriceDisplay(
                offer: offer,
                compact: true,
              ),
            ],
          ),

          // Bouton favori à l'intérieur du conteneur
          Positioned(
            top: 0,
            right: 4,
            child: OfferCardFavoriteButton(
              isFavorite: offer.isFavorite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Valeur fixe
        vertical: 6.0, // Valeur fixe
      ),
      child: Stack(
        children: [
          // Section contenu principale
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom du marchand
              OfferCardMerchantName(
                merchantName: offer.merchantName,
              ),

              const SizedBox(height: 4.0), // Valeur fixe
              // Description
              OfferCardDescription(
                description: offer.description,
              ),

              const SizedBox(height: 4.0), // Valeur fixe
              // Informations de récupération
              OfferCardPickupInfo(
                offer: offer,
                showDistance: showDistance,
                distance: distance,
              ),

              const SizedBox(height: 6.0), // Valeur fixe
              // Ligne de séparation
              Container(
                height: 0.5,
                color: DeepColorTokens.neutral500.withValues(alpha: 0.3),
              ),

              const SizedBox(height: 6.0), // Valeur fixe
              // Prix
              OfferCardPriceDisplay(offer: offer),
            ],
          ),

          // Bouton favori à l'intérieur du conteneur
          Positioned(
            top: 0,
            right: 4,
            child: OfferCardFavoriteButton(
              isFavorite: offer.isFavorite,
            ),
          ),
        ],
      ),
    );
  }
}
