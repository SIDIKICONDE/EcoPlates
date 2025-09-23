import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/association.dart';

part 'association_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssociationModel {
  final String id;
  final String name;
  final String siret;
  final String rna;
  final AssociationType type;
  final AssociationStatus status;
  final DateTime createdAt;
  final DateTime? validatedAt;
  final AssociationDetailsModel details;
  final AssociationStatsModel stats;
  final List<String> volunteerUserIds;
  final List<String> beneficiaryZones;

  const AssociationModel({
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

  factory AssociationModel.fromJson(Map<String, dynamic> json) =>
      _$AssociationModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssociationModelToJson(this);

  factory AssociationModel.fromEntity(Association entity) {
    return AssociationModel(
      id: entity.id,
      name: entity.name,
      siret: entity.siret,
      rna: entity.rna,
      type: entity.type,
      status: entity.status,
      createdAt: entity.createdAt,
      validatedAt: entity.validatedAt,
      details: AssociationDetailsModel.fromEntity(entity.details),
      stats: AssociationStatsModel.fromEntity(entity.stats),
      volunteerUserIds: entity.volunteerUserIds,
      beneficiaryZones: entity.beneficiaryZones,
    );
  }

  Association toEntity() {
    return Association(
      id: id,
      name: name,
      siret: siret,
      rna: rna,
      type: type,
      status: status,
      createdAt: createdAt,
      validatedAt: validatedAt,
      details: details.toEntity(),
      stats: stats.toEntity(),
      volunteerUserIds: volunteerUserIds,
      beneficiaryZones: beneficiaryZones,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AssociationDetailsModel {
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
  final int beneficiariesCount;
  final bool hasCollectAgreement;
  final bool hasColdChain;
  final bool hasVehicles;
  final List<String> certifications;
  final OpeningHoursModel collectHours;

  const AssociationDetailsModel({
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

  factory AssociationDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$AssociationDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssociationDetailsModelToJson(this);

  factory AssociationDetailsModel.fromEntity(AssociationDetails entity) {
    return AssociationDetailsModel(
      description: entity.description,
      address: entity.address,
      city: entity.city,
      postalCode: entity.postalCode,
      phone: entity.phone,
      email: entity.email,
      website: entity.website,
      presidentName: entity.presidentName,
      yearFounded: entity.yearFounded,
      activeVolunteers: entity.activeVolunteers,
      beneficiariesCount: entity.beneficiariesCount,
      hasCollectAgreement: entity.hasCollectAgreement,
      hasColdChain: entity.hasColdChain,
      hasVehicles: entity.hasVehicles,
      certifications: entity.certifications,
      collectHours: OpeningHoursModel.fromEntity(entity.collectHours),
    );
  }

  AssociationDetails toEntity() {
    return AssociationDetails(
      description: description,
      address: address,
      city: city,
      postalCode: postalCode,
      phone: phone,
      email: email,
      website: website,
      presidentName: presidentName,
      yearFounded: yearFounded,
      activeVolunteers: activeVolunteers,
      beneficiariesCount: beneficiariesCount,
      hasCollectAgreement: hasCollectAgreement,
      hasColdChain: hasColdChain,
      hasVehicles: hasVehicles,
      certifications: certifications,
      collectHours: collectHours.toEntity(),
    );
  }
}

@JsonSerializable()
class AssociationStatsModel {
  final int? mealsDistributed;
  final int? peopleHelped;
  final double? foodSaved;
  final double? co2Saved;
  final int? platesUsed;
  final int? volunteersHours;
  final DateTime lastActivityAt;

  const AssociationStatsModel({
    this.mealsDistributed,
    this.peopleHelped,
    this.foodSaved,
    this.co2Saved,
    this.platesUsed,
    this.volunteersHours,
    required this.lastActivityAt,
  });

  factory AssociationStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AssociationStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssociationStatsModelToJson(this);

  factory AssociationStatsModel.fromEntity(AssociationStats entity) {
    return AssociationStatsModel(
      mealsDistributed: entity.mealsDistributed,
      peopleHelped: entity.peopleHelped,
      foodSaved: entity.foodSaved,
      co2Saved: entity.co2Saved,
      platesUsed: entity.platesUsed,
      volunteersHours: entity.volunteersHours,
      lastActivityAt: entity.lastActivityAt,
    );
  }

  AssociationStats toEntity() {
    return AssociationStats(
      mealsDistributed: mealsDistributed ?? 0,
      peopleHelped: peopleHelped ?? 0,
      foodSaved: foodSaved ?? 0.0,
      co2Saved: co2Saved ?? 0.0,
      platesUsed: platesUsed ?? 0,
      volunteersHours: volunteersHours ?? 0,
      lastActivityAt: lastActivityAt,
    );
  }
}

@JsonSerializable()
class OpeningHoursModel {
  final Map<DayOfWeek, TimeSlotModel> schedule;
  final String? specialNotes;

  const OpeningHoursModel({required this.schedule, this.specialNotes});

  factory OpeningHoursModel.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursModelToJson(this);

  factory OpeningHoursModel.fromEntity(OpeningHours entity) {
    final scheduleModel = <DayOfWeek, TimeSlotModel>{};
    entity.schedule.forEach((day, slot) {
      scheduleModel[day] = TimeSlotModel.fromEntity(slot);
    });

    return OpeningHoursModel(
      schedule: scheduleModel,
      specialNotes: entity.specialNotes,
    );
  }

  OpeningHours toEntity() {
    final scheduleEntity = <DayOfWeek, TimeSlot>{};
    schedule.forEach((day, slot) {
      scheduleEntity[day] = slot.toEntity();
    });

    return OpeningHours(schedule: scheduleEntity, specialNotes: specialNotes);
  }
}

@JsonSerializable()
class TimeSlotModel {
  final bool isOpen;
  final String openTime;
  final String closeTime;

  const TimeSlotModel({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);

  factory TimeSlotModel.fromEntity(TimeSlot entity) {
    return TimeSlotModel(
      isOpen: entity.isOpen,
      openTime: entity.openTimeFormatted,
      closeTime: entity.closeTimeFormatted,
    );
  }

  TimeSlot toEntity() {
    return TimeSlot(
      isOpen: isOpen,
      openTime: _timeToMinutes(openTime),
      closeTime: _timeToMinutes(closeTime),
    );
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }
}

@JsonSerializable()
class GroupCollectionModel {
  final String id;
  final String associationId;
  final List<String> offerIds;
  final DateTime scheduledAt;
  final String? volunteerAssignedId;
  final GroupCollectionStatus status;
  final String? notes;

  const GroupCollectionModel({
    required this.id,
    required this.associationId,
    required this.offerIds,
    required this.scheduledAt,
    this.volunteerAssignedId,
    required this.status,
    this.notes,
  });

  factory GroupCollectionModel.fromJson(Map<String, dynamic> json) =>
      _$GroupCollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupCollectionModelToJson(this);

  factory GroupCollectionModel.fromEntity(GroupCollection entity) {
    return GroupCollectionModel(
      id: entity.id,
      associationId: entity.associationId,
      offerIds: entity.offerIds,
      scheduledAt: entity.scheduledAt,
      volunteerAssignedId: entity.volunteerAssignedId,
      status: entity.status,
      notes: entity.notes,
    );
  }

  GroupCollection toEntity() {
    return GroupCollection(
      id: id,
      associationId: associationId,
      offerIds: offerIds,
      scheduledAt: scheduledAt,
      volunteerAssignedId: volunteerAssignedId,
      status: status,
      notes: notes,
    );
  }
}
