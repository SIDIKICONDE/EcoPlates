import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../core/utils/accessibility_helper.dart';

/// Widget pour afficher la note avec des étoiles accessibles WCAG
class RatingDisplay extends StatelessWidget {
  const RatingDisplay({required this.rating, super.key});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final starCount = rating.floor();
    final halfStar = rating - starCount >= 0.5;

    return Semantics(
      label: 'Noté ${rating.toStringAsFixed(1)} sur 5 étoiles',
      child: Row(
        children: [
          ...List.generate(5, (index) {
            if (index < starCount) {
              return Icon(
                Icons.star,
                size: EcoPlatesDesignTokens.size.indicator(context),
                color: AccessibleColors.ratingAmber,
                semanticLabel: '',
              );
            } else if (index == starCount && halfStar) {
              return Icon(
                Icons.star_half,
                size: EcoPlatesDesignTokens.size.indicator(context),
                color: AccessibleColors.ratingAmber,
                semanticLabel: '',
              );
            } else {
              return Icon(
                Icons.star_border,
                size: EcoPlatesDesignTokens.size.indicator(context),
                color: AccessibleColors.ratingAmber.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                semanticLabel: '',
              );
            }
          }),
          SizedBox(width: context.scaleXXS_XS_SM_MD),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: EcoPlatesDesignTokens.colors.textPrimary,
              fontSize: AccessibleFontSizes.small,
              fontWeight: EcoPlatesDesignTokens.typography.bold,
              letterSpacing: EcoPlatesDesignTokens.typography
                  .titleLetterSpacing(context),
            ),
          ),
        ],
      ),
    );
  }
}
