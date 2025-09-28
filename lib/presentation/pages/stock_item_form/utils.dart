import 'package:flutter/material.dart';

/// Utilitaires pour la page de formulaire d'article de stock

/// Liste des catégories disponibles
const List<String> stockItemCategories = [
  'Fruits',
  'Légumes',
  'Plats',
  'Boulangerie',
  'Boissons',
  'Épicerie',
  'Viande',
  'Poisson',
  'Produits laitiers',
  'Surgelés',
  'Autre',
];

/// Liste des unités courantes
const List<String> stockItemUnits = [
  'pièce',
  'kg',
  'g',
  'litre',
  'ml',
  'portion',
  'barquette',
  'sachet',
  'bouteille',
  'pot',
];

/// Retourne la couleur associée à une catégorie
Color getCategoryColor(BuildContext context, String category) {
  final theme = Theme.of(context);
  final colors = {
    'Fruits': theme.colorScheme.secondary,
    'Légumes': theme.colorScheme.primary,
    'Plats': theme.colorScheme.tertiary,
    'Boulangerie': theme.colorScheme.primaryContainer,
    'Boissons': theme.colorScheme.secondaryContainer,
    'Épicerie': theme.colorScheme.tertiaryContainer,
    'Viande': theme.colorScheme.error,
    'Poisson': theme.colorScheme.inversePrimary,
    'Produits laitiers': theme.colorScheme.surfaceContainerHighest,
    'Surgelés': theme.colorScheme.surfaceContainer,
    'Autre': theme.colorScheme.outline,
  };
  return colors[category] ?? theme.colorScheme.outline;
}

/// Retourne l'icône associée à une catégorie
IconData getCategoryIcon(String category) {
  final icons = {
    'Fruits': Icons.apple,
    'Légumes': Icons.eco,
    'Plats': Icons.restaurant,
    'Boulangerie': Icons.bakery_dining,
    'Boissons': Icons.local_drink,
    'Épicerie': Icons.shopping_basket,
    'Viande': Icons.kebab_dining,
    'Poisson': Icons.set_meal,
    'Produits laitiers': Icons.icecream,
    'Surgelés': Icons.ac_unit,
    'Autre': Icons.more_horiz,
  };
  return icons[category] ?? Icons.category;
}

/// Retourne l'icône associée à une unité
IconData getUnitIcon(String unit) {
  final icons = {
    'pièce': Icons.looks_one,
    'kg': Icons.fitness_center,
    'g': Icons.grain,
    'litre': Icons.water_drop,
    'ml': Icons.water_drop_outlined,
    'portion': Icons.restaurant_menu,
    'barquette': Icons.inventory_2,
    'sachet': Icons.shopping_bag,
    'bouteille': Icons.local_drink,
    'pot': Icons.soup_kitchen,
  };
  return icons[unit] ?? Icons.straighten;
}

/// Formate une date/heure de manière relative
String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return "À l'instant";
  } else if (difference.inMinutes < 60) {
    return 'Il y a ${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return 'Il y a ${difference.inHours} h';
  } else if (difference.inDays == 1) {
    return 'Hier';
  } else if (difference.inDays < 7) {
    return 'Il y a ${difference.inDays} jours';
  } else {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
