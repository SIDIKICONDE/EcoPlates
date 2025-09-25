import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_offer.dart';
import 'offers_catalog_provider.dart';

/// Provider pour les offres recommandées (tri simple par rating)
final recommendedOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final offers = ref.watch(offersCatalogProvider);
  final avail = offers.where((o) => o.isAvailable).toList();
  avail.sort((a, b) => b.rating.compareTo(a.rating));
  return avail.take(5).toList();
});
