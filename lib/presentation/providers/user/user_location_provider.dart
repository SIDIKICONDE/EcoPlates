import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Classe pour stocker la localisation de l'utilisateur
class UserLocation {
  final double latitude;
  final double longitude;

  const UserLocation({
    required this.latitude,
    required this.longitude,
  });
}

/// Provider pour la localisation de l'utilisateur
final userLocationProvider = StateProvider<UserLocation?>((ref) {
  // TODO: Implémenter la récupération de la localisation réelle
  // Pour l'instant, on retourne une localisation par défaut (Paris)
  return const UserLocation(
    latitude: 48.8566,
    longitude: 2.3522,
  );
});