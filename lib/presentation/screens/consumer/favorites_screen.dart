import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/consumer/favorites_provider.dart';
import '../../providers/commerce/offers_provider.dart';

/// Écran pour afficher et gérer les favoris
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final favoriteOffersAsync = ref.watch(favoriteOffersProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes Favoris'),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(
                icon: const Icon(Icons.restaurant),
                text: 'Offres (${favoritesState.favoriteOfferIds.length})',
              ),
              Tab(
                icon: const Icon(Icons.store),
                text:
                    'Commerçants (${favoritesState.favoriteMerchantIds.length})',
              ),
            ],
          ),
          actions: [
            if (favoritesState.totalFavorites > 0)
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () => _showClearConfirmation(context, ref),
              ),
          ],
        ),
        body: TabBarView(
          children: [
            // Onglet Offres favorites
            favoriteOffersAsync.when(
              data: (offers) => _buildOffersTab(context, offers),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    const Text('Erreur lors du chargement'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(favoriteOffersProvider),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),

            // Onglet Commerçants favoris
            _buildMerchantsTab(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersTab(BuildContext context, List<FoodOffer> offers) {
    if (offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Aucune offre favorite',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des offres à vos favoris\npour les retrouver facilement',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/offers'),
              icon: const Icon(Icons.search),
              label: const Text('Explorer les offres'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Rafraîchir les données
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return _FavoriteOfferCard(
            offer: offer,
            onTap: () => context.go('/offer/${offer.id}'),
          );
        },
      ),
    );
  }

  Widget _buildMerchantsTab(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);

    if (favoritesState.favoriteMerchantIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Aucun commerçant favori',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Suivez vos commerçants préférés\npour ne rien manquer',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // TODO: Implémenter la liste des commerçants favoris
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoritesState.favoriteMerchantIds.length,
      itemBuilder: (context, index) {
        final merchantId = favoritesState.favoriteMerchantIds.elementAt(index);
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.store)),
            title: Text('Commerçant $merchantId'),
            subtitle: const Text('Détails à implémenter'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                ref
                    .read(favoritesProvider.notifier)
                    .toggleMerchantFavorite(merchantId);
              },
            ),
          ),
        );
      },
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer les favoris'),
        content: const Text(
          'Voulez-vous vraiment supprimer tous vos favoris ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(favoritesProvider.notifier).clearAllFavorites();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tous les favoris ont été supprimés'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

/// Carte pour afficher une offre favorite
class _FavoriteOfferCard extends ConsumerWidget {
  final FoodOffer offer;
  final VoidCallback onTap;

  const _FavoriteOfferCard({required this.offer, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocation = ref.watch(userLocationProvider);
    String distance = 'Distance inconnue';

    if (userLocation != null) {
      final distanceKm = offer.location.distanceFrom(
        userLocation.latitude,
        userLocation.longitude,
      );
      distance = '${distanceKm.toStringAsFixed(1)} km';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image et badges
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey.shade300,
                    image: offer.images.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(offer.images.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: offer.images.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 40,
                            color: Colors.grey.shade500,
                          ),
                        )
                      : null,
                ),
                // Badge de réduction
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: offer.isFree ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      offer.discountBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Bouton favori
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      iconSize: 20,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        await ref
                            .read(favoritesProvider.notifier)
                            .toggleOfferFavorite(offer.id);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Retiré des favoris'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
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
                  // Titre et distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              offer.merchantName,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            distance,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Prix et horaire
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        offer.priceText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: offer.isFree
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_formatTime(offer.pickupStartTime)} - ${_formatTime(offer.pickupEndTime)}',
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

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
