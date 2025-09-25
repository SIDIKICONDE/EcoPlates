import 'package:hive_flutter/hive_flutter.dart';
import '../models/food_offer_model.dart';

/// Interface pour la gestion locale des données d'offres
abstract class FoodOfferLocalDataSource {
  /// Cache une liste d'offres
  Future<void> cacheOffers(List<FoodOfferModel> offers);
  
  /// Récupère toutes les offres en cache
  Future<List<FoodOfferModel>> getCachedOffers();
  
  /// Récupère une offre spécifique par ID
  Future<FoodOfferModel?> getOfferById(String offerId);
  
  /// Cache une offre unique
  Future<void> cacheSingleOffer(FoodOfferModel offer);
  
  /// Met à jour la quantité d'une offre
  Future<void> updateOfferQuantity(String offerId, int delta);
  
  /// Cache les recommandations pour un utilisateur
  Future<void> cacheUserRecommendations(String userId, List<FoodOfferModel> offers);
  
  /// Récupère les recommandations d'un utilisateur
  Future<List<FoodOfferModel>> getUserRecommendations(String userId);
  
  /// Recherche locale des offres
  Future<List<FoodOfferModel>> searchOffers({
    required String query,
    Map<String, dynamic>? filters,
  });
  
  /// Met en file d'attente une réservation pour sync ultérieure
  Future<void> queueReservation({
    required String offerId,
    required String userId,
    required int quantity,
  });
  
  /// Récupère les réservations en attente
  Future<List<Map<String, dynamic>>> getPendingReservations();
  
  /// Marque une réservation comme synchronisée
  Future<void> markReservationSynced(String reservationId);
  
  /// Met en file d'attente une annulation
  Future<void> queueCancellation(String reservationId);
  
  /// Récupère les annulations en attente
  Future<List<String>> getPendingCancellations();
  
  /// Marque une annulation comme synchronisée
  Future<void> markCancellationSynced(String cancellationId);
  
  /// Nettoie les données expirées
  Future<void> cleanExpiredData();
  
  /// Récupère la date de dernière synchronisation
  Future<DateTime?> getLastSyncDate();
  
  /// Met à jour la date de dernière synchronisation
  Future<void> updateLastSyncDate();
  
  /// Vide tout le cache
  Future<void> clearAllCache();
}

/// Implémentation avec Hive
class FoodOfferLocalDataSourceImpl implements FoodOfferLocalDataSource {
  
  FoodOfferLocalDataSourceImpl() {
    _initBoxes();
  }
  static const String _offersBoxName = 'offers';
  static const String _recommendationsBoxName = 'recommendations';
  static const String _pendingActionsBoxName = 'pending_actions';
  static const String _metadataBoxName = 'metadata';
  
  late final Box<FoodOfferModel> _offersBox;
  late final Box<List<String>> _recommendationsBox;
  late final Box<Map<String, dynamic>> _pendingActionsBox;
  late final Box<dynamic> _metadataBox;
  
  Future<void> _initBoxes() async {
    _offersBox = await Hive.openBox<FoodOfferModel>(_offersBoxName);
    _recommendationsBox = await Hive.openBox<List<String>>(_recommendationsBoxName);
    _pendingActionsBox = await Hive.openBox<Map<String, dynamic>>(_pendingActionsBoxName);
    _metadataBox = await Hive.openBox(_metadataBoxName);
  }
  
  @override
  Future<void> cacheOffers(List<FoodOfferModel> offers) async {
    final offersMap = <String, FoodOfferModel>{
      for (final offer in offers) offer.id: offer
    };
    await _offersBox.putAll(offersMap);
    await updateLastSyncDate();
  }
  
  @override
  Future<List<FoodOfferModel>> getCachedOffers() async {
    // Nettoyer les offres expirées avant de retourner
    await cleanExpiredData();
    return _offersBox.values.toList();
  }
  
  @override
  Future<FoodOfferModel?> getOfferById(String offerId) async {
    return _offersBox.get(offerId);
  }
  
  @override
  Future<void> cacheSingleOffer(FoodOfferModel offer) async {
    await _offersBox.put(offer.id, offer);
  }
  
  @override
  Future<void> updateOfferQuantity(String offerId, int delta) async {
    final offer = await getOfferById(offerId);
    if (offer != null) {
      final updatedOffer = offer.copyWith(
        availableQuantity: (offer.availableQuantity + delta).clamp(0, 999),
      );
      await cacheSingleOffer(updatedOffer);
    }
  }
  
  @override
  Future<void> cacheUserRecommendations(String userId, List<FoodOfferModel> offers) async {
    // Sauvegarder les offres
    await cacheOffers(offers);
    
    // Sauvegarder les IDs comme recommandations pour l'utilisateur
    final offerIds = offers.map((o) => o.id).toList();
    await _recommendationsBox.put(userId, offerIds);
  }
  
  @override
  Future<List<FoodOfferModel>> getUserRecommendations(String userId) async {
    final recommendedIds = _recommendationsBox.get(userId) ?? [];
    final offers = <FoodOfferModel>[];
    
    for (final id in recommendedIds) {
      final offer = await getOfferById(id);
      if (offer != null) {
        offers.add(offer);
      }
    }
    
    return offers;
  }
  
