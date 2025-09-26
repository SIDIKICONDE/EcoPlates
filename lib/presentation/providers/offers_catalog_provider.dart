import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';

class OffersCatalogNotifier extends Notifier<List<FoodOffer>> {
  @override
  List<FoodOffer> build() {
    loadMockData();
    return const [];
  }

  // Méthode pour obtenir l'heure actuelle arrondie à l'heure suivante
  DateTime _getCurrentRoundedHour() {
    final now = DateTime.now();
    final nextHour = now.hour + 1;
    return DateTime(
      now.year,
      now.month,
      now.day,
      nextHour >= 24 ? 0 : nextHour,
    );
  }

  // Méthode pour obtenir l'heure de fin (2 heures après le début)
  DateTime _getEndTimeFromStart(DateTime startTime) {
    final endTime = startTime.add(const Duration(hours: 2));
    return endTime;
  }

  void set(List<FoodOffer> offers) => state = List.unmodifiable(offers);

  void upsert(FoodOffer offer) {
    final idx = state.indexWhere((o) => o.id == offer.id);
    if (idx >= 0) {
      final newState = [...state];
      newState[idx] = offer;
      state = List.unmodifiable(newState);
    } else {
      state = List.unmodifiable([...state, offer]);
    }
  }

  void delete(String id) {
    state = List.unmodifiable(state.where((o) => o.id != id).toList());
  }

  void toggleStatus(String id) {
    final idx = state.indexWhere((o) => o.id == id);
    if (idx < 0) return;
    final offer = state[idx];
    final isAvailable = offer.isAvailable;
    final newStatus = isAvailable
        ? OfferStatus.cancelled
        : OfferStatus.available;
    upsert(offer.copyWith(status: newStatus, updatedAt: DateTime.now()));
  }

  void updateQuantity(String id, int newQuantity) {
    final idx = state.indexWhere((o) => o.id == id);
    if (idx < 0) return;
    final offer = state[idx];
    upsert(offer.copyWith(quantity: newQuantity, updatedAt: DateTime.now()));
  }

  void updatePromotionPercent(String id, double? discountPercent) {
    final idx = state.indexWhere((o) => o.id == id);
    if (idx < 0) return;
    final offer = state[idx];
    if (discountPercent == null || discountPercent <= 0) {
      upsert(
        offer.copyWith(
          discountedPrice: offer.originalPrice,
          updatedAt: DateTime.now(),
        ),
      );
      return;
    }
    final discounted = (offer.originalPrice * (1 - discountPercent / 100))
        .clamp(0, offer.originalPrice)
        .toDouble();
    upsert(
      offer.copyWith(discountedPrice: discounted, updatedAt: DateTime.now()),
    );
  }

