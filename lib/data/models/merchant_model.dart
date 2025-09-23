import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/merchant.dart';

part 'merchant_model.g.dart';

/// Modèle de données pour Merchant avec sérialisation JSON
@JsonSerializable(explicitToJson: true)
class MerchantModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final MerchantType type;
  final MerchantStatus status;
  final BusinessInfoModel businessInfo;
  final AddressModel address;
  final List<String> teamMemberIds;
  final MerchantSettingsModel settings;
  final DateTime createdAt;
  final DateTime? verifiedAt;
  final MerchantStatsModel stats;
  final List<String> certifications;
  final double rating;
  final int totalReviews;

  const MerchantModel({
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

  /// Créer une instance depuis JSON
  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);

  /// Convertir en JSON
  Map<String, dynamic> toJson() => _$MerchantModelToJson(this);

  /// Créer depuis l'entité domaine
  factory MerchantModel.fromEntity(Merchant merchant) {
    return MerchantModel(
      id: merchant.id,
      name: merchant.name,
      email: merchant.email,
      phoneNumber: merchant.phoneNumber,
      type: merchant.type,
      status: merchant.status,
      businessInfo: BusinessInfoModel.fromEntity(merchant.businessInfo),
      address: AddressModel.fromEntity(merchant.address),
      teamMemberIds: merchant.teamMemberIds,
      settings: MerchantSettingsModel.fromEntity(merchant.settings),
      createdAt: merchant.createdAt,
      verifiedAt: merchant.verifiedAt,
      stats: MerchantStatsModel.fromEntity(merchant.stats),
      certifications: merchant.certifications,
      rating: merchant.rating,
      totalReviews: merchant.totalReviews,
    );
  }

  /// Convertir vers l'entité domaine
  Merchant toEntity() {
    return Merchant(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      type: type,
      status: status,
      businessInfo: BusinessInfo(
        registrationNumber: businessInfo.registrationNumber,
        vatNumber: businessInfo.vatNumber,
        website: businessInfo.website,
        description: businessInfo.description,
        specialties: businessInfo.specialties,
        openingHours: OpeningHours(
          schedule: businessInfo.openingHours.schedule.map((key, value) =>
            MapEntry(DayOfWeek.values.firstWhere((d) => d.name == key), DayHours(
              isOpen: value.isOpen,
              openTime: value.openTime != null
                  ? TimeOfDay(hour: int.parse(value.openTime!.split(':')[0]), minute: int.parse(value.openTime!.split(':')[1]))
                  : null,
              closeTime: value.closeTime != null
                  ? TimeOfDay(hour: int.parse(value.closeTime!.split(':')[0]), minute: int.parse(value.closeTime!.split(':')[1]))
                  : null,
              breakStart: value.breakStart != null
                  ? TimeOfDay(hour: int.parse(value.breakStart!.split(':')[0]), minute: int.parse(value.breakStart!.split(':')[1]))
                  : null,
              breakEnd: value.breakEnd != null
                  ? TimeOfDay(hour: int.parse(value.breakEnd!.split(':')[0]), minute: int.parse(value.breakEnd!.split(':')[1]))
                  : null,
            ))
          ),
          holidays: businessInfo.openingHours.holidays.map((holiday) =>
            Holiday(
              date: holiday.date,
              name: holiday.name,
              isClosed: holiday.isClosed,
            )
          ).toList(),
        ),
        paymentMethods: businessInfo.paymentMethods,
      ),
      address: Address(
        street: address.street,
        city: address.city,
        postalCode: address.postalCode,
        country: address.country,
        latitude: address.latitude,
        longitude: address.longitude,
        additionalInfo: address.additionalInfo,
      ),
      teamMemberIds: teamMemberIds,
      settings: MerchantSettings(
        maxActiveOffers: settings.maxActiveOffers,
        maxDailyOffers: settings.maxDailyOffers,
        autoAcceptReservations: settings.autoAcceptReservations,
        notifyOnReservation: settings.notifyOnReservation,
        notifyOnLowStock: settings.notifyOnLowStock,
        lowStockThreshold: settings.lowStockThreshold,
        enabledChannels: settings.enabledChannels.map((channelName) => NotificationChannel.values.firstWhere((c) => c.name == channelName)).toList(),
        requireConfirmationCode: settings.requireConfirmationCode,
        defaultPickupDuration: settings.defaultPickupDuration,
      ),
      createdAt: createdAt,
      verifiedAt: verifiedAt,
      stats: MerchantStats(
        totalOffers: stats.totalOffers,
        activeOffers: stats.activeOffers,
        totalReservations: stats.totalReservations,
        completedReservations: stats.completedReservations,
        totalRevenue: stats.totalRevenue,
        totalCo2Saved: stats.totalCo2Saved,
        totalMealsSaved: stats.totalMealsSaved,
        averageRating: stats.averageRating,
        dailyStats: stats.dailyStats.map((key, value) =>
          MapEntry(key, DailyStats(
            date: value.date,
            offersCreated: value.offersCreated,
            reservations: value.reservations,
            completed: value.completed,
            revenue: value.revenue,
            co2Saved: value.co2Saved,
          ))
        ).cast<DateTime, DailyStats>(),
      ),
      certifications: certifications,
      rating: rating,
      totalReviews: totalReviews,
    );
  }
}

