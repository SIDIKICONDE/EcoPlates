/// Entité représentant un utilisateur du système EcoPlates
class User {
  final String id;
  final String email;
  final String name;
  final UserType type;
  final DateTime createdAt;
  final UserProfile profile;
  final bool isEmailVerified;
  final bool isActive;
  
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
  
  /// Vérifie si l'utilisateur est un commerçant
  bool get isMerchant => type == UserType.merchant;
  
  /// Vérifie si l'utilisateur est un consommateur
  bool get isConsumer => type == UserType.consumer;
  
  /// Vérifie si l'utilisateur est un administrateur
  bool get isAdmin => type == UserType.admin;
  
  /// Vérifie si l'utilisateur est une association
  bool get isAssociation => type == UserType.association;
  
  /// Vérifie si l'utilisateur est un bénévole
  bool get isVolunteer => type == UserType.volunteer;
}

/// Types d'utilisateurs dans le système
enum UserType {
  consumer,    // Utilisateur final qui emprunte les assiettes
  merchant,    // Commerçant/Restaurant qui gère les assiettes
  admin,       // Administrateur du système
  staff,       // Personnel du commerçant
  association, // Association caritative
  volunteer,   // Bénévole d'association
}

/// Profil utilisateur avec informations spécifiques selon le type
abstract class UserProfile {
  const UserProfile();
}

/// Profil pour les consommateurs
class ConsumerProfile extends UserProfile {
  final int ecoScore;
  final int totalPlatesUsed;
  final double co2Saved; // en kg
  final DateTime? lastPlateUsedAt;
  final List<String> favoriteLocations;
  final ConsumerTier tier;
  
  const ConsumerProfile({
    this.ecoScore = 0,
    this.totalPlatesUsed = 0,
    this.co2Saved = 0,
    this.lastPlateUsedAt,
    this.favoriteLocations = const [],
    this.tier = ConsumerTier.bronze,
  });
}

/// Niveaux de fidélité pour les consommateurs
enum ConsumerTier {
  bronze,    // 0-99 points
  silver,    // 100-499 points
  gold,      // 500-999 points
  platinum,  // 1000+ points
}

/// Profil pour les commerçants
class MerchantProfile extends UserProfile {
  final String businessName;
  final String businessAddress;
  final String businessPhone;
  final String siret; // Numéro SIRET pour les entreprises françaises
  final int totalPlatesOwned;
  final int platesInCirculation;
  final MerchantPlan subscriptionPlan;
  final DateTime? subscriptionExpiresAt;
  final List<String> staffUserIds;
  
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
}

/// Plans d'abonnement pour les commerçants
enum MerchantPlan {
  starter,     // Jusqu'à 100 assiettes
  business,    // Jusqu'à 500 assiettes
  enterprise,  // Illimité
}

/// Profil pour le personnel des commerçants
class StaffProfile extends UserProfile {
  final String merchantId; // ID du commerçant employeur
  final String position;
  final StaffPermissions permissions;
  
  const StaffProfile({
    required this.merchantId,
    required this.position,
    required this.permissions,
  });
}

/// Permissions pour le personnel
class StaffPermissions {
  final bool canScanPlates;
  final bool canManageInventory;
  final bool canViewReports;
  final bool canManageStaff;
  
  const StaffPermissions({
    this.canScanPlates = true,
    this.canManageInventory = false,
    this.canViewReports = false,
    this.canManageStaff = false,
  });
  
  /// Permissions par défaut pour un caissier
  static const StaffPermissions cashier = StaffPermissions(
    canScanPlates: true,
    canManageInventory: false,
    canViewReports: false,
    canManageStaff: false,
  );
  
  /// Permissions par défaut pour un manager
  static const StaffPermissions manager = StaffPermissions(
    canScanPlates: true,
    canManageInventory: true,
    canViewReports: true,
    canManageStaff: true,
  );
}

/// Profil pour les administrateurs
class AdminProfile extends UserProfile {
  final String department;
  final AdminRole role;
  
  const AdminProfile({
    required this.department,
    required this.role,
  });
}

/// Rôles administrateurs
enum AdminRole {
  superAdmin,    // Accès total
  support,       // Support client
  operations,    // Gestion opérationnelle
  finance,       // Gestion financière
}

/// Profil pour les associations caritatives
class AssociationProfile extends UserProfile {
  final String associationId; // ID de l'association liée
  final String associationName;
  final String role; // Président, Trésorier, Secrétaire, etc.
  final AssociationPermissions permissions;
  final int collectionsManaged;
  final int mealsDistributed;
  final DateTime? memberSince;
  
  const AssociationProfile({
    required this.associationId,
    required this.associationName,
    required this.role,
    required this.permissions,
    this.collectionsManaged = 0,
    this.mealsDistributed = 0,
    this.memberSince,
  });
}

/// Permissions pour les membres d'association
class AssociationPermissions {
  final bool canManageVolunteers;
  final bool canScheduleCollections;
  final bool canAccessReports;
  final bool canValidateDistributions;
  final bool canManageAssociation;
  
  const AssociationPermissions({
    this.canManageVolunteers = false,
    this.canScheduleCollections = true,
    this.canAccessReports = true,
    this.canValidateDistributions = true,
    this.canManageAssociation = false,
  });
  
  /// Permissions par défaut pour un responsable
  static const AssociationPermissions manager = AssociationPermissions(
    canManageVolunteers: true,
    canScheduleCollections: true,
    canAccessReports: true,
    canValidateDistributions: true,
    canManageAssociation: true,
  );
  
  /// Permissions par défaut pour un bénévole
  static const AssociationPermissions volunteer = AssociationPermissions(
    canManageVolunteers: false,
    canScheduleCollections: false,
    canAccessReports: false,
    canValidateDistributions: false,
    canManageAssociation: false,
  );
}

/// Profil pour les bénévoles
class VolunteerProfile extends UserProfile {
  final String associationId; // Association d'appartenance
  final String associationName;
  final DateTime volunteerSince;
  final int hoursContributed;
  final int collectionsParticipated;
  final List<String> availableDays; // Jours de disponibilité
  final bool hasVehicle;
  final bool hasColdChainCertification;
  final VolunteerStatus status;
  
  const VolunteerProfile({
    required this.associationId,
    required this.associationName,
    required this.volunteerSince,
    this.hoursContributed = 0,
    this.collectionsParticipated = 0,
    this.availableDays = const [],
    this.hasVehicle = false,
    this.hasColdChainCertification = false,
    this.status = VolunteerStatus.active,
  });
}

/// Statut d'un bénévole
enum VolunteerStatus {
  active,      // Actif et disponible
  inactive,    // Temporairement indisponible
  onLeave,     // En congé
  retired,     // Retraité du bénévolat
}
