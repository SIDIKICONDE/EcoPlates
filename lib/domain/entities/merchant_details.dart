import 'package:flutter/material.dart';
import 'merchant_types.dart';

/// Informations sur l'entreprise
class BusinessInfo {
  final String registrationNumber;
  final String vatNumber;
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

  BusinessInfo copyWith({
    String? registrationNumber,
    String? vatNumber,
    String? website,
    String? description,
    List<String>? specialties,
    OpeningHours? openingHours,
    List<String>? paymentMethods,
  }) {
    return BusinessInfo(
      registrationNumber: registrationNumber ?? this.registrationNumber,
      vatNumber: vatNumber ?? this.vatNumber,
      website: website ?? this.website,
      description: description ?? this.description,
      specialties: specialties ?? this.specialties,
      openingHours: openingHours ?? this.openingHours,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}

/// Horaires d'ouverture
class OpeningHours {
  final Map<DayOfWeek, DayHours> schedule;
  final List<Holiday> holidays;

  const OpeningHours({
    required this.schedule,
    this.holidays = const [],
  });

  OpeningHours copyWith({
    Map<DayOfWeek, DayHours>? schedule,
    List<Holiday>? holidays,
  }) {
    return OpeningHours(
      schedule: schedule ?? this.schedule,
      holidays: holidays ?? this.holidays,
    );
  }
}

/// Horaires pour une journée
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

  DayHours copyWith({
    bool? isOpen,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    TimeOfDay? breakStart,
    TimeOfDay? breakEnd,
  }) {
    return DayHours(
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
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

  Holiday copyWith({
    DateTime? date,
    String? name,
    bool? isClosed,
  }) {
    return Holiday(
      date: date ?? this.date,
      name: name ?? this.name,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}

/// Adresse physique
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

  Address copyWith({
    String? street,
    String? city,
    String? postalCode,
    String? country,
    double? latitude,
    double? longitude,
    String? additionalInfo,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  String get fullAddress => '$street, $postalCode $city, $country';
}

/// Paramètres du merchant
class MerchantSettings {
  final int maxActiveOffers;
  final int maxDailyOffers;
  final bool autoAcceptReservations;
  final bool notifyOnReservation;
  final bool notifyOnLowStock;
  final int lowStockThreshold;
  final List<NotificationChannel> enabledChannels;
  final bool requireConfirmationCode;
  final int defaultPickupDuration;

  const MerchantSettings({
    this.maxActiveOffers = 10,
    this.maxDailyOffers = 20,
    this.autoAcceptReservations = true,
    this.notifyOnReservation = true,
    this.notifyOnLowStock = true,
    this.lowStockThreshold = 5,
    this.enabledChannels = const [
      NotificationChannel.push,
      NotificationChannel.email
    ],
    this.requireConfirmationCode = true,
    this.defaultPickupDuration = 30,
  });

  MerchantSettings copyWith({
    int? maxActiveOffers,
    int? maxDailyOffers,
    bool? autoAcceptReservations,
    bool? notifyOnReservation,
    bool? notifyOnLowStock,
    int? lowStockThreshold,
    List<NotificationChannel>? enabledChannels,
    bool? requireConfirmationCode,
    int? defaultPickupDuration,
  }) {
    return MerchantSettings(
      maxActiveOffers: maxActiveOffers ?? this.maxActiveOffers,
      maxDailyOffers: maxDailyOffers ?? this.maxDailyOffers,
      autoAcceptReservations:
          autoAcceptReservations ?? this.autoAcceptReservations,
      notifyOnReservation: notifyOnReservation ?? this.notifyOnReservation,
      notifyOnLowStock: notifyOnLowStock ?? this.notifyOnLowStock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      enabledChannels: enabledChannels ?? this.enabledChannels,
      requireConfirmationCode:
          requireConfirmationCode ?? this.requireConfirmationCode,
      defaultPickupDuration:
          defaultPickupDuration ?? this.defaultPickupDuration,
    );
  }
}

/// Statistiques du merchant
class MerchantStats {
  final int totalOffers;
  final int activeOffers;
  final int totalReservations;
  final int completedReservations;
  final double totalRevenue;
  final double totalCo2Saved;
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

  MerchantStats copyWith({
    int? totalOffers,
    int? activeOffers,
    int? totalReservations,
    int? completedReservations,
    double? totalRevenue,
    double? totalCo2Saved,
    int? totalMealsSaved,
    double? averageRating,
    Map<DateTime, DailyStats>? dailyStats,
  }) {
    return MerchantStats(
      totalOffers: totalOffers ?? this.totalOffers,
      activeOffers: activeOffers ?? this.activeOffers,
      totalReservations: totalReservations ?? this.totalReservations,
      completedReservations:
          completedReservations ?? this.completedReservations,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalCo2Saved: totalCo2Saved ?? this.totalCo2Saved,
      totalMealsSaved: totalMealsSaved ?? this.totalMealsSaved,
      averageRating: averageRating ?? this.averageRating,
      dailyStats: dailyStats ?? this.dailyStats,
    );
  }

  /// Taux de conversion des réservations
  double get conversionRate {
    if (totalReservations == 0) return 0;
    return (completedReservations / totalReservations) * 100;
  }

  /// Revenu moyen par transaction
  double get averageTransactionValue {
    if (completedReservations == 0) return 0;
    return totalRevenue / completedReservations;
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

  DailyStats copyWith({
    DateTime? date,
    int? offersCreated,
    int? reservations,
    int? completed,
    double? revenue,
    double? co2Saved,
  }) {
    return DailyStats(
      date: date ?? this.date,
      offersCreated: offersCreated ?? this.offersCreated,
      reservations: reservations ?? this.reservations,
      completed: completed ?? this.completed,
      revenue: revenue ?? this.revenue,
      co2Saved: co2Saved ?? this.co2Saved,
    );
  }

  /// Taux de conversion du jour
  double get dailyConversionRate {
    if (reservations == 0) return 0;
    return (completed / reservations) * 100;
  }
}