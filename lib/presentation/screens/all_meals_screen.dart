import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../providers/meals_provider.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/offer_detail_modal.dart';
import '../widgets/offer_card.dart';

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
          ? const EmptyState(
              icon: Icons.restaurant_outlined,
              title: 'Aucun repas disponible',
              subtitle: 'Revenez plus tard pour découvrir de nouveaux repas',
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: OfferCard(
                    offer: meal,
                    distance: 0.8 + (index * 0.3), // Distance simulée
                    onTap: () async {
                      await _showMealDetailModal(context, meal);
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
      builder: (context) => OfferDetailModal(
        offer: meal,
        title: meal.title,
        subtitle: 'À récupérer : ${_formatPickupTime(meal)}',
        height: 0.7,
        showMealComposition: true,
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
    );
  }

  // Widget modal centralisé via OfferDetailModal

  String _formatPickupTime(FoodOffer meal) {
    final start =
        '${meal.pickupStartTime.hour.toString().padLeft(2, '0')}:${meal.pickupStartTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${meal.pickupEndTime.hour.toString().padLeft(2, '0')}:${meal.pickupEndTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}
