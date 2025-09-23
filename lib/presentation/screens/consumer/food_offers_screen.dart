import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/commerce/offers_provider.dart';
import '../../providers/consumer/filters_provider.dart';
import '../../providers/consumer/search_provider.dart';
import '../../providers/consumer/statistics_provider.dart';
import '../../widgets/consumer/filters_bottom_sheet.dart';
import '../../widgets/consumer/search_bar_widget.dart';

/// Écran principal pour voir les offres anti-gaspillage disponibles
class FoodOffersScreen extends ConsumerWidget {
  const FoodOffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filtersProvider);
    final filtersNotifier = ref.read(filtersProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoPlates'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const FiltersBottomSheet(),
                  );
                },
              ),
              if (filters.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      filters.activeFiltersCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              // TODO: Afficher la carte
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vue carte bientôt disponible'),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(nearbyOffersProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Barre de recherche
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SmartSearchBar(
                  onTap: () {
                    // Optionnel : navigation vers un écran de recherche dédié
                  },
                ),
              ),
            ),
            
            // Header avec statistiques dynamiques
            Consumer(
              builder: (context, ref, child) {
                final statsAsync = ref.watch(userStatisticsProvider);
                
                return statsAsync.when(
                  data: (stats) => SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).colorScheme.primary.withAlpha(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatWidget(
                            icon: Icons.restaurant,
                            value: stats.totalMealsSaved.toString(),
                            label: 'Repas sauvés',
                            color: Colors.green,
                          ),
                          _StatWidget(
                            icon: Icons.euro,
                            value: '${stats.totalMoneySaved.toStringAsFixed(0)}€',
                            label: 'Économisé',
                            color: Colors.blue,
                          ),
                          _StatWidget(
                            icon: Icons.eco,
                            value: '${stats.totalCo2Saved.toStringAsFixed(1)}kg',
                            label: 'CO2 évité',
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading: () => const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  error: (_, __) => SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).colorScheme.primary.withAlpha(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatWidget(
                            icon: Icons.restaurant,
                            value: '0',
                            label: 'Repas sauvés',
                            color: Colors.green,
                          ),
                          _StatWidget(
                            icon: Icons.euro,
                            value: '0€',
                            label: 'Économisé',
                            color: Colors.blue,
                          ),
                          _StatWidget(
                            icon: Icons.eco,
                            value: '0kg',
                            label: 'CO2 évité',
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // Filtres rapides
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _FilterChip(
                      label: 'Gratuit',
                      icon: Icons.money_off,
                      isSelected: filters.isFreeOnly,
                      onTap: () => filtersNotifier.toggleFreeOnly(),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'À proximité',
                      icon: Icons.near_me,
                      isSelected: filters.isNearbyOnly,
                      onTap: () => filtersNotifier.toggleNearbyOnly(),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Végétarien',
                      icon: Icons.eco,
                      isSelected: filters.dietaryPreferences.contains('vegetarian'),
                      onTap: () => filtersNotifier.toggleDietaryPreference('vegetarian'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Boulangerie',
                      icon: Icons.bakery_dining,
                      isSelected: filters.selectedCategories.contains(FoodCategory.boulangerie),
                      onTap: () => filtersNotifier.toggleCategory(FoodCategory.boulangerie),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Dîner',
                      icon: Icons.dinner_dining,
                      isSelected: filters.selectedCategories.contains(FoodCategory.diner),
                      onTap: () => filtersNotifier.toggleCategory(FoodCategory.diner),
                    ),
                  ],
                ),
              ),
            ),
            
            // Liste des offres
            Consumer(
              builder: (context, ref, child) {
                final offersAsync = ref.watch(nearbyOffersProvider);
                
                return offersAsync.when(
                  data: (allOffers) {
                    // Appliquer la recherche d'abord
                    final searchResults = ref.watch(searchResultsProvider);
                    // Puis appliquer les filtres
                    final offers = ref.watch(filteredOffersProvider(searchResults));
                    if (offers.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucune offre disponible',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Vérifiez plus tard ou élargissez votre zone de recherche',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    return SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= offers.length) return null;
                            final offer = offers[index];
                            final userLocation = ref.watch(userLocationProvider);
                            
                            String distance = 'Distance inconnue';
                            if (userLocation != null) {
                              final distanceKm = offer.location.distanceFrom(
                                userLocation.latitude, 
                                userLocation.longitude
                              );
                              distance = '${distanceKm.toStringAsFixed(1)} km';
                            }
                            
                            // Formatage des horaires
                            final pickupTimeText = '${_formatTime(offer.pickupStartTime)} - ${_formatTime(offer.pickupEndTime)}';
                            
                            // Tags basés sur l'offre
                            List<String> tags = [];
                            if (offer.isFree) tags.add('GRATUIT');
                            if (offer.isVegetarian) tags.add('Végétarien');
                            if (offer.isVegan) tags.add('Vegan');
                            if (offer.isHalal) tags.add('Halal');
                            tags.add(_getCategoryName(offer.category));
                            
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index < offers.length - 1 ? 12.0 : 0,
                              ),
                              child: _OfferCard(
                                merchantName: offer.merchantName,
                                title: offer.title,
                                description: offer.description,
                                originalPrice: offer.originalPrice,
                                discountedPrice: offer.discountedPrice,
                                pickupTime: pickupTimeText,
                                distance: distance,
                                imageUrl: offer.images.isNotEmpty ? offer.images.first : null,
                                quantity: offer.quantity,
                                isFree: offer.isFree,
                                tags: tags,
                                onTap: () {
                                  context.go('/offer/${offer.id}');
                                },
                              ),
                            );
                          },
                          childCount: offers.length,
                        ),
                      ),
                    );
                  },
                  loading: () => SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erreur lors du chargement',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tirez vers le bas pour réessayer',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// Formate l'heure pour l'affichage
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  /// Retourne le nom de la catégorie pour l'affichage
  String _getCategoryName(FoodCategory category) {
    switch (category) {
      case FoodCategory.petitDejeuner:
        return 'Petit-déjeuner';
      case FoodCategory.dejeuner:
        return 'Déjeuner';
      case FoodCategory.diner:
        return 'Dîner';
      case FoodCategory.snack:
        return 'Snack';
      case FoodCategory.dessert:
        return 'Dessert';
      case FoodCategory.boisson:
        return 'Boisson';
      case FoodCategory.boulangerie:
        return 'Boulangerie';
      case FoodCategory.fruitLegume:
        return 'Fruits & Légumes';
      case FoodCategory.epicerie:
        return 'Épicerie';
      case FoodCategory.autre:
        return 'Autre';
    }
  }
}

