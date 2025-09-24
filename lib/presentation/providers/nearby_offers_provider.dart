import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_offer.dart';

// TODO: Remplacer par un vrai service de géolocalisation
/// Mock provider pour les offres géolocalisées
final nearbyOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  await Future<void>.delayed(const Duration(seconds: 1));
  
  final now = DateTime.now();
  
  return [
    FoodOffer(
      id: 'nearby1',
      title: 'Pain & Viennoiseries du matin',
      merchantName: 'Boulangerie du Centre',
      merchantId: 'merchant1',
      description: 'Assortiment de pains et viennoiseries',
      originalPrice: 12.0,
      discountedPrice: 4.50,
      pickupStartTime: now.add(const Duration(hours: 1, minutes: 30)),
      pickupEndTime: now.add(const Duration(hours: 2, minutes: 30)),
      quantity: 3,
      images: ['https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800'],
      category: FoodCategory.boulangerie,
      type: OfferType.boulangerie,
      status: OfferStatus.available,
      location: const Location(
        latitude: 48.8566,
        longitude: 2.3522,
        address: '12 Rue du Centre',
        city: 'Paris',
        postalCode: '75003',
      ),
      allergens: const [],
      isVegetarian: true,
      isVegan: false,
      availableQuantity: 3,
      merchantAddress: '12 Rue du Centre, 75003 Paris',
      tags: const ['Bio', 'Local'],
      createdAt: now.subtract(const Duration(hours: 2)),
      updatedAt: now.subtract(const Duration(hours: 1)),
      rating: 4.7,
    ),
    FoodOffer(
      id: 'nearby2',
      title: 'Panier surprise du jour',
      merchantName: 'Le Petit Marché Bio',
      merchantId: 'merchant2',
      description: 'Fruits et légumes frais du jour',
      originalPrice: 20.0,
      discountedPrice: 8.0,
      pickupStartTime: now.add(const Duration(minutes: 30)),
      pickupEndTime: now.add(const Duration(hours: 1, minutes: 30)),
      quantity: 5,
      images: const ['https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800'],
      category: FoodCategory.fruitLegume,
      type: OfferType.fruits,
      status: OfferStatus.available,
      location: const Location(
        latitude: 48.8647,
        longitude: 2.3798,
        address: '45 Avenue de la République',
        city: 'Paris',
        postalCode: '75011',
      ),
      allergens: const [],
      isVegetarian: true,
      isVegan: true,
      availableQuantity: 5,
      merchantAddress: '45 Avenue de la République, 75011 Paris',
      tags: const ['Bio', 'Local', 'Zéro déchet'],
      createdAt: now.subtract(const Duration(hours: 1)),
      updatedAt: now.subtract(const Duration(minutes: 30)),
      rating: 4.9,
      isFavorite: true,
    ),
    FoodOffer(
      id: 'nearby3',
      title: 'Sandwich & dessert du midi',
      merchantName: 'Café des Arts',
      merchantId: 'merchant3',
      description: 'Sandwich du jour + dessert maison',
      originalPrice: 15.0,
      discountedPrice: 6.0,
      pickupStartTime: now.add(const Duration(hours: 2)),
      pickupEndTime: now.add(const Duration(hours: 3)),
      quantity: 8,
      images: const ['https://images.unsplash.com/photo-1553909489-cd47e0907980?w=800'],
      category: FoodCategory.dejeuner,
      type: OfferType.plat,
      status: OfferStatus.available,
      location: const Location(
        latitude: 48.8534,
        longitude: 2.3638,
        address: '78 Rue Saint-Antoine',
        city: 'Paris',
        postalCode: '75004',
      ),
      allergens: const ['Gluten', 'Lactose'],
      nutritionalInfo: const {'calories': '450'},
      isVegetarian: false,
      isVegan: false,
      availableQuantity: 2,
      merchantAddress: '78 Rue Saint-Antoine, 75004 Paris',
      tags: const ['Fait maison'],
      createdAt: now.subtract(const Duration(hours: 1, minutes: 30)),
      updatedAt: now.subtract(const Duration(minutes: 45)),
      rating: 4.5,
    ),
  ];
});

// TODO: Implémenter avec geolocator
/// Provider pour la position actuelle de l'utilisateur
final userLocationProvider = StateProvider<({double lat, double lon, String address})?>((ref) {
  // Position mock : Centre de Paris
  return (lat: 48.8566, lon: 2.3522, address: 'Paris, France');
});

/// Provider pour la distance maximale de recherche (en km)
final searchRadiusProvider = StateProvider<double>((ref) => 2.0);
