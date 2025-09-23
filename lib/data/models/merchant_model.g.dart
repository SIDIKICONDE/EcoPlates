// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantModel _$MerchantModelFromJson(Map<String, dynamic> json) =>
    MerchantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      type: $enumDecode(_$MerchantTypeEnumMap, json['type']),
      status: $enumDecode(_$MerchantStatusEnumMap, json['status']),
      businessInfo: BusinessInfoModel.fromJson(
        json['businessInfo'] as Map<String, dynamic>,
      ),
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      teamMemberIds:
          (json['teamMemberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      settings: MerchantSettingsModel.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      stats: MerchantStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      certifications:
          (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MerchantModelToJson(MerchantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'type': _$MerchantTypeEnumMap[instance.type]!,
      'status': _$MerchantStatusEnumMap[instance.status]!,
      'businessInfo': instance.businessInfo.toJson(),
      'address': instance.address.toJson(),
      'teamMemberIds': instance.teamMemberIds,
      'settings': instance.settings.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'stats': instance.stats.toJson(),
      'certifications': instance.certifications,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
    };

const _$MerchantTypeEnumMap = {
  MerchantType.restaurant: 'restaurant',
  MerchantType.bakery: 'boulangerie',
  MerchantType.cafe: 'cafeteria',
  MerchantType.supermarket: 'supermarche',
  MerchantType.grocery: 'epicerie',
  MerchantType.hotel: 'hotel',
  MerchantType.butcher: 'traiteur',
  MerchantType.other: 'autre',
};

const _$MerchantStatusEnumMap = {
  MerchantStatus.pending: 'pending',
  MerchantStatus.active: 'verified',
  MerchantStatus.suspended: 'suspended',
  MerchantStatus.inactive: 'inactive',
};

BusinessInfoModel _$BusinessInfoModelFromJson(Map<String, dynamic> json) =>
    BusinessInfoModel(
      registrationNumber: json['registrationNumber'] as String,
      vatNumber: json['vatNumber'] as String,
      website: json['website'] as String?,
      description: json['description'] as String?,
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      openingHours: OpeningHoursModel.fromJson(
        json['openingHours'] as Map<String, dynamic>,
      ),
      paymentMethods:
          (json['paymentMethods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BusinessInfoModelToJson(BusinessInfoModel instance) =>
    <String, dynamic>{
      'registrationNumber': instance.registrationNumber,
      'vatNumber': instance.vatNumber,
      'website': instance.website,
      'description': instance.description,
      'specialties': instance.specialties,
      'openingHours': instance.openingHours,
      'paymentMethods': instance.paymentMethods,
    };

OpeningHoursModel _$OpeningHoursModelFromJson(Map<String, dynamic> json) =>
    OpeningHoursModel(
      schedule: (json['schedule'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, DayHoursModel.fromJson(e as Map<String, dynamic>)),
      ),
      holidays:
          (json['holidays'] as List<dynamic>?)
              ?.map((e) => HolidayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OpeningHoursModelToJson(OpeningHoursModel instance) =>
    <String, dynamic>{
      'schedule': instance.schedule,
      'holidays': instance.holidays,
    };

DayHoursModel _$DayHoursModelFromJson(Map<String, dynamic> json) =>
    DayHoursModel(
      isOpen: json['isOpen'] as bool,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      breakStart: json['breakStart'] as String?,
      breakEnd: json['breakEnd'] as String?,
    );

Map<String, dynamic> _$DayHoursModelToJson(DayHoursModel instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'breakStart': instance.breakStart,
      'breakEnd': instance.breakEnd,
    };

HolidayModel _$HolidayModelFromJson(Map<String, dynamic> json) => HolidayModel(
  date: DateTime.parse(json['date'] as String),
  name: json['name'] as String,
  isClosed: json['isClosed'] as bool,
);

Map<String, dynamic> _$HolidayModelToJson(HolidayModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'isClosed': instance.isClosed,
    };

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
  street: json['street'] as String,
  city: json['city'] as String,
  postalCode: json['postalCode'] as String,
  country: json['country'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  additionalInfo: json['additionalInfo'] as String?,
);

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'additionalInfo': instance.additionalInfo,
    };

MerchantSettingsModel _$MerchantSettingsModelFromJson(
  Map<String, dynamic> json,
) => MerchantSettingsModel(
  maxActiveOffers: (json['maxActiveOffers'] as num?)?.toInt() ?? 10,
  maxDailyOffers: (json['maxDailyOffers'] as num?)?.toInt() ?? 20,
  autoAcceptReservations: json['autoAcceptReservations'] as bool? ?? true,
  notifyOnReservation: json['notifyOnReservation'] as bool? ?? true,
  notifyOnLowStock: json['notifyOnLowStock'] as bool? ?? true,
  lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 5,
  enabledChannels:
      (json['enabledChannels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const ['push', 'email'],
  requireConfirmationCode: json['requireConfirmationCode'] as bool? ?? true,
  defaultPickupDuration: (json['defaultPickupDuration'] as num?)?.toInt() ?? 30,
);

Map<String, dynamic> _$MerchantSettingsModelToJson(
  MerchantSettingsModel instance,
) => <String, dynamic>{
  'maxActiveOffers': instance.maxActiveOffers,
  'maxDailyOffers': instance.maxDailyOffers,
  'autoAcceptReservations': instance.autoAcceptReservations,
  'notifyOnReservation': instance.notifyOnReservation,
  'notifyOnLowStock': instance.notifyOnLowStock,
  'lowStockThreshold': instance.lowStockThreshold,
  'enabledChannels': instance.enabledChannels,
  'requireConfirmationCode': instance.requireConfirmationCode,
  'defaultPickupDuration': instance.defaultPickupDuration,
};

MerchantStatsModel _$MerchantStatsModelFromJson(Map<String, dynamic> json) =>
    MerchantStatsModel(
      totalOffers: (json['totalOffers'] as num).toInt(),
      activeOffers: (json['activeOffers'] as num).toInt(),
      totalReservations: (json['totalReservations'] as num).toInt(),
      completedReservations: (json['completedReservations'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalCo2Saved: (json['totalCo2Saved'] as num).toDouble(),
      totalMealsSaved: (json['totalMealsSaved'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      dailyStats:
          (json['dailyStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              DailyStatsModel.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$MerchantStatsModelToJson(MerchantStatsModel instance) =>
    <String, dynamic>{
      'totalOffers': instance.totalOffers,
      'activeOffers': instance.activeOffers,
      'totalReservations': instance.totalReservations,
      'completedReservations': instance.completedReservations,
      'totalRevenue': instance.totalRevenue,
      'totalCo2Saved': instance.totalCo2Saved,
      'totalMealsSaved': instance.totalMealsSaved,
      'averageRating': instance.averageRating,
      'dailyStats': instance.dailyStats,
    };

DailyStatsModel _$DailyStatsModelFromJson(Map<String, dynamic> json) =>
    DailyStatsModel(
      date: DateTime.parse(json['date'] as String),
      offersCreated: (json['offersCreated'] as num).toInt(),
      reservations: (json['reservations'] as num).toInt(),
      completed: (json['completed'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
      co2Saved: (json['co2Saved'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyStatsModelToJson(DailyStatsModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'offersCreated': instance.offersCreated,
      'reservations': instance.reservations,
      'completed': instance.completed,
      'revenue': instance.revenue,
      'co2Saved': instance.co2Saved,
    };
