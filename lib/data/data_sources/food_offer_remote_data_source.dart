import '../../core/network/api_client.dart';
import '../../domain/entities/food_offer.dart';
import '../models/food_offer_model.dart';
import '../repositories/food_offer_repository_impl.dart';

/// Interface pour la source de données distante (API)
abstract class FoodOfferRemoteDataSource {
  /// Récupère les offres urgentes depuis l'API
  Future<List<FoodOfferModel>> getUrgentOffers();

  /// Récupère les offres avec pagination et filtres
  Future<List<FoodOfferModel>> getOffers({
    required int page,
    required int limit,
    String? categoryId,
    double? maxDistance,
    String? sortBy,
  });

  /// Récupère une offre par son ID
  Future<FoodOfferModel> getOfferById(String offerId);

  /// Récupère les offres recommandées pour un utilisateur
  Future<List<FoodOfferModel>> getRecommendedOffers(String userId);

  /// Effectue une réservation
  Future<void> reserveOffer({
    required String offerId,
    required String userId,
    required int quantity,
  });

  /// Annule une réservation
  Future<void> cancelReservation(String reservationId);

  /// Recherche des offres
  Future<List<FoodOfferModel>> searchOffers({
    required String query,
    Map<String, dynamic>? filters,
  });
}

/// Implémentation concrète utilisant l'API REST
class FoodOfferRemoteDataSourceImpl implements FoodOfferRemoteDataSource {
  FoodOfferRemoteDataSourceImpl({required this.apiClient});
  final ApiClient apiClient;

