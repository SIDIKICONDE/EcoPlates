import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/merchant.dart';
import '../../../domain/entities/merchant_details.dart';
import '../../../domain/entities/merchant_types.dart';
import '../merchant_card.dart';

/// Provider temporaire pour les marchands proches
final nearbyMerchantsProvider = Provider<AsyncValue<List<Merchant>>>((ref) {
  // Données de test temporaires
  return AsyncValue.data([
    Merchant(
      id: 'merchant-1',
      name: 'Chez Marie',
      description: 'Restaurant traditionnel français avec des plats faits maison',
      address: Address(
        street: '15 Rue des Roses',
        city: 'Paris',
        postalCode: '75001',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522,
      ),
      phone: '01 42 33 44 55',
      email: 'contact@chezmarie.fr',
      category: 'restaurant',
      cuisineType: 'Française',
      rating: 4.7,
      totalReviews: 234,
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&h=600&fit=crop',
      status: MerchantStatus.active,
      verifiedAt: DateTime.now().subtract(const Duration(days: 30)),
      hasActiveOffer: true,
      availableOffers: 5,
      discountPercentage: 25,
      discountedPrice: 12.50,
      distanceText: '300m',
      isFavorite: false,
      pickupTime: '11:30-13:30',
      latitude: 48.8566,
      longitude: 2.3522,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      phoneNumber: '01 42 33 44 55',
      type: MerchantType.restaurant,
      businessInfo: BusinessInfo(
        registrationNumber: '987654321',
        vatNumber: 'FR987654321',
        openingHours: OpeningHours(schedule: {}),
      ),
      settings: MerchantSettings(),
      stats: MerchantStats(
        totalOffers: 15,
        activeOffers: 5,
        totalReservations: 45,
        completedReservations: 42,
        totalRevenue: 750.0,
        totalCo2Saved: 75.0,
        totalMealsSaved: 150,
        averageRating: 4.7,
      ),
    ),
    Merchant(
      id: 'merchant-2',
      name: 'Boulangerie Bio',
      description: 'Boulangerie artisanale avec produits biologiques',
      address: Address(
        street: '28 Avenue des Champs',
        city: 'Paris',
        postalCode: '75008',
        country: 'France',
        latitude: 48.8606,
        longitude: 2.3376,
      ),
      phone: '01 45 67 89 01',
      email: 'contact@boulangerie-bio.fr',
      category: 'bakery',
      cuisineType: 'Boulangerie Bio',
      rating: 4.5,
      totalReviews: 156,
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&h=600&fit=crop',
      status: MerchantStatus.active,
      verifiedAt: DateTime.now().subtract(const Duration(days: 60)),
      hasActiveOffer: true,
      availableOffers: 8,
      discountPercentage: 30,
      discountedPrice: 3.50,
      distanceText: '500m',
      isFavorite: true,
      pickupTime: '08:00-18:00',
      latitude: 48.8606,
      longitude: 2.3376,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      phoneNumber: '01 45 67 89 01',
      type: MerchantType.bakery,
      businessInfo: BusinessInfo(
        registrationNumber: '456789123',
        vatNumber: 'FR456789123',
        openingHours: OpeningHours(schedule: {}),
      ),
      settings: MerchantSettings(),
      stats: MerchantStats(
        totalOffers: 20,
        activeOffers: 8,
        totalReservations: 32,
        completedReservations: 30,
        totalRevenue: 450.0,
        totalCo2Saved: 45.0,
        totalMealsSaved: 90,
        averageRating: 4.5,
      ),
    ),
    Merchant(
      id: 'merchant-3',
      name: 'Épicerie du Coin',
      description: 'Épicerie locale avec produits frais et de saison',
      address: Address(
        street: '7 Place de la Gare',
        city: 'Paris',
        postalCode: '75013',
        country: 'France',
        latitude: 48.8365,
        longitude: 2.3770,
      ),
      phone: '01 53 24 68 97',
      email: 'contact@epicerie-coin.fr',
      category: 'grocery',
      cuisineType: 'Épicerie',
      rating: 4.3,
      totalReviews: 89,
      imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&h=600&fit=crop',
      status: MerchantStatus.active,
      verifiedAt: DateTime.now().subtract(const Duration(days: 90)),
      hasActiveOffer: true,
      availableOffers: 12,
      discountPercentage: 20,
      discountedPrice: 8.90,
      distanceText: '800m',
      isFavorite: false,
      pickupTime: '09:00-19:00',
      latitude: 48.8365,
      longitude: 2.3770,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      phoneNumber: '01 53 24 68 97',
      type: MerchantType.grocery,
      businessInfo: BusinessInfo(
        registrationNumber: '789123456',
        vatNumber: 'FR789123456',
        openingHours: OpeningHours(schedule: {}),
      ),
      settings: MerchantSettings(),
      stats: MerchantStats(
        totalOffers: 25,
        activeOffers: 12,
        totalReservations: 28,
        completedReservations: 25,
        totalRevenue: 320.0,
        totalCo2Saved: 32.0,
        totalMealsSaved: 64,
        averageRating: 4.3,
      ),
    ),
    Merchant(
      id: 'merchant-4',
      name: 'Au Pain Doré',
      description: 'Boulangerie artisanale avec pains bio et viennoiseries',
      address: Address(
        street: '42 Rue Saint-Honoré',
        city: 'Paris',
        postalCode: '75001',
        country: 'France',
        latitude: 48.8606,
        longitude: 2.3376,
      ),
      phone: '01 42 60 22 33',
      email: 'contact@aupaindore.fr',
      category: 'bakery',
      cuisineType: 'Boulangerie Artisanale',
      rating: 4.8,
      totalReviews: 245,
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
      status: MerchantStatus.active,
      verifiedAt: DateTime.now().subtract(const Duration(days: 120)),
      hasActiveOffer: true,
      availableOffers: 6,
      discountPercentage: 35,
      discountedPrice: 2.50,
      distanceText: '600m',
      isFavorite: true,
      pickupTime: '06:30-19:30',
      latitude: 48.8606,
      longitude: 2.3376,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      phoneNumber: '01 42 60 22 33',
      type: MerchantType.bakery,
      businessInfo: BusinessInfo(
        registrationNumber: '321654987',
        vatNumber: 'FR321654987',
        openingHours: OpeningHours(schedule: {}),
      ),
      settings: MerchantSettings(),
      stats: MerchantStats(
        totalOffers: 30,
        activeOffers: 6,
        totalReservations: 67,
        completedReservations: 65,
        totalRevenue: 580.0,
        totalCo2Saved: 58.0,
        totalMealsSaved: 116,
        averageRating: 4.8,
      ),
    ),
  ]);
});

