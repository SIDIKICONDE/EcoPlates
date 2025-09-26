import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Repas complets',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Menus et formules à prix réduits',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
          height: 275, // Hauteur optimisée pour les cartes d'offres
          child: _buildMealsList(context, ref, allMeals),
        ),

        const SizedBox(height: 16),
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
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Aucun repas disponible',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const BouncingScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width: 340, // Largeur des cartes
            child: OfferCard(
              offer: meal,
              compact: true,
              distance: 0.8 + (index * 0.3), // Distance simulée
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repas complet',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'À récupérer : ${_formatPickupTime(meal)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales
                  OfferInfoSection(offer: meal),
                  const SizedBox(height: 24),

                  // Composition du repas
                  _buildMealComposition(meal),
                  const SizedBox(height: 24),

                  // Détails pratiques
                  OfferDetailsSection(offer: meal),
                  const SizedBox(height: 24),

                  // Adresse
                  OfferAddressSection(offer: meal),
                  const SizedBox(height: 24),

                  // Badges allergènes
                  OfferBadgesSection(offer: meal),
                  const SizedBox(height: 24),

                  // Métadonnées
                  OfferMetadataSection(offer: meal),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Barre de réservation
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
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

  Widget _buildMealComposition(FoodOffer meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Composition du repas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.restaurant_menu,
                    size: 20,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meal.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (meal.isVegetarian) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco, size: 14, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(
                            'Végétarien',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
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
