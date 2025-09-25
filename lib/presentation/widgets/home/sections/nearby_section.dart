import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/food_offer.dart';
import '../../../providers/nearby_offers_provider.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';
import 'categories_section.dart';

/// Section des offres près de chez vous avec géolocalisation
class NearbySection extends ConsumerWidget {
  const NearbySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyOffersAsync = ref.watch(nearbyOffersProvider);
    // Watch providers to trigger rebuilds when they change
    ref.watch(userLocationProvider);
    ref.watch(searchRadiusProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section avec localisation
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Près de chez vous',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Bouton de filtre distance
              IconButton(
                onPressed: () => _showDistanceFilter(context, ref),
                icon: Icon(Icons.tune, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),

        // Liste des offres à proximité
        SizedBox(
          height: 280,
          child: nearbyOffersAsync.when(
            data: (allOffers) {
              // Filtrer les offres selon la catégorie sélectionnée
              final offers = ref.watch(filterOffersByCategoryProvider(allOffers));
              if (offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aucune offre à proximité',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      Text(
                        'Élargissez votre zone de recherche',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              // Afficher les offres avec indicateur de distance
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
final distance = offer.distanceKm ?? (0.3 + (index * 0.4)); // Distance réelle si disponible

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      width: 340,
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
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.directions_walk,
                                    size: 14,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
'${(distance * 15).round()} min',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                      ref.invalidate(nearbyOffersProvider);
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

  void _showDistanceFilter(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _DistanceFilterModal(
        currentRadius: ref.read(searchRadiusProvider),
        onRadiusChanged: (newRadius) {
          ref.read(searchRadiusProvider.notifier).state = newRadius;
          Navigator.pop(context);
          // Rafraîchir les offres
          ref.invalidate(nearbyOffersProvider);
        },
      ),
    );
  }

  void _showOfferDetailModal(BuildContext context, FoodOffer offer) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header avec indicateur de distance
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
                        offer.merchantName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'À 0.5 km • 8 min à pied',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OfferInfoSection(offer: offer),
                    const SizedBox(height: 24),
                    OfferDetailsSection(offer: offer),
                    const SizedBox(height: 24),
                    OfferAddressSection(offer: offer),
                    const SizedBox(height: 24),
                    OfferBadgesSection(offer: offer),
                    const SizedBox(height: 24),
                    OfferMetadataSection(offer: offer),
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
                offer: offer,
                isReserving: false,
                onReserve: () {
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
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Distance maximale',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_selectedRadius.toStringAsFixed(1)} km',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0.5 km', style: TextStyle(color: Colors.grey[600])),
              Text('5.0 km', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onRadiusChanged(_selectedRadius),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Appliquer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
