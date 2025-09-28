import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/env_config.dart';
import '../../core/enums/merchant_enums.dart';
import '../../core/network/api_client.dart';
import '../../core/providers/api_providers.dart';
import '../../domain/entities/merchant_profile.dart';
import '../models/merchant_profile_model.dart';

/// Service pour la gestion des profils merchants
///
/// Gère les opérations CRUD et la persistance locale
/// selon les directives EcoPlates avec Riverpod 2.x
class MerchantProfileService {
  MerchantProfileService({
    required ApiClient apiClient,
    required FlutterSecureStorage storage,
  }) : _apiClient = apiClient,
       _storage = storage;

  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  static const String _profileKey = 'merchant_profile';
  static const String _profileEndpoint = '/api/merchant/profile';

  /// Récupérer le profil merchant actuel
  Future<MerchantProfile?> getCurrentProfile() async {
    try {
      // 1) En mode dev sans backend → utiliser des données mock
      if (EnvConfig.useMockData) {
        final mock = _buildMockProfile();
        // Met à jour le cache pour persistance locale/offline
        await _cacheProfile(mock);
        return mock;
      }

      // 2) Essayer d'abord de récupérer depuis le cache local
      final cachedProfile = await _getCachedProfile();
      if (cachedProfile != null) {
        // Lancer une mise à jour en arrière-plan
        _refreshProfileInBackground();
        return cachedProfile;
      }

      // 3) Si pas de cache, récupérer depuis l'API
      return await _fetchProfileFromApi();
    } catch (e) {
      // 4) En cas d'erreur réseau, fallback sur mock en dev
      if (EnvConfig.useMockData) {
        final mock = _buildMockProfile();
        await _cacheProfile(mock);
        return mock;
      }
      throw Exception('Erreur lors de la récupération du profil: $e');
    }
  }

  /// Mettre à jour le profil merchant
  Future<MerchantProfile> updateProfile(MerchantProfile profile) async {
    try {
      // En mode mock, on met simplement à jour le cache et on retourne
      if (EnvConfig.useMockData) {
        await _cacheProfile(profile.copyWith(updatedAt: DateTime.now()));
        return profile;
      }

      final model = MerchantProfileModel.fromDomain(profile);
      final response = await _apiClient.put(
        _profileEndpoint,
        data: model.toJson(),
      );

      final updatedModel = MerchantProfileModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      final updatedProfile = updatedModel.toDomain();

      // Mettre à jour le cache
      await _cacheProfile(updatedProfile);

      return updatedProfile;
    } catch (e) {
      // Fallback silencieux en dev mock
      if (EnvConfig.useMockData) {
        await _cacheProfile(profile);
        return profile;
      }
      throw Exception('Erreur lors de la mise à jour du profil: $e');
    }
  }

  /// Uploader une photo de profil/logo
  Future<String> uploadLogo(String filePath) async {
    try {
      // En mode mock, retourner une URL placeholder et mettre à jour le cache
      if (EnvConfig.useMockData) {
        const mockUrl = 'https://via.placeholder.com/256?text=Logo';
        final cached = await _getCachedProfile();
        if (cached != null) {
          await _cacheProfile(cached.copyWith(logoUrl: mockUrl));
        }
        return mockUrl;
      }

      // Utiliser FormData pour l'upload
      final formData = FormData.fromMap({
        'logo': await MultipartFile.fromFile(
          filePath,
          filename: 'logo.jpg',
        ),
      });

      final response = await _apiClient.post(
        '$_profileEndpoint/logo',
        data: formData,
      );

      return response.data['logoUrl'] as String;
    } catch (e) {
      // Fallback en dev mock
      if (EnvConfig.useMockData) {
        const mockUrl = 'https://via.placeholder.com/256?text=Logo';
        return mockUrl;
      }
      throw Exception("Erreur lors de l'upload du logo: $e");
    }
  }

  /// Supprimer le logo actuel
  Future<void> deleteLogo() async {
    try {
      // En mode mock, pas d'appel réseau
      if (EnvConfig.useMockData) {
        final cachedProfile = await _getCachedProfile();
        if (cachedProfile != null) {
          final updatedProfile = cachedProfile.copyWith();
          await _cacheProfile(updatedProfile);
        }
        return;
      }

      await _apiClient.delete('$_profileEndpoint/logo');

      // Mettre à jour le cache pour retirer le logo
      final cachedProfile = await _getCachedProfile();
      if (cachedProfile != null) {
        final updatedProfile = cachedProfile.copyWith();
        await _cacheProfile(updatedProfile);
      }
    } catch (e) {
      // Silencieux en dev mock
      if (EnvConfig.useMockData) return;
      throw Exception('Erreur lors de la suppression du logo: $e');
    }
  }

