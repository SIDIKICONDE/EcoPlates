import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

/// Widget affichant les informations de prix de l'offre
class OfferPriceInfo extends StatelessWidget {
  const OfferPriceInfo({
    required this.isFree,
    required this.originalPrice,
    required this.priceText,
    required this.primaryColor,
    super.key,
  });
  final bool isFree;
  final double originalPrice;
  final String priceText;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFree) ...[
          Text(
            '€${originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              decoration: TextDecoration.lineThrough,
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
            ),
          ),
          SizedBox(width: context.scaleXS_SM_MD_LG),
        ],
        Text(
          priceText,
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
            fontWeight: EcoPlatesDesignTokens.typography.bold,
            color: isFree
                ? EcoPlatesDesignTokens.colors.snackbarSuccess
                : primaryColor,
          ),
        ),
      ],
    );
  }
}
