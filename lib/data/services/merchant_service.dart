import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/food_offer.dart';
import '../../domain/entities/analytics.dart';
import '../../domain/repositories/merchant_repository.dart';
import '../../domain/repositories/food_offer_repository.dart';
import '../../domain/repositories/analytics_repository.dart';

/// Service business pour la gestion des commerçants
@injectable
class MerchantService {
  final MerchantRepository _merchantRepository;
  final FoodOfferRepository _offerRepository;
  final AnalyticsRepository _analyticsRepository;

  const MerchantService(
    this._merchantRepository,
    this._offerRepository,
    this._analyticsRepository,
  );

  // === Gestion du profil marchand ===

  /// Récupère le profil du commerçant connecté
  Future<Either<Failure, Merchant>> getMerchantProfile() async {
    try {
      return await _merchantRepository.getCurrentMerchant();
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la récupération du profil'));
    }
  }

  /// Met à jour le profil du commerçant
  Future<Either<Failure, Merchant>> updateProfile({
    required String merchantId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      return await _merchantRepository.updateMerchant(merchantId, updates);
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la mise à jour du profil'));
    }
  }

  /// Met à jour le statut du marchand (ouvert/fermé)
  Future<Either<Failure, void>> updateBusinessStatus({
    required String merchantId,
    required bool isOpen,
    String? reason,
  }) async {
    try {
      final updates = {
        'isOpen': isOpen,
        'lastStatusChange': DateTime.now().toIso8601String(),
        if (reason != null) 'statusReason': reason,
      };

      final result = await _merchantRepository.updateMerchant(
        merchantId,
        updates,
      );
      return result.fold((failure) => Left(failure), (_) => const Right(null));
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la mise à jour du statut'));
    }
  }

  // === Gestion des offres ===

