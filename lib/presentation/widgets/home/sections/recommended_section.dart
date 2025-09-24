import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/recommended_offers_provider.dart';
import '../../offer_card.dart';

/// Section des offres recommandées
class RecommendedSection extends ConsumerWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedOffersAsync = ref.watch(recommendedOffersProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recommandé pour vous',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigation vers toutes les offres recommandées
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Voir toutes les recommandations'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),
        
        // Liste horizontale d'offres
        SizedBox(
          height: 240, // Hauteur ajustée pour éviter l'overflow
          child: recommendedOffersAsync.when(
            data: (offers) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              physics: const BouncingScrollPhysics(),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SizedBox(
                    width: 250, // Largeur fixe pour les cartes
                    child: OfferCard(
                      offer: offer,
                      showDistance: true,
                      distance: 1.2 + (index * 0.3), // Distance simulée
                      onTap: () {
                        // Navigation vers le détail de l'offre
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Offre sélectionnée: ${offer.title}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      ref.invalidate(recommendedOffersProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }
}