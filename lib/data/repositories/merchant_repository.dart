import 'package:dartz/dartz.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/merchant_details.dart';
import '../../core/error/failures.dart';

/// Interface abstraite pour le repository des commerçants
abstract class MerchantRepository {
  /// Récupérer un commerçant par son ID
  Future<Either<Failure, Merchant>> getMerchant(String merchantId);

  /// Récupérer le commerçant actuellement connecté
  Future<Either<Failure, Merchant>> getCurrentMerchant();

  /// Mettre à jour les informations d'un commerçant
  Future<Either<Failure, Merchant>> updateMerchant({
    required String merchantId,
    required UpdateMerchantRequest request,
  });

  /// Mettre à jour les paramètres d'un commerçant
  Future<Either<Failure, Merchant>> updateMerchantSettings({
    required String merchantId,
    required MerchantSettings settings,
  });

  /// Mettre à jour les horaires d'ouverture
  Future<Either<Failure, Merchant>> updateOpeningHours({
    required String merchantId,
    required OpeningHours openingHours,
  });

  /// Récupérer les statistiques d'un commerçant
  Future<Either<Failure, MerchantStats>> getMerchantStats(String merchantId);

  /// Ajouter un membre à l'équipe
  Future<Either<Failure, void>> addTeamMember({
    required String merchantId,
    required String email,
    required TeamRole role,
  });

  /// Retirer un membre de l'équipe
  Future<Either<Failure, void>> removeTeamMember({
    required String merchantId,
    required String memberId,
  });

  /// Récupérer les membres de l'équipe
  Future<Either<Failure, List<TeamMember>>> getTeamMembers(String merchantId);

  /// Vérifier si un commerçant peut créer une offre
  Future<Either<Failure, bool>> canCreateOffer(String merchantId);

  /// Mettre en cache un commerçant
  Future<void> cacheMerchant(Merchant merchant);

  /// Récupérer un commerçant depuis le cache
  Future<Either<Failure, Merchant>> getCachedMerchant(String merchantId);

  /// Vider le cache
  Future<void> clearCache();
}

/// Requête de mise à jour d'un commerçant
class UpdateMerchantRequest {
  final String? name;
  final String? phoneNumber;
  final String? description;
  final Address? address;
  final List<String>? specialties;
  final String? website;
  final List<String>? paymentMethods;

  const UpdateMerchantRequest({
    this.name,
    this.phoneNumber,
    this.description,
    this.address,
    this.specialties,
    this.website,
    this.paymentMethods,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (description != null) data['description'] = description;
    if (address != null) {
      data['address'] = {
        'street': address!.street,
        'city': address!.city,
        'postal_code': address!.postalCode,
        'country': address!.country,
        'latitude': address!.latitude,
        'longitude': address!.longitude,
        'additional_info': address!.additionalInfo,
      };
    }
    if (specialties != null) data['specialties'] = specialties;
    if (website != null) data['website'] = website;
    if (paymentMethods != null) data['payment_methods'] = paymentMethods;

    return data;
  }
}

/// Rôle d'un membre de l'équipe
enum TeamRole {
  owner, // Propriétaire
  manager, // Gérant
  employee, // Employé
  cashier, // Caissier
}

/// Membre de l'équipe
class TeamMember {
  final String id;
  final String email;
  final String name;
  final TeamRole role;
  final DateTime joinedAt;
  final bool isActive;
  final String? phoneNumber;
  final String? profileImageUrl;

  const TeamMember({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.joinedAt,
    required this.isActive,
    this.phoneNumber,
    this.profileImageUrl,
  });
}

/// Extension pour les rôles
extension TeamRoleExtension on TeamRole {
  String get displayName {
    switch (this) {
      case TeamRole.owner:
        return 'Propriétaire';
      case TeamRole.manager:
        return 'Gérant';
      case TeamRole.employee:
        return 'Employé';
      case TeamRole.cashier:
        return 'Caissier';
    }
  }

  /// Permissions du rôle
  Set<MerchantPermission> get permissions {
    switch (this) {
      case TeamRole.owner:
        return MerchantPermission.values.toSet();
      case TeamRole.manager:
        return {
          MerchantPermission.viewDashboard,
          MerchantPermission.manageOffers,
          MerchantPermission.viewReservations,
          MerchantPermission.manageInventory,
          MerchantPermission.viewAnalytics,
          MerchantPermission.manageTeam,
        };
      case TeamRole.employee:
        return {
          MerchantPermission.viewDashboard,
          MerchantPermission.manageOffers,
          MerchantPermission.viewReservations,
          MerchantPermission.manageInventory,
        };
      case TeamRole.cashier:
        return {
          MerchantPermission.viewDashboard,
          MerchantPermission.viewReservations,
          MerchantPermission.scanReservations,
        };
    }
  }
}

/// Permissions des commerçants
enum MerchantPermission {
  viewDashboard,
  manageOffers,
  viewReservations,
  scanReservations,
  manageInventory,
  viewAnalytics,
  exportData,
  manageTeam,
  manageSettings,
  manageBilling,
}
