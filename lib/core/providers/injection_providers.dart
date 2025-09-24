import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/error/failures.dart';
import '../../data/data_sources/food_offer_local_data_source.dart';
import '../../data/data_sources/food_offer_remote_data_source.dart';
import '../../data/repositories/food_offer_repository_impl.dart';
import '../../domain/repositories/food_offer_repository.dart';
import '../../domain/use_cases/get_urgent_offers_use_case.dart';
import 'api_providers.dart';

/// Provider pour le mode développement
/// Permet de basculer entre API réelle et mock
final isDevelopmentModeProvider = StateProvider<bool>((ref) => true);

/// Provider pour la source de données locale (Hive)
final foodOfferLocalDataSourceProvider = Provider<FoodOfferLocalDataSource>((ref) {
  return FoodOfferLocalDataSourceImpl();
});

/// Provider pour la source de données distante (API)
final foodOfferRemoteDataSourceProvider = Provider<FoodOfferRemoteDataSource>((ref) {
  final isDev = ref.watch(isDevelopmentModeProvider);
  final apiClient = ref.watch(apiClientProvider);
  
  // En mode développement, utiliser le mock
  if (isDev) {
    return FoodOfferRemoteDataSourceMock();
  }
  
  return FoodOfferRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider pour le repository des offres
final foodOfferRepositoryProvider = Provider<FoodOfferRepository>((ref) {
  final remoteDataSource = ref.watch(foodOfferRemoteDataSourceProvider);
  final localDataSource = ref.watch(foodOfferLocalDataSourceProvider);
  final apiClient = ref.watch(apiClientProvider);
  
  return FoodOfferRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    apiClient: apiClient,
  );
});

/// Provider pour le use case des offres urgentes
final getUrgentOffersUseCaseProvider = Provider<GetUrgentOffersUseCase>((ref) {
  final repository = ref.watch(foodOfferRepositoryProvider);
  return GetUrgentOffersUseCase(repository);
});

/// Provider pour récupérer les offres urgentes avec gestion d'état
final urgentOffersStateProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final useCase = ref.watch(getUrgentOffersUseCaseProvider);
  
  // Paramètres par défaut (peut être personnalisé via un autre provider)
  const params = UrgentOffersParams(
    maxDistanceKm: 5,
  );
  
  final result = await useCase(params);
  
  return result.fold(
    (failure) => throw Exception(failure.userMessage),
    (offers) => offers,
  );
});

/// Provider pour la synchronisation offline
final syncOfflineDataProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(foodOfferRepositoryProvider);
  final result = await repository.syncOfflineData();
  
  result.fold(
    (failure) => throw Exception('Sync failed: ${failure.message}'),
    (_) => null,
  );
});

/// Provider pour gérer l'état de connexion
final connectivityStateProvider = StreamProvider<bool>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  
  return Stream.periodic(
    const Duration(seconds: 5),
    (_) => apiClient.hasConnectivity(),
  ).asyncMap((future) => future);
});

/// Provider pour nettoyer le cache périodiquement
final cacheCleanupProvider = Provider<void>((ref) {
  final localDataSource = ref.watch(foodOfferLocalDataSourceProvider);
  
  // Nettoyer le cache toutes les heures
  Future.doWhile(() async {
    await Future<void>.delayed(const Duration(hours: 1));
    await localDataSource.cleanExpiredData();
    return true; // Continuer indéfiniment
  });
});

/// State notifier pour gérer les préférences utilisateur
class UserPreferencesNotifier extends StateNotifier<Map<String, dynamic>> {
  UserPreferencesNotifier() : super({
    'maxDistance': 5.0,
    'dietaryPreferences': <String>[],
    'notificationsEnabled': true,
    'darkMode': false,
  });
  
  void updateMaxDistance(double distance) {
    state = {...state, 'maxDistance': distance};
  }
  
  void toggleDietaryPreference(String preference) {
    final current = List<String>.from(state['dietaryPreferences'] as List);
    if (current.contains(preference)) {
      current.remove(preference);
    } else {
      current.add(preference);
    }
    state = {...state, 'dietaryPreferences': current};
  }
  
  void toggleNotifications() {
    state = {...state, 'notificationsEnabled': !(state['notificationsEnabled'] as bool)};
  }
  
  void toggleDarkMode() {
    state = {...state, 'darkMode': !(state['darkMode'] as bool)};
  }
}

/// Provider pour les préférences utilisateur
final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, Map<String, dynamic>>((ref) {
  return UserPreferencesNotifier();
});

/// Provider pour l'initialisation de l'application
final appInitializationProvider = FutureProvider<bool>((ref) async {
  try {
    // Initialiser Hive
    await Hive.initFlutter();
    
    // Enregistrer les adapters Hive (si nécessaire)
    // Hive.registerAdapter(FoodOfferModelAdapter());
    
    // Nettoyer le cache au démarrage
    final localDataSource = ref.read(foodOfferLocalDataSourceProvider);
    await localDataSource.cleanExpiredData();
    
    // Synchroniser si connecté
    final apiClient = ref.read(apiClientProvider);
    if (await apiClient.hasConnectivity()) {
      ref.read(syncOfflineDataProvider);
    }
    
    return true;
  } catch (e) {
    throw Exception('App initialization failed: $e');
  }
});

/// Extension pour simplifier l'utilisation des providers
extension ProviderExtensions on WidgetRef {
  /// Récupère les offres urgentes avec gestion d'erreur
  AsyncValue<List<dynamic>> get urgentOffers => watch(urgentOffersStateProvider);
  
  /// Vérifie si l'app est connectée
  AsyncValue<bool> get isConnected => watch(connectivityStateProvider);
  
  /// Récupère les préférences utilisateur
  Map<String, dynamic> get userPreferences => watch(userPreferencesProvider);
  
  /// Actions sur les préférences
  UserPreferencesNotifier get preferencesActions => read(userPreferencesProvider.notifier);
}
