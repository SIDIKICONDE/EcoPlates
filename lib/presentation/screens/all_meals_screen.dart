import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/meals_provider.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail/index.dart';
import '../../domain/entities/food_offer.dart';

/// Page affichant tous les repas complets disponibles
class AllMealsScreen extends ConsumerWidget {
  const AllMealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tous les repas complets'),
        centerTitle: true,
        elevation: 0,
      ),
      body: mealsAsync.when(
        data: (meals) {
          if (meals.isEmpty) {
            return Center(
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
                    'Aucun repas disponible',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revenez plus tard pour découvrir de nouveaux repas',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OfferCard(
                  offer: meal,
                  compact: false,
                  showDistance: true,
                  distance: 0.8 + (index * 0.3), // Distance simulée
                  onTap: () {
                    _showMealDetailModal(context, meal);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
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
                'Erreur de chargement',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(mealsProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMealDetailModal(BuildContext context, FoodOffer meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMealDetailModal(context, meal),
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
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
  
  Widget _buildMealComposition(FoodOffer meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Composition du repas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
                  const Icon(Icons.restaurant_menu, size: 20, color: Colors.orange),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    final start = '${meal.pickupStartTime.hour.toString().padLeft(2, '0')}:${meal.pickupStartTime.minute.toString().padLeft(2, '0')}';
    final end = '${meal.pickupEndTime.hour.toString().padLeft(2, '0')}:${meal.pickupEndTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}