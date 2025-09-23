import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/merchant.dart';
import '../../../domain/entities/merchant_factory.dart';
import 'filters_provider.dart';
import 'search_provider.dart';

/// Provider pour gérer le panier
final cartCountProvider = StateProvider<int>((ref) => 0);

/// Provider pour la catégorie sélectionnée
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

/// Provider pour récupérer les merchants à proximité
final nearbyMerchantsProvider = FutureProvider<List<Merchant>>((ref) async {
  // final userLocation = ref.watch(userLocationProvider); // Pour utilisation future avec la géolocalisation
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final filters = ref.watch(activeFiltersProvider);

  // Simuler un appel API
  await Future.delayed(const Duration(seconds: 1));

  // Données de démonstration
  List<Merchant> merchants = [
    MerchantFactory.createSimple(
      id: '1',
      name: 'Boulangerie Artisanale',
      cuisineType: 'Pains et viennoiseries',
      category: 'bakery',
      imageUrl:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
      rating: 4.8,
      distanceText: '250m',
      isFavorite: true,
      hasActiveOffer: true,
      discountPercentage: 50,
      originalPrice: 12.0,
      discountedPrice: 6.0,
      minPrice: 3.0,
      availableOffers: 3,
      pickupTime: '18:30 - 19:00',
      latitude: 48.8566,
      longitude: 2.3522,
    ),
    MerchantFactory.createSimple(
      id: '2',
      name: 'Sushi Master',
      cuisineType: 'Japonais',
      category: 'sushi',
      imageUrl:
          'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      rating: 4.5,
      distanceText: '1.2km',
      hasActiveOffer: true,
      discountPercentage: 40,
      originalPrice: 25.0,
      discountedPrice: 15.0,
      minPrice: 10.0,
      availableOffers: 5,
      pickupTime: '19:00 - 20:00',
      latitude: 48.8606,
      longitude: 2.3376,
    ),
    MerchantFactory.createSimple(
      id: '3',
      name: 'Le Bistrot du Coin',
      cuisineType: 'Français traditionnel',
      category: 'Merchant',
      imageUrl:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
      rating: 4.3,
      distanceText: '800m',
      hasActiveOffer: true,
      discountPercentage: 30,
      originalPrice: 18.0,
      discountedPrice: 12.60,
      minPrice: 8.0,
      availableOffers: 2,
      pickupTime: '14:00 - 15:00',
      latitude: 48.8584,
      longitude: 2.3417,
    ),
    MerchantFactory.createSimple(
      id: '4',
      name: 'Pizza Express',
      cuisineType: 'Italien',
      category: 'pizza',
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      rating: 4.6,
      distanceText: '500m',
      isFavorite: true,
      hasActiveOffer: true,
      discountPercentage: 45,
      originalPrice: 15.0,
      discountedPrice: 8.25,
      minPrice: 5.0,
      availableOffers: 4,
      pickupTime: '20:30 - 21:00',
      latitude: 48.8530,
      longitude: 2.3499,
    ),
    MerchantFactory.createSimple(
      id: '5',
      name: 'Café de la Gare',
      cuisineType: 'Café & Snacks',
      category: 'cafe',
      imageUrl:
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
      rating: 4.2,
      distanceText: '350m',
      hasActiveOffer: true,
      discountPercentage: 60,
      originalPrice: 8.0,
      discountedPrice: 3.20,
      minPrice: 2.0,
      availableOffers: 6,
      pickupTime: '16:00 - 17:00',
      latitude: 48.8549,
      longitude: 2.3488,
    ),
    MerchantFactory.createSimple(
      id: '6',
      name: 'Épicerie Bio',
      cuisineType: 'Produits bio',
      category: 'grocery',
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      rating: 4.7,
      distanceText: '1.5km',
      hasActiveOffer: true,
      discountPercentage: 35,
      originalPrice: 20.0,
      discountedPrice: 13.0,
      minPrice: 7.0,
      availableOffers: 8,
      pickupTime: '18:00 - 19:30',
      latitude: 48.8620,
      longitude: 2.3333,
    ),
    MerchantFactory.createSimple(
      id: '7',
      name: 'Pâtisserie Delice',
      cuisineType: 'Desserts et gâteaux',
      category: 'bakery',
      imageUrl:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
      rating: 4.9,
      distanceText: '900m',
      isFavorite: true,
      hasActiveOffer: true,
      discountPercentage: 55,
      originalPrice: 16.0,
      discountedPrice: 7.20,
      minPrice: 4.0,
      availableOffers: 2,
      pickupTime: '17:30 - 18:00',
      latitude: 48.8590,
      longitude: 2.3470,
    ),
    MerchantFactory.createSimple(
      id: '8',
      name: 'Traiteur Asiatique',
      cuisineType: 'Cuisine asiatique',
      category: 'Merchant',
      imageUrl:
          'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400',
      rating: 4.4,
      distanceText: '1.8km',
      hasActiveOffer: false,
      discountPercentage: 0,
      originalPrice: 0,
      discountedPrice: 0,
      minPrice: 9.0,
      availableOffers: 0,
      pickupTime: '12:00 - 13:00',
      latitude: 48.8635,
      longitude: 2.3290,
    ),
    MerchantFactory.createSimple(
      id: '9',
      name: 'Burger & Co',
      cuisineType: 'Fast food',
      category: 'Merchant',
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      rating: 4.1,
      distanceText: '600m',
      hasActiveOffer: true,
      discountPercentage: 40,
      originalPrice: 14.0,
      discountedPrice: 8.40,
      minPrice: 6.0,
      availableOffers: 5,
      pickupTime: '21:00 - 21:30',
      latitude: 48.8570,
      longitude: 2.3456,
    ),
    MerchantFactory.createSimple(
      id: '10',
      name: 'Smoothie Paradise',
      cuisineType: 'Boissons et jus',
      category: 'cafe',
      imageUrl: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400',
      rating: 4.6,
      distanceText: '400m',
      hasActiveOffer: true,
      discountPercentage: 50,
      originalPrice: 10.0,
      discountedPrice: 5.0,
      minPrice: 3.0,
      availableOffers: 7,
      pickupTime: '15:00 - 16:00',
      latitude: 48.8555,
      longitude: 2.3510,
    ),
    MerchantFactory.createSimple(
      id: '11',
      name: 'Green Garden Végé',
      cuisineType: 'Végétarien bio',
      category: 'Merchant',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      rating: 4.8,
      distanceText: '550m',
      isFavorite: true,
      hasActiveOffer: true,
      discountPercentage: 45,
      originalPrice: 12.0,
      discountedPrice: 6.60,
      minPrice: 5.0,
      availableOffers: 4,
      pickupTime: '19:00 - 20:00',
      latitude: 48.8560,
      longitude: 2.3500,
    ),
    MerchantFactory.createSimple(
      id: '12',
      name: 'Bio Market',
      cuisineType: 'Produits bio et vegan',
      category: 'grocery',
      imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400',
      rating: 4.7,
      distanceText: '700m',
      hasActiveOffer: true,
      discountPercentage: 60,
      originalPrice: 8.0,
      discountedPrice: 3.20,
      minPrice: 2.0,
      availableOffers: 2,
      pickupTime: '20:30 - 21:00',
      latitude: 48.8575,
      longitude: 2.3485,
    ),
    MerchantFactory.createSimple(
      id: '13',
      name: 'Quick Bite',
      cuisineType: 'Sandwichs économiques',
      category: 'Merchant',
      imageUrl: 'https://images.unsplash.com/photo-1553909489-cd47e0907980?w=400',
      rating: 4.0,
      distanceText: '300m',
      hasActiveOffer: true,
      discountPercentage: 65,
      originalPrice: 7.0,
      discountedPrice: 2.45,
      minPrice: 2.0,
      availableOffers: 1,
      pickupTime: '21:30 - 22:00',
      latitude: 48.8540,
      longitude: 2.3520,
    ),
    MerchantFactory.createSimple(
      id: '14',
      name: 'Veggie Delight',
      cuisineType: 'Cuisine végétale',
      category: 'Merchant',
      imageUrl: 'https://images.unsplash.com/photo-1609501676725-7186f017a4b7?w=400',
      rating: 4.9,
      distanceText: '450m',
      isFavorite: true,
      hasActiveOffer: true,
      discountPercentage: 55,
      originalPrice: 15.0,
      discountedPrice: 6.75,
      minPrice: 5.0,
      availableOffers: 3,
      pickupTime: '18:00 - 19:00',
      latitude: 48.8565,
      longitude: 2.3495,
    ),
    MerchantFactory.createSimple(
      id: '15',
      name: 'Budget Meal',
      cuisineType: 'Plats du jour',
      category: 'Merchant',
      imageUrl: 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=400',
      rating: 3.9,
      distanceText: '800m',
      hasActiveOffer: true,
      discountPercentage: 70,
      originalPrice: 12.0,
      discountedPrice: 3.60,
      minPrice: 3.0,
      availableOffers: 1,
      pickupTime: '22:00 - 22:30',
      latitude: 48.8585,
      longitude: 2.3475,
    ),
  ];

  // Filtrer par catégorie
  if (selectedCategory != 'all') {
    merchants = merchants
        .where((r) => r.category == selectedCategory)
        .toList();
  }

  // Filtrer par recherche
  if (searchQuery.isNotEmpty) {
    merchants = merchants
        .where(
          (r) =>
              r.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              r.cuisineType.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  // Appliquer les filtres supplémentaires
  if (filters != null) {
    // Filtrer par distance
    if (filters['maxDistance'] != null) {
      // Convertir la distance text en nombre pour le filtre
      merchants = merchants.where((r) {
        final distanceStr = r.distanceText.replaceAll(RegExp(r'[^0-9.]'), '');
        final distance = double.tryParse(distanceStr) ?? 0;
        final distanceKm =
            r.distanceText.contains('m') && !r.distanceText.contains('km')
            ? distance / 1000
            : distance;
        return distanceKm <= filters['maxDistance'];
      }).toList();
    }

    // Filtrer par prix
    if (filters['maxPrice'] != null) {
      merchants = merchants
          .where(
            (r) => r.hasActiveOffer
                ? r.discountedPrice <= filters['maxPrice']
                : r.minPrice <= filters['maxPrice'],
          )
          .toList();
    }

    // Filtrer par favoris uniquement
    if (filters['favoritesOnly'] == true) {
      merchants = merchants.where((r) => r.isFavorite).toList();
    }
  }

  // Trier par distance
  merchants.sort((a, b) {
    final aDistance = _parseDistance(a.distanceText);
    final bDistance = _parseDistance(b.distanceText);
    return aDistance.compareTo(bDistance);
  });

  return merchants;
});

double _parseDistance(String distanceText) {
  final distanceStr = distanceText.replaceAll(RegExp(r'[^0-9.]'), '');
  final distance = double.tryParse(distanceStr) ?? 0;
  return distanceText.contains('m') && !distanceText.contains('km')
      ? distance / 1000
      : distance;
}

/// Provider pour obtenir un Merchant spécifique
final merchantByIdProvider = Provider.family<Merchant?, String>((ref, id) {
  final merchantsAsync = ref.watch(nearbyMerchantsProvider);
  return merchantsAsync.when(
    data: (merchants) => merchants.firstWhere(
      (r) => r.id == id,
      orElse: () => throw Exception('Merchant non trouvé'),
    ),
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider pour les Merchants favoris
final favoriteMerchantsProvider = FutureProvider<List<Merchant>>((
  ref,
) async {
  final allMerchants = await ref.watch(nearbyMerchantsProvider.future);
  return allMerchants.where((r) => r.isFavorite).toList();
});

/// Provider pour les statistiques des Merchants
final merchantStatsProvider = Provider<MerchantStats>((ref) {
  final merchantsAsync = ref.watch(nearbyMerchantsProvider);

  return merchantsAsync.when(
    data: (merchants) {
      final totalMerchants = merchants.length;
      final availableOffers = merchants.where((r) => r.hasActiveOffer).length;
      final totalSavings = merchants
          .where((r) => r.hasActiveOffer)
          .fold<double>(
            0,
            (sum, r) => sum + (r.originalPrice - r.discountedPrice),
          );

      return MerchantStats(
        totalMerchants: totalMerchants,
        availableOffers: availableOffers,
        totalSavings: totalSavings,
      );
    },
    loading: () => MerchantStats(
      totalMerchants: 0,
      availableOffers: 0,
      totalSavings: 0,
    ),
    error: (_, __) => MerchantStats(
      totalMerchants: 0,
      availableOffers: 0,
      totalSavings: 0,
    ),
  );
});

class MerchantStats {
  final int totalMerchants;
  final int availableOffers;
  final double totalSavings;

  MerchantStats({
    required this.totalMerchants,
    required this.availableOffers,
    required this.totalSavings,
  });
}

