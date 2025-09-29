import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../providers/offer_reservation_provider.dart';
import '../providers/offers_catalog_provider.dart';
import '../providers/urgent_offers_provider.dart';
import '../widgets/common/offers_list_view.dart';
import '../widgets/common/urgency_indicator.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail/index.dart';

/// Page affichant toutes les offres urgentes à sauver
class AllUrgentOffersScreen extends ConsumerStatefulWidget {
  const AllUrgentOffersScreen({super.key});

  @override
  ConsumerState<AllUrgentOffersScreen> createState() =>
      _AllUrgentOffersScreenState();
}

class _AllUrgentOffersScreenState extends ConsumerState<AllUrgentOffersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(
          begin: 0.9,
          end: 1.1,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offers = ref.watch(urgentOffersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: const Text('🔥'),
                );
              },
            ),
            SizedBox(width: 8.0),
            const Text("À sauver d'urgence"),
          ],
        ),
        centerTitle: false,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.errorContainer.withOpacity(0.1),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: UrgentOffersListView(
        offers: offers,
        enableRefresh: true,
        onRefresh: () async {
          await ref.read(offersRefreshProvider.notifier).refreshIfStale();
        },
        customCardBuilder: (BuildContext context, FoodOffer offer, int index) {
          final remainingTime = offer.pickupEndTime.difference(DateTime.now());

          return Stack(
            children: [
              OfferCard(
                offer: offer,
                distance: 0.5 + (index * 0.3),
                onTap: () {
                  _navigateToOfferDetail(context, offer);
                },
              ),

              // Badge urgence en overlay avec le nouveau widget
              Positioned(
                top: 16.0,
                right: 16.0,
                child: UrgencyIndicator(
                  remainingTime: remainingTime,
                  animate: true,
                  animationController: _animationController,
                  pulseAnimation: _pulseAnimation,
                ),
              ),

              // Indicateur de stock faible
              if (offer.quantity <= 3)
                Positioned(
                  bottom: 32.0,
                  left: 16.0,
                  child: _buildLowStockIndicator(context, offer),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLowStockIndicator(BuildContext context, FoodOffer offer) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: offer.quantity == 1
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flash_on,
            color: Theme.of(context).colorScheme.onError,
            size: 16.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            offer.quantity == 1
                ? 'Dernier disponible !'
                : 'Plus que ${offer.quantity} restants',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onError,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToOfferDetail(BuildContext context, FoodOffer offer) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildOfferDetailModal(context, offer),
      ),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    final remainingTime = offer.pickupEndTime.difference(DateTime.now());
    final isVeryUrgent = remainingTime.inMinutes <= 30;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          // Header avec gradient et bouton fermer
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isVeryUrgent
                    ? [
                        Theme.of(context).colorScheme.errorContainer,
                        Theme.of(context).colorScheme.tertiaryContainer,
                      ]
                    : [
                        Theme.of(context).colorScheme.secondaryContainer,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isVeryUrgent) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.warning,
                              color: Theme.of(context).colorScheme.error,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'URGENT - ${remainingTime.inMinutes} minutes restantes',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                      ],
                      Text(
                        offer.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Chez ${offer.merchantName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge quantité limitée si applicable
                  if (offer.quantity <= 3)
                    Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          SizedBox(width: 12.0),
                          Text(
                            offer.quantity == 1
                                ? 'Dernier article disponible !'
                                : 'Plus que ${offer.quantity} articles disponibles',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onTertiaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),

                  // Informations principales
                  OfferInfoSection(offer: offer),
                  SizedBox(height: 16.0),

                  // Détails pratiques
                  OfferDetailsSection(offer: offer),
                  SizedBox(height: 16.0),

                  // Adresse
                  OfferAddressSection(offer: offer),
                  SizedBox(height: 16.0),

                  // Badges allergènes
                  OfferBadgesSection(offer: offer),
                  SizedBox(height: 16.0),

                  // Métadonnées
                  OfferMetadataSection(offer: offer),
                  SizedBox(height: 80.0), // Espace pour la barre de réservation
                ],
              ),
            ),
          ),

          // Barre de réservation urgente
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.errorContainer,
                  Theme.of(context).colorScheme.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Prix
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (offer.originalPrice > 0)
                        Text(
                          '${offer.originalPrice.toStringAsFixed(2)}€',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      Text(
                        offer.discountedPrice == 0
                            ? 'Gratuit !'
                            : '${offer.discountedPrice.toStringAsFixed(2)}€',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: offer.discountedPrice == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.0),
                  // Bouton de réservation
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        return ElevatedButton(
                          onPressed: () async {
                            try {
                              await ref
                                  .read(offerReservationProvider.notifier)
                                  .reserve(offer: offer);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green.shade700,
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Bravo ! Vous avez sauvé "${offer.title}"',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            } on Exception catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red.shade700,
                                    content: Text('Réservation impossible: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flash_on,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Sauver maintenant',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trier par',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  leading: Icon(Icons.timer, color: Colors.red.shade700),
                  title: const Text("Plus urgent d'abord"),
                  subtitle: const Text('Offres qui expirent bientôt'),
                  onTap: () => Navigator.pop(context),
                  selected: true,
                  selectedTileColor: Colors.red.shade50,
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.blue.shade700),
                  title: const Text('Plus proche'),
                  subtitle: const Text('Distance la plus courte'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(Icons.euro, color: Colors.green.shade700),
                  title: const Text('Prix le plus bas'),
                  subtitle: const Text('Meilleures affaires'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(Icons.inventory, color: Colors.orange.shade700),
                  title: const Text('Stock faible'),
                  subtitle: const Text('Derniers articles disponibles'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtrer les offres urgentes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                // Filtre par temps restant
                Text(
                  'Temps restant',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('< 30 min'),
                      avatar: const Icon(Icons.warning, size: 18),
                      backgroundColor: Colors.red[50],
                      selectedColor: Colors.red[200],
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 1h'),
                      avatar: const Icon(Icons.timer, size: 18),
                      backgroundColor: Colors.orange[50],
                      selectedColor: Colors.orange[200],
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 2h'),
                      backgroundColor: Colors.amber[50],
                      selectedColor: Colors.amber[200],
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Filtre par quantité
                Text(
                  'Quantité disponible',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Dernier article'),
                      avatar: const Icon(Icons.looks_one, size: 18),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 3 restants'),
                      avatar: const Icon(Icons.inventory_2, size: 18),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 5 restants'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Réinitialiser'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Filtres appliqués'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Appliquer'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
