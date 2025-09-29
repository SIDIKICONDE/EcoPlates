import 'package:flutter/material.dart';

import '../../../core/constants/categories.dart';
import '../../../domain/entities/food_offer.dart';

/// Helper pour gérer les couleurs et icônes des catégories (centralisé)
class CategoryHelper {
  static Color getCategoryColor(String categoryText) {
    final cat = Categories.fromString(categoryText) ?? FoodCategory.autre;
    return Categories.colorOf(cat);
  }

  static IconData getCategoryIcon(String categoryText) {
    final cat = Categories.fromString(categoryText) ?? FoodCategory.autre;
    return Categories.iconOf(cat);
  }
}
