import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/services/image_cache_service.dart';
import '../../../core/utils/offer_formatters.dart';
import '../../../core/widgets/eco_cached_image.dart';
import '../../../domain/entities/food_offer.dart';

/// Header de l'offre avec image et badges
class OfferImageHeader extends StatelessWidget {
  const OfferImageHeader({
    required this.offer,
    required this.onBackPressed,
    super.key,
  });
  final FoodOffer offer;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image principale
            if (offer.images.isNotEmpty)
              EcoCachedImage(
                imageUrl: offer.images.first,
                size: ImageSize.large,
                placeholder: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: _buildPlaceholderImage(context),
              )
            else
              _buildPlaceholderImage(context),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                    ),
                  ],
                ),
              ),
            ),

            // Barre en bas avec tous les éléments alignés
            Positioned(
              bottom: context.scaleMD_LG_XL_XXL,
              left: context.scaleMD_LG_XL_XXL,
              right: context.scaleMD_LG_XL_XXL,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Côté gauche : Merchant et badge temps
                  Expanded(
                    child: Row(
                      children: [
                        // Nom du merchant
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleMD_LG_XL_XXL,
                            vertical: context.scaleXS_SM_MD_LG,
                          ),
                          decoration: BoxDecoration(
                            color: EcoPlatesDesignTokens.colors.overlayBlack
                                .withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .opacity
                                      .almostOpaque,
                                ),
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.xxl,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.restaurant,
                                size: EcoPlatesDesignTokens.size.indicator(
                                  context,
                                ),
                                color: EcoPlatesDesignTokens.colors.textPrimary,
                              ),
                              SizedBox(width: context.scaleXXS_XS_SM_MD),
                              Text(
                                offer.merchantName,
                                style: TextStyle(
                                  color:
                                      EcoPlatesDesignTokens.colors.textPrimary,
                                  fontWeight:
                                      EcoPlatesDesignTokens.typography.medium,
                                  fontSize: EcoPlatesDesignTokens.typography
                                      .hint(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: context.scaleXS_SM_MD_LG),
                        // Badge temps restant
                        if (offer.canPickup)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.scaleMD_LG_XL_XXL,
                              vertical: context.scaleXS_SM_MD_LG,
                            ),
                            decoration: BoxDecoration(
                              color: EcoPlatesDesignTokens.colors.snackbarError,
                              borderRadius: BorderRadius.circular(
                                EcoPlatesDesignTokens.radius.xxl,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: EcoPlatesDesignTokens.size.indicator(
                                    context,
                                  ),
                                  color:
                                      EcoPlatesDesignTokens.colors.textPrimary,
                                ),
                                SizedBox(width: context.scaleXXS_XS_SM_MD),
                                Text(
                                  OfferFormatters.formatTimeRemaining(
                                    offer.timeRemaining,
                                  ),
                                  style: TextStyle(
                                    color: EcoPlatesDesignTokens
                                        .colors
                                        .textPrimary,
                                    fontWeight:
                                        EcoPlatesDesignTokens.typography.bold,
                                    fontSize: EcoPlatesDesignTokens.typography
                                        .hint(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Côté droit : Prix
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (!offer.isFree) ...[
                        Text(
                          '€${offer.originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: EcoPlatesDesignTokens.typography
                                .titleSize(context),
                            decoration: TextDecoration.lineThrough,
                            color: EcoPlatesDesignTokens.colors.textPrimary
                                .withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .opacity
                                      .almostOpaque,
                                ),
                            fontWeight: EcoPlatesDesignTokens.typography.medium,
                          ),
                        ),
                        SizedBox(width: context.scaleMD_LG_XL_XXL),
                      ],
                      Text(
                        offer.priceText,
                        style: TextStyle(
                          fontSize:
                              EcoPlatesDesignTokens.typography.titleSize(
                                context,
                              ) *
                              1.5,
                          fontWeight: EcoPlatesDesignTokens.typography.bold,
                          color: EcoPlatesDesignTokens.colors.textPrimary,
                          shadows: [
                            Shadow(
                              color: EcoPlatesDesignTokens.colors.overlayBlack
                                  .withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .opacity
                                        .almostOpaque,
                                  ),
                              blurRadius:
                                  EcoPlatesDesignTokens.elevation.smallBlur,
                              offset: EcoPlatesDesignTokens
                                  .elevation
                                  .standardOffset,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
          decoration: BoxDecoration(
            color: EcoPlatesDesignTokens.colors.textPrimary.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onPressed: () {
          debugPrint('🔙 Bouton retour SliverAppBar pressé');
          onBackPressed();
        },
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: EcoPlatesDesignTokens.size.modalIcon(context),
          color: Theme.of(context).colorScheme.onSurface.withValues(
            alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
          ),
        ),
      ),
    );
  }
}
