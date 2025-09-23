import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/food_offer.dart';

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

