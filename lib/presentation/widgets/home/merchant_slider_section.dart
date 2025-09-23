import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/merchant.dart';
import '../../providers/consumer/merchants_provider.dart';
import '../merchant_card.dart';

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
            .where((r) => !r.isFavorite && r.rating != null && r.rating! >= 4.5)
            .toList()
          ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        
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
                ref.invalidate(nearbyMerchantsProvider);
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

