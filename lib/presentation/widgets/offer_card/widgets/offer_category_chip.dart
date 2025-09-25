import 'package:flutter/material.dart';

import '../../../../core/constants/categories.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
