import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/food_offer.dart';
import '../../data/repositories/food_offer_repository.dart';
import '../../core/error/failures.dart';
import 'user/user_location_provider.dart';

/// Types de filtres pour les offres
enum OfferFilterType {
  all,
  nearMe,
  lastMinute,
  budget,
  vegetarian,
  bakery,
  newOffers,
  bestDeals,
}

/// Paramètres de filtre pour les offres
class OfferFilterParams {
  final OfferFilterType type;
  final double? maxPrice;
  final double? maxDistance;
  final FoodCategory? category;
  final bool? isVegetarian;
  final bool? isVegan;
  final int limit;

  const OfferFilterParams({
    this.type = OfferFilterType.all,
    this.maxPrice,
    this.maxDistance,
    this.category,
    this.isVegetarian,
    this.isVegan,
    this.limit = 10,
  });

  OfferFilterParams copyWith({
    OfferFilterType? type,
    double? maxPrice,
    double? maxDistance,
    FoodCategory? category,
    bool? isVegetarian,
    bool? isVegan,
    int? limit,
  }) {
    return OfferFilterParams(
      type: type ?? this.type,
      maxPrice: maxPrice ?? this.maxPrice,
      maxDistance: maxDistance ?? this.maxDistance,
      category: category ?? this.category,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      limit: limit ?? this.limit,
    );
  }
}

/// État pour gérer les offres d'un slider
class OffersSliderState {
  final List<FoodOffer> offers;
  final bool isLoading;
  final String? error;
  final OfferFilterParams filters;

  const OffersSliderState({
    this.offers = const [],
    this.isLoading = false,
    this.error,
    required this.filters,
  });

  OffersSliderState copyWith({
    List<FoodOffer>? offers,
    bool? isLoading,
    String? error,
    OfferFilterParams? filters,
  }) {
    return OffersSliderState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filters: filters ?? this.filters,
    );
  }
}

/// Notifier pour gérer l'état des offres du slider
class OffersSliderNotifier extends StateNotifier<OffersSliderState> {
  final FoodOfferRepository _repository;
  final OfferFilterParams initialFilters;
  final Ref _ref;

  OffersSliderNotifier(this._repository, this.initialFilters, this._ref)
      : super(OffersSliderState(filters: initialFilters)) {
    loadOffers();
  }

  /// Charge les offres selon les filtres
  Future<void> loadOffers() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final offers = await _fetchOffersBasedOnFilter();
      state = state.copyWith(
        offers: offers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Impossible de charger les offres: $e',
      );
    }
  }

  /// Récupère les offres en fonction du type de filtre
  Future<List<FoodOffer>> _fetchOffersBasedOnFilter() async {
    // Récupérer la localisation de l'utilisateur
    final userLocation = _ref.read(userLocationProvider);
    final latitude = userLocation?.latitude ?? 48.8566; // Paris par défaut
    final longitude = userLocation?.longitude ?? 2.3522;

    Either<Failure, List<FoodOffer>> result;

    switch (state.filters.type) {
      case OfferFilterType.nearMe:
        result = await _repository.getNearbyOffers(
          latitude: latitude,
          longitude: longitude,
          radius: state.filters.maxDistance ?? 2.0,
          limit: state.filters.limit,
        );
        break;

      case OfferFilterType.lastMinute:
        // Utiliser getExpiringOffers pour les offres dernière minute
        result = await _repository.getExpiringOffers(
          latitude: latitude,
          longitude: longitude,
          hoursAhead: 2,
          limit: state.filters.limit,
        );
        break;

      case OfferFilterType.budget:
        // Utiliser getAvailableOffers avec filtre de prix
        result = await _repository.getAvailableOffers(
          latitude: latitude,
          longitude: longitude,
          limit: state.filters.limit,
        );
        break;

      case OfferFilterType.vegetarian:
        // Utiliser getAvailableOffers avec filtre
        result = await _repository.getAvailableOffers(
          latitude: latitude,
          longitude: longitude,
          limit: state.filters.limit,
        );
        break;

      case OfferFilterType.bakery:
        // Utiliser getAvailableOffers avec catégorie
        result = await _repository.getAvailableOffers(
          latitude: latitude,
          longitude: longitude,
          categories: [FoodCategory.boulangerie],
          limit: state.filters.limit,
        );
        break;

      case OfferFilterType.newOffers:
        // Utiliser getAvailableOffers trié par date de création
        result = await _repository.getAvailableOffers(
          latitude: latitude,
          longitude: longitude,
          sortBy: 'createdAt',
          limit: state.filters.limit,
        );
        break;

      case OfferFilterType.bestDeals:
        // Utiliser getPopularOffers pour les meilleures offres
        result = await _repository.getPopularOffers(
          latitude: latitude,
          longitude: longitude,
          limit: state.filters.limit,
        );
        break;

      case OfferFilterType.all:
        result = await _repository.getAvailableOffers(
          latitude: latitude,
          longitude: longitude,
          limit: state.filters.limit,
        );
        break;
    }

    // Extraire la valeur de Either ou lancer une exception
    return result.fold(
      (failure) => throw Exception(failure.message),
      (offers) {
        // Appliquer des filtres supplémentaires si nécessaire
        var filteredOffers = offers;
        
        // Filtre par prix pour budget
        if (state.filters.type == OfferFilterType.budget && state.filters.maxPrice != null) {
          filteredOffers = filteredOffers
              .where((offer) => offer.discountedPrice <= state.filters.maxPrice!)
              .toList();
        }
        
        // Filtre végétarien/vegan
        if (state.filters.type == OfferFilterType.vegetarian) {
          filteredOffers = filteredOffers.where((offer) {
            if (state.filters.isVegan == true) {
              return offer.isVegan;
            }
            return offer.isVegetarian || offer.isVegan;
          }).toList();
        }
        
        return filteredOffers;
      },
    );
  }

  /// Recharge les offres
  Future<void> refresh() async {
    await loadOffers();
  }

  /// Met à jour les filtres et recharge les offres
  void updateFilters(OfferFilterParams filters) {
    state = state.copyWith(filters: filters);
    loadOffers();
  }

  /// Ajoute plus d'offres (pagination)
  Future<void> loadMore() async {
    if (state.isLoading) return;

    final newFilters = state.filters.copyWith(
      limit: state.filters.limit + 10,
    );
    updateFilters(newFilters);
  }
}

