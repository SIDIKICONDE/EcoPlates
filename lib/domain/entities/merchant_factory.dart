import 'package:flutter/material.dart';
import 'merchant.dart';
import 'merchant_types.dart';
import 'merchant_details.dart';

/// Helper pour créer des Merchants avec des valeurs par défaut
class MerchantFactory {
  /// Crée un Merchant simple avec les valeurs minimum requises
  static Merchant createSimple({
    required String id,
    required String name,
    required String cuisineType,
    required String category,
    String? imageUrl,
    double rating = 0.0,
    required String distanceText,
    bool isFavorite = false,
    bool hasActiveOffer = false,
    int discountPercentage = 0,
    double originalPrice = 0,
    double discountedPrice = 0,
    double minPrice = 0,
    int availableOffers = 0,
    required String pickupTime,
    required double latitude,
    required double longitude,
    String? description,
    String? phone,
    List<String>? tags,
  }) {
    final now = DateTime.now();
    
    return Merchant(
      id: id,
      name: name,
      cuisineType: cuisineType,
      category: category,
      imageUrl: imageUrl,
      rating: rating,
      distanceText: distanceText,
      isFavorite: isFavorite,
      hasActiveOffer: hasActiveOffer,
      discountPercentage: discountPercentage,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      minPrice: minPrice,
      availableOffers: availableOffers,
      pickupTime: pickupTime,
      latitude: latitude,
      longitude: longitude,
      description: description,
      phone: phone,
      tags: tags,
      createdAt: now,
      updatedAt: null,
      // Valeurs par défaut pour les champs étendus
      email: '$id@example.com',
      phoneNumber: phone ?? '+33 1 00 00 00 00',
      type: _getCategoryType(category),
      status: MerchantStatus.active,
      address: Address(
        street: '1 Rue Example',
        city: 'Paris',
        postalCode: '75001',
        country: 'France',
        latitude: latitude,
        longitude: longitude,
      ),
      businessInfo: _createDefaultBusinessInfo(),
      settings: const MerchantSettings(),
      stats: _createDefaultStats(),
      teamMemberIds: [],
      verifiedAt: now.subtract(const Duration(days: 30)),
      certifications: [],
      totalReviews: (rating * 10).toInt(),
    );
  }

  static MerchantType _getCategoryType(String category) {
    switch (category.toLowerCase()) {
      case 'bakery':
        return MerchantType.bakery;
      case 'cafe':
        return MerchantType.cafe;
      case 'sushi':
      case 'restaurant':
      case 'merchant':
        return MerchantType.restaurant;
      case 'pizza':
        return MerchantType.restaurant;
      case 'grocery':
        return MerchantType.grocery;
      case 'supermarket':
        return MerchantType.supermarket;
      default:
        return MerchantType.other;
    }
  }

  static BusinessInfo _createDefaultBusinessInfo() {
    return BusinessInfo(
      registrationNumber: 'REG123456',
      vatNumber: 'FR00123456789',
      website: null,
      description: null,
      specialties: [],
      openingHours: _createDefaultOpeningHours(),
      paymentMethods: ['card', 'cash'],
    );
  }

  static OpeningHours _createDefaultOpeningHours() {
    final defaultSchedule = <DayOfWeek, DayHours>{};
    
    // Horaires du lundi au vendredi
    for (final day in [
      DayOfWeek.monday,
      DayOfWeek.tuesday,
      DayOfWeek.wednesday,
      DayOfWeek.thursday,
      DayOfWeek.friday,
    ]) {
      defaultSchedule[day] = const DayHours(
        isOpen: true,
        openTime: TimeOfDay(hour: 9, minute: 0),
        closeTime: TimeOfDay(hour: 20, minute: 0),
        breakStart: TimeOfDay(hour: 12, minute: 0),
        breakEnd: TimeOfDay(hour: 14, minute: 0),
      );
    }
    
    // Samedi
    defaultSchedule[DayOfWeek.saturday] = const DayHours(
      isOpen: true,
      openTime: TimeOfDay(hour: 10, minute: 0),
      closeTime: TimeOfDay(hour: 18, minute: 0),
    );
    
    // Dimanche fermé
    defaultSchedule[DayOfWeek.sunday] = const DayHours(
      isOpen: false,
    );
    
    return OpeningHours(
      schedule: defaultSchedule,
      holidays: [],
    );
  }

  static MerchantStats _createDefaultStats() {
    return const MerchantStats(
      totalOffers: 0,
      activeOffers: 0,
      totalReservations: 0,
      completedReservations: 0,
      totalRevenue: 0,
      totalCo2Saved: 0,
      totalMealsSaved: 0,
      averageRating: 0,
      dailyStats: {},
    );
  }
}