import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

/// Badge affichant la quantité restante d'offres
class OfferQuantityBadge extends StatelessWidget {
  const OfferQuantityBadge({required this.quantity, super.key});
  final int quantity;

  @override
  Widget build(BuildContext context) {
    // Version ultra-compacte du badge
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
            Icons.inventory_2,
            color: EcoPlatesDesignTokens.colors.textPrimary,
            size: EcoPlatesDesignTokens.size.indicator(context),
          ),
          SizedBox(width: context.scaleXS_SM_MD_LG / 2),
          Text(
            '$quantity',
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
