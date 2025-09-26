import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../providers/recommended_offers_provider.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail/index.dart';

/// Page affichant toutes les offres recommandées
class AllRecommendedOffersScreen extends ConsumerWidget {
  const AllRecommendedOffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(recommendedOffersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offres recommandées'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Afficher les options de filtrage
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: offersAsync.when(
        data: (offers) {
          if (offers.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Forcer le rechargement des offres
              ref.invalidate(recommendedOffersProvider);
              // Attendre que le provider se recharge
              await ref.read(recommendedOffersProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OfferCard(
                    offer: offer,
                    compact: true,
                    onTap: () {
                      // Navigation vers le détail de l'offre
                      _navigateToOfferDetail(context, offer);
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, ref, error),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucune offre disponible',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Revenez plus tard pour découvrir\nde nouvelles offres anti-gaspi',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Erreur lors du chargement',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Forcer le rechargement
                ref.invalidate(recommendedOffersProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToOfferDetail(
    BuildContext context,
    FoodOffer offer,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOfferDetailModal(context, offer),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header de la modal
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Détails de l'offre",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales
                  OfferInfoSection(offer: offer),
                  const SizedBox(height: 24),

                  // Détails pratiques
                  OfferDetailsSection(offer: offer),
                  const SizedBox(height: 24),

                  // Adresse
                  OfferAddressSection(offer: offer),
                  const SizedBox(height: 24),

                  // Badges allergènes
                  OfferBadgesSection(offer: offer),
                  const SizedBox(height: 24),

                  // Métadonnées
                  OfferMetadataSection(offer: offer),
                  const SizedBox(
                    height: 100,
                  ), // Espace pour la barre de réservation
                ],
              ),
            ),
          ),

          // Barre de réservation
          OfferReservationBar(
            offer: offer,
            isReserving: false,
            onReserve: () {
              // Logique de réservation
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Réservation pour "${offer.title}" confirmée !',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtrer les offres',
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
                const SizedBox(height: 20),

                // Filtres par catégorie
                Text(
                  'Catégorie',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Boulangerie'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Fruits & Légumes'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Plats préparés'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Snacks'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Filtres par régime
                Text(
                  'Régime alimentaire',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Végétarien'),
                      avatar: const Icon(Icons.eco, size: 18),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Vegan'),
                      avatar: const Icon(Icons.spa, size: 18),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Sans gluten'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Filtres par prix
                Text('Prix', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Gratuit'),
                      avatar: const Icon(Icons.star, size: 18),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 5€'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('5€ - 10€'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('> 10€'),
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
                        onPressed: () {
                          // Réinitialiser les filtres
                          Navigator.pop(context);
                        },
                        child: const Text('Réinitialiser'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Appliquer les filtres
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Filtres appliqués'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
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
