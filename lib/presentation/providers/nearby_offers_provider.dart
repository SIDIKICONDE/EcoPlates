import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_offer.dart';
import 'offers_catalog_provider.dart';

/// Provider pour les offres proches (vraie distance si position dispo)
final nearbyOffersProvider = Provider<List<FoodOffer>>((ref) {
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
final userLocationProvider = NotifierProvider<UserLocationNotifier, ({double lat, double lon, String address})?>(
  UserLocationNotifier.new,
);

class UserLocationNotifier extends Notifier<({double lat, double lon, String address})?> {
  @override
  ({double lat, double lon, String address})? build() {
    // Position mock : Centre de Paris
    return (lat: 48.8566, lon: 2.3522, address: 'Paris, France');
  }
  
  void updateLocation(double lat, double lon, String address) {
    state = (lat: lat, lon: lon, address: address);
  }
  
  void clearLocation() {
    state = null;
  }
}

/// Provider pour la distance maximale de recherche (en km)
final searchRadiusProvider = NotifierProvider<SearchRadiusNotifier, double>(
  SearchRadiusNotifier.new,
);

class SearchRadiusNotifier extends Notifier<double> {
  @override
  double build() => 2;
  
  void updateRadius(double radius) {
    state = radius.clamp(0.5, 50.0); // Limiter entre 500m et 50km
  }
}
