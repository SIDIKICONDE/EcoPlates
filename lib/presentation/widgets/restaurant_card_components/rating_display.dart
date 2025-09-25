import 'package:flutter/material.dart';
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
              return const Icon(
                Icons.star,
                size: 14,
                color: AccessibleColors.ratingAmber,
                semanticLabel: '',
              );
            } else if (index == starCount && halfStar) {
              return const Icon(
                Icons.star_half,
                size: 14,
                color: AccessibleColors.ratingAmber,
                semanticLabel: '',
              );
            } else {
              return Icon(
                Icons.star_border,
                size: 14,
                color: AccessibleColors.ratingAmber.withValues(alpha: 0.5),
                semanticLabel: '',
              );
            }
          }),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: AccessibleFontSizes.small,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