/// Widget pour une section de restaurants avec slider horizontal
class MerchantSliderSection extends ConsumerWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onActionTap;
  final bool isUrgent;
  final String filterType;

  const MerchantSliderSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onActionTap,
    this.isUrgent = false,
    this.filterType = 'nearby',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utiliser le provider des marchands proches
    final restaurantsAsync = ref.watch(nearbyMerchantsProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la section
          _buildHeader(context),
          const SizedBox(height: 12),

          // Slider horizontal de restaurants
          restaurantsAsync.when(
            data: (merchants) => _buildMerchantList(context, merchants),
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isUrgent ? Colors.orange : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionText,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantList(
    BuildContext context,
    List<Merchant> merchants,
  ) {
    if (merchants.isEmpty) {
      return _buildEmptyState();
    }

    // Filtrer selon le type de section
    List<Merchant> filteredMerchants = _filterMerchants(merchants);

    if (filteredMerchants.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredMerchants.length,
        itemBuilder: (context, index) {
          final merchant = filteredMerchants[index];
          return Container(
            width: 340,
            margin: const EdgeInsets.only(right: 16),
            child: MerchantCard(
              merchant: merchant,
              onTap: () {
                context.go('/merchant/${merchant.id}');
              },
            ),
          );
        },
      ),
    );
  }

  List<Merchant> _filterMerchants(List<Merchant> merchants) {
    switch (filterType) {
      case 'new':
        // Prendre les 5 derniers ajoutés
        return merchants.take(5).toList();

      case 'best-deals':
        // Trier par réduction et prendre les 5 premiers
        final filtered = merchants.where((r) => r.hasActiveOffer).toList()
          ..sort(
            (a, b) => b.discountPercentage.compareTo(a.discountPercentage),
          );
        return filtered.take(5).toList();

      case 'closing-soon':
        // Filtrer ceux qui ferment bientôt
        return merchants
            .where((r) => r.availableOffers > 0 && r.availableOffers <= 3)
            .take(5)
            .toList();
            
      case 'last-minute':
        // Filtrer les offres qui expirent dans moins de 2h
        // En production, utiliser de vraies dates d'expiration
        // Simuler des offres urgentes
        final urgentOffers = merchants
            .where((r) => r.hasActiveOffer && r.availableOffers <= 2)
            .toList()
          ..sort((a, b) => a.availableOffers.compareTo(b.availableOffers));
        
        return urgentOffers.take(8).toList();
        
      case 'vegetarian':
        // Filtrer les restaurants végétariens/vegan
        // En production, utiliser les tags du restaurant
        final vegetarianMerchants = merchants.where((r) {
          // Simuler en utilisant le nom et la catégorie
          final name = r.name.toLowerCase();
          final cuisine = r.cuisineType.toLowerCase();
          return name.contains('bio') || 
                 name.contains('vég') ||
                 cuisine.contains('vég') ||
                 cuisine.contains('bio') ||
                 cuisine.contains('salad') ||
                 r.category == 'grocery'; // Les épiceries ont souvent du bio
        }).toList();
        
        return vegetarianMerchants.take(6).toList();
        
      case 'budget':
        // Filtrer les offres à moins de 5€
        final budgetOffers = merchants
            .where((r) => r.hasActiveOffer && r.discountedPrice <= 5.0)
            .toList()
          ..sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));

        return budgetOffers.take(10).toList();

      case 'bakery':
        // Filtrer les boulangeries et pâtisseries
        final bakeries = merchants
            .where((r) => r.category == 'bakery' || r.type == MerchantType.bakery)
            .toList()
          ..sort((a, b) => b.rating.compareTo(a.rating));

        return bakeries.take(8).toList();

      case 'recommended':
        // Recommandations basées sur les favoris et les offres actives
        final recommendedList = <Merchant>[];
        
        // D'abord les favoris avec offres
        final favoritesWithOffers = merchants
            .where((r) => r.isFavorite && r.hasActiveOffer)
            .toList();
        recommendedList.addAll(favoritesWithOffers);
        
        // Ensuite les restaurants avec les meilleures notes
        final highRated = merchants
            .where((r) => !r.isFavorite && r.rating >= 4.5)
            .toList()
          ..sort((a, b) => b.rating.compareTo(a.rating));
        
        recommendedList.addAll(highRated.take(5 - recommendedList.length));
        
        // Si pas assez, compléter avec des restaurants proches
        if (recommendedList.length < 5) {
          final nearby = merchants
              .where((r) => !recommendedList.contains(r))
              .take(5 - recommendedList.length);
          recommendedList.addAll(nearby);
        }
        
        return recommendedList.take(6).toList();

      case 'nearby':
      default:
        // Près de vous - prendre les 10 premiers
        return merchants.take(10).toList();
    }
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 340,
            margin: const EdgeInsets.only(right: 16),
            child: const ShimmerCard(),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 50, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'Pas d\'offres disponibles',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.red.shade400),
            const SizedBox(height: 8),
            Text(
              'Erreur de chargement',
              style: TextStyle(color: Colors.red.shade600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // TODO: Implement provider invalidation when nearbyMerchantsProvider is available
                // ref.invalidate(nearbyMerchantsProvider);
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte de chargement avec effet shimmer
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(Icons.image, size: 60, color: Colors.grey.shade400),
            ),
          ),
          // Content placeholder
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 16,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

