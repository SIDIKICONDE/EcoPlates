import 'package:dio/dio.dart';
import '../models/food_offer_model.dart';
import '../../domain/entities/food_offer.dart';
import '../../core/constants/env_config.dart';

/// Service pour gérer les offres anti-gaspillage
class FoodOfferService {
  final Dio _dio;

  FoodOfferService({Dio? dio}) : _dio = dio ?? Dio();

  /// Récupérer toutes les offres disponibles
  Future<List<FoodOffer>> getAvailableOffers({
    double? latitude,
    double? longitude,
    double? radius,
    List<FoodCategory>? categories,
    List<OfferType>? types,
    bool? freeOnly,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (latitude != null) queryParams['lat'] = latitude;
      if (longitude != null) queryParams['lng'] = longitude;
      if (radius != null) queryParams['radius'] = radius;
      if (categories != null && categories.isNotEmpty) {
        queryParams['categories'] = categories.map((c) => c.name).join(',');
      }
      if (types != null && types.isNotEmpty) {
        queryParams['types'] = types.map((t) => t.name).join(',');
      }
      if (freeOnly != null) queryParams['free_only'] = freeOnly;
      if (sortBy != null) queryParams['sort_by'] = sortBy;

      final response = await _dio.get(
        '${EnvConfig.apiUrl}/offers',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['offers'];
        return data
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
      }
      
      throw Exception('Erreur lors de la récupération des offres');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer une offre par son ID
  Future<FoodOffer> getOfferById(String offerId) async {
    try {
      final response = await _dio.get(
        '${EnvConfig.apiUrl}/offers/$offerId',
      );

      if (response.statusCode == 200) {
        return FoodOfferModel.fromJson(response.data).toEntity();
      }
      
      throw Exception('Offre non trouvée');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Rechercher des offres par mot-clé
  Future<List<FoodOffer>> searchOffers(String query) async {
    try {
      final response = await _dio.get(
        '${EnvConfig.apiUrl}/offers/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['offers'];
        return data
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
      }
      
      throw Exception('Erreur lors de la recherche');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer les offres d'un commerçant
  Future<List<FoodOffer>> getMerchantOffers(String merchantId) async {
    try {
      final response = await _dio.get(
        '${EnvConfig.apiUrl}/merchants/$merchantId/offers',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['offers'];
        return data
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
      }
      
      throw Exception('Erreur lors de la récupération des offres du commerçant');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer les offres à proximité (géolocalisation)
  Future<List<FoodOffer>> getNearbyOffers({
    required double latitude,
    required double longitude,
    double radius = 5.0, // km par défaut
  }) async {
    try {
      final response = await _dio.get(
        '${EnvConfig.apiUrl}/offers/nearby',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radius,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['offers'];
        return data
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
      }
      
      throw Exception('Erreur lors de la récupération des offres à proximité');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer les offres populaires
  Future<List<FoodOffer>> getPopularOffers() async {
    try {
      final response = await _dio.get(
        '${EnvConfig.apiUrl}/offers/popular',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['offers'];
        return data
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
      }
      
      throw Exception('Erreur lors de la récupération des offres populaires');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer les offres qui expirent bientôt
  Future<List<FoodOffer>> getExpiringOffers() async {
    try {
      final response = await _dio.get(
        '${EnvConfig.apiUrl}/offers/expiring',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['offers'];
        return data
            .map((json) => FoodOfferModel.fromJson(json).toEntity())
            .toList();
      }
      
      throw Exception('Erreur lors de la récupération des offres qui expirent');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Gestion centralisée des erreurs
  Exception _handleError(DioException error) {
    if (error.response != null) {
      switch (error.response?.statusCode) {
        case 400:
          return Exception('Requête invalide');
        case 401:
          return Exception('Non autorisé');
        case 403:
          return Exception('Accès interdit');
        case 404:
          return Exception('Ressource non trouvée');
        case 500:
          return Exception('Erreur serveur');
        default:
          return Exception('Erreur: ${error.response?.statusMessage}');
      }
    }
    
    if (error.type == DioExceptionType.connectionTimeout) {
      return Exception('Délai de connexion dépassé');
    }
    
    if (error.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai de réponse dépassé');
    }
    
    if (error.type == DioExceptionType.connectionError) {
      return Exception('Erreur de connexion réseau');
    }
    
    return Exception('Erreur inconnue: ${error.message}');
  }
}