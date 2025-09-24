import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/recommended_offers_provider.dart';
import '../../offer_card.dart';
import '../../../screens/all_recommended_offers_screen.dart';
import '../../offer_detail/index.dart';
import '../../../../domain/entities/food_offer.dart';

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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                  // Navigation vers la page complète des offres recommandées
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const AllRecommendedOffersScreen(),
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
          height: 250, // Hauteur augmentée pour ligne prix séparée
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
                    width: 280, // Largeur réduite pour les cartes compactes
                    child: OfferCard(
                      offer: offer,
                      compact: true,
                      showDistance: true,
                      distance: 1.2 + (index * 0.3), // Distance simulée
                      onTap: () {
                        // Navigation vers le détail de l'offre
                        _showOfferDetailModal(context, offer);
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

  void _showOfferDetailModal(BuildContext context, FoodOffer offer) {
    showModalBottomSheet(
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Détails de l\'offre',
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
                  const SizedBox(height: 100), // Espace pour la barre de réservation
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
                  content: Text('Réservation pour "${offer.title}" confirmée !'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
