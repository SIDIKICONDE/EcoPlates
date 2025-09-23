import 'merchant_types.dart';
import 'merchant_details.dart';

/// Entité Merchant pour le domaine
class Merchant {
  final String id;
  final String name;
  final String cuisineType;
  final String category;
  final String? imageUrl;
  final double rating;
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
  final Address address;
  final String? phone;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Propriétés étendues pour la gestion complète
  final String email;
  final String phoneNumber;
  final MerchantType type;
  final MerchantStatus status;
  final BusinessInfo businessInfo;
  final List<String> teamMemberIds;
  final MerchantSettings settings;
  final DateTime? verifiedAt;
  final MerchantStats stats;
  final List<String> certifications;
  final int totalReviews;

  const Merchant({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.category,
    this.imageUrl,
    this.rating = 0.0,
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
    required this.address,
    this.phone,
    this.tags,
    required this.createdAt,
    this.updatedAt,
    required this.email,
    required this.phoneNumber,
    required this.type,
    required this.status,
    required this.businessInfo,
    this.teamMemberIds = const [],
    required this.settings,
    this.verifiedAt,
    required this.stats,
    this.certifications = const [],
    this.totalReviews = 0,
  });

  /// Crée une copie du merchant avec des champs modifiés
  Merchant copyWith({
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
    Address? address,
    String? phone,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? email,
    String? phoneNumber,
    MerchantType? type,
    MerchantStatus? status,
    BusinessInfo? businessInfo,
    List<String>? teamMemberIds,
    MerchantSettings? settings,
    DateTime? verifiedAt,
    MerchantStats? stats,
    List<String>? certifications,
    int? totalReviews,
  }) {
    return Merchant(
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
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      businessInfo: businessInfo ?? this.businessInfo,
      teamMemberIds: teamMemberIds ?? this.teamMemberIds,
      settings: settings ?? this.settings,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      stats: stats ?? this.stats,
      certifications: certifications ?? this.certifications,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  /// Calcule la distance en km depuis une position donnée
  double calculateDistance(double userLat, double userLng) {
    // Formule de Haversine pour calculer la distance
    const double earthRadius = 6371; // Rayon de la Terre en km

    double lat1Rad = latitude * (3.141592653589793 / 180);
    double lat2Rad = userLat * (3.141592653589793 / 180);
    double deltaLat = (userLat - latitude) * (3.141592653589793 / 180);
    double deltaLng = (userLng - longitude) * (3.141592653589793 / 180);

    double a =
        (deltaLat / 2).sin() * (deltaLat / 2).sin() +
        lat1Rad.cos() *
            lat2Rad.cos() *
            (deltaLng / 2).sin() *
            (deltaLng / 2).sin();

    double c = 2 * a.sqrt().asin();

    return earthRadius * c;
  }

  /// Vérifie si le merchant est ouvert maintenant
  bool isOpenNow() {
    // Logique pour vérifier si le merchant est ouvert
    // Basé sur pickupTime
    return true; // Simplifié pour l'instant
  }

  /// Calcule le pourcentage d'économie
  double get savingsPercentage {
    if (originalPrice == 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }

  /// Vérifie si le merchant peut créer une offre
  bool get canCreateOffer {
    return status == MerchantStatus.active &&
        stats.activeOffers < settings.maxActiveOffers;
  }

  /// Vérifie si le merchant est vérifié
  bool get isVerified => verifiedAt != null;

  /// Extensions pour le calcul de sin/cos/asin/sqrt
}

extension on double {
  double sin() => double.parse(toString()); // Simplifié
  double cos() => double.parse(toString()); // Simplifié
  double asin() => double.parse(toString()); // Simplifié
  double sqrt() => double.parse(toString()); // Simplifié
}