  @override
  Future<List<FoodOfferModel>> getUrgentOffers() async {
    try {
      final response = await apiClient.get(
        '/offers/urgent',
        queryParameters: {
          'limit': 20,
          'sortBy': 'pickupEndTime',
          'order': 'asc',
        },
      );

      if (response.statusCode == 200) {
        final data =
            (response.data as Map<String, dynamic>)['data'] as List<dynamic>? ??
            [];
        return data
            .map(
              (json) => FoodOfferModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          'Failed to load urgent offers: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<List<FoodOfferModel>> getOffers({
    required int page,
    required int limit,
    String? categoryId,
    double? maxDistance,
    String? sortBy,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (categoryId != null) 'categoryId': categoryId,
        if (maxDistance != null) 'maxDistance': maxDistance,
        if (sortBy != null) 'sortBy': sortBy,
      };

      final response = await apiClient.get(
        '/offers',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data =
            (response.data as Map<String, dynamic>)['data'] as List<dynamic>? ??
            [];
        return data
            .map(
              (json) => FoodOfferModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException('Failed to load offers: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<FoodOfferModel> getOfferById(String offerId) async {
    try {
      final response = await apiClient.get('/offers/$offerId');

      if (response.statusCode == 200) {
        return FoodOfferModel.fromJson(
          (response.data as Map<String, dynamic>)['data']
              as Map<String, dynamic>,
        );
      } else if (response.statusCode == 404) {
        throw const ServerException('Offer not found');
      } else {
        throw ServerException('Failed to load offer: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<List<FoodOfferModel>> getRecommendedOffers(String userId) async {
    try {
      final response = await apiClient.get(
        '/users/$userId/recommended-offers',
        queryParameters: {'limit': 10},
      );

      if (response.statusCode == 200) {
        final data =
            (response.data as Map<String, dynamic>)['data'] as List<dynamic>? ??
            [];
        return data
            .map(
              (json) => FoodOfferModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          'Failed to load recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<void> reserveOffer({
    required String offerId,
    required String userId,
    required int quantity,
  }) async {
    try {
      final response = await apiClient.post(
        '/offers/$offerId/reserve',
        data: {
          'userId': userId,
          'quantity': quantity,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMessage =
            (response.data as Map<String, dynamic>?)?['message'] as String? ??
            'Reservation failed';
        final errorCode =
            (response.data as Map<String, dynamic>?)?['code'] as String?;

        // Gestion des erreurs métier spécifiques
        switch (errorCode) {
          case 'OFFER_EXPIRED':
            throw const ServerException('This offer has expired');
          case 'INSUFFICIENT_QUANTITY':
            throw const ServerException('Not enough quantity available');
          case 'RESERVATION_LIMIT':
            throw const ServerException(
              'You have reached the reservation limit',
            );
          case 'OUTSIDE_PICKUP_HOURS':
            throw const ServerException('Outside pickup hours');
          default:
            throw ServerException(errorMessage);
        }
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<void> cancelReservation(String reservationId) async {
    try {
      final response = await apiClient.delete('/reservations/$reservationId');

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorMessage =
            (response.data as Map<String, dynamic>?)?['message'] as String? ??
            'Cancellation failed';
        throw ServerException(errorMessage);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<List<FoodOfferModel>> searchOffers({
    required String query,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'limit': 50,
        if (filters != null) ...filters,
      };

      final response = await apiClient.get(
        '/offers/search',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data =
            (response.data as Map<String, dynamic>)['data'] as List<dynamic>? ??
            [];
        return data
            .map(
              (json) => FoodOfferModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }
}

/// Mock implementation pour les tests et le développement
class FoodOfferRemoteDataSourceMock implements FoodOfferRemoteDataSource {
  @override
  Future<List<FoodOfferModel>> getUrgentOffers() async {
    // Simuler un délai réseau
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Retourner des données mock
    return _generateMockOffers(count: 5, urgent: true);
  }

  @override
  Future<List<FoodOfferModel>> getOffers({
    required int page,
    required int limit,
    String? categoryId,
    double? maxDistance,
    String? sortBy,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _generateMockOffers(count: limit);
  }

  @override
  Future<FoodOfferModel> getOfferById(String offerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _generateMockOffers(count: 1).first;
  }

  @override
  Future<List<FoodOfferModel>> getRecommendedOffers(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _generateMockOffers(count: 8, recommended: true);
  }

  @override
  Future<void> reserveOffer({
    required String offerId,
    required String userId,
    required int quantity,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    // Simuler des erreurs aléatoires pour tester
    if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
      throw const ServerException('Simulated error for testing');
    }
  }

  @override
  Future<void> cancelReservation(String reservationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<FoodOfferModel>> searchOffers({
    required String query,
    Map<String, dynamic>? filters,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    // Filtrer les résultats mock selon la query
    final allOffers = _generateMockOffers(count: 20);
    return allOffers
        .where(
          (offer) =>
              offer.title.toLowerCase().contains(query.toLowerCase()) ||
              offer.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Génère des offres mock pour le développement
  List<FoodOfferModel> _generateMockOffers({
    required int count,
    bool urgent = false,
    bool recommended = false,
  }) {
    final now = DateTime.now();
    final merchants = [
      'Carrefour',
      'Auchan',
      'Leclerc',
      'Intermarché',
      'Casino',
      "McDonald's",
      'Starbucks',
      'Burger King',
      'Subway',
      'KFC',
    ];
    final categories = [
      FoodCategory.boulangerie,
      FoodCategory.fruitLegume,
      FoodCategory.dejeuner,
      FoodCategory.epicerie,
      FoodCategory.dessert,
    ];
    final images = [
      'https://images.unsplash.com/photo-1509440159596-0249088772ff',
      'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
      'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445',
    ];

    return List.generate(count, (index) {
      final pickupEnd = urgent
          ? now.add(Duration(hours: 1, minutes: index * 10))
          : now.add(Duration(hours: 3 + index));

      return FoodOfferModel(
        id: 'offer_${now.millisecondsSinceEpoch}_$index',
        merchantId: 'merchant_$index',
        merchantName: merchants[index % merchants.length],
        title: urgent
            ? 'Panier Surprise Urgent ${index + 1}'
            : recommended
            ? 'Recommandé pour vous ${index + 1}'
            : 'Panier Anti-Gaspi ${index + 1}',
        description:
            'Délicieux produits à sauver avant la fermeture. Contenu varié selon disponibilité.',
        images: [images[index % images.length]],
        type: OfferType.panier,
        category: categories[index % categories.length],
        originalPrice: 15.0 + (index * 2),
        discountedPrice: 5.0 + (index * 0.5),
        quantity: urgent ? 1 : 3 + (index % 5),
        pickupStartTime: now.add(const Duration(hours: 1)),
        pickupEndTime: pickupEnd,
        createdAt: now.subtract(Duration(days: index)),
        status: OfferStatus.available,
        location: LocationModel(
          latitude: 48.8566 + (index * 0.01),
          longitude: 2.3522 + (index * 0.01),
          address: '${index + 1} rue du Commerce',
          city: 'Paris',
          postalCode: '75015',
        ),
        merchantAddress: '${index + 1} rue du Commerce, 75015 Paris',
        merchantLogo: 'https://via.placeholder.com/100',
        availableQuantity: urgent ? 1 : 3 + (index % 5),
        totalQuantity: 10,
        tags: index % 2 == 0 ? ['Végétarien'] : ['Sans gluten'],
        allergens: index % 3 == 0 ? ['Gluten', 'Lactose'] : [],
        nutritionalInfo: {
          'calories': '${200 + index * 50} kcal',
          'proteins': '${10 + index}g',
        },
        ecoImpact: {
          'co2Saved': '${1.5 + index * 0.2} kg',
          'waterSaved': '${100 + index * 20} L',
        },
        rating: 4.0 + (index % 10) / 10,
        ratingsCount: 50 + index * 10,
        distanceKm: 0.5 + (index * 0.3),
        preparationTime: 5,
        isFavorite: index % 3 == 0,
        viewCount: 100 + index * 20,
        soldCount: 20 + index * 5,
        updatedAt: now.subtract(Duration(hours: index)),
      );
    });
  }
}
