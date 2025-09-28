import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

/// Badge affichant la réduction sur l'offre
class OfferDiscountBadge extends StatelessWidget {
  const OfferDiscountBadge({
    required this.isFree,
    required this.discountBadge,
    super.key,
  });
  final bool isFree;
  final String discountBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleMD_LG_XL_XXL,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: isFree
            ? EcoPlatesDesignTokens.colors.snackbarSuccess
            : EcoPlatesDesignTokens.colors.snackbarWarning,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xxl),
        boxShadow: [
          BoxShadow(
            color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Text(
        discountBadge,
        style: TextStyle(
          color: EcoPlatesDesignTokens.colors.textPrimary,
          fontWeight: EcoPlatesDesignTokens.typography.bold,
          fontSize: EcoPlatesDesignTokens.typography.hint(context),
        ),
      ),
    );
  }
}
