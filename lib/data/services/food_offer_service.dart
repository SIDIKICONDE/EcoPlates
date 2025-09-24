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
    // MOCK DATA - En attendant l'API réelle
    await Future.delayed(const Duration(milliseconds: 800)); // Simuler la latence
    
    return _getMockOffers(freeOnly: freeOnly);
    
    /* TODO: Décommenter quand l'API sera prête
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
    */
  }

  /// Récupérer une offre par son ID
  Future<FoodOffer> getOfferById(String offerId) async {
    // MOCK DATA - En attendant l'API réelle
    await Future.delayed(const Duration(milliseconds: 500)); // Simuler la latence
    
    return _getMockOfferById(offerId);
    
    /* TODO: Décommenter quand l'API sera prête
    try {
      final response = await _dio.get('${EnvConfig.apiUrl}/offers/$offerId');

      if (response.statusCode == 200) {
        return FoodOfferModel.fromJson(response.data).toEntity();
      }

      throw Exception('Offre non trouvée');
    } on DioException catch (e) {
      throw _handleError(e);
    }
    */
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

      throw Exception(
        'Erreur lors de la récupération des offres du commerçant',
      );
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
        queryParameters: {'lat': latitude, 'lng': longitude, 'radius': radius},
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
      final response = await _dio.get('${EnvConfig.apiUrl}/offers/popular');

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
      final response = await _dio.get('${EnvConfig.apiUrl}/offers/expiring');

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
  
  /// Données mock temporaires pour les tests
  FoodOffer _getMockOfferById(String offerId) {
    // Créer une offre de test selon l'ID
    return FoodOffer(
      id: offerId,
      merchantId: 'merchant-1',
      merchantName: 'Au Pain Doré',
      title: 'Panier surprise boulangerie',
      description: 'Assortiment de pains et viennoiseries fraîches du jour avec des croissants, pain au chocolat et autres délices.',
      images: [
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=300&fit=crop',
      ],
      type: OfferType.boulangerie,
      category: FoodCategory.boulangerie,
      originalPrice: 15.00,
      discountedPrice: 5.00,
      quantity: 3,
      pickupStartTime: DateTime.now().add(const Duration(hours: 2)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: OfferStatus.available,
      location: Location(
        latitude: 48.8566,
        longitude: 2.3522,
        address: '123 Rue de la Paix',
        city: 'Paris',
        postalCode: '75001',
        additionalInfo: 'Entrée par la rue latérale, sonner \u00e0 la porte de service',
      ),
      allergens: ['Gluten', 'Œufs', 'Lait'],
      isVegetarian: true,
      isVegan: false,
      isHalal: false,
      co2Saved: 750, // 750g de CO2 économisé
    );
  }
  
  /// Générer une liste d'offres mock
  List<FoodOffer> _getMockOffers({bool? freeOnly}) {
    final offers = [
      // Offre 1 - Boulangerie
      FoodOffer(
        id: 'offer-1',
        merchantId: 'merchant-1',
        merchantName: 'Au Pain Doré',
        title: 'Panier surprise boulangerie',
        description: 'Pains et viennoiseries',
        images: ['https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop'],
        type: OfferType.boulangerie,
        category: FoodCategory.boulangerie,
        originalPrice: 15.00,
        discountedPrice: 5.00,
        quantity: 3,
        pickupStartTime: DateTime.now().add(const Duration(hours: 2)),
        pickupEndTime: DateTime.now().add(const Duration(hours: 6)),
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        status: OfferStatus.available,
        location: Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: '123 Rue de la Paix',
          city: 'Paris',
          postalCode: '75001',
        ),
        allergens: ['Gluten'],
        isVegetarian: true,
        co2Saved: 750,
      ),
      
      // Offre 2 - Restaurant
      FoodOffer(
        id: 'offer-2',
        merchantId: 'merchant-2',
        merchantName: 'Le Petit Bistrot',
        title: 'Plat du jour',
        description: 'Menu complet',
        images: ['https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop'],
        type: OfferType.plat,
        category: FoodCategory.dejeuner,
        originalPrice: 18.00,
        discountedPrice: 8.50,
        quantity: 2,
        pickupStartTime: DateTime.now().add(const Duration(hours: 1)),
        pickupEndTime: DateTime.now().add(const Duration(hours: 4)),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: OfferStatus.available,
        location: Location(
          latitude: 48.8606,
          longitude: 2.3376,
          address: '45 Avenue des Champs',
          city: 'Paris',
          postalCode: '75008',
        ),
        allergens: [],
        isVegetarian: false,
        co2Saved: 900,
      ),
      
      // Offre 3 - Gratuite
      FoodOffer(
        id: 'offer-3',
        merchantId: 'merchant-3',
        merchantName: 'Fresh Market',
        title: 'Fruits et légumes',
        description: 'Invendus fraîcheur',
        images: ['https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=300&fit=crop'],
        type: OfferType.fruits,
        category: FoodCategory.fruitLegume,
        originalPrice: 12.00,
        discountedPrice: 0.00, // Gratuit
        quantity: 5,
        pickupStartTime: DateTime.now().add(const Duration(minutes: 30)),
        pickupEndTime: DateTime.now().add(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        status: OfferStatus.available,
        location: Location(
          latitude: 48.8529,
          longitude: 2.3500,
          address: '78 Boulevard Saint-Germain',
          city: 'Paris',
          postalCode: '75006',
        ),
        allergens: [],
        isVegetarian: true,
        isVegan: true,
        co2Saved: 600,
      ),
    ];
    
    // Filtrer les offres gratuites si demandé
    if (freeOnly == true) {
      return offers.where((offer) => offer.isFree).toList();
    }
    
    return offers;
  }
}
