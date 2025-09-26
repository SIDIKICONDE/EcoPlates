import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/providers/provider.dart';

/// Notifier pour gérer l'état des favoris
class FavoriteMerchantIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    // IDs initiaux des favoris (mock data)
    return {'m1', 'm4', 'm7', 'm10', 'm13'};
  }

  /// Ajoute ou retire un marchand des favoris (toggle)
  void toggleFavorite(String merchantId) {
    if (state.contains(merchantId)) {
      // Retirer des favoris
      state = {...state}..remove(merchantId);
    } else {
      // Ajouter aux favoris
      state = {...state, merchantId};
    }
  }

  /// Vérifie si un marchand est dans les favoris
  bool isFavorite(String merchantId) {
    return state.contains(merchantId);
  }

  /// Ajoute un marchand aux favoris
  void addFavorite(String merchantId) {
    if (!state.contains(merchantId)) {
      state = {...state, merchantId};
    }
  }

  /// Retire un marchand des favoris
  void removeFavorite(String merchantId) {
    if (state.contains(merchantId)) {
      state = {...state}..remove(merchantId);
    }
  }
}

/// Provider pour gérer la liste des IDs de marchands favoris
final favoriteMerchantIdsProvider =
    NotifierProvider<FavoriteMerchantIdsNotifier, Set<String>>(
      FavoriteMerchantIdsNotifier.new,
    );

/// Provider pour vérifier si un marchand spécifique est favori
final ProviderFamily<bool, String> isMerchantFavoriteProvider =
    Provider.family<bool, String>((
      ref,
      merchantId,
    ) {
      final favoriteIds = ref.watch(favoriteMerchantIdsProvider);
      return favoriteIds.contains(merchantId);
    });
