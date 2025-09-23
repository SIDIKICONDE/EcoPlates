import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../domain/entities/reservation.dart';
import '../../providers/commerce/offers_provider.dart'
    hide userLocationProvider;
import '../../providers/commerce/reservations_provider.dart';
import '../../providers/consumer/favorites_provider.dart';
import '../../providers/consumer/statistics_provider.dart';
import '../../providers/user/user_location_provider.dart';

/// Page d'accueil pour les consommateurs
class ConsumerHomeScreen extends ConsumerWidget {
  const ConsumerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoPlates'),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final stats = ref.watch(favoritesStatsProvider);
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_outline),
                    onPressed: () => context.go('/favorites'),
                  ),
                  if (stats.totalOffers > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            stats.totalOffers.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications bientôt disponibles'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Carte de bienvenue
              _buildWelcomeCard(context),
              const SizedBox(height: 20),

              // Statistiques écologiques
              _buildEcoStats(context),
              const SizedBox(height: 24),

              // Actions principales
              Text(
                'Que voulez-vous faire ?',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Grille d'actions
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final offersAsync = ref.watch(nearbyOffersProvider);
                      final offersCount = offersAsync.when(
                        data: (offers) => offers.length.toString(),
                        loading: () => '...',
                        error: (_, __) => '0',
                      );
                      return _ActionTile(
                        icon: Icons.restaurant_menu,
                        title: 'Offres Anti-Gaspi',
                        subtitle: '$offersCount offres près de vous',
                        color: Colors.orange,
                        onTap: () => context.go('/offers'),
                      );
                    },
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final reservationsAsync = ref.watch(
                        userReservationsProvider,
                      );
                      final activeReservationsCount = reservationsAsync.when(
                        data: (reservations) => reservations
                            .where(
                              (r) =>
                                  r.status == ReservationStatus.pending ||
                                  r.status == ReservationStatus.confirmed,
                            )
                            .length,
                        loading: () => 0,
                        error: (_, __) => 0,
                      );
                      return _ActionTile(
                        icon: Icons.confirmation_num,
                        title: 'Mes Réservations',
                        subtitle: '$activeReservationsCount en cours',
                        color: Colors.purple,
                        badge: activeReservationsCount > 0
                            ? '$activeReservationsCount'
                            : null,
                        onTap: () => context.go('/reservations'),
                      );
                    },
                  ),
                  _ActionTile(
                    icon: Icons.history,
                    title: 'Mon Historique',
                    subtitle: '3 commandes finalisées',
                    color: Colors.green,
                    onTap: () => context.go('/history'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Section offres du jour
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Offres à saisir',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/offers'),
                    child: const Text('Voir tout'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Carrousel d'offres rapides
              Consumer(
                builder: (context, ref, child) {
                  final offersAsync = ref.watch(nearbyOffersProvider);

                  return offersAsync.when(
                    data: (offers) {
                      // Prendre seulement les 5 premières offres pour le carrousel
                      final topOffers = offers.take(5).toList();

                      if (topOffers.isEmpty) {
                        return Container(
                          height: 120,
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Aucune offre disponible pour le moment',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: topOffers.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final offer = topOffers[index];
                            final userLocation = ref.watch(
                              userLocationProvider,
                            );
                            String distance = 'Localisation inconnue';

                            if (userLocation != null) {
                              final distanceKm = offer.location.distanceFrom(
                                userLocation.latitude,
                                userLocation.longitude,
                              );
                              distance = distanceKm < 1
                                  ? '${(distanceKm * 1000).round()}m'
                                  : '${distanceKm.toStringAsFixed(1)}km';
                            }

                            return _QuickOfferCard(
                              title: offer.merchantName,
                              subtitle: offer.title,
                              price: offer.priceText,
                              originalPrice:
                                  '${offer.originalPrice.toStringAsFixed(2)}€',
                              distance: distance,
                              isFree: offer.isFree,
                              color: _getOfferColor(offer.category),
                              onTap: () {
                                context.go('/offer/${offer.id}');
                              },
                            );
                          },
                        ),
                      );
                    },
                    loading: () => SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stack) => Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'Erreur lors du chargement des offres',
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Méthode helper pour obtenir la couleur selon la catégorie
  Color _getOfferColor(FoodCategory category) {
    switch (category) {
      case FoodCategory.boulangerie:
        return Colors.brown;
      case FoodCategory.fruitLegume:
        return Colors.green;
      case FoodCategory.dejeuner:
      case FoodCategory.diner:
        return Colors.orange;
      case FoodCategory.dessert:
        return Colors.pink;
      case FoodCategory.boisson:
        return Colors.blue;
      default:
        return Colors.indigo;
    }
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = 'Bonjour';
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = 'Bon après-midi';
      icon = Icons.wb_cloudy;
    } else {
      greeting = 'Bonsoir';
      icon = Icons.nights_stay;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, Marie !',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Prêt à sauver de la nourriture aujourd\'hui ?',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoStats(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final statsAsync = ref.watch(userStatisticsProvider);

        return statsAsync.when(
          data: (stats) => Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.eco,
                  value: '${stats.totalCo2Saved.toStringAsFixed(1)} kg',
                  label: 'CO₂ économisé',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.restaurant,
                  value: stats.totalMealsSaved.toString(),
                  label: 'Repas sauvés',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.euro,
                  value: '${stats.totalMoneySaved.toStringAsFixed(0)}€',
                  label: 'Économisé',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          loading: () => Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.eco,
                  value: '...',
                  label: 'CO₂ économisé',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.restaurant,
                  value: '...',
                  label: 'Repas sauvés',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.euro,
                  value: '...',
                  label: 'Économisé',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          error: (_, __) => Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.eco,
                  value: '0 kg',
                  label: 'CO₂ économisé',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.restaurant,
                  value: '0',
                  label: 'Repas sauvés',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.euro,
                  value: '0€',
                  label: 'Économisé',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Tuile d'action pour la grille
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final String? badge;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Carte de statistique
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Carte d'offre rapide
class _QuickOfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String originalPrice;
  final String distance;
  final Color color;
  final bool isFree;
  final VoidCallback? onTap;

  const _QuickOfferCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.originalPrice,
    required this.distance,
    required this.color,
    this.isFree = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.8),
              color.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (!isFree) ...[
                  Text(
                    originalPrice,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isFree ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    price,
                    style: TextStyle(
                      color: isFree ? Colors.white : color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