/// Modèle pour BusinessInfo avec sérialisation JSON
@JsonSerializable()
class BusinessInfoModel {
  final String registrationNumber;
  final String vatNumber;
  final String? website;
  final String? description;
  final List<String> specialties;
  final OpeningHoursModel openingHours;
  final List<String> paymentMethods;

  const BusinessInfoModel({
    required this.registrationNumber,
    required this.vatNumber,
    this.website,
    this.description,
    this.specialties = const [],
    required this.openingHours,
    this.paymentMethods = const [],
  });

  factory BusinessInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessInfoModelToJson(this);

  factory BusinessInfoModel.fromEntity(BusinessInfo businessInfo) {
    return BusinessInfoModel(
      registrationNumber: businessInfo.registrationNumber,
      vatNumber: businessInfo.vatNumber,
      website: businessInfo.website,
      description: businessInfo.description,
      specialties: businessInfo.specialties,
      openingHours: OpeningHoursModel.fromEntity(businessInfo.openingHours),
      paymentMethods: businessInfo.paymentMethods,
    );
  }
}

/// Modèle pour OpeningHours avec sérialisation JSON
@JsonSerializable()
class OpeningHoursModel {
  final Map<String, DayHoursModel> schedule;
  final List<HolidayModel> holidays;

  const OpeningHoursModel({
    required this.schedule,
    this.holidays = const [],
  });

  factory OpeningHoursModel.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursModelToJson(this);

  factory OpeningHoursModel.fromEntity(OpeningHours openingHours) {
    return OpeningHoursModel(
      schedule: openingHours.schedule.map((key, value) =>
        MapEntry(key.name, DayHoursModel.fromEntity(value))
      ),
      holidays: openingHours.holidays.map((holiday) =>
        HolidayModel.fromEntity(holiday)
      ).toList(),
    );
  }
}

/// Modèle pour DayHours avec sérialisation JSON
@JsonSerializable()
class DayHoursModel {
  final bool isOpen;
  final String? openTime;
  final String? closeTime;
  final String? breakStart;
  final String? breakEnd;

  const DayHoursModel({
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.breakStart,
    this.breakEnd,
  });

  factory DayHoursModel.fromJson(Map<String, dynamic> json) =>
      _$DayHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$DayHoursModelToJson(this);

  factory DayHoursModel.fromEntity(DayHours dayHours) {
    return DayHoursModel(
      isOpen: dayHours.isOpen,
      openTime: dayHours.openTime != null
          ? '${dayHours.openTime!.hour.toString().padLeft(2, '0')}:${dayHours.openTime!.minute.toString().padLeft(2, '0')}'
          : null,
      closeTime: dayHours.closeTime != null
          ? '${dayHours.closeTime!.hour.toString().padLeft(2, '0')}:${dayHours.closeTime!.minute.toString().padLeft(2, '0')}'
          : null,
      breakStart: dayHours.breakStart != null
          ? '${dayHours.breakStart!.hour.toString().padLeft(2, '0')}:${dayHours.breakStart!.minute.toString().padLeft(2, '0')}'
          : null,
      breakEnd: dayHours.breakEnd != null
          ? '${dayHours.breakEnd!.hour.toString().padLeft(2, '0')}:${dayHours.breakEnd!.minute.toString().padLeft(2, '0')}'
          : null,
    );
  }
}

/// Modèle pour Holiday avec sérialisation JSON
@JsonSerializable()
class HolidayModel {
  final DateTime date;
  final String name;
  final bool isClosed;

