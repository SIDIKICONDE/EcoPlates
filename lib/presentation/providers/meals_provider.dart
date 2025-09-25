import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../../domain/services/offer_selection_service.dart';
import 'offers_catalog_provider.dart';

/// Provider pour les offres de repas complets (branché sur le catalogue central)
final mealsProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final offers = ref.watch(offersCatalogProvider);
  final meals = offers
      .where((o) => o.isAvailable && OfferSelectionService.isMeal(o))
      .toList();
  // Option: trier par heure de collecte la plus proche
  meals.sort((a, b) => a.pickupStartTime.compareTo(b.pickupStartTime));
  return meals.take(12).toList();
});

/// Provider pour filtrer les repas végétariens
final vegetarianMealsProvider = Provider<List<FoodOffer>>((ref) {
  final mealsAsync = ref.watch(mealsProvider);
  return mealsAsync.when(
    data: (meals) => meals.where((m) => m.isVegetarian).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});
