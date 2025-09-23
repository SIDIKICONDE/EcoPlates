import 'package:flutter/material.dart';

/// Helper pour gérer les couleurs et icônes des catégories
class CategoryHelper {
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'bakery':
      case 'boulangerie':
        return Colors.brown;
      case 'restaurant':
        return Colors.orange;
      case 'grocery':
      case 'épicerie':
        return Colors.green;
      case 'cafe':
      case 'café':
        return Colors.amber.shade800;
      case 'pizza':
        return Colors.red;
      case 'sushi':
        return Colors.pink;
      default:
        return Colors.indigo;
    }
  }
  
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'bakery':
      case 'boulangerie':
        return Icons.bakery_dining;
      case 'restaurant':
        return Icons.restaurant;
      case 'grocery':
      case 'épicerie':
        return Icons.shopping_basket;
      case 'cafe':
      case 'café':
        return Icons.coffee;
      case 'pizza':
        return Icons.local_pizza;
      case 'sushi':
        return Icons.rice_bowl;
      default:
        return Icons.store;
    }
  }
}