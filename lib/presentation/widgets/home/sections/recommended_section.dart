import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/image_preload_provider.dart';
import '../../../../core/responsive/design_tokens.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offer_reservation_provider.dart';
import '../../../providers/recommended_offers_provider.dart';
import '../../../screens/all_recommended_offers_screen.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';
import 'categories_section.dart';

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
          (MediaQuery.of(context).size.width * 0.85) + context.scaleXS_SM_MD_LG;
      final scrollOffset = _scrollController.offset;
      final visibleIndexValue = (scrollOffset / itemWidth).round();
      visibleIndex = visibleIndexValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendedOffers = ref.watch(recommendedOffersProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section avec style amélioré
        Container(
          padding: EdgeInsets.fromLTRB(
            context.scaleMD_LG_XL_XXL,
            context.scaleLG_XL_XXL_XXXL / 2,
            context.scaleMD_LG_XL_XXL - context.scaleXS_SM_MD_LG,
            context.scaleMD_LG_XL_XXL,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommandé pour vous',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
                  fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
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
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: EcoPlatesDesignTokens.size.indicator(context),
                  color: colorScheme.primary,
                ),
                label: Text(
                  'Voir tout',
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.text(context),
                    color: colorScheme.primary,
                    fontWeight: EcoPlatesDesignTokens.typography.medium,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleMD_LG_XL_XXL,
                    vertical: context.scaleXS_SM_MD_LG,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Liste horizontale d'offres avec animations
        SizedBox(
          height: EcoPlatesDesignTokens.layout.merchantCardHeight(context),
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

              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal:
                      context.scaleMD_LG_XL_XXL - context.scaleXS_SM_MD_LG / 2,
                ),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleXS_SM_MD_LG / 2,
                    ),
                    child: SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                          (MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 0.9
                              : 0.85),
                      child: OfferCard(
                        offer: offer,
                        compact: true,
                        distance:
                            DesignConstants.baseDistance +
                            (index * DesignConstants.distanceIncrement),
                        onTap: () => _showOfferDetailModal(context, offer),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        SizedBox(height: context.scaleLG_XL_XXL_XXXL),
      ],
    );
  }

  // _buildLoadingState supprimé: provider devenu synchrone

  // _buildErrorState supprimé: provider devenu synchrone

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.xxl),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: EcoPlatesDesignTokens.size.modalIcon(context),
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(height: context.scaleMD_LG_XL_XXL),
            Text(
              'Aucune recommandation',
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.modalContent(
                  context,
                ),
                color: colorScheme.onSurface,
                fontWeight: EcoPlatesDesignTokens.typography.medium,
              ),
            ),
            SizedBox(height: context.scaleXS_SM_MD_LG),
            Text(
              'Revenez plus tard pour découvrir de nouvelles offres',
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.text(context),
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
        useSafeArea: true,
        builder: (context) => _buildOfferDetailModal(context, offer),
      ),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          mediaQuery.size.height *
          EcoPlatesDesignTokens.layout.modalHeightFactor(context),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Indicateur de glissement
          Container(
            margin: EdgeInsets.only(top: context.scaleXS_SM_MD_LG),
            width: EcoPlatesDesignTokens.layout.modalHandleWidth,
            height: EcoPlatesDesignTokens.layout.modalHandleHeight,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.xs,
              ),
            ),
          ),

          // Header de la modal avec style Material 3
          Container(
            padding: EdgeInsets.fromLTRB(
              EcoPlatesDesignTokens.spacing.xxxl,
              context.scaleMD_LG_XL_XXL,
              context.scaleMD_LG_XL_XXL,
              context.scaleMD_LG_XL_XXL,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Détails de l'offre",
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.titleSize(
                        context,
                      ),
                      fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
                  ),
                ),
              ],
            ),
          ),

          // Contenu scrollable avec animations
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: EcoPlatesDesignTokens.spacing.xxxl,
                vertical: context.scaleMD_LG_XL_XXL,
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales avec animation
                  _AnimatedSection(
                    delay: 0,
                    child: OfferInfoSection(offer: offer),
                  ),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Détails pratiques
                  _AnimatedSection(
                    delay: 100,
                    child: OfferDetailsSection(offer: offer),
                  ),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Adresse
                  _AnimatedSection(
                    delay: 200,
                    child: OfferAddressSection(offer: offer),
                  ),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Badges allergènes
                  _AnimatedSection(
                    delay: 300,
                    child: OfferBadgesSection(offer: offer),
                  ),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Métadonnées
                  _AnimatedSection(
                    delay: 400,
                    child: OfferMetadataSection(offer: offer),
                  ),
                  SizedBox(
                    height: EcoPlatesDesignTokens.layout.mainContainerMinWidth,
                  ), // Espace pour la barre de réservation
                ],
              ),
            ),
          ),

          // Barre de réservation avec style amélioré
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  ),
                  blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
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
                                  backgroundColor: colorScheme.error,
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
          ),
        ],
      ),
    );
  }

  void _showReservationConfirmation(BuildContext context, FoodOffer offer) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: colorScheme.onPrimary),
            SizedBox(width: context.scaleMD_LG_XL_XXL),
            Expanded(
              child: Text(
                'Réservation pour "${offer.title}" confirmée !',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Voir',
          textColor: colorScheme.onPrimary,
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
