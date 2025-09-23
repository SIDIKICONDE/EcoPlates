import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/error/failures.dart';
import '../../data/repositories/association_repository.dart';
import '../../data/services/association_service.dart';
import '../entities/association.dart';
import '../entities/food_offer.dart';

/// Provider pour les use cases des associations
final getAssociationsUseCaseProvider = Provider<GetAssociationsUseCase>((ref) {
  return GetAssociationsUseCase(ref.watch(associationRepositoryProvider));
});

final getAssociationByIdUseCaseProvider = Provider<GetAssociationByIdUseCase>((
  ref,
) {
  return GetAssociationByIdUseCase(ref.watch(associationRepositoryProvider));
});

final getAssociationPriorityOffersUseCaseProvider =
    Provider<GetAssociationPriorityOffersUseCase>((ref) {
      return GetAssociationPriorityOffersUseCase(
        ref.watch(associationServiceProvider),
      );
    });

final scheduleGroupCollectionUseCaseProvider =
    Provider<ScheduleGroupCollectionUseCase>((ref) {
      return ScheduleGroupCollectionUseCase(
        ref.watch(associationServiceProvider),
      );
    });

final calculateAssociationImpactUseCaseProvider =
    Provider<CalculateAssociationImpactUseCase>((ref) {
      return CalculateAssociationImpactUseCase(
        ref.watch(associationServiceProvider),
      );
    });

final validateAssociationUseCaseProvider = Provider<ValidateAssociationUseCase>(
  (ref) {
    return ValidateAssociationUseCase(ref.watch(associationRepositoryProvider));
  },
);

/// Use case pour récupérer la liste des associations
class GetAssociationsUseCase {
  final AssociationRepository repository;

  GetAssociationsUseCase(this.repository);

  Future<Either<Failure, List<Association>>> call({
    AssociationType? type,
    AssociationStatus? status,
    String? city,
    int page = 1,
    int limit = 20,
  }) async {
    return repository.getAssociations(
      type: type,
      status: status,
      city: city,
      page: page,
      limit: limit,
    );
  }
}

/// Use case pour récupérer une association par ID
class GetAssociationByIdUseCase {
  final AssociationRepository repository;

  GetAssociationByIdUseCase(this.repository);

  Future<Either<Failure, Association>> call(String associationId) async {
    if (associationId.isEmpty) {
      return Left(ValidationFailure('L\'ID de l\'association est requis'));
    }

    return repository.getAssociationById(associationId);
  }
}

/// Use case pour récupérer les offres prioritaires pour une association
class GetAssociationPriorityOffersUseCase {
  final AssociationService service;

  GetAssociationPriorityOffersUseCase(this.service);

  Future<Either<Failure, List<FoodOffer>>> call({
    required String associationId,
    double? maxPrice,
    double? radiusKm,
  }) async {
    if (associationId.isEmpty) {
      return Left(ValidationFailure('L\'ID de l\'association est requis'));
    }

    // Les associations peuvent avoir un prix max de 5€ par défaut
    final priceLimit = maxPrice ?? 5.0;

    return service.getAssociationPriorityOffers(
      associationId: associationId,
      maxPrice: priceLimit,
      radiusKm: radiusKm,
    );
  }
}

/// Use case pour programmer une collecte groupée
class ScheduleGroupCollectionUseCase {
  final AssociationService service;

  ScheduleGroupCollectionUseCase(this.service);

  Future<Either<Failure, GroupCollection>> call({
    required String associationId,
    required List<String> offerIds,
    required DateTime scheduledAt,
  }) async {
    // Validations
    if (associationId.isEmpty) {
      return Left(ValidationFailure('L\'ID de l\'association est requis'));
    }

    if (offerIds.isEmpty) {
      return Left(
        ValidationFailure('Au moins une offre doit être sélectionnée'),
      );
    }

    if (scheduledAt.isBefore(DateTime.now())) {
      return Left(
        ValidationFailure('La date de collecte doit être dans le futur'),
      );
    }

    // Limite de 20 offres par collecte pour éviter les abus
    if (offerIds.length > 20) {
      return Left(ValidationFailure('Maximum 20 offres par collecte groupée'));
    }

    return service.planOptimizedCollection(
      associationId: associationId,
      offerIds: offerIds,
      preferredTime: scheduledAt,
    );
  }
}

