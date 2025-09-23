// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodOfferModel _$FoodOfferModelFromJson(
  Map<String, dynamic> json,
) => FoodOfferModel(
  id: json['id'] as String,
  merchantId: json['merchantId'] as String,
  merchantName: json['merchantName'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  type: $enumDecode(_$OfferTypeEnumMap, json['type']),
  category: $enumDecode(_$FoodCategoryEnumMap, json['category']),
  originalPrice: (json['originalPrice'] as num).toDouble(),
  discountedPrice: (json['discountedPrice'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  pickupStartTime: DateTime.parse(json['pickupStartTime'] as String),
  pickupEndTime: DateTime.parse(json['pickupEndTime'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: $enumDecode(_$OfferStatusEnumMap, json['status']),
  location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
  allergens:
      (json['allergens'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isVegetarian: json['isVegetarian'] as bool? ?? false,
  isVegan: json['isVegan'] as bool? ?? false,
  isHalal: json['isHalal'] as bool? ?? false,
  co2Saved: (json['co2Saved'] as num?)?.toInt() ?? 500,
);

Map<String, dynamic> _$FoodOfferModelToJson(FoodOfferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchantId': instance.merchantId,
      'merchantName': instance.merchantName,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'type': _$OfferTypeEnumMap[instance.type]!,
      'category': _$FoodCategoryEnumMap[instance.category]!,
      'originalPrice': instance.originalPrice,
      'discountedPrice': instance.discountedPrice,
      'quantity': instance.quantity,
      'pickupStartTime': instance.pickupStartTime.toIso8601String(),
      'pickupEndTime': instance.pickupEndTime.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$OfferStatusEnumMap[instance.status]!,
      'location': instance.location.toJson(),
      'allergens': instance.allergens,
      'isVegetarian': instance.isVegetarian,
      'isVegan': instance.isVegan,
      'isHalal': instance.isHalal,
      'co2Saved': instance.co2Saved,
    };

const _$OfferTypeEnumMap = {
  OfferType.panier: 'panier',
  OfferType.plat: 'plat',
  OfferType.boulangerie: 'boulangerie',
  OfferType.fruits: 'fruits',
  OfferType.epicerie: 'epicerie',
  OfferType.autre: 'autre',
};

const _$FoodCategoryEnumMap = {
  FoodCategory.petitDejeuner: 'petitDejeuner',
  FoodCategory.dejeuner: 'dejeuner',
  FoodCategory.diner: 'diner',
  FoodCategory.snack: 'snack',
  FoodCategory.dessert: 'dessert',
  FoodCategory.boisson: 'boisson',
  FoodCategory.boulangerie: 'boulangerie',
  FoodCategory.fruitLegume: 'fruitLegume',
  FoodCategory.epicerie: 'epicerie',
  FoodCategory.autre: 'autre',
};

const _$OfferStatusEnumMap = {
  OfferStatus.draft: 'draft',
  OfferStatus.available: 'available',
  OfferStatus.reserved: 'reserved',
  OfferStatus.collected: 'collected',
  OfferStatus.expired: 'expired',
  OfferStatus.cancelled: 'cancelled',
};

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'additionalInfo': instance.additionalInfo,
    };
