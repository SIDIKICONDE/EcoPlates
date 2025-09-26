import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../../domain/services/offer_selection_service.dart';
import 'offers_catalog_provider.dart';

/// Provider pour les offres de repas complets (branché sur le catalogue central)
final mealsProvider = Provider<List<FoodOffer>>((ref) {
  final offers = ref.watch(offersCatalogProvider);
  final meals =
      offers
          .where((o) => o.isAvailable && OfferSelectionService.isMeal(o))
          .toList()
        ..sort((a, b) => a.pickupStartTime.compareTo(b.pickupStartTime));
  return meals.take(12).toList();
});

/// Provider pour filtrer les repas végétariens
final vegetarianMealsProvider = Provider<List<FoodOffer>>((ref) {
  final meals = ref.watch(mealsProvider);
  return meals.where((m) => m.isVegetarian).toList();
});
