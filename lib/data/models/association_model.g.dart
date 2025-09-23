// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'association_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssociationModel _$AssociationModelFromJson(Map<String, dynamic> json) =>
    AssociationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      siret: json['siret'] as String,
      rna: json['rna'] as String,
      type: $enumDecode(_$AssociationTypeEnumMap, json['type']),
      status: $enumDecode(_$AssociationStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      validatedAt: json['validatedAt'] == null
          ? null
          : DateTime.parse(json['validatedAt'] as String),
      details: AssociationDetailsModel.fromJson(
        json['details'] as Map<String, dynamic>,
      ),
      stats: AssociationStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>,
      ),
      volunteerUserIds:
          (json['volunteerUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      beneficiaryZones:
          (json['beneficiaryZones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AssociationModelToJson(AssociationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'siret': instance.siret,
      'rna': instance.rna,
      'type': _$AssociationTypeEnumMap[instance.type]!,
      'status': _$AssociationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'validatedAt': instance.validatedAt?.toIso8601String(),
      'details': instance.details.toJson(),
      'stats': instance.stats.toJson(),
      'volunteerUserIds': instance.volunteerUserIds,
      'beneficiaryZones': instance.beneficiaryZones,
    };

const _$AssociationTypeEnumMap = {
  AssociationType.foodBank: 'foodBank',
  AssociationType.socialRestaurant: 'socialRestaurant',
  AssociationType.charity: 'charity',
  AssociationType.studentAssociation: 'studentAssociation',
  AssociationType.religiousOrg: 'religiousOrg',
  AssociationType.redCross: 'redCross',
  AssociationType.other: 'other',
};

const _$AssociationStatusEnumMap = {
  AssociationStatus.pending: 'pending',
  AssociationStatus.validated: 'validated',
  AssociationStatus.suspended: 'suspended',
  AssociationStatus.rejected: 'rejected',
  AssociationStatus.expired: 'expired',
};

AssociationDetailsModel _$AssociationDetailsModelFromJson(
  Map<String, dynamic> json,
) => AssociationDetailsModel(
  description: json['description'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  postalCode: json['postalCode'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  website: json['website'] as String,
  presidentName: json['presidentName'] as String,
  yearFounded: (json['yearFounded'] as num).toInt(),
  activeVolunteers: (json['activeVolunteers'] as num).toInt(),
  beneficiariesCount: (json['beneficiariesCount'] as num).toInt(),
  hasCollectAgreement: json['hasCollectAgreement'] as bool,
  hasColdChain: json['hasColdChain'] as bool,
  hasVehicles: json['hasVehicles'] as bool,
  certifications:
      (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  collectHours: OpeningHoursModel.fromJson(
    json['collectHours'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AssociationDetailsModelToJson(
  AssociationDetailsModel instance,
) => <String, dynamic>{
  'description': instance.description,
  'address': instance.address,
  'city': instance.city,
  'postalCode': instance.postalCode,
  'phone': instance.phone,
  'email': instance.email,
  'website': instance.website,
  'presidentName': instance.presidentName,
  'yearFounded': instance.yearFounded,
  'activeVolunteers': instance.activeVolunteers,
  'beneficiariesCount': instance.beneficiariesCount,
  'hasCollectAgreement': instance.hasCollectAgreement,
  'hasColdChain': instance.hasColdChain,
  'hasVehicles': instance.hasVehicles,
  'certifications': instance.certifications,
  'collectHours': instance.collectHours.toJson(),
};

AssociationStatsModel _$AssociationStatsModelFromJson(
  Map<String, dynamic> json,
) => AssociationStatsModel(
  mealsDistributed: (json['mealsDistributed'] as num?)?.toInt(),
  peopleHelped: (json['peopleHelped'] as num?)?.toInt(),
  foodSaved: (json['foodSaved'] as num?)?.toDouble(),
  co2Saved: (json['co2Saved'] as num?)?.toDouble(),
  platesUsed: (json['platesUsed'] as num?)?.toInt(),
  volunteersHours: (json['volunteersHours'] as num?)?.toInt(),
  lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
);

Map<String, dynamic> _$AssociationStatsModelToJson(
  AssociationStatsModel instance,
) => <String, dynamic>{
  'mealsDistributed': instance.mealsDistributed,
  'peopleHelped': instance.peopleHelped,
  'foodSaved': instance.foodSaved,
  'co2Saved': instance.co2Saved,
  'platesUsed': instance.platesUsed,
  'volunteersHours': instance.volunteersHours,
  'lastActivityAt': instance.lastActivityAt.toIso8601String(),
};

OpeningHoursModel _$OpeningHoursModelFromJson(Map<String, dynamic> json) =>
    OpeningHoursModel(
      schedule: (json['schedule'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          $enumDecode(_$DayOfWeekEnumMap, k),
          TimeSlotModel.fromJson(e as Map<String, dynamic>),
        ),
      ),
      specialNotes: json['specialNotes'] as String?,
    );

Map<String, dynamic> _$OpeningHoursModelToJson(OpeningHoursModel instance) =>
    <String, dynamic>{
      'schedule': instance.schedule.map(
        (k, e) => MapEntry(_$DayOfWeekEnumMap[k]!, e),
      ),
      'specialNotes': instance.specialNotes,
    };

const _$DayOfWeekEnumMap = {
  DayOfWeek.monday: 'monday',
  DayOfWeek.tuesday: 'tuesday',
  DayOfWeek.wednesday: 'wednesday',
  DayOfWeek.thursday: 'thursday',
  DayOfWeek.friday: 'friday',
  DayOfWeek.saturday: 'saturday',
  DayOfWeek.sunday: 'sunday',
};

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) =>
    TimeSlotModel(
      isOpen: json['isOpen'] as bool,
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
    );

Map<String, dynamic> _$TimeSlotModelToJson(TimeSlotModel instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
    };

GroupCollectionModel _$GroupCollectionModelFromJson(
  Map<String, dynamic> json,
) => GroupCollectionModel(
  id: json['id'] as String,
  associationId: json['associationId'] as String,
  offerIds: (json['offerIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  scheduledAt: DateTime.parse(json['scheduledAt'] as String),
  volunteerAssignedId: json['volunteerAssignedId'] as String?,
  status: $enumDecode(_$GroupCollectionStatusEnumMap, json['status']),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$GroupCollectionModelToJson(
  GroupCollectionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'associationId': instance.associationId,
  'offerIds': instance.offerIds,
  'scheduledAt': instance.scheduledAt.toIso8601String(),
  'volunteerAssignedId': instance.volunteerAssignedId,
  'status': _$GroupCollectionStatusEnumMap[instance.status]!,
  'notes': instance.notes,
};

const _$GroupCollectionStatusEnumMap = {
  GroupCollectionStatus.scheduled: 'scheduled',
  GroupCollectionStatus.inProgress: 'inProgress',
  GroupCollectionStatus.completed: 'completed',
  GroupCollectionStatus.cancelled: 'cancelled',
};