  /// Récupère toutes les offres du commerçant
  Future<Either<Failure, List<FoodOffer>>> getMerchantOffers({
    OfferStatus? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final filters = <String, dynamic>{
        if (status != null) 'status': status.name,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      return await _offerRepository.getOffersByMerchant(
        await _getCurrentMerchantId(),
        filters,
      );
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la récupération des offres'));
    }
  }

  /// Crée une nouvelle offre
  Future<Either<Failure, FoodOffer>> createOffer(FoodOffer offer) async {
    try {
      // Validation business
      final validationResult = _validateOffer(offer);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      return await _offerRepository.createOffer(offer);
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la création de l\'offre'));
    }
  }

  /// Met à jour une offre existante
  Future<Either<Failure, FoodOffer>> updateOffer({
    required String offerId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      // Vérifier que l'offre appartient au commerçant
      final offerResult = await _offerRepository.getOfferById(offerId);
      return offerResult.fold((failure) => Left(failure), (offer) async {
        final merchantId = await _getCurrentMerchantId();
        if (offer.merchantId != merchantId) {
          return Left(AuthorizationFailure('Accès non autorisé à cette offre'));
        }

        return await _offerRepository.updateOffer(offerId, updates);
      });
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la mise à jour de l\'offre'));
    }
  }

  /// Supprime une offre
  Future<Either<Failure, void>> deleteOffer(String offerId) async {
    try {
      // Vérifier que l'offre appartient au commerçant
      final offerResult = await _offerRepository.getOfferById(offerId);
      return offerResult.fold((failure) => Left(failure), (offer) async {
        final merchantId = await _getCurrentMerchantId();
        if (offer.merchantId != merchantId) {
          return Left(AuthorizationFailure('Accès non autorisé à cette offre'));
        }

        return await _offerRepository.deleteOffer(offerId);
      });
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la suppression de l\'offre'));
    }
  }

  /// Duplique une offre existante
  Future<Either<Failure, FoodOffer>> duplicateOffer(String offerId) async {
    try {
      final offerResult = await _offerRepository.getOfferById(offerId);
      return offerResult.fold((failure) => Left(failure), (offer) async {
        final merchantId = await _getCurrentMerchantId();
        if (offer.merchantId != merchantId) {
          return Left(AuthorizationFailure('Accès non autorisé à cette offre'));
        }

        // Créer une copie avec nouvelles dates
        final duplicatedOffer = FoodOffer(
          id: '', // Nouveau ID sera généré par le système
          merchantId: offer.merchantId,
          merchantName: offer.merchantName,
          title: '${offer.title} (Copie)',
          description: offer.description,
          images: offer.images,
          type: offer.type,
          category: offer.category,
          originalPrice: offer.originalPrice,
          discountedPrice: offer.discountedPrice,
          quantity: offer.quantity,
          pickupStartTime: DateTime.now().add(
            const Duration(hours: 2),
          ), // Commencer dans 2h
          pickupEndTime: DateTime.now().add(
            const Duration(hours: 4),
          ), // Terminer dans 4h
          createdAt: DateTime.now(),
          status: OfferStatus.draft, // Commencer en brouillon
          location: offer.location,
          allergens: offer.allergens,
          isVegetarian: offer.isVegetarian,
          isVegan: offer.isVegan,
          isHalal: offer.isHalal,
          co2Saved: offer.co2Saved,
        );

        return await _offerRepository.createOffer(duplicatedOffer);
      });
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la duplication de l\'offre'));
    }
  }

  /// Active/désactive une offre
  Future<Either<Failure, FoodOffer>> toggleOfferStatus(String offerId) async {
    try {
      final offerResult = await _offerRepository.getOfferById(offerId);
      return offerResult.fold((failure) => Left(failure), (offer) async {
        final merchantId = await _getCurrentMerchantId();
        if (offer.merchantId != merchantId) {
          return Left(AuthorizationFailure('Accès non autorisé à cette offre'));
        }

        final newStatus = offer.status == OfferStatus.available
            ? OfferStatus.cancelled
            : OfferStatus.available;

        return await _offerRepository.updateOffer(offerId, {
          'status': newStatus.name,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      });
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la mise à jour du statut'));
    }
  }

  /// Met à jour le stock d'une offre
  Future<Either<Failure, FoodOffer>> updateOfferStock({
    required String offerId,
    required int newStock,
  }) async {
    try {
      if (newStock < 0) {
        return Left(ValidationFailure('Le stock ne peut pas être négatif'));
      }

      final updates = {
        'availableQuantity': newStock,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Auto-désactiver si stock épuisé
      if (newStock == 0) {
        updates['status'] = OfferStatus.cancelled.name;
      }

      return await updateOffer(offerId: offerId, updates: updates);
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la mise à jour du stock'));
    }
  }

  // === Analytics et statistiques ===

  /// Récupère les analytics du commerçant pour une période
  Future<Either<Failure, Analytics>> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    AnalyticsPeriod? period,
  }) async {
    try {
      final merchantId = await _getCurrentMerchantId();
      return await _analyticsRepository.getMerchantAnalytics(
        merchantId,
        startDate: startDate,
        endDate: endDate,
        period: period,
      );
    } catch (e) {
      return Left(
        ServerFailure('Erreur lors de la récupération des analytics'),
      );
    }
  }

  /// Récupère le dashboard temps réel
  Future<Either<Failure, RealtimeDashboard>> getRealtimeDashboard() async {
    try {
      final merchantId = await _getCurrentMerchantId();
      return await _analyticsRepository.getRealtimeDashboard(merchantId);
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la récupération du dashboard'));
    }
  }

  /// Récupère les insights et recommandations
  Future<Either<Failure, List<Insight>>> getInsights() async {
    try {
      final merchantId = await _getCurrentMerchantId();
      return await _analyticsRepository.getInsights(merchantId);
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la récupération des insights'));
    }
  }

  /// Génère un rapport d'analytics
  Future<Either<Failure, AnalyticsReport>> generateReport({
    required ReportFormat format,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final merchantId = await _getCurrentMerchantId();
      return await _analyticsRepository.generateReport(
        merchantId,
        format,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la génération du rapport'));
    }
  }

  // === Méthodes utilitaires privées ===

  /// Récupère l'ID du commerçant connecté
  Future<String> _getCurrentMerchantId() async {
    final result = await _merchantRepository.getCurrentMerchant();
    return result.fold(
      (failure) => throw Exception('Commerçant non connecté'),
      (merchant) => merchant.id,
    );
  }

  /// Valide une offre avant création/mise à jour
  String? _validateOffer(FoodOffer offer) {
    // Validation du titre
    if (offer.title.trim().isEmpty) {
      return 'Le titre de l\'offre est obligatoire';
    }
    if (offer.title.length < 3) {
      return 'Le titre doit contenir au moins 3 caractères';
    }
    if (offer.title.length > 100) {
      return 'Le titre ne peut pas dépasser 100 caractères';
    }

    // Validation de la description
    if (offer.description.trim().isEmpty) {
      return 'La description est obligatoire';
    }
    if (offer.description.length < 10) {
      return 'La description doit contenir au moins 10 caractères';
    }

    // Validation du prix
    if (offer.originalPrice <= 0) {
      return 'Le prix original doit être positif';
    }
    if (offer.discountedPrice <= 0) {
      return 'Le prix réduit doit être positif';
    }
    if (offer.discountedPrice >= offer.originalPrice) {
      return 'Le prix réduit doit être inférieur au prix original';
    }

    // Validation de la quantité
    if (offer.quantity < 0) {
      return 'La quantité disponible ne peut pas être négative';
    }

    // Validation des dates
    if (offer.pickupEndTime.isBefore(DateTime.now())) {
      return 'La date de fin de collecte doit être dans le futur';
    }
    if (offer.pickupStartTime.isAfter(offer.pickupEndTime)) {
      return 'La date de début doit être antérieure à la date de fin';
    }

    return null; // Validation réussie
  }

  /// Calcule les statistiques rapides
  Future<Either<Failure, MerchantQuickStats>> getQuickStats() async {
    try {
      final merchantId = await _getCurrentMerchantId();

      // Récupérer les offres actives
      final offersResult = await _offerRepository.getOffersByMerchant(
        merchantId,
        {'status': OfferStatus.available.name},
      );

      return offersResult.fold((failure) => Left(failure), (offers) async {
        // Récupérer le dashboard temps réel
        final dashboardResult = await getRealtimeDashboard();

        return dashboardResult.fold(
          (failure) => Left(failure),
          (dashboard) => Right(
            MerchantQuickStats(
              activeOffers: offers.length,
              pendingReservations: dashboard.pendingReservations,
              todayRevenue: dashboard.todayRevenue,
              todayPickups: dashboard.todayPickups,
              lowStockOffers: offers.where((o) => o.quantity <= 5).length,
              expiringToday: offers
                  .where(
                    (o) =>
                        o.pickupEndTime.difference(DateTime.now()).inHours <=
                        24,
                  )
                  .length,
            ),
          ),
        );
      });
    } catch (e) {
      return Left(ServerFailure('Erreur lors du calcul des statistiques'));
    }
  }
}

/// Statistiques rapides pour le commerçant
class MerchantQuickStats {
  final int activeOffers;
  final int pendingReservations;
  final double todayRevenue;
  final int todayPickups;
  final int lowStockOffers;
  final int expiringToday;

  const MerchantQuickStats({
    required this.activeOffers,
    required this.pendingReservations,
    required this.todayRevenue,
    required this.todayPickups,
    required this.lowStockOffers,
    required this.expiringToday,
  });
}
