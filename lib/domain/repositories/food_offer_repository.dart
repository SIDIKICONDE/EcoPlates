import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/food_offer.dart';

/// Repository abstrait pour les offres alimentaires
/// 
/// Suit le principe d'inversion de dépendance (DIP)
/// La couche domain ne connaît pas l'implémentation concrète
abstract class FoodOfferRepository {
  /// Récupère les offres urgentes (< 2h avant expiration)
  Future<Either<Failure, List<FoodOffer>>> getUrgentOffers();
  
  /// Récupère toutes les offres disponibles avec pagination
  Future<Either<Failure, List<FoodOffer>>> getOffers({
    required int page,
    required int limit,
    String? categoryId,
    double? maxDistance,
    String? sortBy,
  });
  
  /// Récupère une offre spécifique par ID
  Future<Either<Failure, FoodOffer>> getOfferById(String offerId);
  
  /// Récupère les offres recommandées pour l'utilisateur
  Future<Either<Failure, List<FoodOffer>>> getRecommendedOffers(String userId);
  
  /// Réserve une offre pour l'utilisateur
  Future<Either<Failure, void>> reserveOffer({
    required String offerId,
    required String userId,
    required int quantity,
  });
  
  /// Annule une réservation
  Future<Either<Failure, void>> cancelReservation(String reservationId);
  
  /// Recherche des offres par critères
  Future<Either<Failure, List<FoodOffer>>> searchOffers({
    required String query,
    Map<String, dynamic>? filters,
  });
  
  /// Met en cache les offres pour le mode offline
  Future<Either<Failure, void>> cacheOffers(List<FoodOffer> offers);
  
  /// Récupère les offres mises en cache
  Future<Either<Failure, List<FoodOffer>>> getCachedOffers();
  
  /// Synchronise les données locales avec le serveur
  Future<Either<Failure, void>> syncOfflineData();
}