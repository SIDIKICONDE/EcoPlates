import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_offer.dart';
import 'offers_catalog_provider.dart';

/// Provider pour les offres proches (vraie distance si position dispo)
final nearbyOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final offers = ref.watch(offersCatalogProvider);
  final userLoc = ref.watch(userLocationProvider);
  final radiusKm = ref.watch(searchRadiusProvider);

  // Si pas de localisation, fallback simple
  if (userLoc == null) {
    return offers.where((o) => o.isAvailable).take(10).toList();
  }

  final withDistance = <FoodOffer>[];
  for (final o in offers) {
    if (!o.isAvailable) continue;
    final d = o.location.distanceFrom(userLoc.lat, userLoc.lon);
    if (d <= radiusKm) {
      withDistance.add(o.copyWith(distanceKm: d));
    }
  }

  withDistance.sort((a, b) => (a.distanceKm ?? 9999).compareTo(b.distanceKm ?? 9999));
  return withDistance.take(12).toList();
});

/// Provider pour la position actuelle de l'utilisateur
final userLocationProvider = StateProvider<({double lat, double lon, String address})?>((ref) {
  // Position mock : Centre de Paris
  return (lat: 48.8566, lon: 2.3522, address: 'Paris, France');
});

/// Provider pour la distance maximale de recherche (en km)
final searchRadiusProvider = StateProvider<double>((ref) => 2.0);
