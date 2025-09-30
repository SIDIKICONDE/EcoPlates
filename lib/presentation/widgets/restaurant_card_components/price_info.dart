import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

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
    final originalPriceFontSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 10.0,
      tablet: 11.0,
      desktop: 12.0,
    );
    final discountedPriceFontSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
    final minPriceFontSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasActiveOffer &&
            originalPrice != null &&
            discountedPrice != null) ...[
          Text(
            '${originalPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: DeepColorTokens.neutral600,
              decoration: TextDecoration.lineThrough,
              fontSize: originalPriceFontSize,
            ),
          ),
          Text(
            '${discountedPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: DeepColorTokens.error,
              fontWeight: FontWeight.bold,
              fontSize: discountedPriceFontSize,
            ),
          ),
        ] else if (minPrice != null) ...[
          Text(
            'Dès ${minPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: DeepColorTokens.neutral800,
              fontSize: minPriceFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
