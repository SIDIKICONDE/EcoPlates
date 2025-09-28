import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';

/// Widget pour afficher les informations de prix
class PriceInfo extends StatelessWidget {
  const PriceInfo({
    required this.hasActiveOffer,
    super.key,
    this.originalPrice,
    this.discountedPrice,
    this.minPrice,
  });
  final bool hasActiveOffer;
  final double? originalPrice;
  final double? discountedPrice;
  final double? minPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasActiveOffer &&
            originalPrice != null &&
            discountedPrice != null) ...[
          Text(
            '${originalPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: EcoPlatesDesignTokens.colors.textSecondary,
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            '${discountedPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: EcoPlatesDesignTokens.colors.textPrimary,
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              fontWeight: EcoPlatesDesignTokens.typography.bold,
            ),
          ),
        ] else if (minPrice != null)
          Text(
            'Dès ${minPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: EcoPlatesDesignTokens.colors.textPrimary,
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
            ),
          ),
      ],
    );
  }
}
