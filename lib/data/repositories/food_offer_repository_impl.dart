import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/food_offer.dart';
import '../../domain/repositories/food_offer_repository.dart';
import '../models/food_offer_model.dart';

/// Implémentation du repository des offres alimentaires
@Injectable(as: FoodOfferRepository)
class FoodOfferRepositoryImpl implements FoodOfferRepository {
  final ApiClient _apiClient;

  const FoodOfferRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<FoodOffer>>> getOffersByMerchant(
    String merchantId,
    Map<String, dynamic> filters,
  ) async {
    try {
      final queryParams = Map<String, dynamic>.from(filters)
        ..['merchantId'] = merchantId;

      final response = await _apiClient.get(
        '/offers',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> offersData = response.data['data'];
        final offers = offersData
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
        return Right(offers);
      }

      return Left(ServerFailure('Erreur lors de la récupération des offres'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FoodOffer>> getOfferById(String id) async {
    try {
      final response = await _apiClient.get('/offers/$id');

      if (response.statusCode == 200) {
        final offerModel = FoodOfferModel.fromJson(response.data['data']);
        return Right(offerModel.toEntity());
      }

      return Left(NotFoundFailure('Offre introuvable'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
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
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (query != null) 'q': query,
        if (latitude != null) 'lat': latitude,
        if (longitude != null) 'lng': longitude,
        if (radius != null) 'radius': radius,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (categories != null) 'categories': categories.join(','),
        if (dietaryOptions != null) 'dietaryOptions': dietaryOptions.join(','),
        if (status != null) 'status': status.name,
        if (sortBy != null) 'sortBy': sortBy.name,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      final response = await _apiClient.get(
        '/offers/search',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> offersData = response.data['data'];
        final offers = offersData
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
        return Right(offers);
      }

      return Left(ServerFailure('Erreur lors de la recherche'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getNearbyOffers({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
        'status': OfferStatus.available.name,
        if (limit != null) 'limit': limit,
      };

      final response = await _apiClient.get(
        '/offers/nearby',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> offersData = response.data['data'];
        final offers = offersData
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
        return Right(offers);
      }

      return Left(ServerFailure('Erreur lors de la recherche de proximité'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getTrendingOffers({
    int? limit,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'trending': true,
        if (limit != null) 'limit': limit,
        if (category != null) 'category': category,
      };

      final response = await _apiClient.get(
        '/offers/trending',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> offersData = response.data['data'];
        final offers = offersData
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
        return Right(offers);
      }

      return Left(
        ServerFailure('Erreur lors de la récupération des tendances'),
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FoodOffer>> createOffer(FoodOffer offer) async {
    try {
      final offerModel = FoodOfferModel.fromEntity(offer);
      final data = offerModel.toJson();

      final response = await _apiClient.post('/offers', data: data);

      if (response.statusCode == 201) {
        final createdOffer = FoodOfferModel.fromJson(response.data['data']);
        return Right(createdOffer.toEntity());
      }

      return Left(ServerFailure('Erreur lors de la création de l\'offre'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FoodOffer>> updateOffer(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiClient.put('/offers/$id', data: updates);

      if (response.statusCode == 200) {
        final updatedOffer = FoodOfferModel.fromJson(response.data['data']);
        return Right(updatedOffer.toEntity());
      }

      return Left(ServerFailure('Erreur lors de la mise à jour de l\'offre'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOffer(String id) async {
    try {
      final response = await _apiClient.delete('/offers/$id');

      if (response.statusCode == 204) {
        return const Right(null);
      }

      return Left(ServerFailure('Erreur lors de la suppression de l\'offre'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleOfferFavorite(String id) async {
    try {
      final response = await _apiClient.post('/offers/$id/toggle-favorite');

      if (response.statusCode == 200) {
        return const Right(null);
      }

      return Left(ServerFailure('Erreur lors de la mise à jour des favoris'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> reportOffer({
    required String id,
    required String reason,
    String? details,
  }) async {
    try {
      final data = {'reason': reason, if (details != null) 'details': details};

      final response = await _apiClient.post('/offers/$id/report', data: data);

      if (response.statusCode == 200) {
        return const Right(null);
      }

      return Left(ServerFailure('Erreur lors du signalement'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getFavoriteOffers() async {
    try {
      final response = await _apiClient.get('/offers/favorites');

      if (response.statusCode == 200) {
        final List<dynamic> offersData = response.data['data'];
        final offers = offersData
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
        return Right(offers);
      }

      return Left(ServerFailure('Erreur lors de la récupération des favoris'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getOfferCategories() async {
    try {
      final response = await _apiClient.get('/offers/categories');

      if (response.statusCode == 200) {
        final List<dynamic> categoriesData = response.data['data'];
        final categories = categoriesData.cast<String>();
        return Right(categories);
      }

      return Left(
        ServerFailure('Erreur lors de la récupération des catégories'),
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getDietaryOptions() async {
    try {
      final response = await _apiClient.get('/offers/dietary-options');

      if (response.statusCode == 200) {
        final List<dynamic> optionsData = response.data['data'];
        final options = optionsData.cast<String>();
        return Right(options);
      }

      return Left(ServerFailure('Erreur lors de la récupération des options'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OfferAnalytics>> getOfferAnalytics(String id) async {
    try {
      final response = await _apiClient.get('/offers/$id/analytics');

      if (response.statusCode == 200) {
        final analyticsData = response.data['data'];
        final analytics = OfferAnalytics(
          views: analyticsData['views'] ?? 0,
          reservations: analyticsData['reservations'] ?? 0,
          completedPickups: analyticsData['completedPickups'] ?? 0,
          conversionRate: (analyticsData['conversionRate'] ?? 0.0).toDouble(),
          averageRating: (analyticsData['averageRating'] ?? 0.0).toDouble(),
          totalReviews: analyticsData['totalReviews'] ?? 0,
          revenue: (analyticsData['revenue'] ?? 0.0).toDouble(),
          co2Saved: (analyticsData['co2Saved'] ?? 0.0).toDouble(),
        );
        return Right(analytics);
      }

      return Left(
        ServerFailure('Erreur lors de la récupération des analytics'),
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOfferStock({
    required String id,
    required int newStock,
  }) async {
    try {
      final data = {
        'availableQuantity': newStock,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Auto-désactiver si stock épuisé
      if (newStock == 0) {
        data['status'] = OfferStatus.cancelled.name;
      }

      final response = await _apiClient.patch('/offers/$id/stock', data: data);

      if (response.statusCode == 200) {
        return const Right(null);
      }

      return Left(ServerFailure('Erreur lors de la mise à jour du stock'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getExpiringSoonOffers({
    required String merchantId,
    int hoursThreshold = 24,
  }) async {
    try {
      final queryParams = {
        'merchantId': merchantId,
        'expiringSoon': true,
        'hoursThreshold': hoursThreshold,
      };

      final response = await _apiClient.get(
        '/offers/expiring-soon',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> offersData = response.data['data'];
        final offers = offersData
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
        return Right(offers);
      }

      return Left(ServerFailure('Erreur lors de la récupération des offres'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> bulkUpdateOffers({
    required List<String> offerIds,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final data = {'offerIds': offerIds, 'updates': updates};

      final response = await _apiClient.patch(
        '/offers/bulk-update',
        data: data,
      );

      if (response.statusCode == 200) {
        return const Right(null);
      }

      return Left(ServerFailure('Erreur lors de la mise à jour en lot'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  /// Gère les erreurs Dio et les convertit en Failure
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('Timeout de connexion');

      case DioExceptionType.connectionError:
        return NetworkFailure('Erreur de connexion réseau');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Erreur serveur';

        switch (statusCode) {
          case 400:
            return ValidationFailure(message);
          case 401:
            return AuthenticationFailure('Token expiré ou invalide');
          case 403:
            return AuthorizationFailure('Accès non autorisé');
          case 404:
            return NotFoundFailure('Ressource introuvable');
          case 422:
            return ValidationFailure(
              _extractValidationErrors(error.response?.data),
            );
          case 500:
          default:
            return ServerFailure(message);
        }

      case DioExceptionType.cancel:
        return NetworkFailure('Requête annulée');

      case DioExceptionType.unknown:
      default:
        return ServerFailure('Erreur réseau inconnue');
    }
  }

  /// Extrait les erreurs de validation de la réponse
  String _extractValidationErrors(Map<String, dynamic>? data) {
    if (data == null) return 'Données invalides';

    final errors = data['errors'] as Map<String, dynamic>?;
    if (errors == null) return data['message'] ?? 'Données invalides';

    final errorMessages = <String>[];
    errors.forEach((field, messages) {
      if (messages is List) {
        errorMessages.addAll(messages.cast<String>());
      } else if (messages is String) {
        errorMessages.add(messages);
      }
    });

    return errorMessages.join(', ');
  }
}