  const HolidayModel({
    required this.date,
    required this.name,
    required this.isClosed,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) =>
      _$HolidayModelFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayModelToJson(this);

  factory HolidayModel.fromEntity(Holiday holiday) {
    return HolidayModel(
      date: holiday.date,
      name: holiday.name,
      isClosed: holiday.isClosed,
    );
  }
}

/// Modèle pour Address avec sérialisation JSON
@JsonSerializable()
class AddressModel {
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;
  final String? additionalInfo;

  const AddressModel({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.additionalInfo,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      street: address.street,
      city: address.city,
      postalCode: address.postalCode,
      country: address.country,
      latitude: address.latitude,
      longitude: address.longitude,
      additionalInfo: address.additionalInfo,
    );
  }
}

/// Modèle pour MerchantSettings avec sérialisation JSON
@JsonSerializable()
class MerchantSettingsModel {
  final int maxActiveOffers;
  final int maxDailyOffers;
  final bool autoAcceptReservations;
  final bool notifyOnReservation;
  final bool notifyOnLowStock;
  final int lowStockThreshold;
  final List<String> enabledChannels;
  final bool requireConfirmationCode;
  final int defaultPickupDuration;

  const MerchantSettingsModel({
    this.maxActiveOffers = 10,
    this.maxDailyOffers = 20,
    this.autoAcceptReservations = true,
    this.notifyOnReservation = true,
    this.notifyOnLowStock = true,
    this.lowStockThreshold = 5,
    this.enabledChannels = const ['push', 'email'],
    this.requireConfirmationCode = true,
    this.defaultPickupDuration = 30,
  });

  factory MerchantSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MerchantSettingsModelToJson(this);

  factory MerchantSettingsModel.fromEntity(MerchantSettings settings) {
    return MerchantSettingsModel(
      maxActiveOffers: settings.maxActiveOffers,
      maxDailyOffers: settings.maxDailyOffers,
      autoAcceptReservations: settings.autoAcceptReservations,
      notifyOnReservation: settings.notifyOnReservation,
      notifyOnLowStock: settings.notifyOnLowStock,
      lowStockThreshold: settings.lowStockThreshold,
        enabledChannels: settings.enabledChannels.map((channel) => channel.name).toList(),
      requireConfirmationCode: settings.requireConfirmationCode,
      defaultPickupDuration: settings.defaultPickupDuration,
    );
  }
}

/// Modèle pour MerchantStats avec sérialisation JSON
@JsonSerializable()
class MerchantStatsModel {
  final int totalOffers;
  final int activeOffers;
  final int totalReservations;
  final int completedReservations;
  final double totalRevenue;
  final double totalCo2Saved;
  final int totalMealsSaved;
  final double averageRating;
  final Map<String, DailyStatsModel> dailyStats;

  const MerchantStatsModel({
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

  factory MerchantStatsModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MerchantStatsModelToJson(this);

  factory MerchantStatsModel.fromEntity(MerchantStats stats) {
    return MerchantStatsModel(
      totalOffers: stats.totalOffers,
      activeOffers: stats.activeOffers,
      totalReservations: stats.totalReservations,
      completedReservations: stats.completedReservations,
      totalRevenue: stats.totalRevenue,
      totalCo2Saved: stats.totalCo2Saved,
      totalMealsSaved: stats.totalMealsSaved,
      averageRating: stats.averageRating,
      dailyStats: stats.dailyStats.map((key, value) =>
        MapEntry(key.toIso8601String().split('T')[0], DailyStatsModel.fromEntity(value))
      ),
    );
  }
}

/// Modèle pour DailyStats avec sérialisation JSON
@JsonSerializable()
class DailyStatsModel {
  final DateTime date;
  final int offersCreated;
  final int reservations;
  final int completed;
  final double revenue;
  final double co2Saved;

  const DailyStatsModel({
    required this.date,
    required this.offersCreated,
    required this.reservations,
    required this.completed,
    required this.revenue,
    required this.co2Saved,
  });

  factory DailyStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatsModelToJson(this);

  factory DailyStatsModel.fromEntity(DailyStats stats) {
    return DailyStatsModel(
      date: stats.date,
      offersCreated: stats.offersCreated,
      reservations: stats.reservations,
      completed: stats.completed,
      revenue: stats.revenue,
      co2Saved: stats.co2Saved,
    );
  }
}
