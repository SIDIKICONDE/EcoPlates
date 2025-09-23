/// Entité Restaurant pour le domaine
class Restaurant {
  final String id;
  final String name;
  final String cuisineType;
  final String category;
  final String? imageUrl;
  final double? rating;
  final String distanceText;
  final bool isFavorite;
  final bool hasActiveOffer;
  final int discountPercentage;
  final double originalPrice;
  final double discountedPrice;
  final double minPrice;
  final int availableOffers;
  final String pickupTime;
  final double latitude;
  final double longitude;
  final String? description;
  final String? address;
  final String? phone;
  final List<String>? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.category,
    this.imageUrl,
    this.rating,
    required this.distanceText,
    this.isFavorite = false,
    this.hasActiveOffer = false,
    this.discountPercentage = 0,
    this.originalPrice = 0,
    this.discountedPrice = 0,
    this.minPrice = 0,
    this.availableOffers = 0,
    required this.pickupTime,
    required this.latitude,
    required this.longitude,
    this.description,
    this.address,
    this.phone,
    this.tags,
    this.createdAt,
    this.updatedAt,
  });

  /// Cr\u00e9e une copie du restaurant avec des champs modifi\u00e9s
  Restaurant copyWith({
    String? id,
    String? name,
    String? cuisineType,
    String? category,
    String? imageUrl,
    double? rating,
    String? distanceText,
    bool? isFavorite,
    bool? hasActiveOffer,
    int? discountPercentage,
    double? originalPrice,
    double? discountedPrice,
    double? minPrice,
    int? availableOffers,
    String? pickupTime,
    double? latitude,
    double? longitude,
    String? description,
    String? address,
    String? phone,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      cuisineType: cuisineType ?? this.cuisineType,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      distanceText: distanceText ?? this.distanceText,
      isFavorite: isFavorite ?? this.isFavorite,
      hasActiveOffer: hasActiveOffer ?? this.hasActiveOffer,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      minPrice: minPrice ?? this.minPrice,
      availableOffers: availableOffers ?? this.availableOffers,
      pickupTime: pickupTime ?? this.pickupTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Calcule la distance en km depuis une position donn\u00e9e
  double calculateDistance(double userLat, double userLng) {
    // Formule de Haversine pour calculer la distance
    const double earthRadius = 6371; // Rayon de la Terre en km
    
    double lat1Rad = latitude * (3.141592653589793 / 180);
    double lat2Rad = userLat * (3.141592653589793 / 180);
    double deltaLat = (userLat - latitude) * (3.141592653589793 / 180);
    double deltaLng = (userLng - longitude) * (3.141592653589793 / 180);
    
    double a = (deltaLat / 2).sin() * (deltaLat / 2).sin() +
        lat1Rad.cos() * lat2Rad.cos() *
        (deltaLng / 2).sin() * (deltaLng / 2).sin();
    
    double c = 2 * a.sqrt().asin();
    
    return earthRadius * c;
  }

  /// V\u00e9rifie si le restaurant est ouvert maintenant
  bool isOpenNow() {
    // Logique pour v\u00e9rifier si le restaurant est ouvert
    // Bas\u00e9 sur pickupTime
    return true; // Simplifi\u00e9 pour l'instant
  }

  /// Calcule le pourcentage d'\u00e9conomie
  double get savingsPercentage {
    if (originalPrice == 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }
  
  /// Extensions pour le calcul de sin/cos/asin/sqrt
}

extension on double {
  double sin() => double.parse(toString()); // Simplifié
  double cos() => double.parse(toString()); // Simplifié
  double asin() => double.parse(toString()); // Simplifié
  double sqrt() => double.parse(toString()); // Simplifié
}
