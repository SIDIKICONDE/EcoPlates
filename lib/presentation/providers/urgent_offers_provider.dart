import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../../domain/services/offer_selection_service.dart';
import 'offers_catalog_provider.dart';

/// Provider pour les offres urgentes à sauver (branché sur le catalogue central)
final urgentOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final offers = ref.watch(offersCatalogProvider);

  // Sélectionner les offres disponibles et urgentes
  final urgent = offers
      .where((o) => o.isAvailable && OfferSelectionService.isUrgent(o))
      .toList();

  // Trier par score d'urgence décroissant (plus urgent en premier)
  urgent.sort((a, b) {
    final sb = OfferSelectionService.urgencyScore(b);
    final sa = OfferSelectionService.urgencyScore(a);
    return sb.compareTo(sa);
  });

  // Limiter à un top N (ex. 10)
  return urgent.take(10).toList();
});
