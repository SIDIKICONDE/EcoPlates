import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/use_cases/use_case.dart';
import '../entities/food_offer.dart';
import '../repositories/food_offer_repository.dart';

/// Use case pour récupérer les offres urgentes
/// 
/// Encapsule la logique métier pour :
/// - Filtrer les offres < 2h avant expiration
/// - Trier par urgence (plus urgent en premier)
/// - Limiter aux offres dans un rayon acceptable
class GetUrgentOffersUseCase {
  final FoodOfferRepository repository;

  const GetUrgentOffersUseCase(this.repository);

  Future<Either<Failure, List<FoodOffer>>> call(UrgentOffersParams params) async {
    // Récupérer les offres depuis le repository
    final result = await repository.getUrgentOffers();
    
    return result.fold(
      // En cas d'erreur, essayer le cache
      (failure) async {
        if (params.allowCached) {
          final cachedResult = await repository.getCachedOffers();
          return cachedResult.map((offers) => _filterUrgentOffers(offers, params));
        }
        return Left(failure);
      },
      // En cas de succès, appliquer les filtres métier
      (offers) {
        final filteredOffers = _filterUrgentOffers(offers, params);
        
        // Mettre en cache pour le mode offline
        repository.cacheOffers(filteredOffers);
        
        return Right(filteredOffers);
      },
    );
  }
  
  /// Filtre et trie les offres selon les critères d'urgence
  List<FoodOffer> _filterUrgentOffers(List<FoodOffer> offers, UrgentOffersParams params) {
    final now = DateTime.now();
    
    return offers
        .where((offer) {
          final timeUntilExpiry = offer.pickupEndTime.difference(now);
          
          // Seulement les offres < 2h avant expiration
          if (timeUntilExpiry.inMinutes > params.maxMinutesBeforeExpiry) {
            return false;
          }
          
          // Filtrer par distance si spécifiée
          if (params.maxDistanceKm != null && offer.distanceKm != null) {
            if (offer.distanceKm! > params.maxDistanceKm!) {
              return false;
            }
          }
          
          // Seulement les offres disponibles
          return offer.canPickup && offer.availableQuantity > 0;
        })
        .toList()
      ..sort((a, b) {
        // Trier par urgence (temps restant)
        final timeA = a.pickupEndTime.difference(now).inMinutes;
        final timeB = b.pickupEndTime.difference(now).inMinutes;
        
        // Si même urgence, trier par distance
        if (timeA == timeB && a.distanceKm != null && b.distanceKm != null) {
          return a.distanceKm!.compareTo(b.distanceKm!);
        }
        
        return timeA.compareTo(timeB);
      });
  }
}

/// Paramètres pour le use case des offres urgentes
class UrgentOffersParams extends Equatable {
  final int maxMinutesBeforeExpiry;
  final double? maxDistanceKm;
  final bool allowCached;

  const UrgentOffersParams({
    this.maxMinutesBeforeExpiry = 120, // 2 heures par défaut
    this.maxDistanceKm,
    this.allowCached = true,
  });

  @override
  List<Object?> get props => [maxMinutesBeforeExpiry, maxDistanceKm, allowCached];
}