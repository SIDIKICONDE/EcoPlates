import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/association.dart';
import '../../domain/entities/food_offer.dart';
import '../repositories/association_repository.dart';
import '../repositories/food_offer_repository.dart';

/// Provider pour le service des associations
final associationServiceProvider = Provider<AssociationService>((ref) {
  return AssociationService(
    associationRepository: ref.watch(associationRepositoryProvider),
    foodOfferRepository: ref.watch(foodOfferRepositoryProvider),
  );
});

/// Service métier pour les associations caritatives
class AssociationService {
  final AssociationRepository associationRepository;
  final FoodOfferRepository foodOfferRepository;

  AssociationService({
    required this.associationRepository,
    required this.foodOfferRepository,
  });

  /// Récupère les offres prioritaires pour les associations
  /// Les associations ont accès prioritaire aux offres gratuites ou à prix réduit
  Future<Either<Failure, List<FoodOffer>>> getAssociationPriorityOffers({
    required String associationId,
    double? maxPrice,
    double? radiusKm,
  }) async {
    try {
      // Récupérer l'association pour avoir sa localisation
      final associationResult = await associationRepository.getAssociationById(
        associationId,
      );

      return associationResult.fold((failure) => Left(failure), (
        association,
      ) async {
        // Récupérer toutes les offres dans la zone
        final offersResult = await foodOfferRepository.getNearbyOffers(
          latitude:
              48.8566, // TODO: Utiliser la vraie localisation de l'association
          longitude: 2.3522,
          radius: radiusKm ?? 10.0,
        );

        return offersResult.fold((failure) => Left(failure), (offers) {
          // Filtrer et trier les offres pour les associations
          final priorityOffers =
              offers.where((offer) {
                // Priorité aux offres gratuites ou très réduites
                if (maxPrice != null && offer.discountedPrice > maxPrice) {
                  return false;
                }

                // Priorité aux offres avec grande quantité (collecte groupée)
                if (offer.quantity < 5) return false;

                // Seulement les offres disponibles et collectables
                return offer.isAvailable && offer.canPickup;
              }).toList()..sort((a, b) {
                // Trier par prix (gratuit d'abord)
                if (a.isFree && !b.isFree) return -1;
                if (!a.isFree && b.isFree) return 1;

                // Puis par quantité (plus grande quantité d'abord)
                return b.quantity.compareTo(a.quantity);
              });

          return Right(priorityOffers);
        });
      });
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la récupération des offres'));
    }
  }

