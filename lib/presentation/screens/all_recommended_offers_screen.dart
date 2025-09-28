import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';

import '../../domain/entities/food_offer.dart';
import '../providers/recommended_offers_provider.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail/index.dart';

/// Page affichant toutes les offres recommandées
class AllRecommendedOffersScreen extends ConsumerWidget {
  const AllRecommendedOffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(recommendedOffersProvider);

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
      body: Builder(
        builder: (context) {
          if (offers.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              // TODO: Brancher sur un provider de refresh réseau si disponible
              // Force rebuild via notifier
              ref.invalidate(recommendedOffersProvider);
            },
            child: ListView.builder(
              padding: EdgeInsets.all(
                EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                  ),
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
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: EcoPlatesDesignTokens.layout.emptyStateIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),
          Text(
            'Aucune offre disponible',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
          Text(
            'Revenez plus tard pour découvrir\nde nouvelles offres anti-gaspi',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
          ),
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

  // _buildErrorState supprimé: provider devenu synchrone

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
      height:
          MediaQuery.of(context).size.height *
          EcoPlatesDesignTokens.layout.modalHeightFactor(context),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EcoPlatesDesignTokens.radius.lg),
        ),
      ),
      child: Column(
        children: [
          // Header de la modal
          Container(
            padding: EdgeInsets.all(
              EcoPlatesDesignTokens.spacing.dialogGap(context),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(EcoPlatesDesignTokens.radius.lg),
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
              padding: EdgeInsets.all(
                EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales
                  OfferInfoSection(offer: offer),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Détails pratiques
                  OfferDetailsSection(offer: offer),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Adresse
                  OfferAddressSection(offer: offer),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Badges allergènes
                  OfferBadgesSection(offer: offer),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Métadonnées
                  OfferMetadataSection(offer: offer),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(EcoPlatesDesignTokens.radius.lg),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(
              EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
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
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),

                // Filtres par catégorie
                Text(
                  'Catégorie',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                Wrap(
                  spacing: EcoPlatesDesignTokens.spacing.xxs,
                  runSpacing: EcoPlatesDesignTokens.spacing.xxs,
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

                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),

                // Filtres par régime
                Text(
                  'Régime alimentaire',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                Wrap(
                  spacing: EcoPlatesDesignTokens.spacing.xxs,
                  runSpacing: EcoPlatesDesignTokens.spacing.xxs,
                  children: [
                    FilterChip(
                      label: const Text('Végétarien'),
                      avatar: Icon(
                        Icons.eco,
                        size: EcoPlatesDesignTokens.typography.label(context),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Vegan'),
                      avatar: Icon(
                        Icons.spa,
                        size: EcoPlatesDesignTokens.typography.label(context),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Sans gluten'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),

                // Filtres par prix
                Text('Prix', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                Wrap(
                  spacing: EcoPlatesDesignTokens.spacing.xxs,
                  runSpacing: EcoPlatesDesignTokens.spacing.xxs,
                  children: [
                    FilterChip(
                      label: const Text('Gratuit'),
                      avatar: Icon(
                        Icons.star,
                        size: EcoPlatesDesignTokens.typography.label(context),
                      ),
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

                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
                ),

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
                    SizedBox(
                      width: EcoPlatesDesignTokens.spacing.microGap(context),
                    ),
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
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
