import '../entities/food_offer.dart';
import '../../data/services/food_offer_service.dart';

/// Use case pour rechercher et filtrer les offres anti-gaspillage
class SearchOffersUseCase {
  final FoodOfferService _offerService;

  SearchOffersUseCase({
    required FoodOfferService offerService,
  }) : _offerService = offerService;

  /// Rechercher des offres avec filtres
  Future<List<FoodOffer>> execute({
    String? searchQuery,
    double? latitude,
    double? longitude,
    double? radius,
    List<FoodCategory>? categories,
    List<OfferType>? types,
    bool? freeOnly,
    SortBy sortBy = SortBy.distance,
  }) async {
    try {
      // Si une recherche textuelle est fournie
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final searchResults = await _offerService.searchOffers(searchQuery);
        
        // Appliquer les filtres supplémentaires localement
        return _applyLocalFilters(
          searchResults,
          categories: categories,
          types: types,
          freeOnly: freeOnly,
          userLat: latitude,
          userLng: longitude,
          maxRadius: radius,
        );
      }

      // Sinon, récupérer les offres avec filtres API
      final offers = await _offerService.getAvailableOffers(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        categories: categories,
        types: types,
        freeOnly: freeOnly,
        sortBy: sortBy.apiValue,
      );

      // Trier localement si nécessaire
      return _sortOffers(offers, sortBy, latitude, longitude);
    } catch (e) {
      throw Exception('Erreur lors de la recherche d\'offres: $e');
    }
  }

  /// Récupérer les offres à proximité
  Future<List<FoodOffer>> getNearbyOffers({
    required double latitude,
    required double longitude,
    double radius = 5.0,
  }) async {
    try {
      return await _offerService.getNearbyOffers(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération des offres à proximité: $e');
    }
  }

  /// Récupérer les offres populaires
  Future<List<FoodOffer>> getPopularOffers() async {
    try {
      return await _offerService.getPopularOffers();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des offres populaires: $e');
    }
  }

  /// Récupérer les offres qui expirent bientôt
  Future<List<FoodOffer>> getExpiringOffers() async {
    try {
      final offers = await _offerService.getExpiringOffers();
      
      // Filtrer uniquement celles qui sont encore disponibles
      return offers.where((offer) => offer.isAvailable).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des offres expirantes: $e');
    }
  }

  /// Appliquer des filtres locaux sur une liste d'offres
  List<FoodOffer> _applyLocalFilters(
    List<FoodOffer> offers, {
    List<FoodCategory>? categories,
    List<OfferType>? types,
    bool? freeOnly,
    double? userLat,
    double? userLng,
    double? maxRadius,
  }) {
    var filtered = offers;

    // Filtrer par catégories
    if (categories != null && categories.isNotEmpty) {
      filtered = filtered
          .where((offer) => categories.contains(offer.category))
          .toList();
    }

    // Filtrer par types
    if (types != null && types.isNotEmpty) {
      filtered = filtered
          .where((offer) => types.contains(offer.type))
          .toList();
    }

    // Filtrer par gratuité
    if (freeOnly == true) {
      filtered = filtered.where((offer) => offer.isFree).toList();
    }

    // Filtrer par distance
    if (userLat != null && userLng != null && maxRadius != null) {
      filtered = filtered.where((offer) {
        final distance = offer.location.distanceFrom(userLat, userLng);
        return distance <= maxRadius;
      }).toList();
    }

    // Filtrer uniquement les offres disponibles
    filtered = filtered.where((offer) => offer.isAvailable).toList();

    return filtered;
  }

  /// Trier les offres selon différents critères
  List<FoodOffer> _sortOffers(
    List<FoodOffer> offers,
    SortBy sortBy,
    double? userLat,
    double? userLng,
  ) {
    final sorted = List<FoodOffer>.from(offers);

    switch (sortBy) {
      case SortBy.distance:
        if (userLat != null && userLng != null) {
          sorted.sort((a, b) {
            final distA = a.location.distanceFrom(userLat, userLng);
            final distB = b.location.distanceFrom(userLat, userLng);
            return distA.compareTo(distB);
          });
        }
        break;
      
      case SortBy.price:
        sorted.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      
      case SortBy.discount:
        sorted.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      
      case SortBy.expiry:
        sorted.sort((a, b) => a.pickupEndTime.compareTo(b.pickupEndTime));
        break;
      
      case SortBy.newest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      
      case SortBy.popularity:
        // Tri par défaut si pas de métrique de popularité
        break;
    }

    return sorted;
  }
}

/// Énumération pour les options de tri
enum SortBy {
  distance,
  price,
  discount,
  expiry,
  newest,
  popularity;

  String get apiValue {
    switch (this) {
      case SortBy.distance:
        return 'distance';
      case SortBy.price:
        return 'price_asc';
      case SortBy.discount:
        return 'discount_desc';
      case SortBy.expiry:
        return 'expiry_asc';
      case SortBy.newest:
        return 'created_desc';
      case SortBy.popularity:
        return 'popular';
    }
  }
}