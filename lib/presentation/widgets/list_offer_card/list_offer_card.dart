import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/extensions/food_offer_extensions.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/food_offer.dart';
import '../closed_badge.dart';
import 'merchant_logo_with_badge.dart';
import 'offer_background_image.dart';
import 'offer_info_section.dart';

/// Carte horizontale style BrandCard pour les offres
class ListOfferCard extends StatefulWidget {
  const ListOfferCard({
    required this.offer,
    super.key,
    this.onTap,
    this.distance,
  });

  final FoodOffer offer;
  final VoidCallback? onTap;
  final double? distance;

  @override
  State<ListOfferCard> createState() => _ListOfferCardState();
}

class _ListOfferCardState extends State<ListOfferCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: EcoPlatesDesignTokens.animation.fast,
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(
          begin: 1,
          end: 0.97,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ),
        );
    _elevationAnimation =
        Tween<double>(
          begin: EcoPlatesDesignTokens.opacity.veryTransparent,
          end: EcoPlatesDesignTokens.opacity.veryOpaque,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    unawaited(_controller.forward());
  }

  void _handleTapUp(TapUpDetails details) {
    unawaited(_controller.reverse());
  }

  void _handleTapCancel() {
    unawaited(_controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: widget.offer.semanticLabel,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: EcoPlatesDesignTokens.layout.merchantCardHeight(context),
              margin: EdgeInsets.only(
                bottom: context.scaleMD_LG_XL_XXL,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.lg,
                ),
                boxShadow: [
                  BoxShadow(
                    color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                      alpha:
                          EcoPlatesDesignTokens.opacity.subtle +
                          (EcoPlatesDesignTokens.opacity.subtle *
                              _elevationAnimation.value),
                    ),
                    blurRadius:
                        EcoPlatesDesignTokens.elevation.mediumBlur +
                        (EcoPlatesDesignTokens.elevation.smallBlur *
                            _elevationAnimation.value),
                    offset: Offset(
                      0,
                      EcoPlatesDesignTokens.elevation.standardOffset.dy +
                          (EcoPlatesDesignTokens.elevation.standardOffset.dy *
                              _elevationAnimation.value),
                    ),
                  ),
                  // Ombre secondaire pour plus de profondeur
                  if (_elevationAnimation.value > 0)
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(
                        alpha:
                            EcoPlatesDesignTokens.opacity.verySubtle *
                            _elevationAnimation.value,
                      ),
                      blurRadius:
                          EcoPlatesDesignTokens.elevation.largeBlur *
                          _elevationAnimation.value,
                      offset: Offset(
                        0,
                        EcoPlatesDesignTokens.elevation.standardOffset.dy *
                            2 *
                            _elevationAnimation.value,
                      ),
                    ),
                ],
              ),
              child: Stack(
                children: [
                  // Image de fond
                  OfferBackgroundImage(offer: widget.offer),

                  // Badge FERMÉ (si la boutique est fermée)
                  if (widget.offer.isClosed)
                    Positioned(
                      top: context.scaleXXS_XS_SM_MD / 2,
                      right: context.scaleXXS_XS_SM_MD / 2,
                      child: ClosedBadge(
                        size: BadgeSize.small,
                        reopenTime: widget.offer.reopenTime,
                      ),
                    ),

                  // Contenu principal
                  Padding(
                    padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
                    child: Row(
                      children: [
                        // Logo Restaurant
                        MerchantLogoWithBadge(
                          merchantName: widget.offer.merchantName,
                          availableQuantity: widget.offer.availableQuantity,
                        ),

                        SizedBox(width: context.scaleMD_LG_XL_XXL),

                        // Info Section
                        OfferInfoSection(
                          merchantName: widget.offer.merchantName,
                          title: widget.offer.title,
                          priceText: widget.offer.priceText,
                          isFree: widget.offer.isFree,
                          pickupTime: widget.offer.pickupTimeFormatted,
                          distance: widget.distance,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