/// Provider principal pour toutes les offres
final allOffersSliderProvider =
    StateNotifierProvider<OffersSliderNotifier, OffersSliderState>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return OffersSliderNotifier(
    repository,
    const OfferFilterParams(type: OfferFilterType.all),
    ref,
  );
});

/// Provider pour les offres près de l'utilisateur
final nearbyOffersSliderProvider =
    StateNotifierProvider<OffersSliderNotifier, OffersSliderState>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return OffersSliderNotifier(
    repository,
    const OfferFilterParams(type: OfferFilterType.nearMe, maxDistance: 2.0),
    ref,
  );
});

/// Provider pour les offres dernière minute
final lastMinuteOffersSliderProvider =
    StateNotifierProvider<OffersSliderNotifier, OffersSliderState>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return OffersSliderNotifier(
    repository,
    const OfferFilterParams(type: OfferFilterType.lastMinute),
    ref,
  );
});

/// Provider pour les offres petit budget
final budgetOffersSliderProvider =
    StateNotifierProvider<OffersSliderNotifier, OffersSliderState>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return OffersSliderNotifier(
    repository,
    const OfferFilterParams(type: OfferFilterType.budget, maxPrice: 5.0),
    ref,
  );
});

/// Provider pour les offres végétariennes
final vegetarianOffersSliderProvider =
    StateNotifierProvider<OffersSliderNotifier, OffersSliderState>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return OffersSliderNotifier(
    repository,
    const OfferFilterParams(
      type: OfferFilterType.vegetarian,
      isVegetarian: true,
    ),
    ref,
  );
});

/// Provider pour les offres boulangerie
final bakeryOffersSliderProvider =
    StateNotifierProvider<OffersSliderNotifier, OffersSliderState>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return OffersSliderNotifier(
    repository,
    const OfferFilterParams(type: OfferFilterType.bakery),
    ref,
  );
});

/// Provider pour les nouvelles offres
final newOffersSliderProvider =
    StateNotifierProvider<OffersSliderNotifier, OffersSliderState>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return OffersSliderNotifier(
    repository,
    const OfferFilterParams(type: OfferFilterType.newOffers),
    ref,
  );
});

/// Provider pour les meilleures offres
final bestDealsSliderProvider =
    StateNotifierProvider<OffersSliderNotifier, OffersSliderState>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return OffersSliderNotifier(
    repository,
    const OfferFilterParams(type: OfferFilterType.bestDeals),
    ref,
  );
});
