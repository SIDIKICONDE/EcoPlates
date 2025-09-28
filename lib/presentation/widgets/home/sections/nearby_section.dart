import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/image_preload_provider.dart';
import '../../../../core/responsive/design_tokens.dart';
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
          (MediaQuery.of(context).size.width * 0.85) +
          context.scaleXS_SM_MD_LG; // largeur + padding
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
            context.scaleMD_LG_XL_XXL,
            context.scaleXXS_XS_SM_MD,
            context.scaleMD_LG_XL_XXL,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Près de chez vous',
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.titleSize(
                      context,
                    ),
                    fontWeight: EcoPlatesDesignTokens.typography.bold,
                  ),
                ),
              ),
              // Bouton de filtre distance
              IconButton(
                onPressed: () => _showDistanceFilter(context),
                icon: Icon(
                  Icons.tune,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        // Liste des offres à proximité
        SizedBox(
          height: EcoPlatesDesignTokens.layout.merchantCardHeight(context),
          child: _buildOffersList(context, ref, allOffers),
        ),

        SizedBox(height: context.scaleMD_LG_XL_XXL),
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
              size: EcoPlatesDesignTokens.size.modalIcon(context),
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
            ),
            SizedBox(height: context.scaleXS_SM_MD_LG),
            Text(
              'Aucune offre à proximité',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                fontSize: EcoPlatesDesignTokens.typography.text(context),
              ),
            ),
            Text(
              'Élargissez votre zone de recherche',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
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
      padding: EdgeInsets.symmetric(horizontal: context.scaleMD_LG_XL_XXL),
      physics: const BouncingScrollPhysics(),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        final distance =
            offer.distanceKm ??
            (DesignConstants.baseDistance +
                (index *
                    DesignConstants
                        .distanceIncrement)); // Distance réelle si disponible

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleXS_SM_MD_LG),
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
                  top: context.scaleXS_SM_MD_LG,
                  right: context.scaleXS_SM_MD_LG,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleXS_SM_MD_LG,
                      vertical: context.scaleXXS_XS_SM_MD,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                      borderRadius: BorderRadius.circular(
                        EcoPlatesDesignTokens.radius.xxl,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow
                              .withValues(
                                alpha: EcoPlatesDesignTokens.opacity.subtle,
                              ),
                          blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
                          offset:
                              EcoPlatesDesignTokens.elevation.standardOffset,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: EcoPlatesDesignTokens.size.indicator(context),
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(
                                alpha:
                                    EcoPlatesDesignTokens.opacity.almostOpaque,
                              ),
                        ),
                        SizedBox(width: context.scaleXXS_XS_SM_MD),
                        Text(
                          '${(distance * 15).round()} min',
                          style: TextStyle(
                            fontSize: EcoPlatesDesignTokens.typography.hint(
                              context,
                            ),
                            fontWeight: EcoPlatesDesignTokens.typography.bold,
                            color: Theme.of(context).colorScheme.onSurface
                                .withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .opacity
                                      .almostOpaque,
                                ),
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
  }

  void _showDistanceFilter(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
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
          height:
              MediaQuery.of(context).size.height *
              EcoPlatesDesignTokens.layout.modalHeightFactor(context),
          decoration: BoxDecoration(
            color: EcoPlatesDesignTokens.colors.modalBackground,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
            ),
          ),
          child: Column(
            children: [
              // Header avec indicateur de distance
              Container(
                padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.xxl),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest
                      .withValues(
                        alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                      ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
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
                          style: TextStyle(
                            fontSize: EcoPlatesDesignTokens.typography
                                .modalContent(context),
                            fontWeight: EcoPlatesDesignTokens.typography.bold,
                          ),
                        ),
                        SizedBox(height: context.scaleXXS_XS_SM_MD),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: EcoPlatesDesignTokens.size.indicator(
                                context,
                              ),
                              color: Theme.of(context).colorScheme.onSurface
                                  .withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .opacity
                                        .almostOpaque,
                                  ),
                            ),
                            SizedBox(width: context.scaleXXS_XS_SM_MD),
                            Text(
                              'À 0.5 km • 8 min à pied',
                              style: TextStyle(
                                fontSize: EcoPlatesDesignTokens.typography.hint(
                                  context,
                                ),
                                color: Theme.of(context).colorScheme.onSurface
                                    .withValues(
                                      alpha: EcoPlatesDesignTokens
                                          .opacity
                                          .almostOpaque,
                                    ),
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
                  padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OfferInfoSection(offer: offer),
                      SizedBox(height: context.scaleLG_XL_XXL_XXXL),
                      OfferDetailsSection(offer: offer),
                      SizedBox(height: context.scaleLG_XL_XXL_XXXL),
                      OfferAddressSection(offer: offer),
                      SizedBox(height: context.scaleLG_XL_XXL_XXXL),
                      OfferBadgesSection(offer: offer),
                      SizedBox(height: context.scaleLG_XL_XXL_XXXL),
                      OfferMetadataSection(offer: offer),
                      SizedBox(
                        height:
                            EcoPlatesDesignTokens.layout.mainContainerMinWidth,
                      ),
                    ],
                  ),
                ),
              ),

              // Barre de réservation
              Container(
                decoration: BoxDecoration(
                  color: EcoPlatesDesignTokens.colors.modalBackground,
                  border: Border(
                    top: BorderSide(
                      color: EcoPlatesDesignTokens.colors.subtleBorder,
                      width: EcoPlatesDesignTokens.layout.cardBorderWidth,
                    ),
                  ),
                ),
                child: Consumer(
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
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                                content: Text('Réservation impossible: $e'),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
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
      padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.xxxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Distance maximale',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                ),
              ),
              Text(
                '${_selectedRadius.toStringAsFixed(1)} km',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.modalContent(
                    context,
                  ),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleLG_XL_XXL_XXXL),
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
          SizedBox(height: context.scaleMD_LG_XL_XXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.5 km',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                  ),
                ),
              ),
              Text(
                '5.0 km',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleLG_XL_XXL_XXXL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onRadiusChanged(_selectedRadius),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: context.scaleMD_LG_XL_XXL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.md,
                  ),
                ),
              ),
              child: Text(
                'Appliquer',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.text(context),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: context.scaleXS_SM_MD_LG),
        ],
      ),
    );
  }
}
