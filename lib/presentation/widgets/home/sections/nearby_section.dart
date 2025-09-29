import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/image_preload_provider.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/nearby_offers_provider.dart';
import '../../../providers/offer_reservation_provider.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';
import 'categories_section.dart';

/// Section des offres près de chez vous avec géolocalisation
class NearbySection extends ConsumerStatefulWidget {
  const NearbySection({super.key});

  @override
  ConsumerState<NearbySection> createState() => _NearbySectionState();
}

class _NearbySectionState extends ConsumerState<NearbySection>
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
    if (_scrollController.hasClients && mounted) {
      final itemWidth =
          (MediaQuery.of(context).size.width * 0.85) + 3.0; // largeur + padding
      final scrollOffset = _scrollController.offset;
      final visibleIndexValue = (scrollOffset / itemWidth).round();
      visibleIndex = visibleIndexValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allOffers = ref.watch(nearbyOffersProvider);
    // Watch providers to trigger rebuilds when they change
    ref
      ..watch(userLocationProvider)
      ..watch(searchRadiusProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section avec localisation
        Padding(
          padding: EdgeInsets.fromLTRB(
            10.0,
            2.0,
            10.0,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Près de chez vous',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Bouton de filtre distance
              IconButton(
                onPressed: () => _showDistanceFilter(context),
                icon: Icon(
                  Icons.tune,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // Liste des offres à proximité
        SizedBox(
          height: 16.0,
          child: _buildOffersList(context, ref, allOffers),
        ),

        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildOffersList(
    BuildContext context,
    WidgetRef ref,
    List<FoodOffer> allOffers,
  ) {
    // Filtrer les offres selon la catégorie sélectionnée
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final offers = selectedCategory == null
        ? allOffers
        : allOffers
              .where((offer) => offer.category == selectedCategory)
              .toList();

    if (offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48.0,
              color: Colors.grey,
            ),
            SizedBox(height: 8.0),
            Text(
              'Aucune offre à proximité',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14.0,
              ),
            ),
            Text(
              'Élargissez votre zone de recherche',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      );
    }

    // Démarrer le préchargement des images proches de l'index visible
    final imageUrls = offers
        .where((FoodOffer o) => o.images.isNotEmpty)
        .map((FoodOffer o) => o.images.first)
        .toList();
    startAutoPreload(imageUrls: imageUrls, ref: ref);

    // Afficher les offres avec indicateur de distance
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      physics: const BouncingScrollPhysics(),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        final distance =
            offer.distanceKm ??
            (0.5 + (index * 0.1)); // Distance réelle si disponible

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Stack(
              children: [
                OfferCard(
                  offer: offer,
                  compact: true,
                  distance: distance,
                  onTap: () {
                    _showOfferDetailModal(context, offer);
                  },
                ),
                // Badge distance en haut à droite
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Text(
                      '${(distance * 15).round()} min',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDistanceFilter(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.0),
          ),
        ),
        builder: (context) => _DistanceFilterModal(
          currentRadius: ref.read(searchRadiusProvider),
          onRadiusChanged: (newRadius) {
            ref.read(searchRadiusProvider.notifier).updateRadius(newRadius);
            Navigator.pop(context);
            // Rafraîchir les offres
            ref.invalidate(nearbyOffersProvider);
          },
        ),
      ),
    );
  }

  void _showOfferDetailModal(BuildContext context, FoodOffer offer) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.0),
            ),
          ),
          child: Column(
            children: [
              // Header avec indicateur de distance
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
                          offer.merchantName,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.0,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 2.0),
                            Text(
                              'À 0.5 km • 8 min à pied',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
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

              // Contenu de l'offre
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      OfferDetailsSection(offer: offer),
                      SizedBox(height: 20.0),
                      OfferAddressSection(offer: offer),
                      SizedBox(height: 20.0),
                      OfferBadgesSection(offer: offer),
                      SizedBox(height: 20.0),
                      OfferMetadataSection(offer: offer),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),

              // Barre de réservation
              Consumer(
                builder: (context, ref, _) {
                  return OfferReservationBar(
                    offer: offer,
                    isReserving: false,
                    onReserve: () async {
                      try {
                        await ref
                            .read(offerReservationProvider.notifier)
                            .reserve(offer: offer);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                '✅ "${offer.title}" réservé avec succès !',
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      } on Exception catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Réservation impossible: $e'),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal de filtre de distance
class _DistanceFilterModal extends StatefulWidget {
  const _DistanceFilterModal({
    required this.currentRadius,
    required this.onRadiusChanged,
  });

  final double currentRadius;
  final void Function(double) onRadiusChanged;

  @override
  State<_DistanceFilterModal> createState() => _DistanceFilterModalState();
}

class _DistanceFilterModalState extends State<_DistanceFilterModal> {
  late double _selectedRadius;

  @override
  void initState() {
    super.initState();
    _selectedRadius = widget.currentRadius;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Distance de recherche',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '${_selectedRadius.toStringAsFixed(1)} km',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 20.0),
          Slider(
            value: _selectedRadius,
            min: 0.5,
            max: 5,
            divisions: 9,
            label: '${_selectedRadius.toStringAsFixed(1)} km',
            onChanged: (value) {
              setState(() {
                _selectedRadius = value;
              });
            },
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.5 km',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.0,
                ),
              ),
              Text(
                '5.0 km',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onRadiusChanged(_selectedRadius),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
              ),
              child: Text(
                'Appliquer',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
