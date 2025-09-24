import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/merchant_details.dart';
import '../../domain/entities/merchant_types.dart';
import '../models/merchant_model.dart';
import 'merchant_repository.dart' as data_repo;

/// Implémentation data-layer de MerchantRepository attendue par les use cases
class DataMerchantRepositoryImpl implements data_repo.MerchantRepository {
  final ApiClient _apiClient;

  DataMerchantRepositoryImpl(this._apiClient);

  Failure _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure('La connexion a expiré', code: 'TIMEOUT', details: e.message);
      case DioExceptionType.connectionError:
        return NetworkFailure('Erreur de connexion', code: 'CONNECTION_ERROR', details: e.message);
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        return ServerFailure('Erreur HTTP $status', code: 'HTTP_$status', details: e.response?.data);
      case DioExceptionType.cancel:
        return UnexpectedFailure('Requête annulée', code: 'CANCELLED', details: e.message);
      default:
        return NetworkFailure('Erreur réseau', code: 'NETWORK_ERROR', details: e.message);
    }
  }

  @override
  Future<Either<Failure, Merchant>> getMerchant(String merchantId) async {
    try {
      final response = await _apiClient.get('/merchants/$merchantId');
      if (response.statusCode == 200) {
        final merchantModel = MerchantModel.fromJson(response.data['data']);
        return Right(merchantModel.toEntity());
      }
      return Left(ServerFailure('Impossible de récupérer le commerçant'));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Merchant>> getCurrentMerchant() async {
    try {
      final response = await _apiClient.get('/merchants/me');
      if (response.statusCode == 200) {
        final merchantModel = MerchantModel.fromJson(response.data['data']);
        return Right(merchantModel.toEntity());
      }
      return Left(ServerFailure('Impossible de récupérer le profil'));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Merchant>> updateMerchant({
    required String merchantId,
    required data_repo.UpdateMerchantRequest request,
  }) async {
    try {
      final response = await _apiClient.put('/merchants/$merchantId', data: request.toJson());
      if (response.statusCode == 200) {
        final merchantModel = MerchantModel.fromJson(response.data['data']);
        return Right(merchantModel.toEntity());
      }
      return Left(ServerFailure('Erreur lors de la mise à jour'));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Merchant>> updateMerchantSettings({
    required String merchantId,
    required MerchantSettings settings,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/merchants/$merchantId/settings',
        data: {
          'maxActiveOffers': settings.maxActiveOffers,
          'maxDailyOffers': settings.maxDailyOffers,
          'autoAcceptReservations': settings.autoAcceptReservations,
          'notifyOnReservation': settings.notifyOnReservation,
          'notifyOnLowStock': settings.notifyOnLowStock,
          'lowStockThreshold': settings.lowStockThreshold,
          'enabledChannels': settings.enabledChannels.map((e) => e.name).toList(),
          'requireConfirmationCode': settings.requireConfirmationCode,
          'defaultPickupDuration': settings.defaultPickupDuration,
        },
      );
      if (response.statusCode == 200) {
        final merchantModel = MerchantModel.fromJson(response.data['data']);
        return Right(merchantModel.toEntity());
      }
      return Left(ServerFailure('Erreur lors de la mise à jour des paramètres'));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Merchant>> updateOpeningHours({
    required String merchantId,
    required OpeningHours openingHours,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/merchants/$merchantId/opening-hours',
        data: OpeningHoursModel.fromEntity(openingHours).toJson(),
      );
      if (response.statusCode == 200) {
        final merchantModel = MerchantModel.fromJson(response.data['data']);
        return Right(merchantModel.toEntity());
      }
      return Left(ServerFailure('Erreur lors de la mise à jour des horaires'));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MerchantStats>> getMerchantStats(String merchantId) async {
    try {
      final response = await _apiClient.get('/merchants/$merchantId/stats');
      if (response.statusCode == 200) {
        final statsData = response.data['data'] as Map<String, dynamic>;
        final stats = MerchantStats(
          totalOffers: (statsData['totalOffers'] ?? 0) as int,
          activeOffers: (statsData['activeOffers'] ?? 0) as int,
          totalReservations: (statsData['totalReservations'] ?? 0) as int,
          completedReservations: (statsData['completedReservations'] ?? 0) as int,
          totalRevenue: (statsData['totalRevenue'] ?? 0.0).toDouble(),
          totalCo2Saved: (statsData['totalCo2Saved'] ?? 0.0).toDouble(),
          totalMealsSaved: (statsData['totalMealsSaved'] ?? 0) as int,
          averageRating: (statsData['averageRating'] ?? 0.0).toDouble(),
        );
        return Right(stats);
      }
      return Left(ServerFailure('Erreur lors de la récupération des statistiques'));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Les méthodes suivantes ne sont pas utilisées par les écrans actuels.
  // Elles peuvent être implémentées plus tard si nécessaire.

  @override
  Future<Either<Failure, void>> addTeamMember({
    required String merchantId,
    required String email,
    required data_repo.TeamRole role,
  }) async => const Left(UnexpectedFailure('Non implémenté'));

  @override
  Future<void> cacheMerchant(Merchant merchant) async {}

  Future<Either<Failure, List<Merchant>>> getMerchantsByCategory(String category) async =>
      const Left(UnexpectedFailure('Non implémenté'));

  @override
  Future<Either<Failure, List<data_repo.TeamMember>>> getTeamMembers(String merchantId) async =>
      const Left(UnexpectedFailure('Non implémenté'));

  @override
  Future<Either<Failure, Merchant>> getCachedMerchant(String merchantId) async =>
      const Left(UnexpectedFailure('Non implémenté'));

  Future<Either<Failure, List<Merchant>>> getNearbyMerchants({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int? limit,
  }) async => const Left(UnexpectedFailure('Non implémenté'));

  Future<Either<Failure, Merchant>> createMerchant(Merchant merchant) async =>
      const Left(UnexpectedFailure('Non implémenté'));

  Future<Either<Failure, void>> deleteMerchant(String id) async =>
      const Left(UnexpectedFailure('Non implémenté'));

  @override
  Future<void> clearCache() async {}

  @override
  Future<Either<Failure, void>> removeTeamMember({
    required String merchantId,
    required String memberId,
  }) async => const Left(UnexpectedFailure('Non implémenté'));

  Future<Either<Failure, List<Merchant>>> searchMerchants({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    List<String>? categories,
    MerchantStatus? status,
    int? limit,
    int? offset,
  }) async => const Left(UnexpectedFailure('Non implémenté'));

  @override
  Future<Either<Failure, bool>> canCreateOffer(String merchantId) async =>
      const Left(UnexpectedFailure('Non implémenté'));

  Future<Either<Failure, void>> updateMerchantStatus({
    required MerchantStatus status,
    String? reason,
  }) async => const Left(UnexpectedFailure('Non implémenté'));
}
