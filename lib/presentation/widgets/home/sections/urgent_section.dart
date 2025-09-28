import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/image_preload_provider.dart';
import '../../../../core/responsive/design_tokens.dart';
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
          context.scaleXXS_XS_SM_MD * 2; // largeur + padding
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
            context.scaleMD_LG_XL_XXL,
            context.scaleXS_SM_MD_LG,
            context.scaleMD_LG_XL_XXL,
            context.scaleMD_LG_XL_XXL,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icône animée d'urgence
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: EcoPlatesDesignTokens.opacity.veryOpaque,
                      end: EcoPlatesDesignTokens.urgentOffers.pulseEnd,
                    ),
                    duration: EcoPlatesDesignTokens.animation.normal,
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
                          decoration: BoxDecoration(
                            color: EcoPlatesDesignTokens.colors.snackbarError
                                .withValues(
                                  alpha:
                                      EcoPlatesDesignTokens.opacity.verySubtle,
                                ),
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.sm,
                            ),
                          ),
                          child: Icon(
                            Icons.timer_outlined,
                            color: EcoPlatesDesignTokens.colors.snackbarError,
                            size: EcoPlatesDesignTokens.size.indicator(context),
                          ),
                        ),
                      );
                    },
                    onEnd: () {},
                  ),
                  SizedBox(width: context.scaleXS_SM_MD_LG),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "À sauver d'urgence !",
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.titleSize(
                            context,
                          ),
                          fontWeight: EcoPlatesDesignTokens.typography.bold,
                          color: EcoPlatesDesignTokens.colors.snackbarError,
                        ),
                      ),
                      Text(
                        'Dernière chance avant fermeture',
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(
                                alpha:
                                    EcoPlatesDesignTokens.opacity.almostOpaque,
                              ),
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
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),

        // Liste horizontale d'offres urgentes
        SizedBox(
          height: EcoPlatesDesignTokens.layout.merchantCardHeight(context) + 50,
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
                        size: EcoPlatesDesignTokens.size.modalIcon(context),
                        color: EcoPlatesDesignTokens.colors.snackbarSuccess
                            .withValues(
                              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                            ),
                      ),
                      SizedBox(height: context.scaleXS_SM_MD_LG),
                      Text(
                        'Aucune offre urgente',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(
                                alpha:
                                    EcoPlatesDesignTokens.opacity.almostOpaque,
                              ),
                          fontSize: EcoPlatesDesignTokens.typography.text(
                            context,
                          ),
                        ),
                      ),
                      Text(
                        'Tout a été sauvé !',
                        style: TextStyle(
                          color: EcoPlatesDesignTokens.colors.snackbarSuccess,
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
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
                  horizontal: context.scaleMD_LG_XL_XXL,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleXXS_XS_SM_MD,
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

        SizedBox(height: context.scaleXS_SM_MD_LG),
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
        ),
      ),
      child: Column(
        children: [
          // Header de la modal avec indicateur d'urgence
          Container(
            padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
            decoration: BoxDecoration(
              color: isVeryUrgent
                  ? EcoPlatesDesignTokens.colors.snackbarError.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                    )
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(EcoPlatesDesignTokens.radius.xxl),
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
                            fontSize: EcoPlatesDesignTokens.typography.hint(
                              context,
                            ),
                            color: EcoPlatesDesignTokens.colors.snackbarError,
                            fontWeight: EcoPlatesDesignTokens.typography.bold,
                          ),
                        ),
                        Text(
                          'À récupérer avant ${_formatTime(offer.pickupEndTime)}',
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
              padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales
                  OfferInfoSection(offer: offer),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Détails pratiques
                  OfferDetailsSection(offer: offer),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Adresse
                  OfferAddressSection(offer: offer),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Badges allergènes
                  OfferBadgesSection(offer: offer),
                  SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                  // Métadonnées
                  OfferMetadataSection(offer: offer),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Barre de réservation avec indication d'urgence
          Container(
            decoration: BoxDecoration(
              color: isVeryUrgent
                  ? EcoPlatesDesignTokens.colors.snackbarError.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                    )
                  : Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: isVeryUrgent
                      ? EcoPlatesDesignTokens.colors.snackbarError.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        )
                      : Theme.of(context).colorScheme.outline.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        ),
                  width: EcoPlatesDesignTokens.layout.cardBorderWidth,
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
                    backgroundColor:
                        EcoPlatesDesignTokens.colors.snackbarSuccess,
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
