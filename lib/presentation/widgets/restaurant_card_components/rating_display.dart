import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget pour afficher la note avec des étoiles accessibles WCAG
class RatingDisplay extends StatelessWidget {
  const RatingDisplay({required this.rating, super.key});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final starCount = rating.floor();
    final halfStar = rating - starCount >= 0.5;

    final starSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );
    final textFontSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
    final spacing = ResponsiveUtils.getHorizontalSpacing(context) * 0.17;

    return Semantics(
      label: 'Noté ${rating.toStringAsFixed(1)} sur 5 étoiles',
      child: Row(
        children: [
          ...List.generate(5, (index) {
            if (index < starCount) {
              return Icon(
                Icons.star,
                size: starSize,
                color: DeepColorTokens.accent,
                semanticLabel: '',
              );
            } else if (index == starCount && halfStar) {
              return Icon(
                Icons.star_half,
                size: starSize,
                color: DeepColorTokens.accent,
                semanticLabel: '',
              );
            } else {
              return Icon(
                Icons.star_border,
                size: starSize,
                color: DeepColorTokens.accent.withValues(alpha: 0.25),
                semanticLabel: '',
              );
            }
          }),
          SizedBox(width: spacing),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: DeepColorTokens.accent,
              fontSize: textFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
