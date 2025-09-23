/// Entité représentant une association caritative dans le système EcoPlates
class Association {
  final String id;
  final String name;
  final String siret; // Numéro SIRET de l'association
  final String rna; // RNA (Répertoire National des Associations)
  final AssociationType type;
  final AssociationStatus status;
  final DateTime createdAt;
  final DateTime? validatedAt;
  final AssociationDetails details;
  final AssociationStats stats;
  final List<String> volunteerUserIds;
  final List<String> beneficiaryZones; // Zones d'intervention

  const Association({
    required this.id,
    required this.name,
    required this.siret,
    required this.rna,
    required this.type,
    required this.status,
    required this.createdAt,
    this.validatedAt,
    required this.details,
    required this.stats,
    this.volunteerUserIds = const [],
    this.beneficiaryZones = const [],
  });

  /// Vérifie si l'association est validée et active
  bool get isActive => status == AssociationStatus.validated;

  /// Vérifie si l'association peut collecter des offres
  bool get canCollectOffers => isActive && details.hasCollectAgreement;

  /// Calcule l'impact social total
  int get totalImpact => stats.mealsDistributed + stats.peopleHelped;
}

/// Types d'associations caritatives
enum AssociationType {
  foodBank, // Banque alimentaire
  socialRestaurant, // Restaurant social/solidaire
  charity, // Association caritative générale
  studentAssociation, // Association étudiante
  religiousOrg, // Organisation religieuse
  redCross, // Croix-Rouge et similaires
  other, // Autre type
}

/// Statut de validation de l'association
enum AssociationStatus {
  pending, // En attente de validation
  validated, // Validée et active
  suspended, // Suspendue temporairement
  rejected, // Rejetée
  expired, // Validation expirée
}

/// Détails de l'association
class AssociationDetails {
  final String description;
  final String address;
  final String city;
  final String postalCode;
  final String phone;
  final String email;
  final String website;
  final String presidentName;
  final int yearFounded;
  final int activeVolunteers;
  final int beneficiariesCount; // Nombre de bénéficiaires
  final bool hasCollectAgreement; // Agrément collecte alimentaire
  final bool hasColdChain; // Capacité chaîne du froid
  final bool hasVehicles; // Véhicules de collecte
  final List<String> certifications; // Agréments et certifications
  final OpeningHours collectHours; // Horaires de collecte

  const AssociationDetails({
    required this.description,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.phone,
    required this.email,
    required this.website,
    required this.presidentName,
    required this.yearFounded,
    required this.activeVolunteers,
    required this.beneficiariesCount,
    required this.hasCollectAgreement,
    required this.hasColdChain,
    required this.hasVehicles,
    this.certifications = const [],
    required this.collectHours,
  });
}

/// Statistiques d'impact social
class AssociationStats {
  final int mealsDistributed; // Nombre de repas distribués
  final int peopleHelped; // Nombre de personnes aidées
  final double foodSaved; // Tonnes de nourriture sauvées
  final double co2Saved; // Tonnes de CO2 évitées
  final int platesUsed; // Nombre d'assiettes EcoPlates utilisées
  final int volunteersHours; // Heures de bénévolat
  final DateTime lastActivityAt;

  const AssociationStats({
    this.mealsDistributed = 0,
    this.peopleHelped = 0,
    this.foodSaved = 0,
    this.co2Saved = 0,
    this.platesUsed = 0,
    this.volunteersHours = 0,
    required this.lastActivityAt,
  });

  /// Impact score basé sur les activités
  double get impactScore {
    return (mealsDistributed * 0.1) +
        (peopleHelped * 0.2) +
        (foodSaved * 100) +
        (co2Saved * 200) +
        (platesUsed * 0.05);
  }
}

/// Horaires d'ouverture pour collecte
class OpeningHours {
  final Map<DayOfWeek, TimeSlot> schedule;
  final String? specialNotes;

  const OpeningHours({required this.schedule, this.specialNotes});

  /// Vérifie si ouvert maintenant
  bool get isOpenNow {
    final now = DateTime.now();
    final today = DayOfWeek.values[now.weekday - 1];
    final slot = schedule[today];

    if (slot == null || !slot.isOpen) return false;

    final currentMinutes = now.hour * 60 + now.minute;
    return currentMinutes >= slot.openTime && currentMinutes <= slot.closeTime;
  }
}

/// Jours de la semaine
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/// Créneau horaire
class TimeSlot {
  final bool isOpen;
  final int openTime; // Minutes depuis minuit (ex: 540 = 9h00)
  final int closeTime; // Minutes depuis minuit (ex: 1080 = 18h00)

  const TimeSlot({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  /// Convertit les minutes en format HH:MM
  String get openTimeFormatted => _minutesToTime(openTime);
  String get closeTimeFormatted => _minutesToTime(closeTime);

  String _minutesToTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }
}

/// Collecte groupée pour associations
class GroupCollection {
  final String id;
  final String associationId;
  final List<String> offerIds;
  final DateTime scheduledAt;
  final String? volunteerAssignedId;
  final GroupCollectionStatus status;
  final String? notes;

  const GroupCollection({
    required this.id,
    required this.associationId,
    required this.offerIds,
    required this.scheduledAt,
    this.volunteerAssignedId,
    required this.status,
    this.notes,
  });
}

/// Statut d'une collecte groupée
enum GroupCollectionStatus {
  scheduled, // Programmée
  inProgress, // En cours
  completed, // Terminée
  cancelled, // Annulée
}
