import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service pour gérer les favoris avec persistance locale
class FavoritesService {
  static const String _boxName = 'favorites';
  static const String _offersKey = 'favorite_offers';
  static const String _merchantsKey = 'favorite_merchants';

  late Box _box;

  /// Initialise le service de favoris
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// Récupère la liste des IDs d'offres favorites
  Set<String> getFavoriteOfferIds() {
    final dynamic storedIds = _box.get(_offersKey);
    if (storedIds is List) {
      return Set<String>.from(storedIds.cast<String>());
    }
    return {};
  }

  /// Récupère la liste des IDs de commerçants favoris
  Set<String> getFavoriteMerchantIds() {
    final dynamic storedIds = _box.get(_merchantsKey);
    if (storedIds is List) {
      return Set<String>.from(storedIds.cast<String>());
    }
    return {};
  }

  /// Ajoute une offre aux favoris
  Future<void> addOfferToFavorites(String offerId) async {
    final favorites = getFavoriteOfferIds();
    favorites.add(offerId);
    await _box.put(_offersKey, favorites.toList());
  }

  /// Retire une offre des favoris
  Future<void> removeOfferFromFavorites(String offerId) async {
    final favorites = getFavoriteOfferIds();
    favorites.remove(offerId);
    await _box.put(_offersKey, favorites.toList());
  }

  /// Toggle le statut favori d'une offre
  Future<bool> toggleOfferFavorite(String offerId) async {
    final favorites = getFavoriteOfferIds();
    if (favorites.contains(offerId)) {
      favorites.remove(offerId);
      await _box.put(_offersKey, favorites.toList());
      return false;
    } else {
      favorites.add(offerId);
      await _box.put(_offersKey, favorites.toList());
      return true;
    }
  }

  /// Vérifie si une offre est dans les favoris
  bool isOfferFavorite(String offerId) {
    return getFavoriteOfferIds().contains(offerId);
  }

  /// Ajoute un commerçant aux favoris
  Future<void> addMerchantToFavorites(String merchantId) async {
    final favorites = getFavoriteMerchantIds();
    favorites.add(merchantId);
    await _box.put(_merchantsKey, favorites.toList());
  }

  /// Retire un commerçant des favoris
  Future<void> removeMerchantFromFavorites(String merchantId) async {
    final favorites = getFavoriteMerchantIds();
    favorites.remove(merchantId);
    await _box.put(_merchantsKey, favorites.toList());
  }

  /// Toggle le statut favori d'un commerçant
  Future<bool> toggleMerchantFavorite(String merchantId) async {
    final favorites = getFavoriteMerchantIds();
    if (favorites.contains(merchantId)) {
      favorites.remove(merchantId);
      await _box.put(_merchantsKey, favorites.toList());
      return false;
    } else {
      favorites.add(merchantId);
      await _box.put(_merchantsKey, favorites.toList());
      return true;
    }
  }

  /// Vérifie si un commerçant est dans les favoris
  bool isMerchantFavorite(String merchantId) {
    return getFavoriteMerchantIds().contains(merchantId);
  }

  /// Efface tous les favoris
  Future<void> clearAllFavorites() async {
    await _box.delete(_offersKey);
    await _box.delete(_merchantsKey);
  }

  /// Récupère des statistiques sur les favoris
  FavoritesStats getStats() {
    return FavoritesStats(
      totalOffers: getFavoriteOfferIds().length,
      totalMerchants: getFavoriteMerchantIds().length,
    );
  }
}

/// Statistiques des favoris
class FavoritesStats {
  final int totalOffers;
  final int totalMerchants;

  FavoritesStats({required this.totalOffers, required this.totalMerchants});

  int get total => totalOffers + totalMerchants;
}

/// Provider pour le service de favoris
final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

/// Provider pour initialiser le service au démarrage
final favoritesInitProvider = FutureProvider<void>((ref) async {
  final service = ref.read(favoritesServiceProvider);
  await service.init();
});