  // Données mock pour dev
  void loadMockData() {
    final now = DateTime.now();

    // Créer des horaires dynamiques pour chaque offre
    final startTime1 = _getCurrentRoundedHour();
    final endTime1 = _getEndTimeFromStart(startTime1);

    final startTime2 = _getCurrentRoundedHour().add(const Duration(hours: 1));
    final endTime2 = _getEndTimeFromStart(startTime2);

    final startTime3 = _getCurrentRoundedHour().add(const Duration(hours: 2));
    final endTime3 = _getEndTimeFromStart(startTime3);

    final startTime4 = _getCurrentRoundedHour().add(
      const Duration(hours: -1),
    ); // Heure passée pour test
    final endTime4 = _getEndTimeFromStart(startTime4);

    final startTime5 = _getCurrentRoundedHour().add(const Duration(hours: 3));
    final endTime5 = _getEndTimeFromStart(startTime5);

    final offers = <FoodOffer>[
      FoodOffer(
        id: '1',
        merchantId: 'merchant1',
        merchantName: 'Le Petit Bistrot',
        title: 'Salade César',
        description: 'Salade fraîche avec poulet grillé et parmesan',
        originalPrice: 12.50,
        discountedPrice: 10.50,
        images: const [
          'https://images.unsplash.com/photo-1546793665-c74683f339c1',
        ],
        type: OfferType.plat,
        category: FoodCategory.dejeuner,
        status: OfferStatus.available,
        quantity: 15,
        availableQuantity: 15,
        totalQuantity: 15,
        pickupStartTime: startTime1,
        pickupEndTime: endTime1,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: '123 Rue de la Paix',
          city: 'Paris',
          postalCode: '75001',
        ),
        merchantAddress: '123 Rue de la Paix, 75001 Paris',
        tags: const ['Salades', 'Plats légers'],
        co2Saved: 650,
      ),
      FoodOffer(
        id: '2',
        merchantId: 'merchant1',
        merchantName: 'Le Petit Bistrot',
        title: 'Pizza Margherita',
        description: 'Pizza traditionnelle avec tomates et mozzarella',
        originalPrice: 14.90,
        discountedPrice: 14.90,
        images: const [
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 8,
        availableQuantity: 8,
        totalQuantity: 10,
        pickupStartTime: startTime2,
        pickupEndTime: endTime2,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: '123 Rue de la Paix',
          city: 'Paris',
          postalCode: '75001',
        ),
        merchantAddress: '123 Rue de la Paix, 75001 Paris',
        tags: const ['Pizzas', 'Plats chauds'],
        isVegetarian: true,
        co2Saved: 800,
      ),
      FoodOffer(
        id: '3',
        merchantId: 'merchant1',
        merchantName: 'Le Petit Bistrot',
        title: 'Sandwich Club',
        description: 'Sandwich triple avec poulet, bacon et œuf',
        originalPrice: 9.90,
        discountedPrice: 7.90,
        images: const [
          'https://images.unsplash.com/photo-1528735602780-2552fd46c7af',
        ],
        type: OfferType.plat,
        category: FoodCategory.dejeuner,
        status: OfferStatus.available,
        quantity: 3,
        availableQuantity: 3,
        totalQuantity: 5,
        pickupStartTime: startTime3,
        pickupEndTime: endTime3,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: '123 Rue de la Paix',
          city: 'Paris',
          postalCode: '75001',
        ),
        merchantAddress: '123 Rue de la Paix, 75001 Paris',
        tags: const ['Sandwichs', 'Plats rapides'],
        co2Saved: 450,
      ),
      FoodOffer(
        id: '4',
        merchantId: 'merchant1',
        merchantName: 'Le Petit Bistrot',
        title: 'Tiramisu maison',
        description: 'Dessert italien au café et mascarpone',
        originalPrice: 6.50,
        discountedPrice: 5.20,
        images: const [
          'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9',
        ],
        type: OfferType.plat,
        category: FoodCategory.dessert,
        status: OfferStatus.expired,
        quantity: 0,
        totalQuantity: 10,
        pickupStartTime: startTime4,
        pickupEndTime: endTime4,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: '123 Rue de la Paix',
          city: 'Paris',
          postalCode: '75001',
        ),
        merchantAddress: '123 Rue de la Paix, 75001 Paris',
        tags: const ['Desserts'],
        co2Saved: 250,
      ),
      FoodOffer(
        id: '5',
        merchantId: 'merchant1',
        merchantName: 'Le Petit Bistrot',
        title: 'Bowl Végétarien',
        description: 'Bowl complet avec quinoa, légumes grillés et houmous',
        originalPrice: 11.50,
        discountedPrice: 11.50,
        images: const [
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
        ],
        type: OfferType.plat,
        category: FoodCategory.dejeuner,
        status: OfferStatus.available,
        quantity: 12,
        availableQuantity: 12,
        totalQuantity: 15,
        pickupStartTime: startTime5,
        pickupEndTime: endTime5,
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: '123 Rue de la Paix',
          city: 'Paris',
          postalCode: '75001',
        ),
        merchantAddress: '123 Rue de la Paix, 75001 Paris',
        tags: const ['Bowls', 'Végétarien'],
        isVegetarian: true,
        isVegan: true,
        co2Saved: 550,
      ),
    ];

    state = List.unmodifiable(offers);
  }
}

/// Source de vérité unique pour les offres (catalogue partagé)
final offersCatalogProvider = NotifierProvider<OffersCatalogNotifier, List<FoodOffer>>(
  OffersCatalogNotifier.new,
);
