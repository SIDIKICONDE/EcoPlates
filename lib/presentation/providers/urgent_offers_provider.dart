import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_offer.dart';

/// Provider pour les offres urgentes à sauver
final urgentOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  // Simuler un appel API
  await Future<void>.delayed(const Duration(milliseconds: 500));
  
  // Données mockées pour les offres qui expirent bientôt
  final now = DateTime.now();
  return [
    FoodOffer(
      id: 'urgent-1',
      merchantId: 'm1',
      merchantName: 'Boulangerie Artisanale',
      title: 'Viennoiseries du matin',
      description: 'Croissants, pains au chocolat et pains aux raisins',
      images: ['https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400'],
      type: OfferType.boulangerie,
      category: FoodCategory.boulangerie,
      originalPrice: 8.50,
      discountedPrice: 2.99,
      merchantAddress: '78 rue de la Boulangerie, 75012 Paris',
      quantity: 2, // Presque épuisé !
      pickupStartTime: now.add(const Duration(minutes: 30)),
      pickupEndTime: now.add(const Duration(hours: 1, minutes: 30)), // Expire très bientôt !
      createdAt: now.subtract(const Duration(hours: 4)),
      status: OfferStatus.available,
      location: const Location(
        latitude: 48.8566,
        longitude: 2.3522,
        address: '23 rue de la Paix',
        city: 'Paris',
        postalCode: '75002',
      ),
      co2Saved: 450,
      updatedAt: now.subtract(const Duration(hours: 4)),
    ),
    FoodOffer(
      id: 'urgent-2',
      merchantId: 'm2',
      merchantName: 'Sushi Shop',
      title: 'Plateau sushi du midi',
      description: 'Assortiment de makis et sashimis frais du jour',
      images: ['https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400'],
      type: OfferType.plat,
      category: FoodCategory.dejeuner,
      originalPrice: 24.90,
      discountedPrice: 9.99,
      merchantAddress: '34 rue du Restaurant, 75013 Paris',
      quantity: 1, // Dernier disponible !
      pickupStartTime: now,
      pickupEndTime: now.add(const Duration(minutes: 45)), // Urgent !
      createdAt: now.subtract(const Duration(hours: 2)),
      status: OfferStatus.available,
      location: const Location(
        latitude: 48.8584,
        longitude: 2.3545,
        address: '15 boulevard Haussmann',
        city: 'Paris',
        postalCode: '75009',
      ),
      allergens: ['poisson', 'soja'],
      co2Saved: 800,
      updatedAt: now.subtract(const Duration(hours: 2)),
    ),
    FoodOffer(
      id: 'urgent-3',
      merchantId: 'm3',
      merchantName: 'Picard',
      title: 'Panier surgelés à date courte',
      description: 'Plats préparés et légumes surgelés à consommer rapidement',
      images: ['https://images.unsplash.com/photo-1600850056064-a8b380df8395?w=400'],
      type: OfferType.panier,
      category: FoodCategory.diner,
      originalPrice: 18,
      discountedPrice: 5.50,
      merchantAddress: '56 avenue du Marché, 75014 Paris',
      quantity: 3,
      pickupStartTime: now.add(const Duration(minutes: 15)),
      pickupEndTime: now.add(const Duration(hours: 1, minutes: 15)),
      createdAt: now.subtract(const Duration(hours: 1)),
      status: OfferStatus.available,
      location: const Location(
        latitude: 48.8530,
        longitude: 2.3499,
        address: '82 avenue de la République',
        city: 'Paris',
        postalCode: '75011',
      ),
      co2Saved: 1000,
      updatedAt: now.subtract(const Duration(hours: 1)),
    ),
    FoodOffer(
      id: 'urgent-4',
      merchantId: 'm4',
      merchantName: 'Café de Flore',
      title: 'Sandwich & dessert du jour',
      description: 'Sandwich jambon-beurre et éclair au chocolat',
      images: ['https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400'],
      type: OfferType.plat,
      category: FoodCategory.dejeuner,
      originalPrice: 12.50,
      discountedPrice: 4,
      merchantAddress: '12 rue de la Gare, 75015 Paris',
      quantity: 4,
      pickupStartTime: now,
      pickupEndTime: now.add(const Duration(hours: 2)),
      createdAt: now.subtract(const Duration(hours: 3)),
      status: OfferStatus.available,
      location: const Location(
        latitude: 48.8540,
        longitude: 2.3333,
        address: '172 boulevard Saint-Germain',
        city: 'Paris',
        postalCode: '75006',
      ),
      co2Saved: 350,
      updatedAt: now.subtract(const Duration(hours: 3)),
    ),
  ];
});
