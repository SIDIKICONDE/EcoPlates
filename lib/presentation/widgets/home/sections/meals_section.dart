import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/design_tokens.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/meals_provider.dart';
import '../../../screens/all_meals_screen.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';
import 'categories_section.dart';

/// Section affichant les offres de repas complets
class MealsSection extends ConsumerWidget {
  const MealsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMeals = ref.watch(mealsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.scaleMD_LG_XL_XXL,
            context.scaleXXS_XS_SM_MD, // réduit
            context.scaleMD_LG_XL_XXL,
            context.scaleXS_SM_MD_LG, // réduit
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Repas complets',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.titleSize(
                        context,
                      ),
                      fontWeight: EcoPlatesDesignTokens.typography.bold,
                    ),
                  ),
                  Text(
                    'Menus et formules à prix réduits',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                      color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  unawaited(
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const AllMealsScreen(),
                      ),
                    ),
                  );
                },
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),

        // Liste horizontale d'offres de repas
        SizedBox(
          height: EcoPlatesDesignTokens.layout.merchantCardHeight(context) - 8,
          child: _buildMealsList(context, ref, allMeals),
        ),

        SizedBox(height: context.scaleXS_SM_MD_LG),
      ],
    );
  }

  Widget _buildMealsList(
    BuildContext context,
    WidgetRef ref,
    List<FoodOffer> allMeals,
  ) {
    // Filtrer les offres selon la catégorie sélectionnée
    final meals = ref.watch(filterOffersByCategoryProvider(allMeals));

    if (meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: EcoPlatesDesignTokens.size.modalIcon(context),
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
            ),
            SizedBox(height: context.scaleXS_SM_MD_LG),
            Text(
              'Aucun repas disponible',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                fontSize: EcoPlatesDesignTokens.typography.text(context),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: context.scaleMD_LG_XL_XXL),
      physics: const BouncingScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleXS_SM_MD_LG),
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width *
                (MediaQuery.of(context).orientation == Orientation.landscape
                    ? 0.9
                    : 0.85),
            child: OfferCard(
              offer: meal,
              compact: true,
              distance:
                  DesignConstants.baseDistance +
                  (index * DesignConstants.distanceIncrement),
              onTap: () {
                _showMealDetailModal(context, meal);
              },
            ),
          ),
        );
      },
    );
  }

  void _showMealDetailModal(BuildContext context, FoodOffer meal) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildMealDetailModal(context, meal),
      ),
    );
  }

  Widget _buildMealDetailModal(BuildContext context, FoodOffer meal) {
    return Container(
      height:
          MediaQuery.of(context).size.height *
          EcoPlatesDesignTokens.layout.modalHeightFactor(context),
      decoration: BoxDecoration(
        color: EcoPlatesDesignTokens.colors.modalBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
        ),
      ),
      child: Column(
        children: [
          // Header de la modal
          Container(
            padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.xxl),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest
                  .withValues(
                    alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                  ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
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
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography
                            .modalSubtitle(context),
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                      ),
                    ),
                    Text(
                      'À récupérer : ${_formatPickupTime(meal)}',
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.hint(
                          context,
                        ),
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(
                              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                            ),
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
              padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales
                  OfferInfoSection(offer: meal),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Composition du repas
                  _buildMealComposition(context, meal),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Détails pratiques
                  OfferDetailsSection(offer: meal),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Adresse
                  OfferAddressSection(offer: meal),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Badges allergènes
                  OfferBadgesSection(offer: meal),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Métadonnées
                  OfferMetadataSection(offer: meal),
                  SizedBox(
                    height: EcoPlatesDesignTokens.layout.mainContainerMinWidth,
                  ),
                ],
              ),
            ),
          ),

          // Barre de réservation
          Container(
            decoration: BoxDecoration(
              color: EcoPlatesDesignTokens.colors.modalBackground,
              border: Border(
                top: BorderSide(
                  color: EcoPlatesDesignTokens.colors.subtleBorder,
                  width: EcoPlatesDesignTokens.layout.cardBorderWidth,
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
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.modalContent(context),
            fontWeight: EcoPlatesDesignTokens.typography.bold,
          ),
        ),
        SizedBox(height: context.scaleMD_LG_XL_XXL),
        Container(
          padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.md,
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
              width: EcoPlatesDesignTokens.layout.cardBorderWidth,
            ),
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
                  SizedBox(width: context.scaleXS_SM_MD_LG),
                  Expanded(
                    child: Text(
                      meal.description,
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.text(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.medium,
                      ),
                    ),
                  ),
                ],
              ),
              if (meal.isVegetarian) ...[
                SizedBox(height: context.scaleXS_SM_MD_LG),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleXS_SM_MD_LG,
                        vertical: context.scaleXXS_XS_SM_MD,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer
                            .withValues(
                              alpha: EcoPlatesDesignTokens.opacity.subtle,
                            ),
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens.radius.xxl,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.eco,
                            size: EcoPlatesDesignTokens.size.indicator(context),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: context.scaleXXS_XS_SM_MD),
                          Text(
                            'Végétarien',
                            style: TextStyle(
                              fontSize: EcoPlatesDesignTokens.typography.hint(
                                context,
                              ),
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
