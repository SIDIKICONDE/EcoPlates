import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_offer.dart';
import 'offers_catalog_provider.dart';

/// Provider synchrone pour les offres recommandées (tri par rating)
final recommendedOffersProvider = Provider<List<FoodOffer>>((ref) {
  final offers = ref.watch(offersCatalogProvider);
  final avail = offers.where((o) => o.isAvailable).toList()
    ..sort((a, b) => b.rating.compareTo(a.rating));
  return avail.take(7).toList();
});
