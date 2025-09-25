import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/food_offer.dart';
import '../../domain/repositories/food_offer_repository.dart';
import '../data_sources/food_offer_local_data_source.dart';
import '../data_sources/food_offer_remote_data_source.dart';
import '../models/food_offer_model.dart';

/// Exceptions personnalisées pour la couche data
class ServerException implements Exception {
  const ServerException([this.message = 'Server error']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);

  final String message;
}

/// Implémentation concrète du repository des offres alimentaires
/// 
/// Gère :
/// - La récupération des données depuis l'API
/// - Le caching local avec Hive
/// - La synchronisation offline/online
/// - La gestion des erreurs
class FoodOfferRepositoryImpl implements FoodOfferRepository {

  FoodOfferRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.apiClient,
  });
  final FoodOfferRemoteDataSource remoteDataSource;
  final FoodOfferLocalDataSource localDataSource;
  final ApiClient apiClient;

  @override
  Future<Either<Failure, List<FoodOffer>>> getUrgentOffers() async {
    try {
      // Vérifier la connectivité
      if (await apiClient.hasConnectivity()) {
        try {
          // Récupérer depuis l'API
          final remoteOffers = await remoteDataSource.getUrgentOffers();
          
          // Mettre à jour le cache
          await localDataSource.cacheOffers(remoteOffers);
          
          return Right(remoteOffers.map((model) => model.toEntity()).toList());
        } catch (e) {
          // En cas d'erreur API, utiliser le cache
          return _getFromCache();
        }
      } else {
        // Pas de connexion, utiliser le cache
        return _getFromCache();
      }
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getOffers({
    required int page,
    required int limit,
    String? categoryId,
    double? maxDistance,
    String? sortBy,
  }) async {
    try {
      if (await apiClient.hasConnectivity()) {
        final remoteOffers = await remoteDataSource.getOffers(
          page: page,
          limit: limit,
          categoryId: categoryId,
          maxDistance: maxDistance,
          sortBy: sortBy,
        );
        
        // Cache uniquement la première page pour économiser l'espace
        if (page == 1) {
          await localDataSource.cacheOffers(remoteOffers);
        }
        
        return Right(remoteOffers.map((model) => model.toEntity()).toList());
      } else {
        // En mode offline, ignorer la pagination
        return _getFromCache();
      }
    } on ServerException {
      return const Left(ServerFailure('Server error occurred'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FoodOffer>> getOfferById(String offerId) async {
    try {
      // Toujours vérifier le cache d'abord pour la rapidité
      final cachedOffer = await localDataSource.getOfferById(offerId);
      if (cachedOffer != null) {
        // Si en ligne, mettre à jour en arrière-plan
        if (await apiClient.hasConnectivity()) {
          _updateOfferInBackground(offerId);
        }
        return Right(cachedOffer.toEntity());
      }
      
      // Pas en cache, récupérer depuis l'API
      if (await apiClient.hasConnectivity()) {
        final remoteOffer = await remoteDataSource.getOfferById(offerId);
        await localDataSource.cacheSingleOffer(remoteOffer);
        return Right(remoteOffer.toEntity());
      } else {
        return const Left(CacheFailure( 'Offer not found in cache'));
      }
    } on ServerException {
      return const Left(ServerFailure('Server error occurred'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getRecommendedOffers(String userId) async {
    try {
      if (await apiClient.hasConnectivity()) {
        final remoteOffers = await remoteDataSource.getRecommendedOffers(userId);
        
        // Cacher les recommandations pour l'utilisateur
        await localDataSource.cacheUserRecommendations(userId, remoteOffers);
        
        return Right(remoteOffers.map((model) => model.toEntity()).toList());
      } else {
        final cachedOffers = await localDataSource.getUserRecommendations(userId);
        return Right(cachedOffers.map((model) => model.toEntity()).toList());
      }
    } on ServerException {
      return const Left(ServerFailure('Server error occurred'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reserveOffer({
    required String offerId,
    required String userId,
    required int quantity,
  }) async {
    try {
      if (!await apiClient.hasConnectivity()) {
        // Enregistrer la réservation en local pour sync ultérieure
        await localDataSource.queueReservation(
          offerId: offerId,
          userId: userId,
          quantity: quantity,
        );
        return const Right(null);
      }
      
      // Réserver via l'API
      await remoteDataSource.reserveOffer(
        offerId: offerId,
        userId: userId,
        quantity: quantity,
      );
      
      // Mettre à jour le cache local
      await localDataSource.updateOfferQuantity(offerId, -quantity);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure( e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelReservation(String reservationId) async {
    try {
      if (!await apiClient.hasConnectivity()) {
        // Enregistrer l'annulation pour sync ultérieure
        await localDataSource.queueCancellation(reservationId);
        return const Right(null);
      }
      
      await remoteDataSource.cancelReservation(reservationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure( e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> searchOffers({
    required String query,
    Map<String, dynamic>? filters,
  }) async {
    try {
      // Recherche locale d'abord pour la rapidité
      final localResults = await localDataSource.searchOffers(
        query: query,
        filters: filters,
      );
      
      // Si en ligne, rechercher aussi sur l'API
      if (await apiClient.hasConnectivity()) {
        try {
          final remoteResults = await remoteDataSource.searchOffers(
            query: query,
            filters: filters,
          );
          
          // Combiner et dédupliquer les résultats
          final combinedResults = _combineSearchResults(localResults, remoteResults);
          
          return Right(combinedResults.map((model) => model.toEntity()).toList());
        } catch (e) {
          // En cas d'erreur API, utiliser seulement les résultats locaux
          return Right(localResults.map((model) => model.toEntity()).toList());
        }
      }
      
      return Right(localResults.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheOffers(List<FoodOffer> offers) async {
    try {
      final models = offers.map(FoodOfferModel.fromEntity).toList();
      await localDataSource.cacheOffers(models);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getCachedOffers() async {
    try {
      final cachedModels = await localDataSource.getCachedOffers();
      return Right(cachedModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncOfflineData() async {
    try {
      if (!await apiClient.hasConnectivity()) {
        return const Left(NetworkFailure( 'No internet connection'));
      }
      
      // Synchroniser les réservations en attente
      final pendingReservations = await localDataSource.getPendingReservations();
      for (final reservation in pendingReservations) {
        await remoteDataSource.reserveOffer(
          offerId: reservation['offerId'] as String,
          userId: reservation['userId'] as String,
          quantity: reservation['quantity'] as int,
        );
        await localDataSource.markReservationSynced(reservation['id'] as String);
      }
      
      // Synchroniser les annulations en attente
      final pendingCancellations = await localDataSource.getPendingCancellations();
      for (final cancellationId in pendingCancellations) {
        await remoteDataSource.cancelReservation(cancellationId);
        await localDataSource.markCancellationSynced(cancellationId);
      }
      
      // Rafraîchir le cache avec les dernières données
      final freshOffers = await remoteDataSource.getOffers(page: 1, limit: 50);
      await localDataSource.cacheOffers(freshOffers);
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure( e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Méthodes privées d'assistance

  Future<Either<Failure, List<FoodOffer>>> _getFromCache() async {
    try {
      final cachedOffers = await localDataSource.getCachedOffers();
      if (cachedOffers.isEmpty) {
        return const Left(CacheFailure( 'No cached data available'));
      }
      return Right(cachedOffers.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure( e.toString()));
    }
  }

  Future<void> _updateOfferInBackground(String offerId) async {
    try {
      final updatedOffer = await remoteDataSource.getOfferById(offerId);
      await localDataSource.cacheSingleOffer(updatedOffer);
    } catch (_) {
      // Ignorer les erreurs de mise à jour en arrière-plan
    }
  }

  List<FoodOfferModel> _combineSearchResults(
    List<FoodOfferModel> local,
    List<FoodOfferModel> remote,
  ) {
    final combined = <String, FoodOfferModel>{};
    
    // Ajouter d'abord les résultats locaux
    for (final offer in local) {
      combined[offer.id] = offer;
    }
    
    // Remplacer/ajouter avec les résultats distants (plus récents)
    for (final offer in remote) {
      combined[offer.id] = offer;
    }
    
    return combined.values.toList();
  }
}
