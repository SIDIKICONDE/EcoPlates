import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';

class OffersCatalogNotifier extends Notifier<List<FoodOffer>> {
  bool _initialized = false;

  @override
  List<FoodOffer> build() {
    // Initialisation sûre: pas d'effets de bord synchrones durant build
    if (!_initialized) {
      _initialized = true;
      state = const <FoodOffer>[];
      // Charger les mocks après le build pour éviter toute boucle de dépendance
      Future.microtask(loadMockData);
    }
    return state;
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

    final startTime6 = _getCurrentRoundedHour().add(const Duration(hours: 4));
    final endTime6 = _getEndTimeFromStart(startTime6);

    final startTime7 = _getCurrentRoundedHour().add(const Duration(hours: 5));
    final endTime7 = _getEndTimeFromStart(startTime7);

    final startTime8 = _getCurrentRoundedHour().add(const Duration(hours: 6));
    final endTime8 = _getEndTimeFromStart(startTime8);

    final startTime9 = _getCurrentRoundedHour().add(const Duration(hours: 7));
    final endTime9 = _getEndTimeFromStart(startTime9);

    final startTime10 = _getCurrentRoundedHour().add(const Duration(hours: 8));
    final endTime10 = _getEndTimeFromStart(startTime10);

    final offers = <FoodOffer>[
      FoodOffer(
        id: '1',
        merchantId: 'merchant1',
        merchantName: 'Le Petit Bistrot',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/Stabucks-Logo.png',
        title: 'Salade César',
        description: 'Salade fraîche avec poulet grillé et parmesan',
        originalPrice: 12.50,
        discountedPrice: 10.50,
        images: const [
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=600&auto=format&q=60&fit=crop',
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
        merchantId: 'merchant2',
        merchantName: 'Pizza Palace',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/McDonalds-logo.png',
        title: 'Pizza Margherita',
        description: 'Pizza traditionnelle avec tomates et mozzarella',
        originalPrice: 14.90,
        discountedPrice: 14.90,
        images: const [
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&auto=format&q=60&fit=crop',
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
          'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=600&auto=format&q=60&fit=crop',
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
          'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&auto=format&q=60&fit=crop',
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
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&q=60&fit=crop',
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

      // Paniers divers
      FoodOffer(
        id: '6',
        merchantId: 'merchant6',
        merchantName: 'Burger House',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/Burger-King-logo.png',
        title: 'Panier Surprise Fruits & Légumes',
        description:
            'Assortiment frais de fruits et légumes de saison à prix réduit',
        originalPrice: 18.90,
        discountedPrice: 12.50,
        images: const [
          'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.fruitLegume,
        status: OfferStatus.available,
        quantity: 8,
        availableQuantity: 8,
        totalQuantity: 10,
        pickupStartTime: startTime6,
        pickupEndTime: endTime6,
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8584,
          longitude: 2.2945,
          address: '45 Boulevard Saint-Michel',
          city: 'Paris',
          postalCode: '75005',
        ),
        merchantAddress: '45 Boulevard Saint-Michel, 75005 Paris',
        tags: const ['Fruits', 'Légumes', 'Bio'],
        co2Saved: 750,
      ),

      FoodOffer(
        id: '7',
        merchantId: 'merchant7',
        merchantName: 'Café Artisan',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/Stabucks-Logo.png',
        title: 'Panier Pâtisserie & Desserts',
        description: 'Sélection de pâtisseries artisanales et desserts maison',
        originalPrice: 25.00,
        discountedPrice: 15.00,
        images: const [
          'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.dessert,
        status: OfferStatus.available,
        quantity: 6,
        availableQuantity: 6,
        totalQuantity: 8,
        pickupStartTime: startTime7,
        pickupEndTime: endTime7,
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        location: const Location(
          latitude: 48.8647,
          longitude: 2.3490,
          address: '12 Rue des Martyrs',
          city: 'Paris',
          postalCode: '75009',
        ),
        merchantAddress: '12 Rue des Martyrs, 75009 Paris',
        tags: const ['Pâtisseries', 'Desserts', 'Artisanal'],
        co2Saved: 400,
      ),

      FoodOffer(
        id: '8',
        merchantId: 'merchant4',
        merchantName: 'Subway',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/Subway-logo.png',
        title: 'Panier Sandwichs & Salades',
        description: 'Assortiment de sandwichs frais et salades préparées',
        originalPrice: 22.50,
        discountedPrice: 16.80,
        images: const [
          'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.dejeuner,
        status: OfferStatus.available,
        quantity: 10,
        availableQuantity: 10,
        totalQuantity: 12,
        pickupStartTime: startTime8,
        pickupEndTime: endTime8,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3211,
          address: '78 Rue Bonaparte',
          city: 'Paris',
          postalCode: '75006',
        ),
        merchantAddress: '78 Rue Bonaparte, 75006 Paris',
        tags: const ['Sandwichs', 'Salades', 'Rapide'],
        co2Saved: 600,
      ),

      FoodOffer(
        id: '9',
        merchantId: 'merchant5',
        merchantName: 'Monoprix',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2020/09/Monoprix-Logo.png',
        title: 'Panier Épicerie Fine',
        description: "Sélection de produits d'épicerie fine et spécialités",
        originalPrice: 35.00,
        discountedPrice: 22.00,
        images: const [
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.epicerie,
        status: OfferStatus.available,
        quantity: 4,
        availableQuantity: 4,
        totalQuantity: 6,
        pickupStartTime: startTime9,
        pickupEndTime: endTime9,
        createdAt: now.subtract(const Duration(hours: 10)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        location: const Location(
          latitude: 48.8518,
          longitude: 2.3399,
          address: '25 Rue de Sèvres',
          city: 'Paris',
          postalCode: '75007',
        ),
        merchantAddress: '25 Rue de Sèvres, 75007 Paris',
        tags: const ['Épicerie', 'Gourmet', 'Spécialités'],
        co2Saved: 900,
      ),

      FoodOffer(
        id: '10',
        merchantId: 'merchant6',
        merchantName: 'Starbucks',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/Stabucks-Logo.png',
        title: 'Panier Petit-déjeuner',
        description: 'Assortiment pour un petit-déjeuner complet et équilibré',
        originalPrice: 16.50,
        discountedPrice: 11.50,
        images: const [
          'https://images.unsplash.com/photo-1559054663-e8c88fb7e5eb?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.boulangerie,
        status: OfferStatus.available,
        quantity: 12,
        availableQuantity: 12,
        totalQuantity: 15,
        pickupStartTime: startTime10,
        pickupEndTime: endTime10,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8698,
          longitude: 2.3076,
          address: '156 Boulevard Haussmann',
          city: 'Paris',
          postalCode: '75008',
        ),
        merchantAddress: '156 Boulevard Haussmann, 75008 Paris',
        tags: const ['Petit-déjeuner', 'Café', 'Pains'],
        co2Saved: 300,
      ),

      // Plats supplémentaires
      FoodOffer(
        id: '11',
        merchantId: 'merchant7',
        merchantName: 'Pizza Hut',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/McDonalds-logo.png',
        title: 'Pizza Pepperoni',
        description: 'Pizza classique avec pepperoni et fromage fondu',
        originalPrice: 16.90,
        discountedPrice: 13.50,
        images: const [
          'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 5,
        availableQuantity: 5,
        totalQuantity: 8,
        pickupStartTime: startTime1,
        pickupEndTime: endTime1,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        location: const Location(
          latitude: 48.8846,
          longitude: 2.3417,
          address: '89 Avenue de la Grande Armée',
          city: 'Paris',
          postalCode: '75016',
        ),
        merchantAddress: '89 Avenue de la Grande Armée, 75016 Paris',
        tags: const ['Pizza', 'Pepperoni', 'Fromage'],
        co2Saved: 850,
      ),

      FoodOffer(
        id: '12',
        merchantId: 'merchant8',
        merchantName: "McDonald's",
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/McDonalds-logo.png',
        title: 'Menu Big Mac',
        description: 'Burger légendaire avec frites et boisson',
        originalPrice: 12.50,
        discountedPrice: 9.90,
        images: const [
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 15,
        availableQuantity: 15,
        totalQuantity: 20,
        pickupStartTime: startTime2,
        pickupEndTime: endTime2,
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        location: const Location(
          latitude: 48.8738,
          longitude: 2.2950,
          address: '123 Champs-Élysées',
          city: 'Paris',
          postalCode: '75008',
        ),
        merchantAddress: '123 Champs-Élysées, 75008 Paris',
        tags: const ['Burger', 'Fast-food', 'Menu'],
      ),

      FoodOffer(
        id: '13',
        merchantId: 'merchant9',
        merchantName: 'KFC',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/KFC-Logo.png',
        title: 'Bucket Poulet',
        description: 'Seau de 8 pièces de poulet frit avec sauces',
        originalPrice: 24.90,
        discountedPrice: 19.90,
        images: const [
          'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 3,
        availableQuantity: 3,
        totalQuantity: 5,
        pickupStartTime: startTime3,
        pickupEndTime: endTime3,
        createdAt: now.subtract(const Duration(hours: 7)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        location: const Location(
          latitude: 48.8584,
          longitude: 2.2945,
          address: '67 Rue de Rivoli',
          city: 'Paris',
          postalCode: '75001',
        ),
        merchantAddress: '67 Rue de Rivoli, 75001 Paris',
        tags: const ['Poulet', 'Frit', 'Bucket'],
        co2Saved: 1200,
      ),

      FoodOffer(
        id: '14',
        merchantId: 'merchant10',
        merchantName: 'Franprix',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2020/09/Franprix-Logo.png',
        title: 'Panier Produits Laitiers',
        description: 'Fromages, yaourts et produits laitiers frais',
        originalPrice: 20.00,
        discountedPrice: 14.00,
        images: const [
          'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.epicerie,
        status: OfferStatus.available,
        quantity: 9,
        availableQuantity: 9,
        totalQuantity: 12,
        pickupStartTime: startTime4,
        pickupEndTime: endTime4,
        createdAt: now.subtract(const Duration(hours: 9)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        location: const Location(
          latitude: 48.8462,
          longitude: 2.3376,
          address: '34 Rue du Bac',
          city: 'Paris',
          postalCode: '75007',
        ),
        merchantAddress: '34 Rue du Bac, 75007 Paris',
        tags: const ['Laitiers', 'Fromages', 'Yaourts'],
        co2Saved: 650,
      ),

      FoodOffer(
        id: '15',
        merchantId: 'merchant11',
        merchantName: 'Auchan',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2020/09/Auchan-Logo.png',
        title: 'Panier Viandes & Poissons',
        description: 'Sélection de viandes et poissons frais de qualité',
        originalPrice: 42.00,
        discountedPrice: 28.00,
        images: const [
          'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.epicerie,
        status: OfferStatus.available,
        quantity: 2,
        availableQuantity: 2,
        totalQuantity: 4,
        pickupStartTime: startTime5,
        pickupEndTime: endTime5,
        createdAt: now.subtract(const Duration(hours: 11)),
        updatedAt: now.subtract(const Duration(hours: 4)),
        location: const Location(
          latitude: 48.8846,
          longitude: 2.3417,
          address: '201 Boulevard Pereire',
          city: 'Paris',
          postalCode: '75017',
        ),
        merchantAddress: '201 Boulevard Pereire, 75017 Paris',
        tags: const ['Viandes', 'Poissons', 'Frais'],
        co2Saved: 1500,
      ),

      // Plus de plats
      FoodOffer(
        id: '16',
        merchantId: 'merchant12',
        merchantName: "L'As du Fallafel",
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/Subway-logo.png',
        title: 'Assiette Fallafel Complet',
        description: 'Fallafels croustillants avec taboulé, houmous et pita',
        originalPrice: 13.50,
        discountedPrice: 10.80,
        images: const [
          'https://images.unsplash.com/photo-1592417817098-8fd3d9eb14ba?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.dejeuner,
        status: OfferStatus.available,
        quantity: 7,
        availableQuantity: 7,
        totalQuantity: 10,
        pickupStartTime: startTime6,
        pickupEndTime: endTime6,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8579,
          longitude: 2.3412,
          address: '34 Rue des Rosiers',
          city: 'Paris',
          postalCode: '75004',
        ),
        merchantAddress: '34 Rue des Rosiers, 75004 Paris',
        tags: const ['Fallafel', 'Libanais', 'Végétarien'],
        isVegetarian: true,
        co2Saved: 400,
      ),

      FoodOffer(
        id: '17',
        merchantId: 'merchant13',
        merchantName: 'Chez Gladines',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2021/04/Paul-logo.png',
        title: 'Couscous Royal',
        description: 'Couscous traditionnel avec agneau, merguez et légumes',
        originalPrice: 18.90,
        discountedPrice: 15.20,
        images: const [
          'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 4,
        availableQuantity: 4,
        totalQuantity: 6,
        pickupStartTime: startTime7,
        pickupEndTime: endTime7,
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        location: const Location(
          latitude: 48.8846,
          longitude: 2.3417,
          address: '30 Rue de Paradis',
          city: 'Paris',
          postalCode: '75010',
        ),
        merchantAddress: '30 Rue de Paradis, 75010 Paris',
        tags: const ['Couscous', 'Marocain', 'Traditionnel'],
        co2Saved: 950,
      ),

      FoodOffer(
        id: '18',
        merchantId: 'merchant14',
        merchantName: 'Sushi Shop',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/KFC-Logo.png',
        title: 'Plateau Sushi Mixte',
        description: 'Assortiment de sushis frais et makis variés',
        originalPrice: 26.50,
        discountedPrice: 21.20,
        images: const [
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 6,
        availableQuantity: 6,
        totalQuantity: 8,
        pickupStartTime: startTime8,
        pickupEndTime: endTime8,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
        location: const Location(
          latitude: 48.8738,
          longitude: 2.2950,
          address: '45 Rue de la Boétie',
          city: 'Paris',
          postalCode: '75008',
        ),
        merchantAddress: '45 Rue de la Boétie, 75008 Paris',
        tags: const ['Sushi', 'Japonais', 'Frais'],
        co2Saved: 700,
      ),

      FoodOffer(
        id: '19',
        merchantId: 'merchant15',
        merchantName: 'Ladurée',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2021/04/Paul-logo.png',
        title: 'Panier Gourmandises',
        description: 'Sélection de macarons et chocolats artisanaux',
        originalPrice: 35.00,
        discountedPrice: 25.00,
        images: const [
          'https://images.unsplash.com/photo-1464305795204-6f5bbfc7fb81?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.dessert,
        status: OfferStatus.available,
        quantity: 3,
        availableQuantity: 3,
        totalQuantity: 5,
        pickupStartTime: startTime9,
        pickupEndTime: endTime9,
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        location: const Location(
          latitude: 48.8647,
          longitude: 2.3490,
          address: '75 Champs-Élysées',
          city: 'Paris',
          postalCode: '75008',
        ),
        merchantAddress: '75 Champs-Élysées, 75008 Paris',
        tags: const ['Macarons', 'Chocolat', 'Gourmand'],
        co2Saved: 350,
      ),

      FoodOffer(
        id: '20',
        merchantId: 'merchant16',
        merchantName: 'Le Grenier de Notre-Dame',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2020/09/Carrefour-Logo.png',
        title: 'Panier Cuisine du Monde',
        description: 'Épices et ingrédients pour cuisiner des plats exotiques',
        originalPrice: 28.50,
        discountedPrice: 19.90,
        images: const [
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.epicerie,
        status: OfferStatus.available,
        quantity: 5,
        availableQuantity: 5,
        totalQuantity: 7,
        pickupStartTime: startTime10,
        pickupEndTime: endTime10,
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        location: const Location(
          latitude: 48.8529,
          longitude: 2.3470,
          address: '18 Rue de la Bûcherie',
          city: 'Paris',
          postalCode: '75005',
        ),
        merchantAddress: '18 Rue de la Bûcherie, 75005 Paris',
        tags: const ['Épices', 'Exotique', 'Cuisine'],
        co2Saved: 550,
      ),

      // Plus de desserts et plats
      FoodOffer(
        id: '21',
        merchantId: 'merchant17',
        merchantName: 'Gelateria dei Gracchi',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2021/04/Picard-logo.png',
        title: 'Glaces Artisanales',
        description: 'Sélection de glaces et sorbets faits maison',
        originalPrice: 8.50,
        discountedPrice: 6.80,
        images: const [
          'https://images.unsplash.com/photo-1501443762994-82bd5dace89a?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.dessert,
        status: OfferStatus.available,
        quantity: 14,
        availableQuantity: 14,
        totalQuantity: 18,
        pickupStartTime: startTime1,
        pickupEndTime: endTime1,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8518,
          longitude: 2.3399,
          address: '15 Rue des Canettes',
          city: 'Paris',
          postalCode: '75006',
        ),
        merchantAddress: '15 Rue des Canettes, 75006 Paris',
        tags: const ['Glaces', 'Italien', 'Artisanal'],
        co2Saved: 200,
      ),

      FoodOffer(
        id: '22',
        merchantId: 'merchant18',
        merchantName: 'Tien Hiang',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/McDonalds-logo.png',
        title: 'Riz Cantonnais aux Crevettes',
        description: 'Riz sauté aux crevettes, légumes et œufs',
        originalPrice: 12.90,
        discountedPrice: 9.70,
        images: const [
          'https://images.unsplash.com/photo-1563379091339-03246963d96c?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 8,
        availableQuantity: 8,
        totalQuantity: 12,
        pickupStartTime: startTime2,
        pickupEndTime: endTime2,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        location: const Location(
          latitude: 48.8647,
          longitude: 2.3490,
          address: '14 Rue de la Grande Truanderie',
          city: 'Paris',
          postalCode: '75001',
        ),
        merchantAddress: '14 Rue de la Grande Truanderie, 75001 Paris',
        tags: const ['Chinois', 'Riz', 'Crevettes'],
        co2Saved: 600,
      ),

      FoodOffer(
        id: '23',
        merchantId: 'merchant19',
        merchantName: "Bio c'Bon",
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2021/04/Picard-logo.png',
        title: 'Panier Bio & Naturel',
        description: 'Produits biologiques et naturels de qualité supérieure',
        originalPrice: 32.00,
        discountedPrice: 24.00,
        images: const [
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.fruitLegume,
        status: OfferStatus.available,
        quantity: 4,
        availableQuantity: 4,
        totalQuantity: 6,
        pickupStartTime: startTime3,
        pickupEndTime: endTime3,
        createdAt: now.subtract(const Duration(hours: 7)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        location: const Location(
          latitude: 48.8584,
          longitude: 2.2945,
          address: '56 Rue Mouffetard',
          city: 'Paris',
          postalCode: '75005',
        ),
        merchantAddress: '56 Rue Mouffetard, 75005 Paris',
        tags: const ['Bio', 'Naturel', 'Écologique'],
        co2Saved: 800,
      ),

      FoodOffer(
        id: '24',
        merchantId: 'merchant20',
        merchantName: 'Caffe Greco',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/Stabucks-Logo.png',
        title: 'Tiramisu Traditionnel',
        description: 'Dessert italien classique au mascarpone et café',
        originalPrice: 7.50,
        discountedPrice: 5.60,
        images: const [
          'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.dessert,
        status: OfferStatus.available,
        quantity: 9,
        availableQuantity: 9,
        totalQuantity: 12,
        pickupStartTime: startTime4,
        pickupEndTime: endTime4,
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        location: const Location(
          latitude: 48.8462,
          longitude: 2.3376,
          address: '10 Rue de Buci',
          city: 'Paris',
          postalCode: '75006',
        ),
        merchantAddress: '10 Rue de Buci, 75006 Paris',
        tags: const ['Tiramisu', 'Italien', 'Café'],
        co2Saved: 250,
      ),

      FoodOffer(
        id: '25',
        merchantId: 'merchant21',
        merchantName: 'Le Grenier de Notre-Dame',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2020/09/Carrefour-Logo.png',
        title: 'Panier Sans Gluten',
        description: 'Produits adaptés aux régimes sans gluten',
        originalPrice: 29.90,
        discountedPrice: 21.40,
        images: const [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.epicerie,
        status: OfferStatus.available,
        quantity: 6,
        availableQuantity: 6,
        totalQuantity: 8,
        pickupStartTime: startTime5,
        pickupEndTime: endTime5,
        createdAt: now.subtract(const Duration(hours: 9)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        location: const Location(
          latitude: 48.8529,
          longitude: 2.3470,
          address: '18 Rue de la Bûcherie',
          city: 'Paris',
          postalCode: '75005',
        ),
        merchantAddress: '18 Rue de la Bûcherie, 75005 Paris',
        tags: const ['Sans gluten', 'Adapté', 'Régime'],
        co2Saved: 650,
      ),

      // Offres urgentes pour testing
      FoodOffer(
        id: '26',
        merchantId: 'merchant22',
        merchantName: 'Quick',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2017/03/Burger-King-logo.png',
        title: 'Menu Royal Cheese URGENT',
        description:
            'Burger emblématique avec frites et boisson - À récupérer rapidement !',
        originalPrice: 11.90,
        discountedPrice: 8.90,
        images: const [
          'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 2,
        availableQuantity: 2,
        totalQuantity: 3,
        pickupStartTime: now.add(const Duration(minutes: 30)),
        pickupEndTime: now.add(const Duration(hours: 1, minutes: 30)),
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8738,
          longitude: 2.2950,
          address: '145 Avenue des Champs-Élysées',
          city: 'Paris',
          postalCode: '75008',
        ),
        merchantAddress: '145 Avenue des Champs-Élysées, 75008 Paris',
        tags: const ['Burger', 'Urgent', 'Fast-food'],
        co2Saved: 450,
      ),

      FoodOffer(
        id: '27',
        merchantId: 'merchant23',
        merchantName: 'Casa Pepe',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2021/04/Paul-logo.png',
        title: 'Paella aux Fruits de Mer URGENTE',
        description: 'Paella espagnole traditionnelle avec fruits de mer frais',
        originalPrice: 22.50,
        discountedPrice: 17.50,
        images: const [
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 1,
        availableQuantity: 1,
        totalQuantity: 2,
        pickupStartTime: now.add(const Duration(minutes: 15)),
        pickupEndTime: now.add(const Duration(hours: 1, minutes: 15)),
        createdAt: now.subtract(const Duration(minutes: 45)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8579,
          longitude: 2.3412,
          address: '5 Rue de la Bastille',
          city: 'Paris',
          postalCode: '75004',
        ),
        merchantAddress: '5 Rue de la Bastille, 75004 Paris',
        tags: const ['Paella', 'Espagnol', 'Fruits de mer'],
        co2Saved: 1100,
      ),

      FoodOffer(
        id: '28',
        merchantId: 'merchant24',
        merchantName: 'Chez Luigi',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2021/04/Picard-logo.png',
        title: 'Lasagnes Bolognaise URGENTES',
        description: 'Lasagnes traditionnelles à la bolognaise maison',
        originalPrice: 15.90,
        discountedPrice: 12.50,
        images: const [
          'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.plat,
        category: FoodCategory.diner,
        status: OfferStatus.available,
        quantity: 3,
        availableQuantity: 3,
        totalQuantity: 4,
        pickupStartTime: now.add(const Duration(minutes: 45)),
        pickupEndTime: now.add(const Duration(hours: 1, minutes: 45)),
        createdAt: now.subtract(const Duration(minutes: 20)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8846,
          longitude: 2.3417,
          address: '23 Rue de Belleville',
          city: 'Paris',
          postalCode: '75019',
        ),
        merchantAddress: '23 Rue de Belleville, 75019 Paris',
        tags: const ['Lasagnes', 'Italien', 'Familial'],
        co2Saved: 750,
      ),

      FoodOffer(
        id: '29',
        merchantId: 'merchant25',
        merchantName: 'Green Deli',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2021/04/Picard-logo.png',
        title: 'Panier Végétarien URGENT',
        description: 'Panier complet végétarien avec légumes bio et tofu',
        originalPrice: 19.90,
        discountedPrice: 14.90,
        images: const [
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.dejeuner,
        status: OfferStatus.available,
        quantity: 2,
        availableQuantity: 2,
        totalQuantity: 3,
        pickupStartTime: now.add(const Duration(minutes: 20)),
        pickupEndTime: now.add(const Duration(hours: 1, minutes: 20)),
        createdAt: now.subtract(const Duration(minutes: 35)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8462,
          longitude: 2.3376,
          address: '8 Rue Cler',
          city: 'Paris',
          postalCode: '75007',
        ),
        merchantAddress: '8 Rue Cler, 75007 Paris',
        tags: const ['Végétarien', 'Bio', 'Urgent'],
        isVegetarian: true,
        isVegan: true,
        co2Saved: 600,
      ),

      FoodOffer(
        id: '30',
        merchantId: 'merchant26',
        merchantName: 'Bakery Corner',
        merchantLogo:
            'https://1000logos.net/wp-content/uploads/2021/04/Paul-logo.png',
        title: 'Croissants et Pains au Chocolat URGENTS',
        description: 'Viennoiseries fraîches du matin à récupérer rapidement',
        originalPrice: 8.50,
        discountedPrice: 6.00,
        images: const [
          'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&auto=format&q=60&fit=crop',
        ],
        type: OfferType.panier,
        category: FoodCategory.boulangerie,
        status: OfferStatus.available,
        quantity: 4,
        availableQuantity: 4,
        totalQuantity: 5,
        pickupStartTime: now.add(const Duration(minutes: 10)),
        pickupEndTime: now.add(const Duration(hours: 1, minutes: 10)),
        createdAt: now.subtract(const Duration(minutes: 50)),
        updatedAt: now,
        location: const Location(
          latitude: 48.8518,
          longitude: 2.3399,
          address: '12 Rue du Four',
          city: 'Paris',
          postalCode: '75006',
        ),
        merchantAddress: '12 Rue du Four, 75006 Paris',
        tags: const ['Viennoiseries', 'Croissants', 'Fraîches'],
        co2Saved: 200,
      ),
    ];

    state = List.unmodifiable(offers);
  }
}

/// Source de vérité unique pour les offres (catalogue partagé)
final offersCatalogProvider =
    NotifierProvider<OffersCatalogNotifier, List<FoodOffer>>(
      OffersCatalogNotifier.new,
    );

/// Provider utilitaire pour rafraîchir le catalogue avec une politique TTL
class OffersRefresher extends Notifier<DateTime?> {
  static const Duration _ttl = Duration(minutes: 5);

  @override
  DateTime? build() => null; // dernière mise à jour

  Future<void> refreshIfStale() async {
    final last = state;
    final now = DateTime.now();
    if (last == null || now.difference(last) > _ttl) {
      await _refreshFromSource();
      state = now;
    }
  }

  Future<void> forceRefresh() async {
    await _refreshFromSource();
    state = DateTime.now();
  }

  Future<void> _refreshFromSource() async {
    // TODO: Brancher sur le repository pour récupérer les vraies offres
    // Pour l’instant, on régénère les données mock (dev)
    ref.read(offersCatalogProvider.notifier).loadMockData();
  }
}

final offersRefreshProvider = NotifierProvider<OffersRefresher, DateTime?>(
  OffersRefresher.new,
);
