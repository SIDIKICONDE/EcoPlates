import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/food_offer.dart';
import '../entities/offer_stats.dart';
import '../entities/offer_requests.dart';

/// Interface du repository pour les offres alimentaires
abstract class FoodOfferRepository {
  /// Récupère les offres d'un marchand avec filtres
  Future<Either<Failure, List<FoodOffer>>> getOffersByMerchant(
    String merchantId,
    Map<String, dynamic> filters,
  );

  /// Récupère une offre par son ID
  Future<Either<Failure, FoodOffer>> getOfferById(String id);

  /// Recherche des offres avec filtres avancés
  Future<Either<Failure, List<FoodOffer>>> searchOffers({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? dietaryOptions,
    OfferStatus? status,
    SortOption? sortBy,
    int? limit,
    int? offset,
  });

  /// Récupère les offres à proximité
  Future<Either<Failure, List<FoodOffer>>> getNearbyOffers({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int? limit,
  });

  /// Récupère les offres tendances
  Future<Either<Failure, List<FoodOffer>>> getTrendingOffers({
    int? limit,
    String? category,
  });

  /// Crée une nouvelle offre
  Future<Either<Failure, FoodOffer>> createOffer(FoodOffer offer);

  /// Met à jour une offre
  Future<Either<Failure, FoodOffer>> updateOffer(
    String id,
    Map<String, dynamic> updates,
  );

  /// Supprime une offre
  Future<Either<Failure, void>> deleteOffer(String id);

  /// Bascule le statut favori d'une offre
  Future<Either<Failure, void>> toggleOfferFavorite(String id);

  /// Signale une offre
  Future<Either<Failure, void>> reportOffer({
    required String id,
    required String reason,
    String? details,
  });

  /// Récupère les offres favorites
  Future<Either<Failure, List<FoodOffer>>> getFavoriteOffers();

  /// Récupère les catégories disponibles
  Future<Either<Failure, List<String>>> getOfferCategories();

  /// Récupère les options alimentaires disponibles
  Future<Either<Failure, List<String>>> getDietaryOptions();

  /// Récupère les analytics d'une offre
  Future<Either<Failure, OfferAnalytics>> getOfferAnalytics(String id);

  /// Met à jour le stock d'une offre
  Future<Either<Failure, void>> updateOfferStock({
    required String id,
    required int newStock,
  });

  /// Récupère les offres qui expirent bientôt
  Future<Either<Failure, List<FoodOffer>>> getExpiringSoonOffers({
    required String merchantId,
    int hoursThreshold = 24,
  });

  /// Met à jour plusieurs offres en lot
  Future<Either<Failure, void>> bulkUpdateOffers({
    required List<String> offerIds,
    required Map<String, dynamic> updates,
  });

  /// Méthodes additionnelles pour les use cases merchant
  
  /// Récupère une offre (alias pour getOfferById)
  Future<Either<Failure, FoodOffer>> getOffer(String id) => getOfferById(id);

  /// Crée une offre avec une requête structurée
  Future<Either<Failure, FoodOffer>> createOfferFromRequest({
    required String merchantId,
    required CreateOfferRequest request,
  });

  /// Met à jour une offre avec une requête structurée
  Future<Either<Failure, FoodOffer>> updateOfferFromRequest({
    required String offerId,
    required UpdateOfferRequest request,
  });

  /// Supprime une offre avec une raison
  Future<Either<Failure, void>> deleteOfferWithReason({
    required String offerId,
    String? reason,
  });

  /// Récupère les offres d'un marchand avec filtres avancés
  Future<Either<Failure, List<FoodOffer>>> getMerchantOffersAdvanced({
    required String merchantId,
    OfferStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// Alias pour getMerchantOffersAdvanced
  Future<Either<Failure, List<FoodOffer>>> getMerchantOffers({
    required String merchantId,
    OfferStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) => getMerchantOffersAdvanced(
    merchantId: merchantId,
    status: status,
    startDate: startDate,
    endDate: endDate,
    limit: limit,
    offset: offset,
  );

  /// Récupère les statistiques d'une offre
  Future<Either<Failure, OfferStats>> getOfferStats(String offerId);

  /// Met à jour le statut d'une offre
  Future<Either<Failure, FoodOffer>> updateOfferStatus({
    required String offerId,
    required OfferStatus status,
  });

  /// Vérifie s'il y a des réservations actives pour une offre
  Future<bool> hasActiveReservations(String offerId);

  /// Récupère le nombre de réservations actives pour une offre
  Future<int> getActiveReservationsCount(String offerId);

  /// Met à jour le stock d'une offre (surcharge avec quantité)
  Future<Either<Failure, FoodOffer>> updateOfferStockQuantity({
    required String offerId,
    required int quantity,
  });
}

/// Options de tri disponibles
enum SortOption {
  relevance('Pertinence'),
  distance('Distance'),
  price('Prix'),
  discount('Réduction'),
  pickupTime('Heure de collecte'),
  newest('Plus récent'),
  expiringSoon('Expire bientôt');

  final String label;
  const SortOption(this.label);
}

/// Analytics d'une offre spécifique
class OfferAnalytics {
  final int views;
  final int reservations;
  final int completedPickups;
  final double conversionRate;
  final double averageRating;
  final int totalReviews;
  final double revenue;
  final double co2Saved;

  const OfferAnalytics({
    required this.views,
    required this.reservations,
    required this.completedPickups,
    required this.conversionRate,
    required this.averageRating,
    required this.totalReviews,
    required this.revenue,
    required this.co2Saved,
  });
}
