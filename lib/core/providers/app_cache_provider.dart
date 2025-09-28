import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/app_cache_service.dart';

/// Provider pour le service de cache global de l'application
final appCacheServiceProvider = Provider<AppCacheService>((ref) {
  return AppCacheService.instance;
});

/// Provider pour initialiser le cache au démarrage
final cacheInitProvider = FutureProvider<bool>((ref) async {
  final cacheService = ref.read(appCacheServiceProvider);
  await cacheService.init();

  // Nettoyage automatique des entrées expirées au démarrage
  final cleaned = await cacheService.cleanExpired();
  if (cleaned > 0) {
    print('Cache: $cleaned entrées expirées nettoyées au démarrage');
  }

  return true;
});

/// Provider pour les statistiques du cache (dev/debug)
final cacheStatsProvider = Provider<CacheStats>((ref) {
  final cacheService = ref.read(appCacheServiceProvider);
  return cacheService.getStats();
});

/// Notifier pour gérer les préférences utilisateur avec cache
class CachedUserPreferencesNotifier extends Notifier<Map<String, dynamic>> {
  late final AppCacheService _cache;

  @override
  Map<String, dynamic> build() {
    _cache = ref.read(appCacheServiceProvider);

    // Charger depuis le cache ou valeurs par défaut
    return _cache.getOrDefault(CacheKeys.userPreferences, {
      'theme': 'system', // system, light, dark
      'language': 'fr',
      'notificationsEnabled': true,
      'locationEnabled': true,
      'maxDistance': 5.0, // km
      'dietaryPreferences': <String>[],
      'priceRange': {'min': 0.0, 'max': 50.0},
      'autoRefresh': true,
      'cacheExpiry': 300, // 5 minutes en secondes
    });
  }

  Future<void> updatePreference(String key, dynamic value) async {
    final newState = {...state, key: value};
    state = newState;

    // Sauvegarder dans le cache avec TTL d'1 an
    await _cache.set(
      CacheKeys.userPreferences,
      newState,
      ttl: const Duration(days: 365),
    );
  }

  Future<void> updateMultiple(Map<String, dynamic> updates) async {
    final newState = {...state, ...updates};
    state = newState;

    await _cache.set(
      CacheKeys.userPreferences,
      newState,
      ttl: const Duration(days: 365),
    );
  }

  Future<void> reset() async {
    await _cache.remove(CacheKeys.userPreferences);
    ref.invalidateSelf(); // Recharger les valeurs par défaut
  }
}

/// Provider pour les préférences utilisateur avec cache persistant
final cachedUserPreferencesProvider =
    NotifierProvider<CachedUserPreferencesNotifier, Map<String, dynamic>>(
      CachedUserPreferencesNotifier.new,
    );

/// Notifier pour gérer l'historique de recherche avec cache
class SearchHistoryNotifier extends Notifier<List<String>> {
  late final AppCacheService _cache;
  static const int maxHistoryItems = 20;

  @override
  List<String> build() {
    _cache = ref.read(appCacheServiceProvider);
    return _cache.getOrDefault(CacheKeys.searchHistory, <String>[]);
  }

  Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;

    final newHistory = [
      query,
      ...state.where((s) => s != query),
    ].take(maxHistoryItems).toList();

    state = newHistory;

    // Sauvegarder avec TTL de 30 jours
    await _cache.set(
      CacheKeys.searchHistory,
      newHistory,
      ttl: const Duration(days: 30),
    );
  }

  Future<void> removeSearch(String query) async {
    final newHistory = state.where((s) => s != query).toList();
    state = newHistory;

    await _cache.set(
      CacheKeys.searchHistory,
      newHistory,
      ttl: const Duration(days: 30),
    );
  }

  Future<void> clearHistory() async {
    state = [];
    await _cache.remove(CacheKeys.searchHistory);
  }
}

/// Provider pour l'historique de recherche avec cache
final searchHistoryProvider =
    NotifierProvider<SearchHistoryNotifier, List<String>>(
      SearchHistoryNotifier.new,
    );

/// Notifier pour gérer les favoris avec cache
class FavoritesNotifier extends Notifier<Set<String>> {
  late final AppCacheService _cache;

  @override
  Set<String> build() {
    _cache = ref.read(appCacheServiceProvider);
    final favoritesList = _cache.getOrDefault(CacheKeys.favorites, <String>[]);
    return Set.from(favoritesList);
  }

  Future<void> toggle(String offerId) async {
    final newFavorites = Set<String>.from(state);

    if (newFavorites.contains(offerId)) {
      newFavorites.remove(offerId);
    } else {
      newFavorites.add(offerId);
    }

    state = newFavorites;

    // Sauvegarder avec TTL de 1 an
    await _cache.set(
      CacheKeys.favorites,
      newFavorites.toList(),
      ttl: const Duration(days: 365),
    );
  }

  Future<void> clear() async {
    state = {};
    await _cache.remove(CacheKeys.favorites);
  }

  bool isFavorite(String offerId) {
    return state.contains(offerId);
  }
}

/// Provider pour les favoris avec cache
final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);

/// Notifier pour la localisation utilisateur avec cache
class UserLocationNotifier extends Notifier<Map<String, dynamic>?> {
  late final AppCacheService _cache;

  @override
  Map<String, dynamic>? build() {
    _cache = ref.read(appCacheServiceProvider);
    return _cache.get(CacheKeys.userLocation);
  }

  Future<void> updateLocation({
    required double lat,
    required double lng,
    required String address,
    String? city,
    String? postalCode,
  }) async {
    final locationData = {
      'lat': lat,
      'lng': lng,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    state = locationData;

    // Cache avec TTL de 1 heure (localisation peut changer)
    await _cache.set(
      CacheKeys.userLocation,
      locationData,
      ttl: const Duration(hours: 1),
    );
  }

  Future<void> clearLocation() async {
    state = null;
    await _cache.remove(CacheKeys.userLocation);
  }

  bool get hasLocation => state != null;

  double? get lat => state?['lat'] as double?;
  double? get lng => state?['lng'] as double?;
  String? get address => state?['address'] as String?;
}

/// Provider pour la localisation utilisateur avec cache
final userLocationProvider =
    NotifierProvider<UserLocationNotifier, Map<String, dynamic>?>(
      UserLocationNotifier.new,
    );

/// Extension pour simplifier l'utilisation du cache
extension WidgetRefCacheExtensions on WidgetRef {
  /// Accès rapide au service de cache
  AppCacheService get cache => read(appCacheServiceProvider);

  /// Sauvegarder rapidement une valeur
  Future<bool> cacheSet<T>(String key, T value, {Duration? ttl}) {
    return cache.set(key, value, ttl: ttl);
  }

  /// Récupérer rapidement une valeur
  T? cacheGet<T>(String key) {
    return cache.get<T>(key);
  }

  /// Récupérer avec fallback
  T cacheGetOrDefault<T>(String key, T defaultValue) {
    return cache.getOrDefault(key, defaultValue);
  }
}
