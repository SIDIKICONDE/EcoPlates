import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/image_preload_provider.dart';
import '../../../../core/responsive/responsive_utils.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/nearby_offers_provider.dart';
import '../../../providers/offer_reservation_provider.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';
import 'categories_section.dart';
import 'responsive_card_config.dart';

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
          ResponsiveCardConfig.getSliderCardWidth(context) +
          ResponsiveCardConfig.getCardSpacing(context);
      final scrollOffset = _scrollController.offset;
      final visibleIndexValue = (scrollOffset / itemWidth).round();
      visibleIndex = visibleIndexValue;
    }
  }

  double _calculateCardHeight(BuildContext context) {
    // Hauteur de l'image (depuis OfferCardImage)
    final imageHeight = ResponsiveUtils.responsiveValue(
      context,
      mobile: 120.0, // Mode compact
      tablet: 120.0,
      tabletLarge: 140.0,
      desktop: 160.0,
      desktopLarge: 180.0,
    );

    // Hauteur estimée du contenu en mode compact
    // (titre + description + pickup info + séparateur + prix + espacements)
    final contentHeight = ResponsiveUtils.responsiveValue(
      context,
      mobile: 110.0, // Contenu compact avec séparateur
      tablet: 110.0,
      tabletLarge: 120.0,
      desktop: 130.0,
      desktopLarge: 140.0,
    );

    // Paddings (top image: 2, top content: 4, bottom content: 2)
    const totalPadding = 8.0;

    return imageHeight + contentHeight + totalPadding;
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
            ResponsiveCardConfig.getSliderPadding(context).left,
            ResponsiveUtils.getVerticalSpacing(context) * 0.1,
            ResponsiveCardConfig.getSliderPadding(context).right,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Près de chez vous',
                  style: TextStyle(
                    fontSize: ResponsiveCardConfig.getSectionTitleFontSize(
                      context,
                    ),
                    fontWeight: FontWeight.w600,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
              ),
              // Bouton de filtre distance
              TextButton(
                onPressed: () => _showDistanceFilter(context),
                child: Text(
                  'Filtrer',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      14.0,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Liste des offres à proximité
        SizedBox(
          height: _calculateCardHeight(context),
          child: _buildOffersList(context, ref, allOffers),
        ),

        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),
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
              size: ResponsiveUtils.getIconSize(context, baseSize: 48.0),
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) * 0.4),
            Text(
              'Aucune offre à proximité',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14.0),
              ),
            ),
            Text(
              'Élargissez votre zone de recherche',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12.0),
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

    // Utiliser la configuration responsive
    final cardWidth = ResponsiveCardConfig.getSliderCardWidth(context);
    final cardSpacing = ResponsiveCardConfig.getCardSpacing(context);

    // Afficher les offres avec indicateur de distance
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: ResponsiveCardConfig.getSliderPadding(context),
      physics: const BouncingScrollPhysics(),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        final distance =
            offer.distanceKm ??
            (0.5 + (index * 0.1)); // Distance réelle si disponible

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: cardSpacing / 2),
          child: SizedBox(
            width: cardWidth,
            child: OfferCard(
              offer: offer,
              compact: true,
              isHomeSection: true,
              distance: distance,
              // showDistance: true est la valeur par défaut
              onTap: () {
                _showOfferDetailModal(context, offer);
              },
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
                padding: EdgeInsets.all(
                  ResponsiveUtils.getVerticalSpacing(context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              16.0,
                            ),
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(
                          height:
                              ResponsiveUtils.getVerticalSpacing(context) * 0.1,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: ResponsiveUtils.getIconSize(
                                context,
                                baseSize: 16.0,
                              ),
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            SizedBox(
                              width:
                                  ResponsiveUtils.getHorizontalSpacing(
                                    context,
                                  ) *
                                  0.1,
                            ),
                            Text(
                              'À 0.5 km • 8 min à pied',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  14.0,
                                ),
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: ResponsiveUtils.getIconSize(context),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Contenu de l'offre
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getVerticalSpacing(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ResponsiveUtils.getVerticalSpacing(context),
                      ),
                      OfferDetailsSection(offer: offer),
                      SizedBox(
                        height:
                            ResponsiveUtils.getVerticalSpacing(context) * 1.25,
                      ),
                      OfferAddressSection(offer: offer),
                      SizedBox(
                        height:
                            ResponsiveUtils.getVerticalSpacing(context) * 1.25,
                      ),
                      OfferBadgesSection(offer: offer),
                      SizedBox(
                        height:
                            ResponsiveUtils.getVerticalSpacing(context) * 1.25,
                      ),
                      OfferMetadataSection(offer: offer),
                      SizedBox(
                        height: ResponsiveUtils.getVerticalSpacing(context),
                      ),
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
      padding: EdgeInsets.all(
        ResponsiveUtils.getVerticalSpacing(context) * 1.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Distance de recherche',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20.0),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) * 0.4),
          Text(
            '${_selectedRadius.toStringAsFixed(1)} km',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) * 1.25),
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
          SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) * 0.6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.5 km',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    12.0,
                  ),
                ),
              ),
              Text(
                '5.0 km',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    12.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) * 1.25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onRadiusChanged(_selectedRadius),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getVerticalSpacing(context) * 0.6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Appliquer',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    13.0,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),
        ],
      ),
    );
  }
}
