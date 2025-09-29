import 'package:flutter/material.dart';

/// Options de tri pour les offres alimentaires
enum SortOption {
  relevance('Pertinence', 'Résultats les plus pertinents'),
  urgency('Plus urgent', 'Offres qui expirent bientôt'),
  distance('Plus proche', 'Distance la plus courte'),
  priceLow('Prix le plus bas', 'Meilleures affaires'),
  priceHigh('Prix le plus élevé', 'Offres premium'),
  newest('Plus récent', 'Offres récemment ajoutées'),
  rating('Mieux noté', 'Offres les mieux évaluées');

  const SortOption(this.label, this.description);

  final String label;
  final String description;

  /// Icône associée à chaque option de tri
  IconData get icon {
    switch (this) {
      case SortOption.relevance:
        return Icons.trending_up;
      case SortOption.urgency:
        return Icons.timer;
      case SortOption.distance:
        return Icons.location_on;
      case SortOption.priceLow:
        return Icons.euro;
      case SortOption.priceHigh:
        return Icons.euro_symbol;
      case SortOption.newest:
        return Icons.schedule;
      case SortOption.rating:
        return Icons.star;
    }
  }

  /// Couleur associée à chaque option de tri
  Color get color {
    switch (this) {
      case SortOption.relevance:
        return Colors.blue;
      case SortOption.urgency:
        return Colors.red;
      case SortOption.distance:
        return Colors.green;
      case SortOption.priceLow:
        return Colors.orange;
      case SortOption.priceHigh:
        return Colors.purple;
      case SortOption.newest:
        return Colors.teal;
      case SortOption.rating:
        return Colors.amber;
    }
  }
}
