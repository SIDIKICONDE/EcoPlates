import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/merchant_enums.dart';
import '../../domain/entities/merchant_profile.dart';

part 'merchant_profile_model.freezed.dart';
part 'merchant_profile_model.g.dart';

/// Modèle de données pour le profil merchant avec support JSON
///
/// Utilise Freezed pour la génération automatique de code
/// selon les directives EcoPlates
@freezed
abstract class MerchantProfileModel with _$MerchantProfileModel {
  const factory MerchantProfileModel({
    required String id,
    required String name,
    required String categoryKey,
    String? logoUrl,
    String? description,
    MerchantAddressModel? address,
    String? phoneNumber,
    String? email,
    @Default({}) Map<String, OpeningHoursModel> openingHours,
    GeoCoordinatesModel? coordinates,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isVerified,
    @Default(0.0) double rating,
    @Default(0) int totalReviews,
  }) = _MerchantProfileModel;

  const MerchantProfileModel._();

  factory MerchantProfileModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantProfileModelFromJson(json);

  /// Créer depuis l'entité domaine
  factory MerchantProfileModel.fromDomain(MerchantProfile profile) {
    final modelHours = <String, OpeningHoursModel>{};
    profile.openingHours.forEach((key, value) {
      modelHours[key.name] = OpeningHoursModel.fromDomain(value);
    });

    return MerchantProfileModel(
      id: profile.id,
      name: profile.name,
      categoryKey: profile.category.key,
      logoUrl: profile.logoUrl,
      description: profile.description,
      address: profile.address != null
          ? MerchantAddressModel.fromDomain(profile.address!)
          : null,
      phoneNumber: profile.phoneNumber,
      email: profile.email,
      openingHours: modelHours,
      coordinates: profile.coordinates != null
          ? GeoCoordinatesModel.fromDomain(profile.coordinates!)
          : null,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
      isVerified: profile.isVerified,
      rating: profile.rating,
      totalReviews: profile.totalReviews,
    );
  }

  /// Convertir vers l'entité domaine
  MerchantProfile toDomain() {
    return MerchantProfile(
      id: id,
      name: name,
      category: MerchantCategory.fromKey(categoryKey),
      logoUrl: logoUrl,
      description: description,
      address: address?.toDomain(),
      phoneNumber: phoneNumber,
      email: email,
      openingHours: _convertOpeningHours(),
      coordinates: coordinates?.toDomain(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isVerified: isVerified,
      rating: rating,
      totalReviews: totalReviews,
    );
  }

  /// Convertir les horaires d'ouverture
  Map<WeekDay, OpeningHours> _convertOpeningHours() {
    final domainHours = <WeekDay, OpeningHours>{};
    openingHours.forEach((key, value) {
      final weekDay = WeekDay.values.firstWhere(
        (day) => day.name == key,
        orElse: () => WeekDay.monday,
      );
      domainHours[weekDay] = value.toDomain();
    });
    return domainHours;
  }
}

/// Modèle d'adresse avec support JSON
@freezed
abstract class MerchantAddressModel with _$MerchantAddressModel {
  const factory MerchantAddressModel({
    required String street,
    required String postalCode,
    required String city,
    String? complement,
    @Default('France') String country,
  }) = _MerchantAddressModel;

  const MerchantAddressModel._();

  factory MerchantAddressModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantAddressModelFromJson(json);

  /// Créer depuis l'entité domaine
  factory MerchantAddressModel.fromDomain(MerchantAddress address) {
    return MerchantAddressModel(
      street: address.street,
      postalCode: address.postalCode,
      city: address.city,
      complement: address.complement,
      country: address.country,
    );
  }

  /// Convertir vers l'entité domaine
  MerchantAddress toDomain() {
    return MerchantAddress(
      street: street,
      postalCode: postalCode,
      city: city,
      complement: complement,
      country: country,
    );
  }
}

/// Modèle de coordonnées GPS avec support JSON
@freezed
abstract class GeoCoordinatesModel with _$GeoCoordinatesModel {
  const factory GeoCoordinatesModel({
    required double latitude,
    required double longitude,
  }) = _GeoCoordinatesModel;

  const GeoCoordinatesModel._();

  factory GeoCoordinatesModel.fromJson(Map<String, dynamic> json) =>
      _$GeoCoordinatesModelFromJson(json);

  /// Créer depuis l'entité domaine
  factory GeoCoordinatesModel.fromDomain(GeoCoordinates coordinates) {
    return GeoCoordinatesModel(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );
  }

  /// Convertir vers l'entité domaine
  GeoCoordinates toDomain() {
    return GeoCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

/// Modèle des horaires d'ouverture avec support JSON
@freezed
abstract class OpeningHoursModel with _$OpeningHoursModel {
  const factory OpeningHoursModel({
    required String openTime,
    required String closeTime,
    String? breakStart,
    String? breakEnd,
    @Default(false) bool isClosed,
  }) = _OpeningHoursModel;

  const OpeningHoursModel._();

  factory OpeningHoursModel.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursModelFromJson(json);

  /// Créer pour un jour fermé
  factory OpeningHoursModel.closed() {
    return const OpeningHoursModel(
      openTime: '00:00',
      closeTime: '00:00',
      isClosed: true,
    );
  }

  /// Créer depuis l'entité domaine
  factory OpeningHoursModel.fromDomain(OpeningHours hours) {
    return OpeningHoursModel(
      openTime: hours.openTime,
      closeTime: hours.closeTime,
      breakStart: hours.breakStart,
      breakEnd: hours.breakEnd,
      isClosed: hours.isClosed,
    );
  }

  /// Convertir vers l'entité domaine
  OpeningHours toDomain() {
    return OpeningHours(
      openTime: openTime,
      closeTime: closeTime,
      breakStart: breakStart,
      breakEnd: breakEnd,
      isClosed: isClosed,
    );
  }
}
