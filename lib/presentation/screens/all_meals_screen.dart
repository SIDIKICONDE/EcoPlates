import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
import '../../domain/entities/food_offer.dart';
import '../providers/meals_provider.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail/index.dart';

/// Page affichant tous les repas complets disponibles
class AllMealsScreen extends ConsumerWidget {
  const AllMealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tous les repas complets'),
        centerTitle: true,
        elevation: 0,
      ),
      body: meals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_outlined,
                    size: EcoPlatesDesignTokens.layout.emptyStateIconSize,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                  ),
                  Text(
                    'Aucun repas disponible',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.microGap(context),
                  ),
                  Text(
                    'Revenez plus tard pour découvrir de nouveaux repas',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: EcoPlatesDesignTokens.spacing.dialogGap(context),
                vertical: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                  ),
                  child: OfferCard(
                    offer: meal,
                    distance: 0.8 + (index * 0.3), // Distance simulée
                    onTap: () {
                      _showMealDetailModal(context, meal);
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _showMealDetailModal(
    BuildContext context,
    FoodOffer meal,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMealDetailModal(context, meal),
    );
  }

  Widget _buildMealDetailModal(BuildContext context, FoodOffer meal) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repas complet',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
                      ),
                    ),
                    Text(
                      'À récupérer : ${_formatPickupTime(meal)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
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
                  OfferInfoSection(offer: meal),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Composition du repas
                  _buildMealComposition(context, meal),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Détails pratiques
                  OfferDetailsSection(offer: meal),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Adresse
                  OfferAddressSection(offer: meal),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Badges allergènes
                  OfferBadgesSection(offer: meal),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                      context,
                    ),
                  ),

                  // Métadonnées
                  OfferMetadataSection(offer: meal),
                  SizedBox(
                    height:
                        EcoPlatesDesignTokens.spacing.sectionSpacing(context) *
                        3,
                  ),
                ],
              ),
            ),
          ),

          // Barre de réservation
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: OfferReservationBar(
              offer: meal,
              isReserving: false,
              onReserve: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('✅ "${meal.title}" réservé avec succès !'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealComposition(BuildContext context, FoodOffer meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Composition du repas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: EcoPlatesDesignTokens.typography.bold,
          ),
        ),
        SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),
        Container(
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.spacing.interfaceGap(context),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.md,
            ),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: EcoPlatesDesignTokens.size.icon(context),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    width: EcoPlatesDesignTokens.spacing.microGap(context),
                  ),
                  Expanded(
                    child: Text(
                      meal.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: EcoPlatesDesignTokens.typography.medium,
                      ),
                    ),
                  ),
                ],
              ),
              if (meal.isVegetarian) ...[
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: EcoPlatesDesignTokens.spacing.microGap(
                          context,
                        ),
                        vertical: EcoPlatesDesignTokens.spacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens.radius.sm,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.eco,
                            size: EcoPlatesDesignTokens.typography.label(
                              context,
                            ),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: EcoPlatesDesignTokens.spacing.xxs),
                          Text(
                            'Végétarien',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight:
                                      EcoPlatesDesignTokens.typography.medium,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatPickupTime(FoodOffer meal) {
    final start =
        '${meal.pickupStartTime.hour.toString().padLeft(2, '0')}:${meal.pickupStartTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${meal.pickupEndTime.hour.toString().padLeft(2, '0')}:${meal.pickupEndTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}
