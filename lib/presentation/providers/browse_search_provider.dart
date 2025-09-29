import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/map_service.dart';

/// Provider pour gérer le texte de recherche
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
  void clear() => state = '';
}

/// Provider pour gérer l'état du filtre actif
final isFilterActiveProvider = NotifierProvider<FilterActiveNotifier, bool>(
  FilterActiveNotifier.new,
);

class FilterActiveNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set({required bool value}) => state = value;
}

/// Provider pour gérer la localisation active
final isLocationActiveProvider = NotifierProvider<LocationActiveNotifier, bool>(
  LocationActiveNotifier.new,
);

class LocationActiveNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set({required bool value}) => state = value;
}

/// Classe pour gérer les filtres de recherche
class BrowseFilters {
  const BrowseFilters({
    this.maxDistance,
    this.minPrice,
    this.maxPrice,
    this.categories = const [],
    this.dietaryPreferences = const [],
    this.availableNow = false,
    this.freeOnly = false,
  });
  final double? maxDistance; // en km
  final double? minPrice;
  final double? maxPrice;
  final List<String>
  categories; // slugs ou labels (convertis via Categories.fromString)
  final List<String> dietaryPreferences;
  final bool availableNow;
  final bool freeOnly;

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
    var count = 0;
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
final browseFiltersProvider =
    NotifierProvider<BrowseFiltersNotifier, BrowseFilters>(
      BrowseFiltersNotifier.new,
    );

class BrowseFiltersNotifier extends Notifier<BrowseFilters> {
  @override
  BrowseFilters build() => const BrowseFilters();

  set filters(BrowseFilters filters) => state = filters;
  BrowseFilters get filters => state;
  void clearFilters() => state = const BrowseFilters();

  void updateMaxDistance(double? distance) {
    state = state.copyWith(maxDistance: distance);
  }

  void updatePriceRange({double? min, double? max}) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void updateCategories(List<String> categories) {
    state = state.copyWith(categories: categories);
  }

  void toggleAvailableNow() {
    state = state.copyWith(availableNow: !state.availableNow);
  }

  void toggleFreeOnly() {
    state = state.copyWith(freeOnly: !state.freeOnly);
  }
}

/// Provider pour centrer la carte sur la position utilisateur
final centerMapOnUserProvider = FutureProvider<void>((ref) async {
  await MapService().centerOnUserLocation();
});
