import 'dart:math' as math;

/// Entité représentant une offre anti-gaspillage
class FoodOffer {
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
    required this.updatedAt,
  });

  /// Calcule le pourcentage de réduction
  double get discountPercentage {
    if (originalPrice == 0) return 100;
    return ((originalPrice - discountedPrice) / originalPrice * 100);
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
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String postalCode;
  final String? additionalInfo; // "Entrée par la rue X", etc.

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.postalCode,
    this.additionalInfo,
  });

  /// Calcule la distance depuis une position (en km)
  double distanceFrom(double lat, double lng) {
    // Formule simplifiée de Haversine
    const double earthRadius = 6371; // km
    double dLat = _toRadians(latitude - lat);
    double dLng = _toRadians(longitude - lng);
    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat)) *
            math.cos(_toRadians(latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }
}
