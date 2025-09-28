import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../../domain/services/offer_selection_service.dart';
import 'offers_catalog_provider.dart';

/// Provider synchrone pour les offres urgentes (évite les rechargements)
final urgentOffersProvider = Provider<List<FoodOffer>>((ref) {
  final offers = ref.watch(offersCatalogProvider);

  final urgent =
      offers
          .where((o) => o.isAvailable && OfferSelectionService.isUrgent(o))
          .toList()
        ..sort((a, b) {
          final sb = OfferSelectionService.urgencyScore(b);
          final sa = OfferSelectionService.urgencyScore(a);
          return sb.compareTo(sa);
        });

  return urgent.take(10).toList();
});
