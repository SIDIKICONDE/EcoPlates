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
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
