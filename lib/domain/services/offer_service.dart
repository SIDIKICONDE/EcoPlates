import '../../domain/entities/food_offer.dart';

/// Service pour gérer les opérations CRUD sur les offres
class OfferService {
  // TODO: Remplacer par une vraie implémentation avec API/Firebase
  final List<FoodOffer> _offers = [];

  /// Crée une nouvelle offre
  Future<void> createOffer(FoodOffer offer) async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(seconds: 1));
    _offers.add(offer);
  }

  /// Met à jour une offre existante
  Future<void> updateOffer(String offerId, Map<String, dynamic> updates) async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(milliseconds: 500));

    final offerIndex = _offers.indexWhere((o) => o.id == offerId);
    if (offerIndex == -1) {
      throw Exception('Offre non trouvée');
    }

    // TODO: Appliquer les mises à jour à l'offre
    // Pour l'instant, on simule seulement
  }

  /// Supprime une offre
  Future<void> deleteOffer(String offerId) async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(milliseconds: 300));

    final offerIndex = _offers.indexWhere((o) => o.id == offerId);
    if (offerIndex == -1) {
      throw Exception('Offre non trouvée');
    }

    _offers.removeAt(offerIndex);
  }

  /// Récupère une offre par son ID
  Future<FoodOffer?> getOfferById(String offerId) async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _offers.firstWhere((o) => o.id == offerId);
    } catch (e) {
      return null;
    }
  }

  /// Récupère toutes les offres d'un marchand
  Future<List<FoodOffer>> getOffersByMerchant(String merchantId) async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(milliseconds: 300));

    return _offers.where((o) => o.merchantId == merchantId).toList();
  }

  /// Recherche des offres
  Future<List<FoodOffer>> searchOffers({
    String? query,
    String? category,
    String? merchantId,
    double? latitude,
    double? longitude,
    double? radiusKm,
  }) async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(milliseconds: 400));

    var results = _offers;

    if (merchantId != null) {
      results = results.where((o) => o.merchantId == merchantId).toList();
    }

    if (query != null && query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      results = results
          .where(
            (o) =>
                o.title.toLowerCase().contains(queryLower) ||
                o.description.toLowerCase().contains(queryLower),
          )
          .toList();
    }

    if (category != null) {
      results = results.where((o) => o.category.name == category).toList();
    }

    // TODO: Filtrage par distance si latitude/longitude/radius fournis

    return results;
  }
}
