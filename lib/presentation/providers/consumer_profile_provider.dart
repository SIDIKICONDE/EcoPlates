import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/providers/provider.dart';

import '../../domain/entities/user.dart';

/// Notifier pour le profil consommateur
class ConsumerProfileNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    // Simuler un délai de chargement
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Retourner un utilisateur mock pour le développement
    return _createMockConsumerUser();
  }

  /// Met à jour le profil consommateur
  Future<void> updateProfile({
    String? name,
    String? email,
    ConsumerProfile? profile,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Simuler une requête réseau
      await Future<void>.delayed(const Duration(milliseconds: 1500));

      final currentUser = state.value;
      if (currentUser == null) {
        throw Exception('Utilisateur non trouvé');
      }

      // Créer un nouvel utilisateur avec les données mises à jour
      final updatedUser = User(
        id: currentUser.id,
        email: email ?? currentUser.email,
        name: name ?? currentUser.name,
        type: currentUser.type,
        createdAt: currentUser.createdAt,
        profile: profile ?? currentUser.profile,
        isEmailVerified: currentUser.isEmailVerified,
        isActive: currentUser.isActive,
      );

      state = AsyncValue.data(updatedUser);
    } on Object catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Met à jour les statistiques écologiques
  Future<void> updateEcoStats({
    int? ecoScore,
    int? totalPlatesUsed,
    double? co2Saved,
    DateTime? lastPlateUsedAt,
    ConsumerTier? tier,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final currentProfile = currentUser.profile as ConsumerProfile;
    final updatedProfile = ConsumerProfile(
      ecoScore: ecoScore ?? currentProfile.ecoScore,
      totalPlatesUsed: totalPlatesUsed ?? currentProfile.totalPlatesUsed,
      co2Saved: co2Saved ?? currentProfile.co2Saved,
      lastPlateUsedAt: lastPlateUsedAt ?? currentProfile.lastPlateUsedAt,
      favoriteLocations: currentProfile.favoriteLocations,
      tier: tier ?? currentProfile.tier,
    );

    await updateProfile(profile: updatedProfile);
  }

  /// Ajoute un lieu aux favoris
  Future<void> addFavoriteLocation(String locationId) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final currentProfile = currentUser.profile as ConsumerProfile;
    final updatedLocations = [...currentProfile.favoriteLocations];

    if (!updatedLocations.contains(locationId)) {
      updatedLocations.add(locationId);

      final updatedProfile = ConsumerProfile(
        ecoScore: currentProfile.ecoScore,
        totalPlatesUsed: currentProfile.totalPlatesUsed,
        co2Saved: currentProfile.co2Saved,
        lastPlateUsedAt: currentProfile.lastPlateUsedAt,
        favoriteLocations: updatedLocations,
        tier: currentProfile.tier,
      );

      await updateProfile(profile: updatedProfile);
    }
  }

  /// Retire un lieu des favoris
  Future<void> removeFavoriteLocation(String locationId) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final currentProfile = currentUser.profile as ConsumerProfile;
    final updatedLocations = currentProfile.favoriteLocations
        .where((id) => id != locationId)
        .toList();

    final updatedProfile = ConsumerProfile(
      ecoScore: currentProfile.ecoScore,
      totalPlatesUsed: currentProfile.totalPlatesUsed,
      co2Saved: currentProfile.co2Saved,
      lastPlateUsedAt: currentProfile.lastPlateUsedAt,
      favoriteLocations: updatedLocations,
      tier: currentProfile.tier,
    );

    await updateProfile(profile: updatedProfile);
  }

  /// Simule l'utilisation d'une assiette (pour les tests)
  Future<void> simulatePlateUsage({
    int platesUsed = 1,
    double co2SavedPerPlate = 0.8,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final currentProfile = currentUser.profile as ConsumerProfile;

    final newTotalPlates = currentProfile.totalPlatesUsed + platesUsed;
    final newCo2Saved =
        currentProfile.co2Saved + (co2SavedPerPlate * platesUsed);
    final newEcoScore =
        currentProfile.ecoScore + (platesUsed * 10); // 10 points par assiette

    // Calculer le nouveau tier basé sur l'EcoScore
    var newTier = currentProfile.tier;
    if (newEcoScore >= 1000) {
      newTier = ConsumerTier.platinum;
    } else if (newEcoScore >= 500) {
      newTier = ConsumerTier.gold;
    } else if (newEcoScore >= 100) {
      newTier = ConsumerTier.silver;
    } else {
      newTier = ConsumerTier.bronze;
    }

    await updateEcoStats(
      ecoScore: newEcoScore,
      totalPlatesUsed: newTotalPlates,
      co2Saved: newCo2Saved,
      lastPlateUsedAt: DateTime.now(),
      tier: newTier,
    );
  }

  /// Force le rechargement du profil
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      state = AsyncValue.data(_createMockConsumerUser());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Crée un utilisateur consommateur mock pour le développement
  User _createMockConsumerUser() {
    return User(
      id: 'consumer_123',
      email: 'marie.dupont@example.com',
      name: 'Marie Dupont',
      type: UserType.consumer,
      createdAt: DateTime.parse(
        '2023-12-01T00:00:00.000Z',
      ), // Il y a environ 2 mois
      profile: ConsumerProfile(
        ecoScore: 245,
        totalPlatesUsed: 18,
        co2Saved: 14.4, // 18 * 0.8 kg en moyenne
        lastPlateUsedAt: DateTime.parse(
          '2024-01-25T18:30:00.000Z',
        ), // Il y a quelques jours
        favoriteLocations: const [
          'restaurant_bistrot_123',
          'cafe_eco_456',
          'green_garden_789',
        ],
        tier: ConsumerTier.silver, // 245 points = niveau Silver
      ),
      isEmailVerified: true,
    );
  }
}

/// Provider pour le profil consommateur
final consumerProfileProvider =
    AsyncNotifierProvider<ConsumerProfileNotifier, User?>(
      ConsumerProfileNotifier.new,
    );

/// Provider pour obtenir les statistiques écologiques du consommateur
final consumerEcoStatsProvider = Provider<ConsumerProfile?>((ref) {
  final user = ref.watch(consumerProfileProvider).value;
  return user?.profile as ConsumerProfile?;
});

/// Provider pour vérifier si un lieu est dans les favoris
final ProviderFamily<bool, String> isFavoriteLocationProvider = Provider.family<bool, String>((
  ref,
  locationId,
) {
  final profile = ref.watch(consumerEcoStatsProvider);
  return profile?.favoriteLocations.contains(locationId) ?? false;
});

/// Provider pour obtenir le niveau actuel du consommateur
final consumerTierProvider = Provider<ConsumerTier>((ref) {
  final profile = ref.watch(consumerEcoStatsProvider);
  return profile?.tier ?? ConsumerTier.bronze;
});

/// Provider pour calculer la progression vers le prochain niveau
final tierProgressProvider = Provider<double>((ref) {
  final profile = ref.watch(consumerEcoStatsProvider);
  if (profile == null) return 0.0;

  final currentScore = profile.ecoScore;
  final currentTier = profile.tier;

  switch (currentTier) {
    case ConsumerTier.bronze:
      return (currentScore / 100).clamp(0.0, 1.0);
    case ConsumerTier.silver:
      return ((currentScore - 100) / 400).clamp(0.0, 1.0);
    case ConsumerTier.gold:
      return ((currentScore - 500) / 500).clamp(0.0, 1.0);
    case ConsumerTier.platinum:
      return 1.0; // Niveau maximum atteint
  }
});
