import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/repositories/merchant_repository.dart';
import '../models/merchant_model.dart';

/// Implémentation du repository des commerçants
@Injectable(as: MerchantRepository)
class MerchantRepositoryImpl implements MerchantRepository {
  final ApiClient _apiClient;
  
  const MerchantRepositoryImpl(this._apiClient);
  
  @override
  Future<Either<Failure, Merchant>> getCurrentMerchant() async {
    try {
      final response = await _apiClient.get('/merchants/me');
      
      if (response.statusCode == 200) {
        final merchantModel = MerchantModel.fromJson(response.data['data']);
        return Right(merchantModel.toEntity());
      }
      
      return Left(ServerFailure('Impossible de récupérer le profil'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, Merchant>> getMerchantById(String id) async {
    try {
      final response = await _apiClient.get('/merchants/$id');
      
      if (response.statusCode == 200) {
        final merchantModel = MerchantModel.fromJson(response.data['data']);
        return Right(merchantModel.toEntity());
      }
      
      return Left(NotFoundFailure('Commerçant introuvable'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, List<Merchant>>> searchMerchants({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    List<String>? categories,
    MerchantStatus? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (query != null) 'q': query,
        if (latitude != null) 'lat': latitude,
        if (longitude != null) 'lng': longitude,
        if (radius != null) 'radius': radius,
        if (categories != null) 'categories': categories.join(','),
        if (status != null) 'status': status.name,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };
      
      final response = await _apiClient.get(
        '/merchants/search',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> merchantsData = response.data['data'];
        final merchants = merchantsData
            .map((json) => MerchantModel.fromJson(json).toEntity())
            .toList();
        return Right(merchants);
      }
      
      return Left(ServerFailure('Erreur lors de la recherche'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, List<Merchant>>> getNearbyMerchants({
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
        if (limit != null) 'limit': limit,
      };
      
      final response = await _apiClient.get(
        '/merchants/nearby',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> merchantsData = response.data['data'];
        final merchants = merchantsData
            .map((json) => MerchantModel.fromJson(json).toEntity())
            .toList();
        return Right(merchants);
      }
      
      return Left(ServerFailure('Erreur lors de la recherche de proximité'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, Merchant>> createMerchant(Merchant merchant) async {
    try {
      final merchantModel = MerchantModel.fromEntity(merchant);
      final data = merchantModel.toJson();
      
      final response = await _apiClient.post('/merchants', data: data);
      
      if (response.statusCode == 201) {
        final createdMerchant = MerchantModel.fromJson(response.data['data']);
        return Right(createdMerchant.toEntity());
      }
      
      return Left(ServerFailure('Erreur lors de la création du compte'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, Merchant>> updateMerchant(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiClient.put('/merchants/$id', data: updates);
      
      if (response.statusCode == 200) {
        final updatedMerchant = MerchantModel.fromJson(response.data['data']);
        return Right(updatedMerchant.toEntity());
      }
      
      return Left(ServerFailure('Erreur lors de la mise à jour'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteMerchant(String id) async {
    try {
      final response = await _apiClient.delete('/merchants/$id');
      
      if (response.statusCode == 204) {
        return const Right(null);
      }
      
      return Left(ServerFailure('Erreur lors de la suppression'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, List<Merchant>>> getMerchantsByCategory(
    String category,
  ) async {
    try {
      final response = await _apiClient.get('/merchants/category/$category');
      
      if (response.statusCode == 200) {
        final List<dynamic> merchantsData = response.data['data'];
        final merchants = merchantsData
            .map((json) => MerchantModel.fromJson(json).toEntity())
            .toList();
        return Right(merchants);
      }
      
      return Left(ServerFailure('Erreur lors de la récupération par catégorie'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, MerchantStats>> getMerchantStats(String id) async {
    try {
      final response = await _apiClient.get('/merchants/$id/stats');
      
      if (response.statusCode == 200) {
        final statsData = response.data['data'];
        final stats = MerchantStats(
          totalOffers: statsData['totalOffers'] ?? 0,
          activeOffers: statsData['activeOffers'] ?? 0,
          totalReservations: statsData['totalReservations'] ?? 0,
          completedReservations: statsData['completedReservations'] ?? 0,
          totalRevenue: (statsData['totalRevenue'] ?? 0.0).toDouble(),
          totalCo2Saved: (statsData['totalCo2Saved'] ?? 0.0).toDouble(),
          totalMealsSaved: statsData['totalMealsSaved'] ?? 0,
          averageRating: (statsData['averageRating'] ?? 0.0).toDouble(),
        );
        return Right(stats);
      }
      
      return Left(ServerFailure('Erreur lors de la récupération des statistiques'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateMerchantStatus({
    required String id,
    required MerchantStatus status,
    String? reason,
  }) async {
    try {
      final data = {
        'status': status.name,
        if (reason != null) 'reason': reason,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      final response = await _apiClient.patch('/merchants/$id/status', data: data);
      
      if (response.statusCode == 200) {
        return const Right(null);
      }
      
      return Left(ServerFailure('Erreur lors de la mise à jour du statut'));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> toggleMerchantFavorite(String id) async {
    try {
      final response = await _apiClient.post('/merchants/$id/toggle-favorite');
      
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
  Future<Either<Failure, List<String>>> getMerchantCategories() async {
    try {
      final response = await _apiClient.get('/merchants/categories');
      
      if (response.statusCode == 200) {
        final List<dynamic> categoriesData = response.data['data'];
        final categories = categoriesData.cast<String>();
        return Right(categories);
      }
      
      return Left(ServerFailure('Erreur lors de la récupération des catégories'));
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
            return ValidationFailure(_extractValidationErrors(error.response?.data));
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
