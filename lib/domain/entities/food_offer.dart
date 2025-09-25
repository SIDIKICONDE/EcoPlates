import 'dart:math' as math;

/// Entité représentant une offre anti-gaspillage
class FoodOffer {
  const FoodOffer({
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
    required this.updatedAt,
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isHalal = false,
    this.co2Saved = 500, // 500g par défaut
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
  });
  final String id;
  final String merchantId;
  final String merchantName;
  final String title;
  final String description;
  final List<String> images;
  final OfferType type;
  final FoodCategory category;
  final double originalPrice;
  final double discountedPrice; // 0 si gratuit
  final int quantity; // Nombre de paniers disponibles
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final DateTime createdAt;
  final OfferStatus status;
  final Location location;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isHalal;
  final int co2Saved; // en grammes
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
  final double? distanceKm; // Distance calculée depuis l'utilisateur
  final int preparationTime; // en minutes
  final bool isFavorite;
  final int viewCount;
  final int soldCount;
  final DateTime updatedAt;

  FoodOffer copyWith({
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
    Location? location,
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
    return FoodOffer(
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

  /// Calcule le pourcentage de réduction
  double get discountPercentage {
    if (originalPrice == 0) return 100;
    return (originalPrice - discountedPrice) / originalPrice * 100;
  }

  /// Vérifie si l'offre est gratuite
  bool get isFree => discountedPrice == 0;

  /// Vérifie si l'offre est encore disponible
  bool get isAvailable => status == OfferStatus.available && quantity > 0;

  /// Vérifie si on peut encore récupérer l'offre
  bool get canPickup {
    final now = DateTime.now();
    return now.isAfter(pickupStartTime) && now.isBefore(pickupEndTime);
  }

  /// Temps restant avant la fin de collecte
  Duration get timeRemaining => pickupEndTime.difference(DateTime.now());

  /// Texte pour afficher le prix
  String get priceText {
    if (isFree) return 'GRATUIT';
    return '${discountedPrice.toStringAsFixed(2)}€';
  }

  /// Badge de réduction
  String get discountBadge {
    if (isFree) return 'GRATUIT';
    return '-${discountPercentage.toStringAsFixed(0)}%';
  }
}

/// Types d'offres
enum OfferType {
  panier, // Panier surprise
  plat, // Plat spécifique
  boulangerie, // Produits de boulangerie
  fruits, // Fruits et légumes
  epicerie, // Produits d'épicerie
  autre, // Autres
}

/// Catégories de nourriture
enum FoodCategory {
  petitDejeuner,
  dejeuner,
  diner,
  snack,
  dessert,
  boisson,
  boulangerie,
  fruitLegume,
  epicerie,
  autre,
}

/// Statut de l'offre
enum OfferStatus {
  draft, // Brouillon
  available, // Disponible
  reserved, // Réservée (en attente de collecte)
  collected, // Collectée
  expired, // Expirée
  cancelled, // Annulée
}

/// Localisation du commerçant
class Location {
  // "Entrée par la rue X", etc.

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.postalCode,
    this.additionalInfo,
  });
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String postalCode;
  final String? additionalInfo;

  /// Calcule la distance depuis une position (en km)
  double distanceFrom(double lat, double lng) {
    // Formule simplifiée de Haversine
    const double earthRadius = 6371; // km
    final dLat = _toRadians(latitude - lat);
    final dLng = _toRadians(longitude - lng);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat)) *
            math.cos(_toRadians(latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }
}

/// Niveau d'alerte pour le stock des offres
enum OfferAlertLevel {
  /// Stock normal
  normal,

  /// Stock faible
  low,

  /// Rupture de stock
  outOfStock,
}

/// Extension pour calculer le niveau d'alerte des offres
extension OfferAlertLevelExtension on FoodOffer {
  /// Calcule le niveau d'alerte basé sur la quantité disponible
  OfferAlertLevel get alertLevel {
    final currentQuantity = availableQuantity > 0
        ? availableQuantity
        : quantity;

    if (currentQuantity == 0) {
      return OfferAlertLevel.outOfStock;
    } else if (currentQuantity < 5) {
      return OfferAlertLevel.low;
    } else {
      return OfferAlertLevel.normal;
    }
  }

  /// Couleur associée au niveau d'alerte
  String get alertColorKey {
    switch (alertLevel) {
      case OfferAlertLevel.normal:
        return 'success';
      case OfferAlertLevel.low:
        return 'warning';
      case OfferAlertLevel.outOfStock:
        return 'error';
    }
  }

  /// Icône associée au niveau d'alerte
  String get alertIconName {
    switch (alertLevel) {
      case OfferAlertLevel.normal:
        return 'check_circle';
      case OfferAlertLevel.low:
        return 'warning';
      case OfferAlertLevel.outOfStock:
        return 'error';
    }
  }
}
