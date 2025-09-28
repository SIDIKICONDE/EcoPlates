import 'package:flutter/material.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/responsive/design_tokens.dart';
import '../../../../domain/entities/food_offer.dart';

/// Chip affichant la catégorie de l'offre (centralisé)
class OfferCategoryChip extends StatelessWidget {
  const OfferCategoryChip({required this.category, super.key});
  final FoodCategory category;

  @override
  Widget build(BuildContext context) {
    final label = Categories.labelOf(category);
    final color = Categories.colorOf(category);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXS_SM_MD_LG,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: EcoPlatesDesignTokens.opacity.verySubtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        border: Border.all(
          color: color.withValues(alpha: EcoPlatesDesignTokens.opacity.subtle),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: EcoPlatesDesignTokens.typography.hint(context),
          color: color,
          fontWeight: EcoPlatesDesignTokens.typography.semiBold,
        ),
      ),
    );
  }
}
