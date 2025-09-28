import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/food_offer.dart';

/// Section d'informations essentielles pour l'acheteur
class OfferInfoSection extends StatelessWidget {
  const OfferInfoSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de l'offre
        Text(
          offer.title,
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.titleSize(context) * 1.2,
            fontWeight: EcoPlatesDesignTokens.typography.bold,
          ),
        ),
        SizedBox(height: context.scaleLG_XL_XXL_XXXL),

        // Description
        Text(
          'Que contient cette offre ?',
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
            fontWeight: EcoPlatesDesignTokens.typography.bold,
          ),
        ),
        SizedBox(height: context.scaleXXS_XS_SM_MD),
        Text(
          offer.description,
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.text(context),
            height: EcoPlatesDesignTokens.layout.textLineHeight,
          ),
        ),
      ],
    );
  }
}
