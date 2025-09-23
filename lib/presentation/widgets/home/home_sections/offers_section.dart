import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../offer_card.dart';

/// Section "Offres du moment" - slider horizontal d'offres individuelles
class OffersSection extends ConsumerWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final String? route;

  const OffersSection({
    super.key,
    this.title = '🔥 Offres du moment',
    this.subtitle = 'Économisez sur vos repas préférés',
    this.actionText = 'Voir tout',
    this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utiliser le provider d'offres
    final offersAsync = ref.watch(offersProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 6),

          // Contenu
          offersAsync.when(
            data: (offers) => _buildOffersList(context, offers),
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titre
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          // Bouton voir tout
          TextButton(
            onPressed: () => context.go(route ?? '/offers'),
            style: TextButton.styleFrom(
              foregroundColor: theme.primaryColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: theme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersList(BuildContext context, List<FoodOffer> offers) {
    if (offers.isEmpty) {
      return _buildEmptyState(context);
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            width: 300,
            margin: EdgeInsets.only(
              right: index < offers.length - 1 ? 16 : 0,
            ),
            child: OfferCard(
              offer: offer,
              onTap: () => context.go('/offer/${offer.id}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            child: const _ShimmerCard(),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Aucune offre disponible',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
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
            Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(offersProvider),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider temporaire pour les offres
final offersProvider = Provider<AsyncValue<List<FoodOffer>>>((ref) {
  // Données de test temporaires pour les offres
  return AsyncValue.data([
    FoodOffer(
      id: 'offer-1',
      merchantId: 'merchant-1',
      merchantName: 'Chez Marie',
      title: 'Plat du jour - Coq au vin',
      description: 'Délicieux coq au vin traditionnel avec légumes frais de saison',
      images: ['https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&h=600&fit=crop'],
      type: OfferType.plat,
      category: FoodCategory.dejeuner,
      originalPrice: 18.50,
      discountedPrice: 12.90,
      quantity: 5,
      pickupStartTime: DateTime.now().add(const Duration(hours: 1)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: OfferStatus.available,
      location: Location(
        latitude: 48.8566,
        longitude: 2.3522,
        address: '15 Rue des Roses',
        city: 'Paris',
        postalCode: '75001',
      ),
      allergens: ['gluten', 'lactose'],
      isVegetarian: false,
      isVegan: false,
      isHalal: false,
      co2Saved: 850,
    ),
    FoodOffer(
      id: 'offer-2',
      merchantId: 'merchant-2',
      merchantName: 'Boulangerie Bio',
      title: 'Baguette tradition bio',
      description: 'Baguette artisanale au levain naturel, ingrédients 100% bio',
      images: ['https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&h=600&fit=crop'],
      type: OfferType.boulangerie,
      category: FoodCategory.petitDejeuner,
      originalPrice: 1.20,
      discountedPrice: 0.80,
      quantity: 12,
      pickupStartTime: DateTime.now().add(const Duration(hours: 1)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: OfferStatus.available,
      location: Location(
        latitude: 48.8606,
        longitude: 2.3376,
        address: '28 Avenue des Champs',
        city: 'Paris',
        postalCode: '75008',
      ),
      allergens: ['gluten'],
      isVegetarian: true,
      isVegan: true,
      isHalal: true,
      co2Saved: 150,
    ),
    FoodOffer(
      id: 'offer-3',
      merchantId: 'merchant-3',
      merchantName: 'Épicerie du Coin',
      title: 'Panier de légumes bio',
      description: 'Assortiment de légumes frais et bio de saison',
      images: ['https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&h=600&fit=crop'],
      type: OfferType.fruits,
      category: FoodCategory.fruitLegume,
      originalPrice: 15.90,
      discountedPrice: 9.50,
      quantity: 8,
      pickupStartTime: DateTime.now().add(const Duration(hours: 2)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 5)),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: OfferStatus.available,
      location: Location(
        latitude: 48.8365,
        longitude: 2.3770,
        address: '7 Place de la Gare',
        city: 'Paris',
        postalCode: '75013',
      ),
      allergens: [],
      isVegetarian: true,
      isVegan: true,
      isHalal: true,
      co2Saved: 1200,
    ),
    FoodOffer(
      id: 'offer-4',
      merchantId: 'merchant-4',
      merchantName: 'Au Pain Doré',
      title: 'Croissants frais (lot de 6)',
      description: 'Croissants pur beurre frais du jour, croustillants et dorés',
      images: ['https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop'],
      type: OfferType.boulangerie,
      category: FoodCategory.petitDejeuner,
      originalPrice: 7.20,
      discountedPrice: 4.50,
      quantity: 3,
      pickupStartTime: DateTime.now().add(const Duration(hours: 1)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 4)),
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      status: OfferStatus.available,
      location: Location(
        latitude: 48.8606,
        longitude: 2.3376,
        address: '42 Rue Saint-Honoré',
        city: 'Paris',
        postalCode: '75001',
      ),
      allergens: ['gluten', 'lactose'],
      isVegetarian: true,
      isVegan: false,
      isHalal: false,
      co2Saved: 300,
    ),
  ]);
});

/// Widget de chargement avec effet shimmer pour les offres
class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
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
            height: 140,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
          ),

          // Content placeholder
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                Container(
                  height: 16,
                  width: 150,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle placeholder
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),

                // Price placeholder
                Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