  /// Valider les horaires d'ouverture
  bool validateOpeningHours(Map<WeekDay, OpeningHours> hours) {
    for (final entry in hours.entries) {
      final dayHours = entry.value;

      if (dayHours.isClosed) continue;

      // Vérifier que les heures sont valides
      if (!_isValidTime(dayHours.openTime) ||
          !_isValidTime(dayHours.closeTime)) {
        return false;
      }

      // Vérifier les heures de pause si présentes
      if (dayHours.breakStart != null || dayHours.breakEnd != null) {
        if (dayHours.breakStart == null ||
            dayHours.breakEnd == null ||
            !_isValidTime(dayHours.breakStart!) ||
            !_isValidTime(dayHours.breakEnd!)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Vérifier le format d'une heure
  bool _isValidTime(String time) {
    final regex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    return regex.hasMatch(time);
  }

  /// Récupérer le profil depuis le cache local
  Future<MerchantProfile?> _getCachedProfile() async {
    try {
      final jsonString = await _storage.read(key: _profileKey);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = MerchantProfileModel.fromJson(json);
      return model.toDomain();
    } on Exception {
      // En cas d'erreur, supprimer le cache corrompu
      await _storage.delete(key: _profileKey);
      return null;
    }
  }

  /// Mettre en cache le profil
  Future<void> _cacheProfile(MerchantProfile profile) async {
    try {
      final model = MerchantProfileModel.fromDomain(profile);
      final jsonString = jsonEncode(model.toJson());
      await _storage.write(key: _profileKey, value: jsonString);
    } on Exception {
      // Ne pas bloquer si le cache échoue
      // Log error silently
    }
  }

  /// Récupérer le profil depuis l'API
  Future<MerchantProfile?> _fetchProfileFromApi() async {
    try {
      final response = await _apiClient.get(_profileEndpoint);

      if (response.data == null) return null;

      final model = MerchantProfileModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      final profile = model.toDomain();

      // Mettre en cache pour usage offline
      await _cacheProfile(profile);

      return profile;
    } on Exception catch (e) {
      if (EnvConfig.useMockData) {
        // Fallback immédiat sur mock en dev
        final mock = _buildMockProfile();
        await _cacheProfile(mock);
        return mock;
      }
      throw Exception('Erreur réseau lors de la récupération du profil: $e');
    }
  }

  /// Rafraîchir le profil en arrière-plan
  void _refreshProfileInBackground() {
    // Lancer la mise à jour sans attendre
    _fetchProfileFromApi().catchError((Object e) {
      // Logger l'erreur mais ne pas la propager
      return null;
    });
  }

  /// Construire un profil mock pour le développement/offline
  MerchantProfile _buildMockProfile() {
    final now = DateTime.now();
    final defaultHours = <WeekDay, OpeningHours>{
      for (final day in WeekDay.sortedDays)
        day: day == WeekDay.sunday
            ? const OpeningHours.closed()
            : const OpeningHours(
                openTime: '09:00',
                closeTime: '19:00',
                breakStart: '13:00',
                breakEnd: '14:00',
              ),
    };

    return MerchantProfile(
      id: 'mock-merchant-001',
      name: 'Boulangerie Demo',
      category: MerchantCategory.bakery,
      logoUrl: 'https://via.placeholder.com/128?text=EcoPlates',
      description:
          'Profil mock pour développement. Affiche des données locales sans connexion réseau.',
      address: const MerchantAddress(
        street: '12 Rue de Paris',
        postalCode: '75002',
        city: 'Paris',
      ),
      phoneNumber: '+33123456789',
      email: 'contact@demo.fr',
      openingHours: defaultHours,
      coordinates: const GeoCoordinates(latitude: 48.8566, longitude: 2.3522),
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
      isVerified: true,
      rating: 4.6,
      totalReviews: 128,
    );
  }

  /// Nettoyer le cache
  Future<void> clearCache() async {
    await _storage.delete(key: _profileKey);
  }
}

/// Provider pour le service de profil merchant
final merchantProfileServiceProvider = Provider<MerchantProfileService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  const storage = FlutterSecureStorage();

  return MerchantProfileService(
    apiClient: apiClient,
    storage: storage,
  );
});

/// Provider d'état pour le profil merchant actuel
final merchantProfileProvider =
    AsyncNotifierProvider<MerchantProfileNotifier, MerchantProfile?>(() {
      return MerchantProfileNotifier();
    });

/// Notifier pour gérer l'état du profil merchant
class MerchantProfileNotifier extends AsyncNotifier<MerchantProfile?> {
  @override
  Future<MerchantProfile?> build() async {
    final service = ref.watch(merchantProfileServiceProvider);
    return service.getCurrentProfile();
  }

  /// Mettre à jour le profil
  Future<void> updateProfile(MerchantProfile profile) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(merchantProfileServiceProvider);
      final updatedProfile = await service.updateProfile(profile);
      state = AsyncValue.data(updatedProfile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Uploader un logo
  Future<void> uploadLogo(String filePath) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    try {
      final service = ref.read(merchantProfileServiceProvider);
      final logoUrl = await service.uploadLogo(filePath);
      final updatedProfile = currentProfile.copyWith(logoUrl: logoUrl);
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      // Garder l'état actuel en cas d'erreur
      state = AsyncValue.data(currentProfile);
      rethrow;
    }
  }

  /// Supprimer le logo
  Future<void> deleteLogo() async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    try {
      final service = ref.read(merchantProfileServiceProvider);
      await service.deleteLogo();
      final updatedProfile = currentProfile.copyWith();
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      // Garder l'état actuel en cas d'erreur
      state = AsyncValue.data(currentProfile);
      rethrow;
    }
  }

  /// Rafraîchir le profil
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