/// Use case pour calculer l'impact social d'une association
class CalculateAssociationImpactUseCase {
  final AssociationService service;

  CalculateAssociationImpactUseCase(this.service);

  Future<Either<Failure, AssociationImpactReport>> call({
    required String associationId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (associationId.isEmpty) {
      return Left(ValidationFailure('L\'ID de l\'association est requis'));
    }

    // Validation des dates
    if (fromDate != null && toDate != null && fromDate.isAfter(toDate)) {
      return Left(
        ValidationFailure('La date de début doit être avant la date de fin'),
      );
    }

    return service.calculateAssociationImpact(
      associationId: associationId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}

/// Use case pour valider une association (admin uniquement)
class ValidateAssociationUseCase {
  final AssociationRepository repository;

  ValidateAssociationUseCase(this.repository);

  Future<Either<Failure, Association>> call({
    required String associationId,
    required bool approved,
    String? rejectionReason,
  }) async {
    // Validations
    if (associationId.isEmpty) {
      return Left(ValidationFailure('L\'ID de l\'association est requis'));
    }

    if (!approved && (rejectionReason == null || rejectionReason.isEmpty)) {
      return Left(
        ValidationFailure('Une raison de rejet est requise en cas de refus'),
      );
    }

    return repository.validateAssociation(
      associationId: associationId,
      approved: approved,
      rejectionReason: rejectionReason,
    );
  }
}

/// Use case pour créer une nouvelle association
class CreateAssociationUseCase {
  final AssociationRepository repository;

  CreateAssociationUseCase(this.repository);

  Future<Either<Failure, Association>> call({
    required Association association,
    required Map<String, dynamic> documents,
  }) async {
    // Validations de base
    if (association.name.isEmpty) {
      return Left(ValidationFailure('Le nom de l\'association est requis'));
    }

    if (association.siret.isEmpty || association.siret.length != 14) {
      return Left(
        ValidationFailure('Le numéro SIRET doit contenir 14 chiffres'),
      );
    }

    if (association.rna.isEmpty) {
      return Left(ValidationFailure('Le numéro RNA est requis'));
    }

    // Vérifier que tous les documents requis sont fournis
    final requiredDocuments = ['statuts', 'bureau', 'assurance'];
    for (final doc in requiredDocuments) {
      if (!documents.containsKey(doc)) {
        return Left(ValidationFailure('Document manquant: $doc'));
      }
    }

    return repository.createAssociation(
      association: association,
      documents: documents,
    );
  }
}

/// Use case pour gérer les bénévoles
class ManageVolunteersUseCase {
  final AssociationRepository repository;

  ManageVolunteersUseCase(this.repository);

  Future<Either<Failure, void>> addVolunteer({
    required String associationId,
    required String userId,
  }) async {
    if (associationId.isEmpty || userId.isEmpty) {
      return Left(ValidationFailure('IDs requis'));
    }

    return repository.addVolunteer(
      associationId: associationId,
      userId: userId,
    );
  }

  Future<Either<Failure, void>> removeVolunteer({
    required String associationId,
    required String userId,
  }) async {
    if (associationId.isEmpty || userId.isEmpty) {
      return Left(ValidationFailure('IDs requis'));
    }

    return repository.removeVolunteer(
      associationId: associationId,
      userId: userId,
    );
  }
}

/// Use case pour rechercher des associations par zone
class SearchAssociationsByZoneUseCase {
  final AssociationRepository repository;

  SearchAssociationsByZoneUseCase(this.repository);

  Future<Either<Failure, List<Association>>> call({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    // Validation des coordonnées
    if (latitude < -90 || latitude > 90) {
      return Left(ValidationFailure('Latitude invalide'));
    }

    if (longitude < -180 || longitude > 180) {
      return Left(ValidationFailure('Longitude invalide'));
    }

    if (radiusKm <= 0 || radiusKm > 50) {
      return Left(ValidationFailure('Le rayon doit être entre 0 et 50 km'));
    }

    return repository.getAssociationsByZone(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }
}
