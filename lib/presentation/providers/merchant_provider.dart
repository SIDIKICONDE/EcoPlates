import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/merchant_details.dart';
import '../../domain/entities/merchant_types.dart';

/// Provider pour récupérer un merchant par son ID
final merchantByIdProvider = Provider.family<Merchant?, String>((ref, merchantId) {
  // TODO: Implémenter le service des merchants
  // Pour l'instant, retourner des données de test
  return Merchant(
    id: merchantId,
    name: 'Restaurant Test',
    description: 'Un excellent restaurant pour réduire le gaspillage alimentaire',
    address: Address(
      street: '123 Rue de la Paix',
      city: 'Paris',
      postalCode: '75001',
      country: 'France',
      latitude: 48.8566,
      longitude: 2.3522,
    ),
    phone: '01 23 45 67 89',
    email: 'contact@restaurant-test.fr',
    category: 'restaurant',
    cuisineType: 'Française',
    rating: 4.5,
    totalReviews: 127,
    imageUrl: 'https://example.com/restaurant.jpg',
    status: MerchantStatus.active,
    verifiedAt: DateTime.now(),
    hasActiveOffer: true,
    availableOffers: 3,
    discountPercentage: 30,
    discountedPrice: 8.50,
    distanceText: '500m',
    isFavorite: false,
    pickupTime: '12:00-14:00',
    latitude: 48.8566,
    longitude: 2.3522,
    createdAt: DateTime.now(),
    phoneNumber: '01 23 45 67 89',
    type: MerchantType.restaurant,
    businessInfo: BusinessInfo(
      registrationNumber: '123456789',
      vatNumber: 'FR123456789',
      openingHours: OpeningHours(schedule: {}),
    ),
    settings: MerchantSettings(),
    stats: MerchantStats(
      totalOffers: 10,
      activeOffers: 3,
      totalReservations: 25,
      completedReservations: 20,
      totalRevenue: 500.0,
      totalCo2Saved: 50.0,
      totalMealsSaved: 100,
      averageRating: 4.5,
    ),
  );
});
