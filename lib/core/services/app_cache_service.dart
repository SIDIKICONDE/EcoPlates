import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de cache générique pour toute l'application avec SharedPreferences
///
/// Permet de stocker n'importe quel type de données de façon persistante
/// avec TTL (Time To Live) et gestion automatique de l'expiration
class AppCacheService {
  AppCacheService._();
  static final AppCacheService _instance = AppCacheService._();
  static AppCacheService get instance => _instance;

  SharedPreferences? _prefs;
  final Map<String, Timer> _timers = {};

  /// Initialise le service (à appeler au démarrage de l'app)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception(
        "AppCacheService non initialisé. Appelez init() d'abord.",
      );
    }
    return _prefs!;
  }

  /// Sauvegarde une valeur avec TTL optionnel
  Future<bool> set<T>(
    String key,
    T value, {
    Duration? ttl,
  }) async {
    try {
      final cacheEntry = CacheEntry<T>(
        value: value,
        createdAt: DateTime.now(),
        expiresAt: ttl != null ? DateTime.now().add(ttl) : null,
      );

      final json = jsonEncode(cacheEntry.toJson());
      final success = await _preferences.setString(key, json);

      // Programmer l'expiration automatique si TTL défini
      if (ttl != null && success) {
        _scheduleExpiration(key, ttl);
      }

      return success;
    } catch (e) {
      print('Erreur lors de la sauvegarde du cache $key: $e');
      return false;
    }
  }

  /// Récupère une valeur du cache
  T? get<T>(String key) {
    try {
      final jsonString = _preferences.getString(key);
      if (jsonString == null) return null;

      final cacheEntry = CacheEntry<T>.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );

      // Vérifier l'expiration
      if (cacheEntry.isExpired) {
        remove(key); // Nettoyer automatiquement
        return null;
      }

      return cacheEntry.value;
    } catch (e) {
      print('Erreur lors de la lecture du cache $key: $e');
      return null;
    }
  }

  /// Récupère une valeur avec fallback
  T getOrDefault<T>(String key, T defaultValue) {
    return get<T>(key) ?? defaultValue;
  }

  /// Vérifie si une clé existe et n'est pas expirée
  bool contains(String key) {
    return get(key) != null;
  }

  /// Supprime une entrée du cache
  Future<bool> remove(String key) async {
    _timers[key]?.cancel();
    _timers.remove(key);
    return _preferences.remove(key);
  }

  /// Vide tout le cache
  Future<bool> clear() async {
    _clearAllTimers();
    return _preferences.clear();
  }

  /// Récupère les métadonnées d'une entrée de cache
  CacheMetadata? getMetadata(String key) {
    try {
      final jsonString = _preferences.getString(key);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return CacheMetadata(
        createdAt: DateTime.parse(json['createdAt'] as String),
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
        isExpired: json['expiresAt'] != null
            ? DateTime.now().isAfter(
                DateTime.parse(json['expiresAt'] as String),
              )
            : false,
      );
    } catch (e) {
      return null;
    }
  }

  /// Nettoyage automatique des entrées expirées
  Future<int> cleanExpired() async {
    final keys = _preferences.getKeys();
    var cleaned = 0;

    for (final key in keys) {
      final metadata = getMetadata(key);
      if (metadata != null && metadata.isExpired) {
        await remove(key);
        cleaned++;
      }
    }

    return cleaned;
  }

  /// Récupère toutes les clés du cache
  Set<String> getAllKeys() {
    return _preferences.getKeys();
  }

  /// Sauvegarde en JSON (pour objets complexes)
  Future<bool> setJson(
    String key,
    Map<String, dynamic> value, {
    Duration? ttl,
  }) async {
    return set(key, value, ttl: ttl);
  }

  /// Récupère depuis JSON
  Map<String, dynamic>? getJson(String key) {
    return get<Map<String, dynamic>>(key);
  }

  /// Sauvegarde une liste
  Future<bool> setList<T>(
    String key,
    List<T> value, {
    Duration? ttl,
  }) async {
    return set(key, value, ttl: ttl);
  }

  /// Récupère une liste
  List<T>? getList<T>(String key) {
    return get<List<T>>(key);
  }

  /// Programmation de l'expiration automatique
  void _scheduleExpiration(String key, Duration ttl) {
    _timers[key]?.cancel();
    _timers[key] = Timer(ttl, () async {
      await remove(key);
      print('Cache expiré automatiquement: $key');
    });
  }

  /// Nettoie tous les timers
  void _clearAllTimers() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }

  /// Stats du cache
  CacheStats getStats() {
    final keys = getAllKeys();
    var expired = 0;
    var valid = 0;

    for (final key in keys) {
      final metadata = getMetadata(key);
      if (metadata != null) {
        if (metadata.isExpired) {
          expired++;
        } else {
          valid++;
        }
      }
    }

    return CacheStats(
      totalEntries: keys.length,
      validEntries: valid,
      expiredEntries: expired,
    );
  }
}

/// Entrée de cache avec métadonnées
class CacheEntry<T> {

  const CacheEntry({
    required this.value,
    required this.createdAt,
    this.expiresAt,
  });

  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry<T>(
      value: json['value'] as T,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }
  final T value;
  final DateTime createdAt;
  final DateTime? expiresAt;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

/// Métadonnées d'une entrée de cache
class CacheMetadata {

  const CacheMetadata({
    required this.createdAt,
    required this.isExpired, this.expiresAt,
  });
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isExpired;
}

/// Statistiques du cache
class CacheStats {

  const CacheStats({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
  });
  final int totalEntries;
  final int validEntries;
  final int expiredEntries;

  @override
  String toString() {
    return 'CacheStats(total: $totalEntries, valid: $validEntries, expired: $expiredEntries)';
  }
}

/// Clés de cache prédéfinies pour l'application
class CacheKeys {
  // Données utilisateur
  static const String userPreferences = 'user_preferences';
  static const String userProfile = 'user_profile';
  static const String userSettings = 'user_settings';
  static const String userLocation = 'user_location';

  // Données offres
  static const String foodOffers = 'food_offers';
  static const String urgentOffers = 'urgent_offers';
  static const String recommendedOffers = 'recommended_offers';
  static const String nearbyOffers = 'nearby_offers';

  // Données marchands
  static const String merchants = 'merchants';
  static const String brands = 'brands';

  // Configuration app
  static const String appConfig = 'app_config';
  static const String apiCache = 'api_cache';
  static const String imageCache = 'image_cache_urls';

  // Session et auth
  static const String sessionData = 'session_data';
  static const String authTokens = 'auth_tokens';

  // Historique et favoris
  static const String searchHistory = 'search_history';
  static const String favorites = 'favorites';
  static const String recentlyViewed = 'recently_viewed';

  // Performance et analytics
  static const String performanceMetrics = 'performance_metrics';
  static const String crashLogs = 'crash_logs';
}
