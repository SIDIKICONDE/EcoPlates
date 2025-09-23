import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/food_offer.dart';

/// État des filtres appliqués
@immutable
class OfferFilters {
  final bool isFreeOnly;
  final bool isNearbyOnly;
  final double maxDistance;
  final List<FoodCategory> selectedCategories;
  final List<String> dietaryPreferences;
  final double? maxPrice;
  final TimeOfDay? pickupTimeStart;
  final TimeOfDay? pickupTimeEnd;
  final SortOption sortBy;
  final bool showExpiredOffers;

  const OfferFilters({
    this.isFreeOnly = false,
    this.isNearbyOnly = true,
    this.maxDistance = 5.0, // km
    this.selectedCategories = const [],
    this.dietaryPreferences = const [],
    this.maxPrice,
    this.pickupTimeStart,
    this.pickupTimeEnd,
    this.sortBy = SortOption.distance,
    this.showExpiredOffers = false,
  });

  OfferFilters copyWith({
    bool? isFreeOnly,
    bool? isNearbyOnly,
    double? maxDistance,
    List<FoodCategory>? selectedCategories,
    List<String>? dietaryPreferences,
    double? maxPrice,
    TimeOfDay? pickupTimeStart,
    TimeOfDay? pickupTimeEnd,
    SortOption? sortBy,
    bool? showExpiredOffers,
  }) {
    return OfferFilters(
      isFreeOnly: isFreeOnly ?? this.isFreeOnly,
      isNearbyOnly: isNearbyOnly ?? this.isNearbyOnly,
      maxDistance: maxDistance ?? this.maxDistance,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      maxPrice: maxPrice ?? this.maxPrice,
      pickupTimeStart: pickupTimeStart ?? this.pickupTimeStart,
      pickupTimeEnd: pickupTimeEnd ?? this.pickupTimeEnd,
      sortBy: sortBy ?? this.sortBy,
      showExpiredOffers: showExpiredOffers ?? this.showExpiredOffers,
    );
  }

  /// Vérifie si des filtres actifs sont appliqués
  bool get hasActiveFilters {
    return isFreeOnly ||
        selectedCategories.isNotEmpty ||
        dietaryPreferences.isNotEmpty ||
        maxPrice != null ||
        pickupTimeStart != null ||
        pickupTimeEnd != null ||
        !isNearbyOnly ||
        maxDistance != 5.0;
  }

  /// Compte le nombre de filtres actifs
  int get activeFiltersCount {
    int count = 0;
    if (isFreeOnly) count++;
    if (selectedCategories.isNotEmpty) count++;
    if (dietaryPreferences.isNotEmpty) count++;
    if (maxPrice != null) count++;
    if (pickupTimeStart != null || pickupTimeEnd != null) count++;
    if (!isNearbyOnly || maxDistance != 5.0) count++;
    return count;
  }

  /// Réinitialise tous les filtres
  static const OfferFilters initial = OfferFilters();
}

/// Options de tri disponibles
enum SortOption {
  distance('Distance'),
  price('Prix'),
  discount('Réduction'),
  pickupTime('Heure de collecte'),
  newest('Plus récent'),
  expiringSoon('Expire bientôt');

  final String label;
  const SortOption(this.label);
}

/// Provider pour gérer les filtres
class FiltersNotifier extends StateNotifier<OfferFilters> {
  FiltersNotifier() : super(OfferFilters.initial);

  /// Met à jour le filtre gratuit uniquement
  void toggleFreeOnly() {
    state = state.copyWith(isFreeOnly: !state.isFreeOnly);
  }

  /// Met à jour le filtre de proximité
  void toggleNearbyOnly() {
    state = state.copyWith(isNearbyOnly: !state.isNearbyOnly);
  }

  /// Met à jour la distance maximum
  void setMaxDistance(double distance) {
    state = state.copyWith(maxDistance: distance);
  }

