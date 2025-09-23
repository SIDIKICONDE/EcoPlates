import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/statistics_service.dart';
import '../commerce/reservations_provider.dart';

/// Provider pour les statistiques utilisateur
final userStatisticsProvider = FutureProvider<UserStatistics>((ref) async {
  // Initialiser le service
  final service = ref.read(statisticsServiceProvider);
  await service.init();

  // Récupérer les réservations de l'utilisateur
  final reservations = await ref.watch(userReservationsProvider.future);

  // Calculer les statistiques
  final stats = service.calculateStatistics(reservations);

  // Sauvegarder pour accès hors ligne
  await service.saveStatistics(stats);

  return stats;
});

/// Provider pour les statistiques en cache
final cachedStatisticsProvider = Provider<UserStatistics>((ref) {
  final service = ref.read(statisticsServiceProvider);
  return service.getStoredStatistics();
});

/// Provider pour rafraîchir les statistiques
final refreshStatisticsProvider = FutureProvider<void>((ref) async {
  ref.invalidate(userStatisticsProvider);
});
