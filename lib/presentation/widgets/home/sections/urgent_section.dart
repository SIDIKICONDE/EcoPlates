import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/image_preload_provider.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/urgent_offers_provider.dart';
import '../../../screens/all_urgent_offers_screen.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';
import 'categories_section.dart';

/// Section des offres urgentes à sauver avant qu'il soit trop tard
class UrgentSection extends ConsumerStatefulWidget {
  const UrgentSection({super.key});

  @override
  ConsumerState<UrgentSection> createState() => _UrgentSectionState();
}

class _UrgentSectionState extends ConsumerState<UrgentSection>
    with AutoPreloadImages {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // Déterminer l'index visible pour le préchargement
    if (_scrollController.hasClients) {
      const itemWidth = 340.0 + 8.0; // largeur + padding
      final scrollOffset = _scrollController.offset;
      final visibleIndexValue = (scrollOffset / itemWidth).round();
      visibleIndex = visibleIndexValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgentOffersAsync = ref.watch(urgentOffersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section avec indicateur d'urgence
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icône animée d'urgence
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1, end: 1.2),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.timer_outlined,
                            color: Colors.red[600],
                            size: 20,
                          ),
                        ),
                      );
                    },
                    onEnd: () {},
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "À sauver d'urgence !",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        'Dernière chance avant fermeture',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigation vers la page complète des offres urgentes
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const AllUrgentOffersScreen(),
                    ),
                  );
                },
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),

        // Liste horizontale d'offres urgentes
        SizedBox(
          height: 275, // Hauteur ajustée pour éliminer l'espace blanc
          child: urgentOffersAsync.when(
            data: (allOffers) {
              // Filtrer les offres selon la catégorie sélectionnée
              final offers = ref.watch(filterOffersByCategoryProvider(allOffers));
              if (offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.green[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aucune offre urgente',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      Text(
                        'Tout a été sauvé !',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Précharger les images des offres urgentes
              final imageUrls = offers.map((o) => o.images.first).toList();
              startAutoPreload(imageUrls: imageUrls, ref: ref);

              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      width: 340,
                      child: OfferCard(
                        offer: offer,
                        compact: true,
                        distance:
                            0.5 +
                            (index *
                                0.2), // Distance plus proche pour l'urgence
                        onTap: () {
                          _showOfferDetailModal(context, offer);
                        },
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      ref.invalidate(urgentOffersProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  void _showOfferDetailModal(BuildContext context, FoodOffer offer) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOfferDetailModal(context, offer),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    final remainingTime = offer.pickupEndTime.difference(DateTime.now());
    final isVeryUrgent = remainingTime.inMinutes <= 60;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header de la modal avec indicateur d'urgence
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isVeryUrgent ? Colors.red[50] : Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Offre urgente !',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'À récupérer avant ${_formatTime(offer.pickupEndTime)}',
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
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Barre de réservation avec indication d'urgence
          Container(
            decoration: BoxDecoration(
              color: isVeryUrgent ? Colors.red[50] : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isVeryUrgent ? Colors.red[200]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: OfferReservationBar(
              offer: offer,
              isReserving: false,
              onReserve: () {
                // Logique de réservation
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('✅ "${offer.title}" réservé avec succès !'),
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

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
