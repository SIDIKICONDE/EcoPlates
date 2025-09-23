import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/food_offer.dart';

part 'food_offer_model.g.dart';

/// Modèle de données pour FoodOffer avec sérialisation JSON
@JsonSerializable(explicitToJson: true)
class FoodOfferModel {
  final String id;
  final String merchantId;
  final String merchantName;
  final String title;
  final String description;
  final List<String> images;
  final OfferType type;
  final FoodCategory category;
  final double originalPrice;
  final double discountedPrice;
  final int quantity;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final DateTime createdAt;
  final OfferStatus status;
  final LocationModel location;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isHalal;
  final int co2Saved;

  const FoodOfferModel({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.title,
    required this.description,
    required this.images,
    required this.type,
    required this.category,
    required this.originalPrice,
    required this.discountedPrice,
    required this.quantity,
    required this.pickupStartTime,
    required this.pickupEndTime,
    required this.createdAt,
    required this.status,
    required this.location,
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isHalal = false,
    this.co2Saved = 500,
  });

  /// Créer une instance depuis JSON
  factory FoodOfferModel.fromJson(Map<String, dynamic> json) =>
      _$FoodOfferModelFromJson(json);

  /// Convertir en JSON
  Map<String, dynamic> toJson() => _$FoodOfferModelToJson(this);

  /// Créer depuis l'entité domaine
  factory FoodOfferModel.fromEntity(FoodOffer offer) {
    return FoodOfferModel(
      id: offer.id,
      merchantId: offer.merchantId,
      merchantName: offer.merchantName,
      title: offer.title,
      description: offer.description,
      images: offer.images,
      type: offer.type,
      category: offer.category,
      originalPrice: offer.originalPrice,
      discountedPrice: offer.discountedPrice,
      quantity: offer.quantity,
      pickupStartTime: offer.pickupStartTime,
      pickupEndTime: offer.pickupEndTime,
      createdAt: offer.createdAt,
      status: offer.status,
      location: LocationModel.fromEntity(offer.location),
      allergens: offer.allergens,
      isVegetarian: offer.isVegetarian,
      isVegan: offer.isVegan,
      isHalal: offer.isHalal,
      co2Saved: offer.co2Saved,
    );
  }

  /// Convertir vers l'entité domaine
  FoodOffer toEntity() {
    return FoodOffer(
      id: id,
      merchantId: merchantId,
      merchantName: merchantName,
      title: title,
      description: description,
      images: images,
      type: type,
      category: category,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      quantity: quantity,
      pickupStartTime: pickupStartTime,
      pickupEndTime: pickupEndTime,
      createdAt: createdAt,
      status: status,
      location: Location(
        latitude: location.latitude,
        longitude: location.longitude,
        address: location.address,
        city: location.city,
        postalCode: location.postalCode,
        additionalInfo: location.additionalInfo,
      ),
      allergens: allergens,
      isVegetarian: isVegetarian,
      isVegan: isVegan,
      isHalal: isHalal,
      co2Saved: co2Saved,
    );
  }
}

/// Modèle pour Location avec sérialisation JSON
@JsonSerializable()
class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String postalCode;
  final String? additionalInfo;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.postalCode,
    this.additionalInfo,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      address: location.address,
      city: location.city,
      postalCode: location.postalCode,
      additionalInfo: location.additionalInfo,
    );
  }
}
