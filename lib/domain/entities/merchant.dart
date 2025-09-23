/// Entité représentant un commerçant/commerce dans EcoPlates
class Merchant {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final MerchantType type;
  final MerchantStatus status;
  final BusinessInfo businessInfo;
  final Address address;
  final List<String> teamMemberIds;
  final MerchantSettings settings;
  final DateTime createdAt;
  final DateTime? verifiedAt;
  final MerchantStats stats;
  final List<String> certifications;
  final double rating;
  final int totalReviews;

  const Merchant({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.type,
    required this.status,
    required this.businessInfo,
    required this.address,
    this.teamMemberIds = const [],
    required this.settings,
    required this.createdAt,
    this.verifiedAt,
    required this.stats,
    this.certifications = const [],
    this.rating = 0.0,
    this.totalReviews = 0,
  });

  /// Vérifie si le commerçant est vérifié
  bool get isVerified =>
      status == MerchantStatus.verified && verifiedAt != null;

  /// Calcule l'impact écologique total
  double get totalCo2Saved => stats.totalCo2Saved;

  /// Vérifie si le commerçant peut créer une nouvelle offre
  bool get canCreateOffer =>
      status == MerchantStatus.verified &&
      stats.activeOffers < settings.maxActiveOffers;
}

/// Types de commerces
enum MerchantType {
  restaurant,
  boulangerie,
  supermarche,
  epicerie,
  traiteur,
  cafeteria,
  hotel,
  autre,
}

/// Statut du commerçant
enum MerchantStatus {
  pending, // En attente de vérification
  verified, // Vérifié
  suspended, // Suspendu
  inactive, // Inactif
}

/// Informations business
class BusinessInfo {
  final String registrationNumber; // SIRET/SIREN
  final String vatNumber; // Numéro TVA
  final String? website;
  final String? description;
  final List<String> specialties;
  final OpeningHours openingHours;
  final List<String> paymentMethods;

  const BusinessInfo({
    required this.registrationNumber,
    required this.vatNumber,
    this.website,
    this.description,
    this.specialties = const [],
    required this.openingHours,
    this.paymentMethods = const [],
  });
}

/// Horaires d'ouverture
class OpeningHours {
  final Map<DayOfWeek, DayHours> schedule;
  final List<Holiday> holidays;

  const OpeningHours({required this.schedule, this.holidays = const []});

  /// Vérifie si ouvert maintenant
  bool get isOpenNow {
    final now = DateTime.now();
    final todaySchedule = schedule[DayOfWeek.fromDateTime(now)];
    if (todaySchedule == null || !todaySchedule.isOpen) return false;

    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
    return todaySchedule.isTimeInRange(currentTime);
  }
}

/// Jour de la semaine
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  static DayOfWeek fromDateTime(DateTime date) {
    return DayOfWeek.values[date.weekday - 1];
  }
}

/// Horaires pour un jour
class DayHours {
  final bool isOpen;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;
  final TimeOfDay? breakStart;
  final TimeOfDay? breakEnd;

  const DayHours({
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.breakStart,
    this.breakEnd,
  });

  bool isTimeInRange(TimeOfDay time) {
    if (!isOpen || openTime == null || closeTime == null) return false;

    final timeMinutes = time.hour * 60 + time.minute;
    final openMinutes = openTime!.hour * 60 + openTime!.minute;
    final closeMinutes = closeTime!.hour * 60 + closeTime!.minute;

    // Gérer la pause déjeuner
    if (breakStart != null && breakEnd != null) {
      final breakStartMinutes = breakStart!.hour * 60 + breakStart!.minute;
      final breakEndMinutes = breakEnd!.hour * 60 + breakEnd!.minute;

      if (timeMinutes >= breakStartMinutes && timeMinutes <= breakEndMinutes) {
        return false;
      }
    }

    return timeMinutes >= openMinutes && timeMinutes <= closeMinutes;
  }
}

/// Jour férié
class Holiday {
  final DateTime date;
  final String name;
  final bool isClosed;

  const Holiday({
    required this.date,
    required this.name,
    required this.isClosed,
  });
}

/// Représente une heure
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});
}

/// Adresse
class Address {
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;
  final String? additionalInfo;

  const Address({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.additionalInfo,
  });

  String get fullAddress => '$street, $postalCode $city';
}

/// Paramètres du commerçant
class MerchantSettings {
  final int maxActiveOffers;
  final int maxDailyOffers;
  final bool autoAcceptReservations;
  final bool notifyOnReservation;
  final bool notifyOnLowStock;
  final int lowStockThreshold;
  final List<NotificationChannel> enabledChannels;
  final bool requireConfirmationCode;
  final int defaultPickupDuration; // en minutes

  const MerchantSettings({
    this.maxActiveOffers = 10,
    this.maxDailyOffers = 20,
    this.autoAcceptReservations = true,
    this.notifyOnReservation = true,
    this.notifyOnLowStock = true,
    this.lowStockThreshold = 5,
    this.enabledChannels = const [
      NotificationChannel.push,
      NotificationChannel.email,
    ],
    this.requireConfirmationCode = true,
    this.defaultPickupDuration = 30,
  });
}

/// Canaux de notification
enum NotificationChannel { push, email, sms }

/// Statistiques du commerçant
class MerchantStats {
  final int totalOffers;
  final int activeOffers;
  final int totalReservations;
  final int completedReservations;
  final double totalRevenue;
  final double totalCo2Saved; // en kg
  final int totalMealsSaved;
  final double averageRating;
  final Map<DateTime, DailyStats> dailyStats;

  const MerchantStats({
    required this.totalOffers,
    required this.activeOffers,
    required this.totalReservations,
    required this.completedReservations,
    required this.totalRevenue,
    required this.totalCo2Saved,
    required this.totalMealsSaved,
    required this.averageRating,
    this.dailyStats = const {},
  });

  /// Taux de completion
  double get completionRate {
    if (totalReservations == 0) return 0;
    return (completedReservations / totalReservations) * 100;
  }
}

/// Statistiques journalières
class DailyStats {
  final DateTime date;
  final int offersCreated;
  final int reservations;
  final int completed;
  final double revenue;
  final double co2Saved;

  const DailyStats({
    required this.date,
    required this.offersCreated,
    required this.reservations,
    required this.completed,
    required this.revenue,
    required this.co2Saved,
  });
}
