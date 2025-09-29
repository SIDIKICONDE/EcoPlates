import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import 'offers_catalog_provider.dart';

/// Provider pour obtenir toutes les offres disponibles (source partagée)
final allOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final offers = ref.watch(offersCatalogProvider);
  return offers.where((o) => o.isAvailable).toList();
});
