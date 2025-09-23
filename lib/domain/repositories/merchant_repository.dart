import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/merchant.dart';

/// Interface du repository pour les commerçants
abstract class MerchantRepository {
  /// Récupère le profil du commerçant actuel
  Future<Either<Failure, Merchant>> getCurrentMerchant();

  /// Récupère un commerçant par son ID
  Future<Either<Failure, Merchant>> getMerchantById(String id);

  /// Recherche des commerçants avec filtres
  Future<Either<Failure, List<Merchant>>> searchMerchants({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    List<String>? categories,
    MerchantStatus? status,
    int? limit,
    int? offset,
  });

  /// Récupère les commerçants à proximité
  Future<Either<Failure, List<Merchant>>> getNearbyMerchants({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int? limit,
  });

  /// Crée un nouveau commerçant
  Future<Either<Failure, Merchant>> createMerchant(Merchant merchant);

  /// Met à jour un commerçant
  Future<Either<Failure, Merchant>> updateMerchant(
    String id,
    Map<String, dynamic> updates,
  );

  /// Supprime un commerçant
  Future<Either<Failure, void>> deleteMerchant(String id);

  /// Récupère les commerçants par catégorie
  Future<Either<Failure, List<Merchant>>> getMerchantsByCategory(String category);

  /// Récupère les statistiques d'un commerçant
  Future<Either<Failure, MerchantStats>> getMerchantStats(String id);

  /// Met à jour le statut d'un commerçant
  Future<Either<Failure, void>> updateMerchantStatus({
    required String id,
    required MerchantStatus status,
    String? reason,
  });

  /// Bascule le statut favori d'un commerçant
  Future<Either<Failure, void>> toggleMerchantFavorite(String id);

  /// Récupère les catégories de commerçants disponibles
  Future<Either<Failure, List<String>>> getMerchantCategories();
}
