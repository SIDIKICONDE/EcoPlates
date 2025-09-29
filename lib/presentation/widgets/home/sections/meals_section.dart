import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/meals_provider.dart';
import '../../../screens/all_meals_screen.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';
import 'categories_section.dart';
import 'responsive_card_config.dart';

/// Section affichant les offres de repas complets
class MealsSection extends ConsumerWidget {
  const MealsSection({super.key});

  double _calculateCardHeight(BuildContext context) {
    // Hauteur de l'image (depuis OfferCardImage)
    final imageHeight = ResponsiveUtils.responsiveValue(
      context,
      mobile: 120.0,  // Mode compact
      tablet: 120.0,
      tabletLarge: 140.0,
      desktop: 160.0,
      desktopLarge: 180.0,
    );
    
    // Hauteur estimée du contenu en mode compact
    // (titre + description + pickup info + séparateur + prix + espacements)
    final contentHeight = ResponsiveUtils.responsiveValue(
      context,
      mobile: 110.0,  // Contenu compact avec séparateur
      tablet: 110.0,
      tabletLarge: 120.0,
      desktop: 130.0,
      desktopLarge: 140.0,
    );
    
    // Paddings (top image: 2, top content: 4, bottom content: 2)
    const totalPadding = 8.0;
    
    return imageHeight + contentHeight + totalPadding;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMeals = ref.watch(mealsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: EdgeInsets.fromLTRB(
            20.0,
            4.0, // réduit
            20.0,
            8.0, // réduit
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
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 18.0,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      unawaited(
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const AllMealsScreen(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 16.0,
                      color: Colors.blue,
                    ),
                    label: Text(
                      'Voir tout',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Liste horizontale d'offres de repas
        SizedBox(
          height: _calculateCardHeight(context),
          child: _buildMealsList(context, ref, allMeals),
        ),

        SizedBox(height: 16.0),
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
              size: 48.0,
              color: Colors.grey,
            ),
            SizedBox(height: 8.0),
            Text(
              'Aucun repas disponible',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      );
    }

    // Utiliser la configuration responsive
    final cardWidth = ResponsiveCardConfig.getSliderCardWidth(context);
    final cardSpacing = ResponsiveCardConfig.getCardSpacing(context);
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: ResponsiveCardConfig.getSliderPadding(context),
      physics: const BouncingScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: cardSpacing / 2),
          child: SizedBox(
            width: cardWidth,
            child: OfferCard(
              offer: meal,
              compact: true,
              distance: 0.5 + (index * 0.1),
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
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          // Header de la modal
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
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
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      meal.title,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
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
                  SizedBox(height: 16.0),

                  // Composition du repas
                  _buildMealComposition(context, meal),
                  SizedBox(height: 24.0),

                  // Détails pratiques
                  OfferDetailsSection(offer: meal),
                  SizedBox(height: 24.0),

                  // Adresse
                  OfferAddressSection(offer: meal),
                  SizedBox(height: 24.0),

                  // Badges allergènes
                  OfferBadgesSection(offer: meal),
                  SizedBox(height: 24.0),

                  // Métadonnées
                  OfferMetadataSection(offer: meal),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),

          // Barre de réservation
          OfferReservationBar(
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
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.0),
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.green.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      meal.description,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.eco,
                          size: 14.0,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          'Végétarien',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