  /// Planifie une collecte groupée optimisée
  Future<Either<Failure, GroupCollection>> planOptimizedCollection({
    required String associationId,
    required List<String> offerIds,
    required DateTime preferredTime,
  }) async {
    try {
      // Vérifier que l'association peut collecter
      final associationResult = await associationRepository.getAssociationById(
        associationId,
      );

      return await associationResult.fold(
        (failure) => Future.value(Left<Failure, GroupCollection>(failure)),
        (association) async {
          if (!association.canCollectOffers) {
            return Left(
              ValidationFailure(
                'L\'association n\'est pas autorisée à collecter des offres',
              ),
            );
          }

          // Vérifier la disponibilité des offres
          final validOfferIds = <String>[];
          for (final offerId in offerIds) {
            // TODO: Vérifier chaque offre via foodOfferRepository
            validOfferIds.add(offerId);
          }

          if (validOfferIds.isEmpty) {
            return Left(
              ValidationFailure('Aucune offre valide pour la collecte'),
            );
          }

          // Créer la collecte groupée
          return await associationRepository.scheduleGroupCollection(
            associationId: associationId,
            offerIds: validOfferIds,
            scheduledAt: preferredTime,
            notes: 'Collecte groupée pour ${association.name}',
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la planification'));
    }
  }

  /// Calcule l'impact social d'une association
  Future<Either<Failure, AssociationImpactReport>> calculateAssociationImpact({
    required String associationId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      // Récupérer les statistiques
      final statsResult = await associationRepository.getAssociationStats(
        associationId,
      );

      return await statsResult.fold(
        (failure) =>
            Future.value(Left<Failure, AssociationImpactReport>(failure)),
        (stats) async {
          // Récupérer l'historique des collectes
          final collectionsResult = await associationRepository
              .getAssociationCollections(
                associationId: associationId,
                status: GroupCollectionStatus.completed,
                fromDate: fromDate,
                toDate: toDate,
              );

          return collectionsResult.fold((failure) => Left(failure), (
            collections,
          ) {
            // Calculer l'impact total
            final report = AssociationImpactReport(
              associationId: associationId,
              period: ImpactPeriod(
                from:
                    fromDate ??
                    DateTime.now().subtract(const Duration(days: 365)),
                to: toDate ?? DateTime.now(),
              ),
              totalMealsDistributed: stats.mealsDistributed,
              totalPeopleHelped: stats.peopleHelped,
              totalFoodSaved: stats.foodSaved,
              totalCo2Saved: stats.co2Saved,
              totalPlatesUsed: stats.platesUsed,
              totalCollections: collections.length,
              averageMealsPerCollection: collections.isEmpty
                  ? 0
                  : stats.mealsDistributed / collections.length,
              impactScore: stats.impactScore,
              monthlyTrend: _calculateMonthlyTrend(collections),
            );

            return Right(report);
          });
        },
      );
    } catch (e) {
      return Left(ServerFailure('Erreur lors du calcul de l\'impact'));
    }
  }

  /// Valide les documents d'une association (pour les admins)
  Future<Either<Failure, AssociationValidationResult>>
  validateAssociationDocuments({
    required String associationId,
    required String adminId,
    required Map<String, bool> documentChecks,
  }) async {
    try {
      // Vérifier tous les documents requis
      final requiredDocs = [
        'siret_valid',
        'rna_valid',
        'statuts_fournis',
        'assurance_valide',
        'president_identifie',
      ];

      final missingChecks = requiredDocs
          .where(
            (doc) =>
                !documentChecks.containsKey(doc) ||
                documentChecks[doc] == false,
          )
          .toList();

      if (missingChecks.isNotEmpty) {
        return Right(
          AssociationValidationResult(
            approved: false,
            rejectionReasons: missingChecks
                .map((doc) => 'Document manquant: $doc')
                .toList(),
            validatedBy: adminId,
            validatedAt: DateTime.now(),
          ),
        );
      }

      // Si tous les documents sont valides, approuver l'association
      final result = await associationRepository.validateAssociation(
        associationId: associationId,
        approved: true,
      );

      return result.fold(
        (failure) => Left(failure),
        (association) => Right(
          AssociationValidationResult(
            approved: true,
            rejectionReasons: [],
            validatedBy: adminId,
            validatedAt: DateTime.now(),
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la validation'));
    }
  }

  /// Attribue un bénévole à une collecte
  Future<Either<Failure, void>> assignVolunteerToCollection({
    required String collectionId,
    required String volunteerId,
    required String associationId,
  }) async {
    try {
      // TODO: Implémenter l'assignation via le repository
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Erreur lors de l\'assignation'));
    }
  }

  /// Calcule la tendance mensuelle
  Map<String, int> _calculateMonthlyTrend(List<GroupCollection> collections) {
    final trend = <String, int>{};

    for (final collection in collections) {
      final monthKey =
          '${collection.scheduledAt.year}-${collection.scheduledAt.month.toString().padLeft(2, '0')}';
      trend[monthKey] = (trend[monthKey] ?? 0) + 1;
    }

    return trend;
  }
}

/// Rapport d'impact social d'une association
class AssociationImpactReport {
  final String associationId;
  final ImpactPeriod period;
  final int totalMealsDistributed;
  final int totalPeopleHelped;
  final double totalFoodSaved;
  final double totalCo2Saved;
  final int totalPlatesUsed;
  final int totalCollections;
  final double averageMealsPerCollection;
  final double impactScore;
  final Map<String, int> monthlyTrend;

  const AssociationImpactReport({
    required this.associationId,
    required this.period,
    required this.totalMealsDistributed,
    required this.totalPeopleHelped,
    required this.totalFoodSaved,
    required this.totalCo2Saved,
    required this.totalPlatesUsed,
    required this.totalCollections,
    required this.averageMealsPerCollection,
    required this.impactScore,
    required this.monthlyTrend,
  });
}

/// Période pour le rapport d'impact
class ImpactPeriod {
  final DateTime from;
  final DateTime to;

  const ImpactPeriod({required this.from, required this.to});

  int get daysCount => to.difference(from).inDays;
}

/// Résultat de validation d'une association
class AssociationValidationResult {
  final bool approved;
  final List<String> rejectionReasons;
  final String validatedBy;
  final DateTime validatedAt;

  const AssociationValidationResult({
    required this.approved,
    required this.rejectionReasons,
    required this.validatedBy,
    required this.validatedAt,
  });
}
