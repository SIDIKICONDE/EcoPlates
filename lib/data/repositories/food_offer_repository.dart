import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_offer.dart';
import '../../domain/usecases/merchant/manage_offers_usecase.dart';
import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import 'food_offer_repository_impl.dart';

/// Provider pour l'ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Provider pour le repository des offres alimentaires
final foodOfferRepositoryProvider = Provider<FoodOfferRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FoodOfferRepositoryImpl(apiClient) as FoodOfferRepository;
});

/// Interface abstraite pour le repository des offres alimentaires
abstract class FoodOfferRepository {
  /// Créer une nouvelle offre
  Future<Either<Failure, FoodOffer>> createOffer({
    required String merchantId,
    required CreateOfferRequest request,
  });

  /// Récupérer une offre par son ID
  Future<Either<Failure, FoodOffer>> getOffer(String offerId);

  /// Mettre à jour une offre
  Future<Either<Failure, FoodOffer>> updateOffer({
    required String offerId,
    required UpdateOfferRequest request,
  });

  /// Supprimer une offre
  Future<Either<Failure, void>> deleteOffer({
    required String offerId,
    String? reason,
  });

  /// Mettre à jour le statut d'une offre
  Future<Either<Failure, FoodOffer>> updateOfferStatus({
    required String offerId,
    required OfferStatus status,
  });

  /// Mettre à jour le stock d'une offre
  Future<Either<Failure, FoodOffer>> updateOfferStock({
    required String offerId,
    required int quantity,
  });

  /// Récupérer les offres d'un commerçant
  Future<Either<Failure, List<FoodOffer>>> getMerchantOffers({
    required String merchantId,
    OfferStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// Récupérer toutes les offres disponibles
  Future<Either<Failure, List<FoodOffer>>> getAvailableOffers({
    double? latitude,
    double? longitude,
    double? radius,
    List<FoodCategory>? categories,
    List<OfferType>? types,
    bool? freeOnly,
    String? sortBy,
    int? limit,
    int? offset,
  });

  /// Récupérer les offres à proximité
  Future<Either<Failure, List<FoodOffer>>> getNearbyOffers({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int? limit,
  });

  /// Rechercher des offres
  Future<Either<Failure, List<FoodOffer>>> searchOffers({
    required String query,
    double? latitude,
    double? longitude,
    List<FoodCategory>? categories,
    int? limit,
    int? offset,
  });

  /// Récupérer les statistiques d'une offre
  Future<Either<Failure, OfferStats>> getOfferStats(String offerId);

  /// Vérifier s'il y a des réservations actives
  Future<bool> hasActiveReservations(String offerId);

  /// Récupérer le nombre de réservations actives
  Future<int> getActiveReservationsCount(String offerId);

  /// Récupérer les offres populaires
  Future<Either<Failure, List<FoodOffer>>> getPopularOffers({
    double? latitude,
    double? longitude,
    int limit = 10,
  });

  /// Récupérer les offres qui expirent bientôt
  Future<Either<Failure, List<FoodOffer>>> getExpiringOffers({
    double? latitude,
    double? longitude,
    int hoursAhead = 2,
    int limit = 20,
  });

  /// Récupérer les offres recommandées pour un utilisateur
  Future<Either<Failure, List<FoodOffer>>> getRecommendedOffers({
    required String userId,
    double? latitude,
    double? longitude,
    int limit = 10,
  });

  /// Upload des images d'offre
  Future<Either<Failure, List<String>>> uploadOfferImages({
    required String merchantId,
    required List<String> imagePaths,
  });

  /// Supprimer une image d'offre
  Future<Either<Failure, void>> deleteOfferImage({
    required String offerId,
    required String imageUrl,
  });

  /// Mettre en cache une offre
  Future<void> cacheOffer(FoodOffer offer);

  /// Mettre en cache une liste d'offres
  Future<void> cacheOffers(List<FoodOffer> offers);

  /// Récupérer une offre depuis le cache
  Future<Either<Failure, FoodOffer>> getCachedOffer(String offerId);

  /// Récupérer les offres depuis le cache
  Future<Either<Failure, List<FoodOffer>>> getCachedOffers({
    String? merchantId,
    OfferStatus? status,
  });

  /// Vider le cache
  Future<void> clearCache();

  /// Vider le cache pour un commerçant
  Future<void> clearMerchantCache(String merchantId);
}

/// Filtres pour les offres
class OfferFilters {
  final double? minPrice;
  final double? maxPrice;
  final double? minDiscount;
  final List<FoodCategory>? categories;
  final List<OfferType>? types;
  final bool? isVegetarian;
  final bool? isVegan;
  final bool? isHalal;
  final bool? freeOnly;
  final DateTime? availableFrom;
  final DateTime? availableUntil;
  final double? maxDistance;
  final String? searchQuery;

  const OfferFilters({
    this.minPrice,
    this.maxPrice,
    this.minDiscount,
    this.categories,
    this.types,
    this.isVegetarian,
    this.isVegan,
    this.isHalal,
    this.freeOnly,
    this.availableFrom,
    this.availableUntil,
    this.maxDistance,
    this.searchQuery,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (minDiscount != null) params['min_discount'] = minDiscount;
    if (categories != null && categories!.isNotEmpty) {
      params['categories'] = categories!.map((c) => c.name).join(',');
    }
    if (types != null && types!.isNotEmpty) {
      params['types'] = types!.map((t) => t.name).join(',');
    }
    if (isVegetarian != null) params['is_vegetarian'] = isVegetarian;
    if (isVegan != null) params['is_vegan'] = isVegan;
    if (isHalal != null) params['is_halal'] = isHalal;
    if (freeOnly != null) params['free_only'] = freeOnly;
    if (availableFrom != null) {
      params['available_from'] = availableFrom!.toIso8601String();
    }
    if (availableUntil != null) {
      params['available_until'] = availableUntil!.toIso8601String();
    }
    if (maxDistance != null) params['max_distance'] = maxDistance;
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['q'] = searchQuery;
    }

    return params;
  }
}

/// Options de tri pour les offres
enum OfferSortBy {
  distance, // Plus proche
  price, // Prix croissant
  discount, // Réduction décroissante
  expiringTime, // Expire bientôt
  createdAt, // Plus récent
  popularity, // Plus populaire
  rating, // Mieux noté
}