/// Widget pour afficher une statistique
class _StatWidget extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  
  const _StatWidget({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

/// Chip de filtre
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary 
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte d'offre anti-gaspillage
class _OfferCard extends StatelessWidget {
  final String merchantName;
  final String title;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final String pickupTime;
  final String distance;
  final String? imageUrl;
  final int quantity;
  final bool isFree;
  final List<String> tags;
  final VoidCallback? onTap;
  
  const _OfferCard({
    required this.merchantName,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.pickupTime,
    required this.distance,
    required this.imageUrl,
    required this.quantity,
    required this.isFree,
    required this.tags,
    this.onTap,
  });
  
  String get _discountBadge {
    if (isFree) return 'GRATUIT';
    final discount = ((originalPrice - discountedPrice) / originalPrice * 100);
    return '-${discount.toStringAsFixed(0)}%';
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image et badge
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey.shade300,
                    image: imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageUrl == null
                      ? Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 50,
                            color: Colors.grey.shade500,
                          ),
                        )
                      : null,
                ),
                // Badge de réduction
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isFree ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _discountBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                // Quantité restante
                if (quantity <= 5)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Plus que $quantity !',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Contenu
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du commerçant et distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          merchantName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            distance,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Titre
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Description
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tag == 'GRATUIT' 
                            ? Colors.green.shade100 
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          color: tag == 'GRATUIT' 
                              ? Colors.green.shade800 
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 8),
                  
                  // Prix et horaire
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Prix
                      Row(
                        children: [
                          if (!isFree) ...[
                            Text(
                              '${originalPrice.toStringAsFixed(2)}€',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            isFree ? 'GRATUIT' : '${discountedPrice.toStringAsFixed(2)}€',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isFree ? Colors.green : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      // Horaire de collecte
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            pickupTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}