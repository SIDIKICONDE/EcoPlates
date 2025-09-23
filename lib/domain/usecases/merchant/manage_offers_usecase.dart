import '../../entities/food_offer.dart';
import '../../../data/repositories/merchant_repository.dart';
import '../../../data/repositories/food_offer_repository.dart';
import '../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// Use case pour gérer les offres d'un commerçant
class ManageOffersUseCase {
  final MerchantRepository merchantRepository;
  final FoodOfferRepository offerRepository;
  
  const ManageOffersUseCase({
    required this.merchantRepository,
    required this.offerRepository,
  });
  
  /// Créer une nouvelle offre
  Future<Either<Failure, FoodOffer>> createOffer({
    required String merchantId,
    required CreateOfferRequest request,
  }) async {
    try {
      // Vérifier que le commerçant peut créer une offre
      final merchantResult = await merchantRepository.getMerchant(merchantId);
      
      return merchantResult.fold(
        (failure) => Left(failure),
        (merchant) async {
          // Vérifications business
          if (!merchant.canCreateOffer) {
            return Left(BusinessFailure('Limite d\'offres actives atteinte'));
          }
          
          if (!merchant.isVerified) {
            return Left(BusinessFailure('Le compte doit être vérifié'));
          }
          
          // Validation des données
          final validationError = _validateOfferData(request);
          if (validationError != null) {
            return Left(ValidationFailure(validationError));
          }
          
          // Créer l'offre
          final offer = await offerRepository.createOffer(
            merchantId: merchantId,
            request: request,
          );
          
          return offer;
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Mettre à jour une offre existante
  Future<Either<Failure, FoodOffer>> updateOffer({
    required String merchantId,
    required String offerId,
    required UpdateOfferRequest request,
  }) async {
    try {
      // Vérifier que l'offre appartient au commerçant
      final offerResult = await offerRepository.getOffer(offerId);
      
      return offerResult.fold(
        (failure) => Left(failure),
        (offer) async {
          if (offer.merchantId != merchantId) {
            return Left(PermissionFailure('Vous ne pouvez pas modifier cette offre'));
          }
          
          // Vérifier le statut de l'offre
          if (offer.status == OfferStatus.collected) {
            return Left(BusinessFailure('Une offre collectée ne peut pas être modifiée'));
          }
          
          // Validation des nouvelles données
          final validationError = _validateUpdateData(request, offer);
          if (validationError != null) {
            return Left(ValidationFailure(validationError));
          }
          
          // Mettre à jour l'offre
          return await offerRepository.updateOffer(
            offerId: offerId,
            request: request,
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Supprimer une offre
  Future<Either<Failure, void>> deleteOffer({
    required String merchantId,
    required String offerId,
    String? reason,
  }) async {
    try {
      final offerResult = await offerRepository.getOffer(offerId);
      
      return offerResult.fold(
        (failure) => Left(failure),
        (offer) async {
          if (offer.merchantId != merchantId) {
            return Left(PermissionFailure('Vous ne pouvez pas supprimer cette offre'));
          }
          
          // Vérifier s'il y a des réservations actives
          final hasActiveReservations = await offerRepository.hasActiveReservations(offerId);
          if (hasActiveReservations) {
            return Left(BusinessFailure(
              'Impossible de supprimer : des réservations sont en cours'
            ));
          }
          
          // Supprimer l'offre
          return await offerRepository.deleteOffer(
            offerId: offerId,
            reason: reason,
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Dupliquer une offre existante
  Future<Either<Failure, FoodOffer>> duplicateOffer({
    required String merchantId,
    required String offerId,
    DateTime? newPickupStartTime,
    DateTime? newPickupEndTime,
  }) async {
    try {
      final offerResult = await offerRepository.getOffer(offerId);
      
      return offerResult.fold(
        (failure) => Left(failure),
        (offer) async {
          if (offer.merchantId != merchantId) {
            return Left(PermissionFailure('Vous ne pouvez pas dupliquer cette offre'));
          }
          
          // Créer la nouvelle offre à partir de l'ancienne
          final request = CreateOfferRequest(
            title: offer.title,
            description: offer.description,
            type: offer.type,
            category: offer.category,
            originalPrice: offer.originalPrice,
            discountedPrice: offer.discountedPrice,
            quantity: offer.quantity,
            pickupStartTime: newPickupStartTime ?? offer.pickupStartTime.add(const Duration(days: 1)),
            pickupEndTime: newPickupEndTime ?? offer.pickupEndTime.add(const Duration(days: 1)),
            images: offer.images,
            allergens: offer.allergens,
            isVegetarian: offer.isVegetarian,
            isVegan: offer.isVegan,
            isHalal: offer.isHalal,
          );
          
          return await createOffer(merchantId: merchantId, request: request);
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Récupérer toutes les offres d'un commerçant
  Future<Either<Failure, List<FoodOffer>>> getMerchantOffers({
    required String merchantId,
    OfferStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      return await offerRepository.getMerchantOffers(
        merchantId: merchantId,
        status: status,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Récupérer les statistiques d'une offre
  Future<Either<Failure, OfferStats>> getOfferStats(String offerId) async {
    try {
      return await offerRepository.getOfferStats(offerId);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Activer/Désactiver une offre
  Future<Either<Failure, FoodOffer>> toggleOfferStatus({
    required String merchantId,
    required String offerId,
    required bool activate,
  }) async {
    try {
      final offerResult = await offerRepository.getOffer(offerId);
      
      return offerResult.fold(
        (failure) => Left(failure),
        (offer) async {
          if (offer.merchantId != merchantId) {
            return Left(PermissionFailure('Vous ne pouvez pas modifier cette offre'));
          }
          
          if (activate && offer.status != OfferStatus.draft) {
            return Left(BusinessFailure('Seuls les brouillons peuvent être activés'));
          }
          
          if (!activate && offer.status != OfferStatus.available) {
            return Left(BusinessFailure('Seules les offres disponibles peuvent être désactivées'));
          }
          
          return await offerRepository.updateOfferStatus(
            offerId: offerId,
            status: activate ? OfferStatus.available : OfferStatus.draft,
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Mettre à jour le stock d'une offre
  Future<Either<Failure, FoodOffer>> updateOfferStock({
    required String merchantId,
    required String offerId,
    required int newQuantity,
  }) async {
    try {
      if (newQuantity < 0) {
        return Left(ValidationFailure('La quantité doit être positive'));
      }
      
      final offerResult = await offerRepository.getOffer(offerId);
      
      return offerResult.fold(
        (failure) => Left(failure),
        (offer) async {
          if (offer.merchantId != merchantId) {
            return Left(PermissionFailure('Vous ne pouvez pas modifier cette offre'));
          }
          
          if (offer.status != OfferStatus.available) {
            return Left(BusinessFailure('Seules les offres disponibles peuvent être modifiées'));
          }
          
          // Vérifier les réservations existantes
          final activeReservations = await offerRepository.getActiveReservationsCount(offerId);
          if (newQuantity < activeReservations) {
            return Left(BusinessFailure(
              'Le nouveau stock doit être supérieur aux réservations actives ($activeReservations)'
            ));
          }
          
          return await offerRepository.updateOfferStock(
            offerId: offerId,
            quantity: newQuantity,
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Validation des données de création
  String? _validateOfferData(CreateOfferRequest request) {
    if (request.title.isEmpty) {
      return 'Le titre est obligatoire';
    }
    
    if (request.title.length < 3) {
      return 'Le titre doit contenir au moins 3 caractères';
    }
    
    if (request.description.isEmpty) {
      return 'La description est obligatoire';
    }
    
    if (request.originalPrice <= 0) {
      return 'Le prix original doit être supérieur à 0';
    }
    
    if (request.discountedPrice < 0) {
      return 'Le prix réduit ne peut pas être négatif';
    }
    
    if (request.discountedPrice >= request.originalPrice) {
      return 'Le prix réduit doit être inférieur au prix original';
    }
    
    if (request.quantity <= 0) {
      return 'La quantité doit être supérieure à 0';
    }
    
    final now = DateTime.now();
    if (request.pickupStartTime.isBefore(now)) {
      return 'L\'heure de début de collecte doit être dans le futur';
    }
    
    if (!request.pickupEndTime.isAfter(request.pickupStartTime)) {
      return 'L\'heure de fin doit être après l\'heure de début';
    }
    
    final duration = request.pickupEndTime.difference(request.pickupStartTime);
    if (duration.inMinutes < 30) {
      return 'La fenêtre de collecte doit être d\'au moins 30 minutes';
    }
    
    if (duration.inHours > 4) {
      return 'La fenêtre de collecte ne peut pas dépasser 4 heures';
    }
    
    return null;
  }
  
  /// Validation des données de mise à jour
  String? _validateUpdateData(UpdateOfferRequest request, FoodOffer currentOffer) {
    // Similaire à _validateOfferData mais avec des champs optionnels
    if (request.title != null && request.title!.isEmpty) {
      return 'Le titre ne peut pas être vide';
    }
    
    if (request.originalPrice != null && request.originalPrice! <= 0) {
      return 'Le prix original doit être supérieur à 0';
    }
    
    if (request.discountedPrice != null && request.discountedPrice! < 0) {
      return 'Le prix réduit ne peut pas être négatif';
    }
    
    final originalPrice = request.originalPrice ?? currentOffer.originalPrice;
    final discountedPrice = request.discountedPrice ?? currentOffer.discountedPrice;
    
    if (discountedPrice >= originalPrice) {
      return 'Le prix réduit doit être inférieur au prix original';
    }
    
    // Validation des horaires si modifiés
    if (request.pickupStartTime != null || request.pickupEndTime != null) {
      final startTime = request.pickupStartTime ?? currentOffer.pickupStartTime;
      final endTime = request.pickupEndTime ?? currentOffer.pickupEndTime;
      
      if (!endTime.isAfter(startTime)) {
        return 'L\'heure de fin doit être après l\'heure de début';
      }
      
      final duration = endTime.difference(startTime);
      if (duration.inMinutes < 30) {
        return 'La fenêtre de collecte doit être d\'au moins 30 minutes';
      }
    }
    
    return null;
  }
}

/// Requête de création d'offre
class CreateOfferRequest {
  final String title;
  final String description;
  final OfferType type;
  final FoodCategory category;
  final double originalPrice;
  final double discountedPrice;
  final int quantity;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final List<String> images;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isHalal;
  
  const CreateOfferRequest({
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.originalPrice,
    required this.discountedPrice,
    required this.quantity,
    required this.pickupStartTime,
    required this.pickupEndTime,
    this.images = const [],
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isHalal = false,
  });
}

/// Requête de mise à jour d'offre
class UpdateOfferRequest {
  final String? title;
  final String? description;
  final OfferType? type;
  final FoodCategory? category;
  final double? originalPrice;
  final double? discountedPrice;
  final int? quantity;
  final DateTime? pickupStartTime;
  final DateTime? pickupEndTime;
  final List<String>? images;
  final List<String>? allergens;
  final bool? isVegetarian;
  final bool? isVegan;
  final bool? isHalal;
  
  const UpdateOfferRequest({
    this.title,
    this.description,
    this.type,
    this.category,
    this.originalPrice,
    this.discountedPrice,
    this.quantity,
    this.pickupStartTime,
    this.pickupEndTime,
    this.images,
    this.allergens,
    this.isVegetarian,
    this.isVegan,
    this.isHalal,
  });
}

/// Statistiques d'une offre
class OfferStats {
  final String offerId;
  final int views;
  final int reservations;
  final int completed;
  final int cancelled;
  final int noShow;
  final double revenue;
  final double averageRating;
  final int reviewsCount;
  final double co2Saved;
  final Map<DateTime, int> viewsByDay;
  final Map<DateTime, int> reservationsByDay;
  
  const OfferStats({
    required this.offerId,
    required this.views,
    required this.reservations,
    required this.completed,
    required this.cancelled,
    required this.noShow,
    required this.revenue,
    required this.averageRating,
    required this.reviewsCount,
    required this.co2Saved,
    this.viewsByDay = const {},
    this.reservationsByDay = const {},
  });
  
  double get conversionRate => views > 0 ? (reservations / views) * 100 : 0;
  double get completionRate => reservations > 0 ? (completed / reservations) * 100 : 0;
}