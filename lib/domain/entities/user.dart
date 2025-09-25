/// Entité représentant un utilisateur du système EcoPlates
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.profile,
    this.isEmailVerified = false,
    this.isActive = true,
  });
  final String id;
  final String email;
  final String name;
  final UserType type;
  final DateTime createdAt;
  final UserProfile profile;
  final bool isEmailVerified;
  final bool isActive;

  /// Vérifie si l'utilisateur est un commerçant
  bool get isMerchant => type == UserType.merchant;

  /// Vérifie si l'utilisateur est un consommateur
  bool get isConsumer => type == UserType.consumer;

  /// Vérifie si l'utilisateur est un administrateur
  bool get isAdmin => type == UserType.admin;
}

/// Types d'utilisateurs dans le système
enum UserType {
  consumer, // Utilisateur final qui emprunte les assiettes
  merchant, // Commerçant/Restaurant qui gère les assiettes
  admin, // Administrateur du système
  staff, // Personnel du commerçant
}

/// Profil utilisateur avec informations spécifiques selon le type
abstract class UserProfile {
  const UserProfile();
}

/// Profil pour les consommateurs
class ConsumerProfile extends UserProfile {
  const ConsumerProfile({
    this.ecoScore = 0,
    this.totalPlatesUsed = 0,
    this.co2Saved = 0,
    this.lastPlateUsedAt,
    this.favoriteLocations = const [],
    this.tier = ConsumerTier.bronze,
  });
  final int ecoScore;
  final int totalPlatesUsed;
  final double co2Saved; // en kg
  final DateTime? lastPlateUsedAt;
  final List<String> favoriteLocations;
  final ConsumerTier tier;
}

/// Niveaux de fidélité pour les consommateurs
enum ConsumerTier {
  bronze, // 0-99 points
  silver, // 100-499 points
  gold, // 500-999 points
  platinum, // 1000+ points
}

/// Profil pour les commerçants
class MerchantProfile extends UserProfile {
  const MerchantProfile({
    required this.businessName,
    required this.businessAddress,
    required this.businessPhone,
    required this.siret,
    this.totalPlatesOwned = 0,
    this.platesInCirculation = 0,
    this.subscriptionPlan = MerchantPlan.starter,
    this.subscriptionExpiresAt,
    this.staffUserIds = const [],
  });
  final String businessName;
  final String businessAddress;
  final String businessPhone;
  final String siret; // Numéro SIRET pour les entreprises françaises
  final int totalPlatesOwned;
  final int platesInCirculation;
  final MerchantPlan subscriptionPlan;
  final DateTime? subscriptionExpiresAt;
  final List<String> staffUserIds;
}

/// Plans d'abonnement pour les commerçants
enum MerchantPlan {
  starter, // Jusqu'à 100 assiettes
  business, // Jusqu'à 500 assiettes
  enterprise, // Illimité
}

/// Profil pour le personnel des commerçants
class StaffProfile extends UserProfile {
  const StaffProfile({
    required this.merchantId,
    required this.position,
    required this.permissions,
  });
  final String merchantId; // ID du commerçant employeur
  final String position;
  final StaffPermissions permissions;
}

/// Permissions pour le personnel
class StaffPermissions {
  const StaffPermissions({
    this.canScanPlates = true,
    this.canManageInventory = false,
    this.canViewReports = false,
    this.canManageStaff = false,
  });
  final bool canScanPlates;
  final bool canManageInventory;
  final bool canViewReports;
  final bool canManageStaff;

  /// Permissions par défaut pour un caissier
  static const StaffPermissions cashier = StaffPermissions();

  /// Permissions par défaut pour un manager
  static const StaffPermissions manager = StaffPermissions(
    canManageInventory: true,
    canViewReports: true,
    canManageStaff: true,
  );
}

/// Profil pour les administrateurs
class AdminProfile extends UserProfile {
  const AdminProfile({required this.department, required this.role});
  final String department;
  final AdminRole role;
}

/// Rôles administrateurs
enum AdminRole {
  superAdmin, // Accès total
  support, // Support client
  operations, // Gestion opérationnelle
  finance, // Gestion financière
}
