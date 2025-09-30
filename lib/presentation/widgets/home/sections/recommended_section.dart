import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/image_preload_provider.dart';
import '../../../../core/responsive/responsive_utils.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offer_reservation_provider.dart';
import '../../../providers/recommended_offers_provider.dart';
import '../../../screens/all_recommended_offers_screen.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';
import 'categories_section.dart';
import 'responsive_card_config.dart';

/// Section des offres recommandées avec style Material 3
class RecommendedSection extends ConsumerStatefulWidget {
  const RecommendedSection({super.key});

  @override
  ConsumerState<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends ConsumerState<RecommendedSection>
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
    if (_scrollController.hasClients) {
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

    // Paddings (top image: 2, top content: 6, bottom content: 4)
    const totalPadding = 12.0;

    return imageHeight + contentHeight + totalPadding;
  }

  @override
  Widget build(BuildContext context) {
    final recommendedOffers = ref.watch(recommendedOffersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section avec style amélioré
        Container(
          padding: EdgeInsets.fromLTRB(
            ResponsiveCardConfig.getSliderPadding(context).left,
            ResponsiveUtils.getVerticalSpacing(context) * 0.4,
            ResponsiveCardConfig.getSliderPadding(context).right,
            ResponsiveUtils.getVerticalSpacing(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommandé pour vous',
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
              TextButton(
                onPressed: () {
                  unawaited(
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            const AllRecommendedOffersScreen(),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Voir tout',
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

        // Liste horizontale d'offres avec animations
        SizedBox(
          height: _calculateCardHeight(context),
          child: Builder(
            builder: (context) {
              final offers = ref.watch(
                filterOffersByCategoryProvider(recommendedOffers),
              );

              if (offers.isEmpty) {
                return _buildEmptyState(context);
              }

              // Démarrer le préchargement des images proches de l'index visible
              final imageUrls = offers
                  .where((o) => o.images.isNotEmpty)
                  .map((o) => o.images.first)
                  .toList();
              startAutoPreload(imageUrls: imageUrls, ref: ref);

              // Utiliser la configuration responsive pour la largeur des cartes
              final cardWidth = ResponsiveCardConfig.getSliderCardWidth(
                context,
              );
              final cardSpacing = ResponsiveCardConfig.getCardSpacing(context);

              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: ResponsiveCardConfig.getSliderPadding(context),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(horizontal: cardSpacing / 2),
                    child: SizedBox(
                      width: cardWidth, // Utiliser la valeur responsive
                      child: OfferCard(
                        offer: offer,
                        compact: true,
                        isHomeSection: true,
                        distance: 50.0 + (index * 10.0),
                        onTap: () => _showOfferDetailModal(context, offer),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) * 1.5),
      ],
    );
  }

  // _buildLoadingState supprimé: provider devenu synchrone

  // _buildErrorState supprimé: provider devenu synchrone

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.getVerticalSpacing(context),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: ResponsiveUtils.getIconSize(context, baseSize: 48.0),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),
          Text(
            'Aucune recommandation',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18.0),
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) * 0.4),
          Text(
            'Revenez plus tard pour découvrir de nouvelles offres',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14.0),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showOfferDetailModal(BuildContext context, FoodOffer offer) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        useSafeArea: true,
        builder: (context) => _buildOfferDetailModal(context, offer),
      ),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    final mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: mediaQuery.size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 16.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Indicateur de glissement et header
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.getVerticalSpacing(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Détails de l'offre",
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        18.0,
                      ),
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    padding: EdgeInsets.all(
                      ResponsiveUtils.getVerticalSpacing(context) * 0.5,
                    ),
                  ),
                  icon: Icon(
                    Icons.close,
                    size: ResponsiveUtils.getIconSize(context),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Contenu scrollable avec animations
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getVerticalSpacing(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales avec animation
                  _AnimatedSection(
                    delay: 0,
                    child: OfferInfoSection(offer: offer),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.getVerticalSpacing(context) * 1.5,
                  ),

                  // Détails pratiques
                  _AnimatedSection(
                    delay: 100,
                    child: OfferDetailsSection(offer: offer),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.getVerticalSpacing(context) * 1.5,
                  ),

                  // Adresse
                  _AnimatedSection(
                    delay: 200,
                    child: OfferAddressSection(offer: offer),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.getVerticalSpacing(context) * 1.5,
                  ),

                  // Badges allergènes
                  _AnimatedSection(
                    delay: 300,
                    child: OfferBadgesSection(offer: offer),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.getVerticalSpacing(context) * 1.5,
                  ),

                  // Métadonnées
                  _AnimatedSection(
                    delay: 400,
                    child: OfferMetadataSection(offer: offer),
                  ),
                  SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),
                ],
              ),
            ),
          ),

          // Barre de réservation
          SafeArea(
            top: false,
            child: Builder(
              builder: (context) {
                return Consumer(
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
                            _showReservationConfirmation(context, offer);
                          }
                        } on Exception catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                                content: Text(
                                  'Réservation impossible: $e',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationConfirmation(BuildContext context, FoodOffer offer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                'Réservation pour "${offer.title}" confirmée !',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        action: SnackBarAction(
          label: 'Voir',
          textColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            // Navigation vers les réservations
          },
        ),
      ),
    );
  }
}

// Widget d'animation pour les sections
class _AnimatedSection extends StatefulWidget {
  const _AnimatedSection({required this.child, required this.delay});
  final Widget child;
  final int delay;

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        unawaited(_controller.forward());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
