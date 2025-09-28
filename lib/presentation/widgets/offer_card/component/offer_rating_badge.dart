import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

/// Badge affichant le rating de l'enseigne avec étoiles
class OfferRatingBadge extends StatelessWidget {
  const OfferRatingBadge({required this.rating, super.key});
  final double rating;

  @override
  Widget build(BuildContext context) {
    // Version compacte du badge de rating
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleMD_LG_XL_XXL,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
          alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: EcoPlatesDesignTokens.colors.snackbarWarning,
            size: EcoPlatesDesignTokens.size.indicator(context),
          ),
          SizedBox(width: context.scaleXS_SM_MD_LG / 2),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: EcoPlatesDesignTokens.colors.textPrimary,
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              fontWeight: EcoPlatesDesignTokens.typography.bold,
              height: EcoPlatesDesignTokens.layout.textLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
