import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/association.dart';
import '../models/association_model.dart';

/// Provider pour le repository des associations
final associationRepositoryProvider = Provider<AssociationRepository>((ref) {
  return AssociationRepositoryImpl(dio: Dio());
});

/// Interface du repository pour les associations
abstract class AssociationRepository {
  /// Récupère la liste des associations
  Future<Either<Failure, List<Association>>> getAssociations({
    AssociationType? type,
    AssociationStatus? status,
    String? city,
    int? page,
    int? limit,
  });

  /// Récupère une association par son ID
  Future<Either<Failure, Association>> getAssociationById(String id);

  /// Récupère les associations d'une zone géographique
  Future<Either<Failure, List<Association>>> getAssociationsByZone({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });

  /// Crée une nouvelle association (demande de validation)
  Future<Either<Failure, Association>> createAssociation({
    required Association association,
    required Map<String, dynamic> documents,
  });

  /// Met à jour une association
  Future<Either<Failure, Association>> updateAssociation(
    Association association,
  );

  /// Valide une association (admin uniquement)
  Future<Either<Failure, Association>> validateAssociation({
    required String associationId,
    required bool approved,
    String? rejectionReason,
  });

  /// Récupère les statistiques d'une association
  Future<Either<Failure, AssociationStats>> getAssociationStats(
    String associationId,
  );

  /// Programme une collecte groupée
  Future<Either<Failure, GroupCollection>> scheduleGroupCollection({
    required String associationId,
    required List<String> offerIds,
    required DateTime scheduledAt,
    String? notes,
  });

  /// Récupère les collectes d'une association
  Future<Either<Failure, List<GroupCollection>>> getAssociationCollections({
    required String associationId,
    GroupCollectionStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Ajoute un bénévole à une association
  Future<Either<Failure, void>> addVolunteer({
    required String associationId,
    required String userId,
  });

  /// Retire un bénévole d'une association
  Future<Either<Failure, void>> removeVolunteer({
    required String associationId,
    required String userId,
  });
}

/// Implémentation concrète du repository
class AssociationRepositoryImpl implements AssociationRepository {
  final Dio dio;
  static const String baseUrl = 'https://api.ecoplates.com/v1';

  AssociationRepositoryImpl({required this.dio});

  @override
  Future<Either<Failure, List<Association>>> getAssociations({
    AssociationType? type,
    AssociationStatus? status,
    String? city,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type.name;
      if (status != null) queryParams['status'] = status.name;
      if (city != null) queryParams['city'] = city;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await dio.get(
        '$baseUrl/associations',
        queryParameters: queryParams,
      );

      final associations = (response.data['associations'] as List)
          .map((json) => AssociationModel.fromJson(json).toEntity())
          .toList();

      return Right(associations);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Erreur lors de la récupération des associations',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, Association>> getAssociationById(String id) async {
    try {
      final response = await dio.get('$baseUrl/associations/$id');
      final association = AssociationModel.fromJson(response.data).toEntity();
      return Right(association);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left(NotFoundFailure('Association non trouvée'));
      }
      return Left(
        ServerFailure(
          e.message ?? 'Erreur lors de la récupération de l\'association',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, List<Association>>> getAssociationsByZone({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/associations/nearby',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radiusKm,
        },
      );

      final associations = (response.data['associations'] as List)
          .map((json) => AssociationModel.fromJson(json).toEntity())
          .toList();

      return Right(associations);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Erreur lors de la récupération des associations',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, Association>> createAssociation({
    required Association association,
    required Map<String, dynamic> documents,
  }) async {
    try {
      final formData = FormData.fromMap({
        'association': AssociationModel.fromEntity(association).toJson(),
        ...documents,
      });

      final response = await dio.post('$baseUrl/associations', data: formData);

      final newAssociation = AssociationModel.fromJson(
        response.data,
      ).toEntity();
      return Right(newAssociation);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Left(
          ConflictFailure('Une association avec ce SIRET existe déjà'),
        );
      }
      return Left(
        ServerFailure(
          e.message ?? 'Erreur lors de la création de l\'association',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, Association>> updateAssociation(
    Association association,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/associations/${association.id}',
        data: AssociationModel.fromEntity(association).toJson(),
      );

      final updatedAssociation = AssociationModel.fromJson(
        response.data,
      ).toEntity();
      return Right(updatedAssociation);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Erreur lors de la mise à jour de l\'association',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, Association>> validateAssociation({
    required String associationId,
    required bool approved,
    String? rejectionReason,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/associations/$associationId/validate',
        data: {
          'approved': approved,
          if (rejectionReason != null) 'rejection_reason': rejectionReason,
        },
      );

      final association = AssociationModel.fromJson(response.data).toEntity();
      return Right(association);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return Left(
          UnauthorizedFailure(
            'Vous n\'êtes pas autorisé à valider des associations',
          ),
        );
      }
      return Left(ServerFailure(e.message ?? 'Erreur lors de la validation'));
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, AssociationStats>> getAssociationStats(
    String associationId,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/associations/$associationId/stats',
      );
      final stats = AssociationStatsModel.fromJson(response.data).toEntity();
      return Right(stats);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Erreur lors de la récupération des statistiques',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, GroupCollection>> scheduleGroupCollection({
    required String associationId,
    required List<String> offerIds,
    required DateTime scheduledAt,
    String? notes,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/associations/$associationId/collections',
        data: {
          'offer_ids': offerIds,
          'scheduled_at': scheduledAt.toIso8601String(),
          if (notes != null) 'notes': notes,
        },
      );

      final collection = GroupCollectionModel.fromJson(
        response.data,
      ).toEntity();
      return Right(collection);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return Left(ValidationFailure('Données de collecte invalides'));
      }
      return Left(
        ServerFailure(
          e.message ?? 'Erreur lors de la programmation de la collecte',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, List<GroupCollection>>> getAssociationCollections({
    required String associationId,
    GroupCollectionStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status.name;
      if (fromDate != null) queryParams['from'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['to'] = toDate.toIso8601String();

      final response = await dio.get(
        '$baseUrl/associations/$associationId/collections',
        queryParameters: queryParams,
      );

      final collections = (response.data['collections'] as List)
          .map((json) => GroupCollectionModel.fromJson(json).toEntity())
          .toList();

      return Right(collections);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Erreur lors de la récupération des collectes',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, void>> addVolunteer({
    required String associationId,
    required String userId,
  }) async {
    try {
      await dio.post(
        '$baseUrl/associations/$associationId/volunteers',
        data: {'user_id': userId},
      );
      return const Right(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Left(ConflictFailure('L\'utilisateur est déjà bénévole'));
      }
      return Left(
        ServerFailure(e.message ?? 'Erreur lors de l\'ajout du bénévole'),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, void>> removeVolunteer({
    required String associationId,
    required String userId,
  }) async {
    try {
      await dio.delete(
        '$baseUrl/associations/$associationId/volunteers/$userId',
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Erreur lors du retrait du bénévole'),
      );
    } catch (e) {
      return Left(ServerFailure('Une erreur inattendue est survenue'));
    }
  }
}
