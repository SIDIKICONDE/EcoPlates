import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/favorites_service.dart';
import '../../../domain/entities/food_offer.dart';
import '../commerce/offers_provider.dart';

/// État des favoris
@immutable
class FavoritesState {
  final Set<String> favoriteOfferIds;
  final Set<String> favoriteMerchantIds;
  final bool isInitialized;

  const FavoritesState({
    this.favoriteOfferIds = const {},
    this.favoriteMerchantIds = const {},
    this.isInitialized = false,
  });

  FavoritesState copyWith({
    Set<String>? favoriteOfferIds,
    Set<String>? favoriteMerchantIds,
    bool? isInitialized,
  }) {
    return FavoritesState(
      favoriteOfferIds: favoriteOfferIds ?? this.favoriteOfferIds,
      favoriteMerchantIds: favoriteMerchantIds ?? this.favoriteMerchantIds,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  /// Vérifie si une offre est favorite
  bool isOfferFavorite(String offerId) => favoriteOfferIds.contains(offerId);

  /// Vérifie si un commerçant est favori
  bool isMerchantFavorite(String merchantId) => favoriteMerchantIds.contains(merchantId);

  /// Compte total de favoris
  int get totalFavorites => favoriteOfferIds.length + favoriteMerchantIds.length;
}

/// Notifier pour gérer l'état des favoris
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final FavoritesService _service;
  
  FavoritesNotifier(this._service) : super(const FavoritesState()) {
    _initialize();
  }

  /// Initialise le service et charge les favoris
  Future<void> _initialize() async {
    await _service.init();
    state = FavoritesState(
      favoriteOfferIds: _service.getFavoriteOfferIds(),
      favoriteMerchantIds: _service.getFavoriteMerchantIds(),
      isInitialized: true,
    );
  }

  /// Toggle le statut favori d'une offre avec animation
  Future<bool> toggleOfferFavorite(String offerId) async {
    if (!state.isInitialized) return false;
    
    final isFavorite = await _service.toggleOfferFavorite(offerId);
    
    // Mise à jour optimiste de l'état
    if (isFavorite) {
      state = state.copyWith(
        favoriteOfferIds: {...state.favoriteOfferIds, offerId},
      );
    } else {
      state = state.copyWith(
        favoriteOfferIds: {...state.favoriteOfferIds}..remove(offerId),
      );
    }
    
    return isFavorite;
  }

  /// Toggle le statut favori d'un commerçant
  Future<bool> toggleMerchantFavorite(String merchantId) async {
    if (!state.isInitialized) return false;
    
    final isFavorite = await _service.toggleMerchantFavorite(merchantId);
    
    // Mise à jour optimiste de l'état
    if (isFavorite) {
      state = state.copyWith(
        favoriteMerchantIds: {...state.favoriteMerchantIds, merchantId},
      );
    } else {
      state = state.copyWith(
        favoriteMerchantIds: {...state.favoriteMerchantIds}..remove(merchantId),
      );
    }
    
    return isFavorite;
  }

  /// Ajoute une offre aux favoris
  Future<void> addOfferToFavorites(String offerId) async {
    if (!state.isInitialized) return;
    
    await _service.addOfferToFavorites(offerId);
    state = state.copyWith(
      favoriteOfferIds: {...state.favoriteOfferIds, offerId},
    );
  }

  /// Retire une offre des favoris
  Future<void> removeOfferFromFavorites(String offerId) async {
    if (!state.isInitialized) return;
    
    await _service.removeOfferFromFavorites(offerId);
    state = state.copyWith(
      favoriteOfferIds: {...state.favoriteOfferIds}..remove(offerId),
    );
  }

  /// Efface tous les favoris
  Future<void> clearAllFavorites() async {
    if (!state.isInitialized) return;
    
    await _service.clearAllFavorites();
    state = state.copyWith(
      favoriteOfferIds: {},
      favoriteMerchantIds: {},
    );
  }

  /// Recharge les favoris depuis le stockage
  Future<void> refresh() async {
    if (!state.isInitialized) {
      await _initialize();
    } else {
      state = state.copyWith(
        favoriteOfferIds: _service.getFavoriteOfferIds(),
        favoriteMerchantIds: _service.getFavoriteMerchantIds(),
      );
    }
  }
}

/// Provider principal pour les favoris
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  final service = ref.watch(favoritesServiceProvider);
  return FavoritesNotifier(service);
});

/// Provider pour récupérer les offres favorites
final favoriteOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final favorites = ref.watch(favoritesProvider);
  
  if (!favorites.isInitialized || favorites.favoriteOfferIds.isEmpty) {
    return [];
  }
  
  // Récupérer toutes les offres
  final allOffers = await ref.watch(nearbyOffersProvider.future);
  
  // Filtrer uniquement les offres favorites
  return allOffers.where((offer) => 
    favorites.favoriteOfferIds.contains(offer.id)
  ).toList();
});

/// Provider pour vérifier si une offre est favorite
final isOfferFavoriteProvider = Provider.family<bool, String>((ref, offerId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.isOfferFavorite(offerId);
});

/// Provider pour vérifier si un commerçant est favori
final isMerchantFavoriteProvider = Provider.family<bool, String>((ref, merchantId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.isMerchantFavorite(merchantId);
});

/// Provider pour les statistiques des favoris
final favoritesStatsProvider = Provider<FavoritesStats>((ref) {
  final favorites = ref.watch(favoritesProvider);
  return FavoritesStats(
    totalOffers: favorites.favoriteOfferIds.length,
    totalMerchants: favorites.favoriteMerchantIds.length,
  );
});