  /// Ajoute ou retire une catégorie
  void toggleCategory(FoodCategory category) {
    final categories = List<FoodCategory>.from(state.selectedCategories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(selectedCategories: categories);
  }

  /// Ajoute ou retire une préférence alimentaire
  void toggleDietaryPreference(String preference) {
    final preferences = List<String>.from(state.dietaryPreferences);
    if (preferences.contains(preference)) {
      preferences.remove(preference);
    } else {
      preferences.add(preference);
    }
    state = state.copyWith(dietaryPreferences: preferences);
  }

  /// Met à jour le prix maximum
  void setMaxPrice(double? price) {
    state = state.copyWith(maxPrice: price);
  }

  /// Met à jour l'heure de collecte début
  void setPickupTimeStart(TimeOfDay? time) {
    state = state.copyWith(pickupTimeStart: time);
  }

  /// Met à jour l'heure de collecte fin
  void setPickupTimeEnd(TimeOfDay? time) {
    state = state.copyWith(pickupTimeEnd: time);
  }

  /// Met à jour l'option de tri
  void setSortOption(SortOption option) {
    state = state.copyWith(sortBy: option);
  }

  /// Réinitialise tous les filtres
  void resetFilters() {
    state = OfferFilters.initial;
  }

  /// Applique un ensemble de filtres prédéfinis
  void applyPreset(FilterPreset preset) {
    switch (preset) {
      case FilterPreset.freeOnly:
        state = OfferFilters.initial.copyWith(isFreeOnly: true);
        break;
      case FilterPreset.vegetarian:
        state = OfferFilters.initial.copyWith(
          dietaryPreferences: ['vegetarian', 'vegan'],
        );
        break;
      case FilterPreset.bakery:
        state = OfferFilters.initial.copyWith(
          selectedCategories: [FoodCategory.boulangerie],
        );
        break;
      case FilterPreset.dinner:
        state = OfferFilters.initial.copyWith(
          selectedCategories: [FoodCategory.diner],
          pickupTimeStart: const TimeOfDay(hour: 18, minute: 0),
          pickupTimeEnd: const TimeOfDay(hour: 22, minute: 0),
        );
        break;
      case FilterPreset.nearMe:
        state = OfferFilters.initial.copyWith(
          isNearbyOnly: true,
          maxDistance: 2.0,
        );
        break;
    }
  }
}

/// Présets de filtres pour accès rapide
enum FilterPreset {
  freeOnly,
  vegetarian,
  bakery,
  dinner,
  nearMe,
}

/// Provider principal pour les filtres
final filtersProvider = StateNotifierProvider<FiltersNotifier, OfferFilters>((ref) {
  return FiltersNotifier();
});

/// Provider pour filtrer les offres selon les critères
final filteredOffersProvider = Provider.family<List<FoodOffer>, List<FoodOffer>>((ref, offers) {
  final filters = ref.watch(filtersProvider);
  
  return offers.where((offer) {
    // Filtre gratuit
    if (filters.isFreeOnly && !offer.isFree) {
      return false;
    }
    
    // Filtre catégories
    if (filters.selectedCategories.isNotEmpty && 
        !filters.selectedCategories.contains(offer.category)) {
      return false;
    }
    
    // Filtre préférences alimentaires
    if (filters.dietaryPreferences.isNotEmpty) {
      bool matchesPreference = false;
      for (final pref in filters.dietaryPreferences) {
        switch (pref) {
          case 'vegetarian':
            if (offer.isVegetarian) matchesPreference = true;
            break;
          case 'vegan':
            if (offer.isVegan) matchesPreference = true;
            break;
          case 'halal':
            if (offer.isHalal) matchesPreference = true;
            break;
        }
      }
      if (!matchesPreference) return false;
    }
    
    // Filtre prix maximum
    if (filters.maxPrice != null && offer.discountedPrice > filters.maxPrice!) {
      return false;
    }
    
    // Filtre horaire de collecte
    if (filters.pickupTimeStart != null || filters.pickupTimeEnd != null) {
      final offerStartTime = TimeOfDay.fromDateTime(offer.pickupStartTime);
      final offerEndTime = TimeOfDay.fromDateTime(offer.pickupEndTime);
      
      if (filters.pickupTimeStart != null) {
        if (_timeToMinutes(offerStartTime) < _timeToMinutes(filters.pickupTimeStart!)) {
          return false;
        }
      }
      
      if (filters.pickupTimeEnd != null) {
        if (_timeToMinutes(offerEndTime) > _timeToMinutes(filters.pickupTimeEnd!)) {
          return false;
        }
      }
    }
    
    // Filtre offres expirées
    if (!filters.showExpiredOffers && !offer.isAvailable) {
      return false;
    }
    
    return true;
  }).toList()
    ..sort((a, b) {
      // Appliquer le tri
      switch (filters.sortBy) {
        case SortOption.distance:
          // TODO: Implémenter avec la vraie distance utilisateur
          return 0;
        case SortOption.price:
          return a.discountedPrice.compareTo(b.discountedPrice);
        case SortOption.discount:
          final discountA = (a.originalPrice - a.discountedPrice) / a.originalPrice;
          final discountB = (b.originalPrice - b.discountedPrice) / b.originalPrice;
          return discountB.compareTo(discountA); // Plus grande réduction en premier
        case SortOption.pickupTime:
          return a.pickupStartTime.compareTo(b.pickupStartTime);
        case SortOption.newest:
          return b.createdAt.compareTo(a.createdAt);
        case SortOption.expiringSoon:
          return a.pickupEndTime.compareTo(b.pickupEndTime);
      }
    });
});

/// Convertit TimeOfDay en minutes pour la comparaison
int _timeToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

/// Provider pour obtenir les filtres actifs sous forme de Map
final activeFiltersProvider = Provider<Map<String, dynamic>?>((ref) {
  final filters = ref.watch(filtersProvider);
  
  if (!filters.hasActiveFilters) {
    return null;
  }
  
  return {
    'maxDistance': filters.maxDistance,
    'maxPrice': filters.maxPrice,
    'favoritesOnly': filters.isFreeOnly, // Adapter selon besoin
    'categories': filters.selectedCategories,
    'dietaryPreferences': filters.dietaryPreferences,
    'pickupTimeStart': filters.pickupTimeStart,
    'pickupTimeEnd': filters.pickupTimeEnd,
    'sortBy': filters.sortBy,
  };
});
