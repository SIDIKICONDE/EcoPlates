import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/error/failures.dart';
import '../../core/providers/injection_providers.dart';
import '../../domain/entities/food_offer.dart';
import '../../domain/use_cases/get_urgent_offers_use_case.dart';

/// Provider pour les paramètres des offres urgentes
/// Peut être overridé pour personnaliser les critères
final urgentOffersParamsProvider = Provider<UrgentOffersParams>((ref) {
  final userPrefs = ref.watch(userPreferencesProvider);
  
  return UrgentOffersParams(
    maxMinutesBeforeExpiry: 120, // 2 heures
    maxDistanceKm: userPrefs['maxDistance'] as double? ?? 5.0,
    allowCached: true,
  );
});

/// Provider principal pour les offres urgentes
/// Utilise la Clean Architecture avec use cases
final urgentOffersProviderV2 = FutureProvider.autoDispose<List<FoodOffer>>((ref) async {
  final useCase = ref.watch(getUrgentOffersUseCaseProvider);
  final params = ref.watch(urgentOffersParamsProvider);
  
  final result = await useCase(params);
  
  return result.fold(
    (failure) => throw Exception(failure.userMessage),
    (offers) => offers,
  );
});

/// Provider pour rafraîchir manuellement les offres urgentes
final refreshUrgentOffersProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(urgentOffersProviderV2);
    await ref.read(urgentOffersProviderV2.future);
  };
});

/// Provider pour surveiller les changements en temps réel
final urgentOffersStreamProvider = StreamProvider.autoDispose<List<FoodOffer>>((ref) {
  final useCase = ref.watch(getUrgentOffersUseCaseProvider);
  final params = ref.watch(urgentOffersParamsProvider);
  
  // Créer un stream qui rafraîchit toutes les 30 secondes
  return Stream.periodic(
    const Duration(seconds: 30),
    (_) async {
      final result = await useCase(params);
      return result.fold(
        (failure) => throw Exception(failure.userMessage),
        (offers) => offers,
      );
    },
  ).asyncMap((future) => future);
});

/// State notifier pour gérer l'état complexe des offres urgentes
class UrgentOffersNotifier extends StateNotifier<AsyncValue<List<FoodOffer>>> {
  final GetUrgentOffersUseCase _useCase;
  final Ref _ref;
  
  UrgentOffersNotifier(this._useCase, this._ref) : super(const AsyncValue.loading()) {
    loadOffers();
  }
  
  Future<void> loadOffers() async {
    state = const AsyncValue.loading();
    
    try {
      final params = _ref.read(urgentOffersParamsProvider);
      final result = await _useCase(params);
      
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (offers) => state = AsyncValue.data(offers),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> refresh() async {
    await loadOffers();
  }
  
  void filterByDistance(double maxDistance) {
    if (state.hasValue) {
      final filtered = state.value!.where((offer) {
        return offer.distanceKm != null && offer.distanceKm! <= maxDistance;
      }).toList();
      state = AsyncValue.data(filtered);
    }
  }
  
  void sortByUrgency() {
    if (state.hasValue) {
      final sorted = List<FoodOffer>.from(state.value!);
      sorted.sort((a, b) {
        final timeA = a.pickupEndTime.difference(DateTime.now()).inMinutes;
        final timeB = b.pickupEndTime.difference(DateTime.now()).inMinutes;
        return timeA.compareTo(timeB);
      });
      state = AsyncValue.data(sorted);
    }
  }
  
  void filterByCategory(FoodCategory category) {
    if (state.hasValue) {
      final filtered = state.value!.where((offer) {
        return offer.category == category;
      }).toList();
      state = AsyncValue.data(filtered);
    }
  }
  
  void filterByDietaryPreference(List<String> preferences) {
    if (state.hasValue) {
      final filtered = state.value!.where((offer) {
        // Vérifier si l'offre correspond aux préférences alimentaires
        for (final pref in preferences) {
          if (pref == 'vegetarian' && !offer.tags.contains('Végétarien')) {
            return false;
          }
          if (pref == 'vegan' && !offer.tags.contains('Vegan')) {
            return false;
          }
          if (pref == 'glutenFree' && !offer.tags.contains('Sans gluten')) {
            return false;
          }
        }
        return true;
      }).toList();
      state = AsyncValue.data(filtered);
    }
  }
  
  void resetFilters() {
    loadOffers(); // Recharger toutes les offres
  }
}

/// Provider pour le state notifier
final urgentOffersNotifierProvider = 
    StateNotifierProvider.autoDispose<UrgentOffersNotifier, AsyncValue<List<FoodOffer>>>((ref) {
  final useCase = ref.watch(getUrgentOffersUseCaseProvider);
  return UrgentOffersNotifier(useCase, ref);
});

/// Provider pour compter les offres très urgentes (< 30 min)
final veryUrgentOffersCountProvider = Provider.autoDispose<int>((ref) {
  final offersAsync = ref.watch(urgentOffersProviderV2);
  
  return offersAsync.when(
    data: (offers) {
      final now = DateTime.now();
      return offers.where((offer) {
        final timeLeft = offer.pickupEndTime.difference(now).inMinutes;
        return timeLeft <= 30;
      }).length;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider pour grouper les offres par catégorie
final urgentOffersByCategoryProvider = Provider.autoDispose<Map<String, List<FoodOffer>>>((ref) {
  final offersAsync = ref.watch(urgentOffersProviderV2);
  
  return offersAsync.when(
    data: (offers) {
      final Map<String, List<FoodOffer>> grouped = {};
      for (final offer in offers) {
        grouped.putIfAbsent(offer.category.name, () => []).add(offer);
      }
      return grouped;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

/// Extension pour faciliter l'utilisation dans les widgets
extension UrgentOffersProviderExtension on WidgetRef {
  /// Récupère les offres urgentes avec gestion d'erreur intégrée
  AsyncValue<List<FoodOffer>> get urgentOffersV2 => watch(urgentOffersProviderV2);
  
  /// Rafraîchit les offres urgentes
  Future<void> refreshUrgentOffers() => read(refreshUrgentOffersProvider)();
  
  /// Accède au notifier pour des actions avancées
  UrgentOffersNotifier get urgentOffersNotifier => read(urgentOffersNotifierProvider.notifier);
  
  /// Nombre d'offres très urgentes
  int get veryUrgentCount => watch(veryUrgentOffersCountProvider);
  
  /// Offres groupées par catégorie
  Map<String, List<FoodOffer>> get offersByCategory => watch(urgentOffersByCategoryProvider);
}