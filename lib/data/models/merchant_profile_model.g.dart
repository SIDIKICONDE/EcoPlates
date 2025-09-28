// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MerchantProfileModel _$MerchantProfileModelFromJson(
  Map<String, dynamic> json,
) => _MerchantProfileModel(
  id: json['id'] as String,
  name: json['name'] as String,
  categoryKey: json['categoryKey'] as String,
  logoUrl: json['logoUrl'] as String?,
  description: json['description'] as String?,
  address: json['address'] == null
      ? null
      : MerchantAddressModel.fromJson(json['address'] as Map<String, dynamic>),
  phoneNumber: json['phoneNumber'] as String?,
  email: json['email'] as String?,
  openingHours:
      (json['openingHours'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, OpeningHoursModel.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  coordinates: json['coordinates'] == null
      ? null
      : GeoCoordinatesModel.fromJson(
          json['coordinates'] as Map<String, dynamic>,
        ),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  isVerified: json['isVerified'] as bool? ?? false,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MerchantProfileModelToJson(
  _MerchantProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'categoryKey': instance.categoryKey,
  'logoUrl': instance.logoUrl,
  'description': instance.description,
  'address': instance.address,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'openingHours': instance.openingHours,
  'coordinates': instance.coordinates,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'isVerified': instance.isVerified,
  'rating': instance.rating,
  'totalReviews': instance.totalReviews,
};

_MerchantAddressModel _$MerchantAddressModelFromJson(
  Map<String, dynamic> json,
) => _MerchantAddressModel(
  street: json['street'] as String,
  postalCode: json['postalCode'] as String,
  city: json['city'] as String,
  complement: json['complement'] as String?,
  country: json['country'] as String? ?? 'France',
);

Map<String, dynamic> _$MerchantAddressModelToJson(
  _MerchantAddressModel instance,
) => <String, dynamic>{
  'street': instance.street,
  'postalCode': instance.postalCode,
  'city': instance.city,
  'complement': instance.complement,
  'country': instance.country,
};

_GeoCoordinatesModel _$GeoCoordinatesModelFromJson(Map<String, dynamic> json) =>
    _GeoCoordinatesModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoCoordinatesModelToJson(
  _GeoCoordinatesModel instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

_OpeningHoursModel _$OpeningHoursModelFromJson(Map<String, dynamic> json) =>
    _OpeningHoursModel(
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      breakStart: json['breakStart'] as String?,
      breakEnd: json['breakEnd'] as String?,
      isClosed: json['isClosed'] as bool? ?? false,
    );

Map<String, dynamic> _$OpeningHoursModelToJson(_OpeningHoursModel instance) =>
    <String, dynamic>{
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'breakStart': instance.breakStart,
      'breakEnd': instance.breakEnd,
      'isClosed': instance.isClosed,
    };
