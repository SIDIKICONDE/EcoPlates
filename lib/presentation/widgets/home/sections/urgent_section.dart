import 'dart:async';
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
      final itemWidth =
          (MediaQuery.of(context).size.width * 0.85) +
          16.0; // largeur + padding
      final scrollOffset = _scrollController.offset;
      final visibleIndexValue = (scrollOffset / itemWidth).round();
      visibleIndex = visibleIndexValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgentOffers = ref.watch(urgentOffersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section avec indicateur d'urgence
        Padding(
          padding: EdgeInsets.fromLTRB(
            16.0,
            12.0,
            16.0,
            16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icône animée d'urgence
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 1.2),
                    duration: Duration(seconds: 1),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            Icons.warning,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      );
                    },
                    onEnd: () {},
                  ),
                  SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "À sauver d'urgence !",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigation vers la page complète des offres urgentes
                  unawaited(
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const AllUrgentOffersScreen(),
                      ),
                    ),
                  );
                },
                child: Text(
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
        ),

        // Liste horizontale d'offres urgentes
        SizedBox(
          height: 280.0,
          child: Builder(
            builder: (context) {
              // Filtrer les offres selon la catégorie sélectionnée
              final offers = ref.watch(
                filterOffersByCategoryProvider(urgentOffers),
              );

              if (offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48.0,
                        color: Colors.green,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Aucune offre urgente',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Tout a été sauvé !',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
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
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: OfferCard(
                        offer: offer,
                        compact: true,
                        distance: 0.5 + (index * 0.2),
                        onTap: () {
                          _showOfferDetailModal(context, offer);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        SizedBox(height: 16.0),
      ],
    );
  }

  void _showOfferDetailModal(BuildContext context, FoodOffer offer) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildOfferDetailModal(context, offer),
      ),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    final remainingTime = offer.pickupEndTime.difference(DateTime.now());
    final isVeryUrgent = remainingTime.inMinutes <= 60;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isVeryUrgent ? Colors.red.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offre urgente',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: isVeryUrgent ? Colors.red : Colors.black,
                      ),
                    ),
                    Text(
                      offer.title,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade600,
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales
                  OfferInfoSection(offer: offer),
                  SizedBox(height: 20.0),

                  // Détails pratiques
                  OfferDetailsSection(offer: offer),
                  SizedBox(height: 20.0),

                  // Adresse
                  OfferAddressSection(offer: offer),
                  SizedBox(height: 20.0),

                  // Badges allergènes
                  OfferBadgesSection(offer: offer),
                  SizedBox(height: 20.0),

                  // Métadonnées
                  OfferMetadataSection(offer: offer),
                  SizedBox(height: 100.0),
                ],
              ),
            ),
          ),

          // Barre de réservation avec indication d'urgence
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isVeryUrgent ? Colors.red.shade50 : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isVeryUrgent
                      ? Colors.red.shade200
                      : Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVeryUrgent ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  isVeryUrgent ? 'RÉSERVER URGENT' : 'Réserver',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
