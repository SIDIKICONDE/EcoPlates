import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/categories.dart';
import '../../core/services/promotion_service.dart';
import '../../domain/entities/food_offer.dart';
import 'offers_catalog_provider.dart';

/// Durée par défaut des promotions individuelles (en jours)
const kDefaultPromotionDurationDays = 7;

/// Enum pour les options de tri
enum StoreSortOption {
  nameAsc('Nom (A-Z)', 'Trier par ordre alphabétique croissant'),
  nameDesc('Nom (Z-A)', 'Trier par ordre alphabétique décroissant'),
  priceAsc('Prix croissant', 'Du moins cher au plus cher'),
  priceDesc('Prix décroissant', 'Du plus cher au moins cher'),
  popularityDesc('Popularité', 'Les plus populaires en premier'),
  dateDesc('Plus récents', 'Les offres les plus récentes en premier'),
  stockAsc('Stock faible', 'Articles avec stock faible en premier'),
  promotionFirst('Promotions', 'Offres en promotion en premier');

  const StoreSortOption(this.label, this.description);
  final String label;
  final String description;
}

/// Mode d'affichage (grille ou liste)
enum StoreViewMode { grid, list }

/// État d'affichage des offres
enum OfferDisplayMode { all, activeOnly, inactiveOnly }

/// État des filtres de la boutique
class StoreFiltersState {
  const StoreFiltersState({
    this.searchQuery = '',
    this.displayMode = OfferDisplayMode.all,
    this.showPromotionsOnly = false,
    this.selectedCategories = const [],
    this.sortBy = StoreSortOption.nameAsc,
  });

  final String searchQuery;
  final OfferDisplayMode displayMode;
  final bool showPromotionsOnly;
  final List<FoodCategory> selectedCategories;
  final StoreSortOption sortBy;

