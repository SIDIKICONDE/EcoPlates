import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/responsive/responsive_utils.dart';
import '../../core/services/image_cache_service.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
import '../../core/widgets/eco_cached_image.dart';
import '../../domain/entities/brand.dart';
import 'brand_card/brand_background_image_service.dart';
import 'brand_card/components/brand_premium_badge.dart';
import 'brand_card/components/brand_stats_row.dart';

/// Carte horizontale sophistiquée avec image de fond de nourriture
class BrandCard extends StatefulWidget {
  const BrandCard({required this.brand, super.key, this.onTap});
  final Brand brand;
  final VoidCallback? onTap;

  @override
  State<BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<BrandCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(
          begin: 1.0,
          end: 0.98,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) {
          if (!_isHovered && mounted) {
            setState(() => _isHovered = true);
          }
        },
        onExit: (_) {
          if (_isHovered && mounted) {
            setState(() => _isHovered = false);
          }
        },
        child: GestureDetector(
          onTapDown: (_) {
            if (!_controller.isAnimating && mounted) {
              _controller.forward();
            }
          },
          onTapUp: (_) {
            if (!_controller.isAnimating && mounted) {
              _controller.reverse();
            }
          },
          onTapCancel: () {
            if (!_controller.isAnimating && mounted) {
              _controller.reverse();
            }
          },
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getBorderRadius(context),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: DeepColorTokens.shadowDeep.withValues(
                          alpha: _isHovered ? 0.3 : 0.15,
                        ),
                        blurRadius: _isHovered ? 20 : 10,
                        offset: Offset(0, _isHovered ? 8 : 4),
                        spreadRadius: _isHovered ? 2 : 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getBorderRadius(context),
                    ),
                    child: SizedBox(
                      height: ResponsiveUtils.getMerchantCardHeight(context),
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image de fond avec effet parallaxe
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            tween: Tween<double>(
                              begin: 1.0,
                              end: _isHovered ? 1.05 : 1.0,
                            ),
                            builder: (context, scale, child) => Transform.scale(
                              scale: scale,
                              child: EcoCachedImage(
                                imageUrl: widget
                                    .brand
                                    .category
                                    .brandBackgroundImageUrl,
                                placeholder: Container(
                                  color: isDarkMode
                                      ? const Color(0xFF2A2A2A)
                                      : const Color(0xFFE5E5E5),
                                ),
                                errorWidget: ColoredBox(
                                  color: isDarkMode
                                      ? const Color(0xFF2A2A2A)
                                      : const Color(0xFFE5E5E5),
                                  child: const Icon(
                                    Icons.error_outline,
                                    color: DeepColorTokens.error,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Overlay gradient amélioré pour la lisibilité
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0x00000000),
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.black.withValues(alpha: 0.6),
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                                stops: const [0.0, 0.5, 0.8, 1.0],
                              ),
                            ),
                          ),
                          // Effet de flou sur hover
                          if (_isHovered)
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                              child: Container(
                                color: DeepColorTokens.shadowDeep.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                          // Contenu principal
                          Padding(
                            padding: ResponsiveUtils.getResponsivePadding(
                              context,
                            ),
                            child: Stack(
                              children: [
                                // Zone texte pleine largeur, avec marge basse pour le logo
                                Positioned.fill(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: FontSizes.titleMedium.getSize(
                                        context,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Brand Name - Taille responsive
                                        Text(
                                          widget.brand.name,
                                          style: TextStyle(
                                            fontSize: FontSizes.titleMedium
                                                .getSize(
                                                  context,
                                                ),
                                            fontWeight: FontWeight.bold,
                                            color: DeepColorTokens.neutral0,
                                            shadows: [
                                              BoxShadow(
                                                color: DeepColorTokens
                                                    .shadowMedium,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Pousse le sous-titre et les offres vers le bas
                                        const Spacer(),
                                        // Sous-titre et offres décalés vers la droite
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left:
                                                ResponsiveUtils.getHorizontalSpacing(
                                                  context,
                                                ) *
                                                0.33,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Category - Taille responsive
                                              Text(
                                                widget.brand.category,
                                                style: TextStyle(
                                                  fontSize: FontSizes
                                                      .subtitleSmall
                                                      .getSize(
                                                        context,
                                                      ),
                                                  fontWeight: FontWeight.w500,
                                                  color: DeepColorTokens
                                                      .neutral0
                                                      .withValues(
                                                        alpha: 0.8,
                                                      ),
                                                  shadows: [
                                                    BoxShadow(
                                                      color: DeepColorTokens
                                                          .shadowMedium,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ResponsiveUtils.getVerticalSpacing(
                                                      context,
                                                    ) *
                                                    0.1,
                                              ),
                                              // Stats Row
                                              BrandStatsRow(
                                                activeOffers:
                                                    widget.brand.activeOffers,
                                                averageDiscount: widget
                                                    .brand
                                                    .averageDiscount,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Logo en bas à gauche avec animation
                                Align(
                                  alignment: const Alignment(
                                    -1.0,
                                    1.0,
                                  ), // Complètement à gauche
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    width: _isHovered
                                        ? FontSizes.titleLarge.getSize(
                                                context,
                                              ) *
                                              1.1
                                        : FontSizes.titleLarge.getSize(context),
                                    height: _isHovered
                                        ? FontSizes.titleLarge.getSize(
                                                context,
                                              ) *
                                              1.1
                                        : FontSizes.titleLarge.getSize(context),
                                    padding: EdgeInsets.all(
                                      ResponsiveUtils.getHorizontalSpacing(
                                            context,
                                          ) *
                                          0.25,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: _isHovered ? 0.95 : 0.85,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.getHorizontalSpacing(
                                              context,
                                            ) *
                                            0.25,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: DeepColorTokens.shadowDeep
                                              .withValues(
                                                alpha: 0.2,
                                              ),
                                          blurRadius: _isHovered ? 12 : 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: EcoCachedImage(
                                            imageUrl: widget.brand.logoUrl,
                                            width: FontSizes.bodyLarge.getSize(
                                              context,
                                            ),
                                            height: FontSizes.bodyLarge.getSize(
                                              context,
                                            ),
                                            fit: BoxFit.contain,
                                            size: ImageSize.thumbnail,
                                            placeholder: SizedBox(
                                              width: FontSizes.caption.getSize(
                                                context,
                                              ),
                                              height: FontSizes.caption.getSize(
                                                context,
                                              ),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(
                                                      theme.primaryColor
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                    ),
                                              ),
                                            ),
                                            errorWidget: Icon(
                                              Icons.storefront_outlined,
                                              size: FontSizes.caption.getSize(
                                                context,
                                              ),
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ),
                                        // Badge Premium/New
                                        BrandPremiumBadge(
                                          isPremium: widget.brand.isPremium,
                                          isNew: widget.brand.isNew,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
