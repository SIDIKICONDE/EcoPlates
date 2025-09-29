import 'package:flutter/material.dart';

import '../../domain/entities/food_offer.dart';

/// Métadonnées centralisées pour les catégories d'offres
class CategoryInfo {
  const CategoryInfo({
    required this.id,
    required this.slug,
    required this.label,
    this.synonyms = const [],
  });

  final FoodCategory id;
  final String slug; // ex: "petit-dejeuner"
  final String label; // ex: "Petit-déjeuner"
  final List<String> synonyms; // ex: ["petit dej", "breakfast"]
}

class Categories {
  static const Map<FoodCategory, CategoryInfo> _info = {
    FoodCategory.petitDejeuner: CategoryInfo(
      id: FoodCategory.petitDejeuner,
      slug: 'petit-dejeuner',
      label: 'Petit-déjeuner',
      synonyms: ['petit dej', 'breakfast', 'matin'],
    ),
    FoodCategory.dejeuner: CategoryInfo(
      id: FoodCategory.dejeuner,
      slug: 'dejeuner',
      label: 'Déjeuner',
      synonyms: ['lunch', 'midi', 'repas'],
    ),
    FoodCategory.diner: CategoryInfo(
      id: FoodCategory.diner,
      slug: 'diner',
      label: 'Dîner',
      synonyms: ['soir', 'dinner', 'repas'],
    ),
    FoodCategory.snack: CategoryInfo(
      id: FoodCategory.snack,
      slug: 'snack',
      label: 'Snack',
      synonyms: ['encas', 'gouter', 'goûter'],
    ),
    FoodCategory.dessert: CategoryInfo(
      id: FoodCategory.dessert,
      slug: 'dessert',
      label: 'Dessert',
      synonyms: ['sucré', 'patisserie', 'pâtisserie'],
    ),
    FoodCategory.boisson: CategoryInfo(
      id: FoodCategory.boisson,
      slug: 'boisson',
      label: 'Boisson',
      synonyms: ['cafe', 'café', 'the', 'thé', 'jus'],
    ),
    FoodCategory.boulangerie: CategoryInfo(
      id: FoodCategory.boulangerie,
      slug: 'boulangerie',
      label: 'Boulangerie',
      synonyms: ['bakery', 'pain', 'viennoiserie'],
    ),
    FoodCategory.fruitLegume: CategoryInfo(
      id: FoodCategory.fruitLegume,
      slug: 'fruits-legumes',
      label: 'Fruits et légumes',
      synonyms: ['fruit', 'legume', 'légume', 'primeur'],
    ),
    FoodCategory.epicerie: CategoryInfo(
      id: FoodCategory.epicerie,
      slug: 'epicerie',
      label: 'Épicerie',
      synonyms: ['grocery', 'épicerie', 'courses'],
    ),
    FoodCategory.autre: CategoryInfo(
      id: FoodCategory.autre,
      slug: 'autre',
      label: 'Autre',
      synonyms: ['divers'],
    ),
  };

  static const List<FoodCategory> ordered = [
    FoodCategory.petitDejeuner,
    FoodCategory.dejeuner,
    FoodCategory.diner,
    FoodCategory.snack,
    FoodCategory.dessert,
    FoodCategory.boisson,
    FoodCategory.boulangerie,
    FoodCategory.fruitLegume,
    FoodCategory.epicerie,
    FoodCategory.autre,
  ];

  static List<FoodCategory> get all => FoodCategory.values;

  static CategoryInfo of(FoodCategory category) => _info[category]!;

  static String labelOf(FoodCategory category) => of(category).label;

  static String slugOf(FoodCategory category) => of(category).slug;

  /// Retourne l'icône associée à la catégorie
  static IconData iconOf(FoodCategory category) {
    switch (category) {
      case FoodCategory.petitDejeuner:
        return Icons.free_breakfast;
      case FoodCategory.dejeuner:
        return Icons.lunch_dining;
      case FoodCategory.diner:
        return Icons.dinner_dining;
      case FoodCategory.snack:
        return Icons.fastfood;
      case FoodCategory.dessert:
        return Icons.cake;
      case FoodCategory.boisson:
        return Icons.local_drink;
      case FoodCategory.boulangerie:
        return Icons.bakery_dining;
      case FoodCategory.fruitLegume:
        return Icons.grass; // Alternative: spa, eco
      case FoodCategory.epicerie:
        return Icons.shopping_basket;
      case FoodCategory.autre:
        return Icons.category;
    }
  }

  /// Retourne la couleur associée à la catégorie
  static Color colorOf(FoodCategory category) {
    switch (category) {
      case FoodCategory.petitDejeuner:
        return Colors.orange;
      case FoodCategory.dejeuner:
        return Colors.blue;
      case FoodCategory.diner:
        return Colors.purple;
      case FoodCategory.snack:
        return Colors.pink;
      case FoodCategory.dessert:
        return Colors.brown;
      case FoodCategory.boisson:
        return Colors.cyan;
      case FoodCategory.boulangerie:
        return Colors.amber;
      case FoodCategory.fruitLegume:
        return Colors.green;
      case FoodCategory.epicerie:
        return Colors.teal;
      case FoodCategory.autre:
        return Colors.grey;
    }
  }

  /// Conversion inverse à partir d'un texte (slug, label ou synonymes)
  static FoodCategory? fromString(String value) {
    final v = value.trim().toLowerCase();
    for (final entry in _info.entries) {
      final info = entry.value;
      if (info.slug == v) return entry.key;
      if (info.label.toLowerCase() == v) return entry.key;
      if (info.synonyms.map((s) => s.toLowerCase()).contains(v)) {
        return entry.key;
      }
    }
    return null;
  }
}
