import 'package:flutter/material.dart';
import '../../../../domain/entities/food_offer.dart';

/// Chip affichant la catégorie de l'offre
class OfferCategoryChip extends StatelessWidget {
  const OfferCategoryChip({required this.category, super.key});
  final FoodCategory category;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _getCategoryInfo(category);

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

  (String, Color) _getCategoryInfo(FoodCategory category) {
    switch (category) {
      case FoodCategory.petitDejeuner:
        return ('Petit-déj', Colors.orange);
      case FoodCategory.dejeuner:
        return ('Déjeuner', Colors.blue);
      case FoodCategory.diner:
        return ('Dîner', Colors.purple);
      case FoodCategory.snack:
        return ('Snack', Colors.pink);
      case FoodCategory.dessert:
        return ('Dessert', Colors.brown);
      case FoodCategory.boisson:
        return ('Boisson', Colors.cyan);
      case FoodCategory.boulangerie:
        return ('Boulangerie', Colors.amber);
      case FoodCategory.fruitLegume:
        return ('Fruits/Légumes', Colors.green);
      case FoodCategory.epicerie:
        return ('Épicerie', Colors.teal);
      default:
        return ('Autre', Colors.grey);
    }
  }
}
