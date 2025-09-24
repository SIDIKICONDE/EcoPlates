import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/food_offer.dart';
import '../widgets/offer_card/offer_card.dart';
import '../widgets/home/home_sections/offers_section.dart';

/// Liste des offres "Recommandé pour vous"
class RecommendedOffersScreen extends ConsumerWidget {
  const RecommendedOffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(recommendedOffersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommandé pour vous'),
      ),
      body: offersAsync.when(
        data: (offers) => _OffersList(offers: offers),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 32),
                const SizedBox(height: 8),
                Text('Impossible de charger les recommandations',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade700)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(recommendedOffersProvider),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OffersList extends StatelessWidget {
  final List<FoodOffer> offers;
  const _OffersList({required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const Center(child: Text('Aucune recommandation pour le moment'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final offer = offers[index];
        return OfferCard(
          offer: offer,
          onTap: () => context.go('/offer/${offer.id}')
        );
      },
    );
  }
}

/// Provider simple pour des recommandations (placeholder basé sur offersProvider)
final recommendedOffersProvider = Provider<AsyncValue<List<FoodOffer>>>((ref) {
  // Pour l'instant, on réutilise les données du provider d'offres et
  // on applique un tri/filtre léger pour simuler des recommandations.
  final base = ref.watch(offersProvider);
  return base.whenData((list) {
    final sorted = [...list]..sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
    return sorted.take(10).toList();
  });
});