  StoreFiltersState copyWith({
    String? searchQuery,
    OfferDisplayMode? displayMode,
    bool? showPromotionsOnly,
    List<FoodCategory>? selectedCategories,
    StoreSortOption? sortBy,
  }) {
    return StoreFiltersState(
      searchQuery: searchQuery ?? this.searchQuery,
      displayMode: displayMode ?? this.displayMode,
      showPromotionsOnly: showPromotionsOnly ?? this.showPromotionsOnly,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class StoreViewModeNotifier extends Notifier<StoreViewMode> {
  @override
  StoreViewMode build() {
    return StoreViewMode.grid;
  }

  void toggle() {
    state = state == StoreViewMode.grid
        ? StoreViewMode.list
        : StoreViewMode.grid;
  }

  void setMode(StoreViewMode mode) {
    state = mode;
  }
}

class StoreFiltersNotifier extends Notifier<StoreFiltersState> {
  @override
  StoreFiltersState build() {
    return const StoreFiltersState();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setDisplayMode(OfferDisplayMode mode) {
    state = state.copyWith(displayMode: mode);
  }

  void toggleDisplayMode() {
    final nextMode = switch (state.displayMode) {
      OfferDisplayMode.all => OfferDisplayMode.activeOnly,
      OfferDisplayMode.activeOnly => OfferDisplayMode.inactiveOnly,
      OfferDisplayMode.inactiveOnly => OfferDisplayMode.all,
    };
    state = state.copyWith(displayMode: nextMode);
  }

  void togglePromotionsOnly() {
    state = state.copyWith(showPromotionsOnly: !state.showPromotionsOnly);
  }

  void toggleCategory(FoodCategory category) {
    final categories = List<FoodCategory>.from(state.selectedCategories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(selectedCategories: categories);
  }

  void clearCategories() {
    state = state.copyWith(selectedCategories: []);
  }

  void updateSortBy(StoreSortOption option) {
    state = state.copyWith(sortBy: option);
  }

  void resetFilters() {
    state = const StoreFiltersState();
  }
}

/// Provider principal pour les offres de la boutique
final storeOffersProvider =
    AsyncNotifierProvider<StoreOffersNotifier, List<FoodOffer>>(
      StoreOffersNotifier.new,
    );

class StoreOffersNotifier extends AsyncNotifier<List<FoodOffer>> {
  Timer? _searchDebounceTimer;

  @override
  Future<List<FoodOffer>> build() async {
    // Surveiller les changements de filtres
    final filters = ref.watch(storeFiltersProvider);

    // Annuler le timer précédent
    _searchDebounceTimer?.cancel();

    // Appliquer un debounce pour la recherche
    if (filters.searchQuery.isNotEmpty) {
      final completer = Completer<List<FoodOffer>>();

      _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
        try {
          final result = await _loadOffers(filters);
          if (!completer.isCompleted) {
            completer.complete(result);
          }
        } catch (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        }
      });

      return completer.future;
    }

    // Charger les offres immédiatement pour les autres filtres
    return _loadOffers(filters);
  }

  Future<List<FoodOffer>> _loadOffers(StoreFiltersState filters) async {
    // Lire les offres depuis le catalogue central
    final allOffers = ref.read(offersCatalogProvider);
    const merchantId = 'merchant1';

    // Filtrer pour le marchand courant
    var filtered = allOffers.where((o) => o.merchantId == merchantId).toList();

    // Filtre par statut d'affichage
    switch (filters.displayMode) {
      case OfferDisplayMode.activeOnly:
        filtered = filtered.where((offer) => offer.isAvailable).toList();
      case OfferDisplayMode.inactiveOnly:
        filtered = filtered.where((offer) => !offer.isAvailable).toList();
      case OfferDisplayMode.all:
      // Ne rien filtrer
    }

    // Filtre par promotions
    if (filters.showPromotionsOnly) {
      filtered = filtered
          .where((offer) => offer.discountPercentage > 0)
          .toList();
    }

    // Filtre par recherche
    if (filters.searchQuery.isNotEmpty) {
      final query = filters.searchQuery.toLowerCase();
      filtered = filtered.where((offer) {
        return offer.title.toLowerCase().contains(query) ||
            offer.description.toLowerCase().contains(query);
      }).toList();
    }

    // Filtre par catégories
    if (filters.selectedCategories.isNotEmpty) {
      filtered = filtered.where((offer) {
        return filters.selectedCategories.contains(offer.category);
      }).toList();
    }

    // Appliquer le tri
    return _sortOffers(filtered, filters.sortBy);
  }

  List<FoodOffer> _sortOffers(List<FoodOffer> offers, StoreSortOption sortBy) {
    final sorted = List<FoodOffer>.from(offers);

    switch (sortBy) {
      case StoreSortOption.nameAsc:
        sorted.sort((a, b) => a.title.compareTo(b.title));
      case StoreSortOption.nameDesc:
        sorted.sort((a, b) => b.title.compareTo(a.title));
      case StoreSortOption.priceAsc:
        sorted.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
      case StoreSortOption.priceDesc:
        sorted.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
      case StoreSortOption.popularityDesc:
        // FIXME: Implement with real popularity data
        sorted.sort((a, b) => b.viewCount.compareTo(a.viewCount));
      case StoreSortOption.dateDesc:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case StoreSortOption.stockAsc:
        sorted.sort((a, b) => a.quantity.compareTo(b.quantity));
      case StoreSortOption.promotionFirst:
        sorted.sort((a, b) {
          final aHasPromo = a.discountPercentage > 0;
          final bHasPromo = b.discountPercentage > 0;
          if (aHasPromo && !bHasPromo) return -1;
          if (!aHasPromo && bHasPromo) return 1;
          return 0;
        });
    }

    return sorted;
  }

  /// Rafraîchir les offres (recalcule les filtres actuels)
  Future<void> refresh() async {
    final filters = ref.read(storeFiltersProvider);
    final result = await _loadOffers(filters);
    state = AsyncData(result);
  }

  /// Basculer le statut d'une offre via le catalogue central
  Future<void> toggleOfferStatus(String offerId) async {
    ref.read(offersCatalogProvider.notifier).toggleStatus(offerId);
    await refresh();
  }

  /// Mettre à jour une promotion via le service de promotion
  Future<void> updatePromotion(String offerId, double? discountPercent) async {
    final promotionService = PromotionService();

    if (discountPercent == null || discountPercent <= 0) {
      // Supprimer la promotion
      await promotionService.removeOfferPromotion(offerId);
      // Mettre à jour le catalogue local
      ref
          .read(offersCatalogProvider.notifier)
          .updatePromotionPercent(offerId, null);
    } else {
      // Appliquer la promotion
      await promotionService.applyOfferPromotion(
        offerId: offerId,
        discountPercentage: discountPercent,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(
          const Duration(days: kDefaultPromotionDurationDays),
        ),
      );
      // Mettre à jour le catalogue local
      ref
          .read(offersCatalogProvider.notifier)
          .updatePromotionPercent(offerId, discountPercent);
    }

    await refresh();
  }

  /// Supprimer une offre via le catalogue central
  Future<void> deleteOffer(String offerId) async {
    ref.read(offersCatalogProvider.notifier).delete(offerId);
    await refresh();
  }

  /// Appliquer une promotion globale
  Future<void> applyGlobalPromotion({
    required double discountPercentage,
    required DateTime startDate,
    required DateTime endDate,
    double? minPrice,
    List<String>? categoryFilters,
  }) async {
    final promotionService = PromotionService();

    // FIXME: Get merchant ID from authenticated user
    const merchantId = 'current_merchant_id';

    await promotionService.applyGlobalPromotion(
      merchantId: merchantId,
      discountPercentage: discountPercentage,
      startDate: startDate,
      endDate: endDate,
      categoryFilters: categoryFilters,
    );

    // Recharger les données
    await refresh();
  }

  /// Supprimer toutes les promotions
  Future<void> removeAllPromotions() async {
    final promotionService = PromotionService();

    // FIXME: Get merchant ID from authenticated user
    const merchantId = 'current_merchant_id';

    await promotionService.removeAllPromotions(merchantId);

    // Recharger les données
    await refresh();
  }
}

/// Provider pour le nombre d'offres actives
final activeOffersCountProvider = Provider<int>((ref) {
  final offers = ref.watch(storeOffersProvider).value ?? [];
  return offers.where((offer) => offer.isAvailable).length;
});

/// Provider pour le nombre de promotions actives
final activePromotionsCountProvider = Provider<int>((ref) {
  final offers = ref.watch(storeOffersProvider).value ?? [];
  return offers
      .where((offer) => offer.isAvailable && offer.discountPercentage > 0)
      .length;
});

/// Provider pour les catégories disponibles dans le store
///
/// Retourne les catégories centralisées qui sont réellement utilisées
/// par les offres actuellement affichées dans le store
final availableCategoriesProvider = Provider<List<FoodCategory>>((ref) {
  final offers = ref.watch(storeOffersProvider).value ?? [];
  final availableCategories = <FoodCategory>{};

  // Collecter les catégories des offres disponibles
  for (final offer in offers) {
    if (offer.isAvailable) {
      availableCategories.add(offer.category);
    }
  }

  // Retourner dans l'ordre logique (petit-déjeuner, déjeuner, etc.)
  return Categories.ordered.where(availableCategories.contains).toList();
});

/// Provider pour les labels des catégories disponibles (pour compatibilité)
final availableCategoriesLabelsProvider = Provider<List<String>>((ref) {
  final categories = ref.watch(availableCategoriesProvider);
  return categories.map(Categories.labelOf).toList();
});

/// Provider pour les statistiques de promotion
final promotionStatsProvider = Provider<PromotionStats>((ref) {
  // Pour l'instant, retourner des données simulées
  // Dans un vrai environnement, ce serait :
  // return ref.watch(futureProvider((ref) => promotionService.getPromotionStats(merchantId)));

  return const PromotionStats(
    activePromotions: 3,
    totalDiscountGiven: 45.80,
    averageDiscount: 18.5,
    totalRevenueFromPromotions: 1250.30,
    promotionViews: 850,
    promotionConversions: 65,
  );
});

/// Provider pour les statistiques de la boutique
final storeStatsProvider = Provider<StoreStats>((ref) {
  final offers = ref.watch(storeOffersProvider).value ?? [];

  final activeOffers = offers.where((o) => o.isAvailable).toList();
  final inactiveOffers = offers.where((o) => !o.isAvailable).toList();
  final promotions = activeOffers
      .where((o) => o.discountPercentage > 0)
      .toList();
  final lowStock = activeOffers.where((o) => o.quantity < 5).toList();

  // Calculer le revenu potentiel
  double potentialRevenue = 0;
  for (final offer in activeOffers) {
    potentialRevenue += offer.discountedPrice * offer.quantity;
  }

  // Calculer le pourcentage de réduction moyen
  double avgDiscount = 0;
  if (promotions.isNotEmpty) {
    avgDiscount =
        promotions.map((o) => o.discountPercentage).reduce((a, b) => a + b) /
        promotions.length;
  }

  return StoreStats(
    totalOffers: offers.length,
    activeOffers: activeOffers.length,
    inactiveOffers: inactiveOffers.length,
    promotionsCount: promotions.length,
    lowStockCount: lowStock.length,
    potentialRevenue: potentialRevenue,
    averageDiscount: avgDiscount,
  );
});

/// Modèle pour les statistiques de la boutique
class StoreStats {
  const StoreStats({
    required this.totalOffers,
    required this.activeOffers,
    required this.inactiveOffers,
    required this.promotionsCount,
    required this.lowStockCount,
    required this.potentialRevenue,
    required this.averageDiscount,
  });

  final int totalOffers;
  final int activeOffers;
  final int inactiveOffers;
  final int promotionsCount;
  final int lowStockCount;
  final double potentialRevenue;
  final double averageDiscount;
}

/// Provider pour le nombre d'offres inactives
final inactiveOffersCountProvider = Provider<int>((ref) {
  return ref.watch(storeStatsProvider).inactiveOffers;
});

/// Provider pour le mode d'affichage de la boutique
final storeViewModeProvider = NotifierProvider<StoreViewModeNotifier, StoreViewMode>(
  StoreViewModeNotifier.new,
);

/// Provider pour les filtres de la boutique
final storeFiltersProvider = NotifierProvider<StoreFiltersNotifier, StoreFiltersState>(
  StoreFiltersNotifier.new,
);