  @override
  Future<List<FoodOfferModel>> searchOffers({
    required String query,
    Map<String, dynamic>? filters,
  }) async {
    final allOffers = await getCachedOffers();
    final queryLower = query.toLowerCase();
    
    return allOffers.where((offer) {
      // Recherche dans le titre et la description
      final matchesQuery = offer.title.toLowerCase().contains(queryLower) ||
          offer.description.toLowerCase().contains(queryLower) ||
          offer.merchantName.toLowerCase().contains(queryLower);
      
      if (!matchesQuery) return false;
      
      // Appliquer les filtres si présents
      if (filters != null) {
        // Filtre par catégorie
        if (filters['category'] != null && offer.category != filters['category']) {
          return false;
        }
        
        // Filtre par prix max
        if (filters['maxPrice'] != null && offer.discountedPrice > (filters['maxPrice'] as num)) {
          return false;
        }
        
        // Filtre par distance
        if (filters['maxDistance'] != null && 
            offer.distanceKm != null && 
            offer.distanceKm! > (filters['maxDistance'] as num)) {
          return false;
        }
        
        // Filtre par régimes alimentaires
        if (filters['dietaryTags'] != null) {
          final requiredTags = filters['dietaryTags'] as List<String>;
          if (!requiredTags.every((tag) => offer.tags.contains(tag))) {
            return false;
          }
        }
      }
      
      return true;
    }).toList();
  }
  
  @override
  Future<void> queueReservation({
    required String offerId,
    required String userId,
    required int quantity,
  }) async {
    final reservation = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'reservation',
      'offerId': offerId,
      'userId': userId,
      'quantity': quantity,
      'timestamp': DateTime.now().toIso8601String(),
      'synced': false,
    };
    
    await _pendingActionsBox.put(reservation['id']! as String, reservation);
  }
  
  @override
  Future<List<Map<String, dynamic>>> getPendingReservations() async {
    return _pendingActionsBox.values
        .where((action) => action['type'] == 'reservation' && action['synced'] == false)
        .toList();
  }
  
  @override
  Future<void> markReservationSynced(String reservationId) async {
    final reservation = _pendingActionsBox.get(reservationId);
    if (reservation != null) {
      reservation['synced'] = true;
      await _pendingActionsBox.put(reservationId, reservation);
    }
  }
  
  @override
  Future<void> queueCancellation(String reservationId) async {
    final cancellation = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'cancellation',
      'reservationId': reservationId,
      'timestamp': DateTime.now().toIso8601String(),
      'synced': false,
    };
    
    await _pendingActionsBox.put(cancellation['id']! as String, cancellation);
  }
  
  @override
  Future<List<String>> getPendingCancellations() async {
    return _pendingActionsBox.values
        .where((action) => action['type'] == 'cancellation' && action['synced'] == false)
        .map((action) => action['reservationId'] as String)
        .toList();
  }
  
  @override
  Future<void> markCancellationSynced(String cancellationId) async {
    final cancellation = _pendingActionsBox.values
        .firstWhere((action) => 
            action['type'] == 'cancellation' && 
            action['reservationId'] == cancellationId,
            orElse: () => <String, dynamic>{});
    
    if (cancellation.isNotEmpty) {
      cancellation['synced'] = true;
      await _pendingActionsBox.put(cancellation['id'] as String, cancellation);
    }
  }
  
  @override
  Future<void> cleanExpiredData() async {
    final now = DateTime.now();
    final keysToDelete = <String>[];
    
    // Parcourir toutes les offres et supprimer celles expirées
    for (final entry in _offersBox.toMap().entries) {
      if (entry.value.pickupEndTime.isBefore(now)) {
        keysToDelete.add(entry.key as String);
      }
    }
    
    // Supprimer en batch
    await _offersBox.deleteAll(keysToDelete);
    
    // Nettoyer les actions synchronisées de plus de 7 jours
    final weekAgo = now.subtract(const Duration(days: 7));
    final actionsToDelete = <String>[];
    
    for (final entry in _pendingActionsBox.toMap().entries) {
      final timestamp = DateTime.parse(entry.value['timestamp'] as String);
      if (entry.value['synced'] == true && timestamp.isBefore(weekAgo)) {
        actionsToDelete.add(entry.key as String);
      }
    }
    
    await _pendingActionsBox.deleteAll(actionsToDelete);
  }
  
  @override
  Future<DateTime?> getLastSyncDate() async {
    final dateString = _metadataBox.get('lastSyncDate') as String?;
    return dateString != null ? DateTime.parse(dateString) : null;
  }
  
  @override
  Future<void> updateLastSyncDate() async {
    await _metadataBox.put('lastSyncDate', DateTime.now().toIso8601String());
  }
  
  @override
  Future<void> clearAllCache() async {
    await Future.wait([
      _offersBox.clear(),
      _recommendationsBox.clear(),
      _pendingActionsBox.clear(),
      _metadataBox.clear(),
    ]);
  }
}
