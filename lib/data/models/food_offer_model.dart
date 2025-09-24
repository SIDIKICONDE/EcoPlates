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
  // Propriétés étendues
  final String merchantAddress;
  final String? merchantLogo;
  final int availableQuantity;
  final int totalQuantity;
  final List<String> tags;
  final Map<String, dynamic>? nutritionalInfo;
  final Map<String, dynamic>? ecoImpact;
  final double rating;
  final int ratingsCount;
  final double? distanceKm;
  final int preparationTime;
  final bool isFavorite;
  final int viewCount;
  final int soldCount;
  final DateTime updatedAt;

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
    required this.merchantAddress,
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isHalal = false,
    this.co2Saved = 500,
    this.merchantLogo,
    this.availableQuantity = 0,
    this.totalQuantity = 0,
    this.tags = const [],
    this.nutritionalInfo,
    this.ecoImpact,
    this.rating = 0.0,
    this.ratingsCount = 0,
    this.distanceKm,
    this.preparationTime = 30,
    this.isFavorite = false,
    this.viewCount = 0,
    this.soldCount = 0,
    required this.updatedAt,
  });

  /// Créer une instance depuis JSON
  factory FoodOfferModel.fromJson(Map<String, dynamic> json) =>
      _$FoodOfferModelFromJson(json);

  /// Convertir en JSON
  Map<String, dynamic> toJson() => _$FoodOfferModelToJson(this);

  /// Créer une copie avec certains champs modifiés
  FoodOfferModel copyWith({
    String? id,
    String? merchantId,
    String? merchantName,
    String? title,
    String? description,
    List<String>? images,
    OfferType? type,
    FoodCategory? category,
    double? originalPrice,
    double? discountedPrice,
    int? quantity,
    DateTime? pickupStartTime,
    DateTime? pickupEndTime,
    DateTime? createdAt,
    OfferStatus? status,
    LocationModel? location,
    List<String>? allergens,
    bool? isVegetarian,
    bool? isVegan,
    bool? isHalal,
    int? co2Saved,
    String? merchantAddress,
    String? merchantLogo,
    int? availableQuantity,
    int? totalQuantity,
    List<String>? tags,
    Map<String, dynamic>? nutritionalInfo,
    Map<String, dynamic>? ecoImpact,
    double? rating,
    int? ratingsCount,
    double? distanceKm,
    int? preparationTime,
    bool? isFavorite,
    int? viewCount,
    int? soldCount,
    DateTime? updatedAt,
  }) {
    return FoodOfferModel(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      type: type ?? this.type,
      category: category ?? this.category,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      quantity: quantity ?? this.quantity,
      pickupStartTime: pickupStartTime ?? this.pickupStartTime,
      pickupEndTime: pickupEndTime ?? this.pickupEndTime,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      location: location ?? this.location,
      allergens: allergens ?? this.allergens,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isHalal: isHalal ?? this.isHalal,
      co2Saved: co2Saved ?? this.co2Saved,
      merchantAddress: merchantAddress ?? this.merchantAddress,
      merchantLogo: merchantLogo ?? this.merchantLogo,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      tags: tags ?? this.tags,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      ecoImpact: ecoImpact ?? this.ecoImpact,
      rating: rating ?? this.rating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      distanceKm: distanceKm ?? this.distanceKm,
      preparationTime: preparationTime ?? this.preparationTime,
      isFavorite: isFavorite ?? this.isFavorite,
      viewCount: viewCount ?? this.viewCount,
      soldCount: soldCount ?? this.soldCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
      merchantAddress: offer.merchantAddress,
      merchantLogo: offer.merchantLogo,
      availableQuantity: offer.availableQuantity,
      totalQuantity: offer.totalQuantity,
      tags: offer.tags,
      nutritionalInfo: offer.nutritionalInfo,
      ecoImpact: offer.ecoImpact,
      rating: offer.rating,
      ratingsCount: offer.ratingsCount,
      distanceKm: offer.distanceKm,
      preparationTime: offer.preparationTime,
      isFavorite: offer.isFavorite,
      viewCount: offer.viewCount,
      soldCount: offer.soldCount,
      updatedAt: offer.updatedAt,
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
      merchantAddress: merchantAddress,
      merchantLogo: merchantLogo,
      availableQuantity: availableQuantity,
      totalQuantity: totalQuantity,
      tags: tags,
      nutritionalInfo: nutritionalInfo,
      ecoImpact: ecoImpact,
      rating: rating,
      ratingsCount: ratingsCount,
      distanceKm: distanceKm,
      preparationTime: preparationTime,
      isFavorite: isFavorite,
      viewCount: viewCount,
      soldCount: soldCount,
      updatedAt: updatedAt,
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
