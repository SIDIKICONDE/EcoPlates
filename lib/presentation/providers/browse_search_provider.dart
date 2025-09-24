import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/map_service.dart';

/// Provider pour gérer le texte de recherche
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider pour gérer l'état du filtre actif
final isFilterActiveProvider = StateProvider<bool>((ref) => false);

/// Provider pour gérer la localisation active
final isLocationActiveProvider = StateProvider<bool>((ref) => false);

/// Classe pour gérer les filtres de recherche
class BrowseFilters {
  final double? maxDistance; // en km
  final double? minPrice;
  final double? maxPrice;
  final List<String> categories;
  final List<String> dietaryPreferences;
  final bool availableNow;
  final bool freeOnly;

  const BrowseFilters({
    this.maxDistance,
    this.minPrice,
    this.maxPrice,
    this.categories = const [],
    this.dietaryPreferences = const [],
    this.availableNow = false,
    this.freeOnly = false,
  });

  BrowseFilters copyWith({
    double? maxDistance,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? dietaryPreferences,
    bool? availableNow,
    bool? freeOnly,
  }) {
    return BrowseFilters(
      maxDistance: maxDistance ?? this.maxDistance,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      categories: categories ?? this.categories,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      availableNow: availableNow ?? this.availableNow,
      freeOnly: freeOnly ?? this.freeOnly,
    );
  }

  bool get hasActiveFilters {
    return maxDistance != null ||
        minPrice != null ||
        maxPrice != null ||
        categories.isNotEmpty ||
        dietaryPreferences.isNotEmpty ||
        availableNow ||
        freeOnly;
  }

  int get activeFiltersCount {
    int count = 0;
    if (maxDistance != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (categories.isNotEmpty) count++;
    if (dietaryPreferences.isNotEmpty) count++;
    if (availableNow) count++;
    if (freeOnly) count++;
    return count;
  }
}

/// Provider pour gérer les filtres de recherche
final browseFiltersProvider = StateProvider<BrowseFilters>((ref) {
  return const BrowseFilters();
});

/// Provider pour centrer la carte sur la position utilisateur
final centerMapOnUserProvider = FutureProvider<void>((ref) async {
  await MapService.instance.centerOnUserLocation();
});