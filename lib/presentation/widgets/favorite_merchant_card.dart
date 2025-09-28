import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
import '../../core/services/image_cache_service.dart';
import '../../core/widgets/eco_cached_image.dart';
import '../../domain/entities/merchant.dart';
import '../providers/favorites_provider.dart';

/// Carte dédiée aux favoris avec un style distinctif
/// - Effet glassmorphism (verre dépoli)
/// - Image carrée à gauche, infos à droite
/// - Badge "Favori" et bouton toggle pour retirer des favoris
class FavoriteMerchantCard extends ConsumerWidget {
  const FavoriteMerchantCard({required this.merchant, super.key, this.onTap});

  final Merchant merchant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFavorite = ref.watch(isMerchantFavoriteProvider(merchant.id));

    return InkWell(
      borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
      onTap: onTap,
      child: Stack(
        children: [
          // Effet glassmorphism
          ClipRRect(
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.lg,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: EcoPlatesDesignTokens.elevation.largeBlur,
                sigmaY: EcoPlatesDesignTokens.elevation.largeBlur,
              ),
              child: Container(
                height: EcoPlatesDesignTokens.size.buttonHeight(context) * 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.7),
                      Colors.white.withValues(alpha: 0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.lg,
                  ),
                  border: Border.all(
                    width: 1.5,
                    color: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.3),
                        Colors.pink.withValues(alpha: 0.3),
                      ],
                    ).colors.first,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                      ),
                      blurRadius: EcoPlatesDesignTokens.elevation.largeBlur,
                      offset: EcoPlatesDesignTokens.elevation.elevatedOffset,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Contenu principal (responsive)
                    Padding(
                      padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final bool isNarrow = constraints.maxWidth < 320;
                          final double targetSide =
                              EcoPlatesDesignTokens.size.icon(context) * 4.6;
                          final double imageSide = math.max(
                            40,
                            math.min(
                              targetSide,
                              constraints.maxWidth * (isNarrow ? 0.28 : 0.30),
                            ),
                          );

                          final Widget image = ClipRRect(
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.md,
                            ),
                            child: EcoCachedImage(
                              imageUrl: merchant.imageUrl,
                              width: imageSide,
                              height: imageSide,
                              size: ImageSize.thumbnail,
                              placeholder: Container(
                                width: imageSide,
                                height: imageSide,
                                color: Colors.grey[200],
                              ),
                              errorWidget: Container(
                                width: imageSide,
                                height: imageSide,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.store,
                                  color: Colors.grey,
                                  size: EcoPlatesDesignTokens.size.icon(
                                    context,
                                  ),
                                ),
                              ),
                            ),
                          );

                          final Widget infoColumn = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Ligne titre + coeur
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          merchant.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: EcoPlatesDesignTokens
                                                .typography
                                                .titleSize(context),
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(
                                          height: context.scaleXXS_XS_SM_MD / 2,
                                        ),
                                        Text(
                                          merchant.cuisineType,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: EcoPlatesDesignTokens
                                                .typography
                                                .hint(context),
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Bouton toggle favori
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .read(
                                            favoriteMerchantIdsProvider
                                                .notifier,
                                          )
                                          .toggleFavorite(merchant.id);

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isFavorite
                                                  ? 'Retiré des favoris'
                                                  : 'Ajouté aux favoris',
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                            backgroundColor: isFavorite
                                                ? Colors.grey[700]
                                                : Colors.green[700],
                                          ),
                                        );
                                      }
                                    },
                                    icon: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        key: ValueKey(isFavorite),
                                        size: EcoPlatesDesignTokens.size.icon(
                                          context,
                                        ),
                                        color: isFavorite
                                            ? Colors.red[500]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(
                                      minWidth: EcoPlatesDesignTokens
                                          .size
                                          .minTouchTarget,
                                      minHeight: EcoPlatesDesignTokens
                                          .size
                                          .minTouchTarget,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

                              // Rating + distance
                              Row(
                                children: [
                                  _StarRating(rating: merchant.rating),
                                  SizedBox(width: context.scaleXXS_XS_SM_MD),
                                  _Chip(
                                    icon: Icons.place_outlined,
                                    text: merchant.distanceText,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ),

                              SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

                              // Offre / prix minimum
                              if (merchant.hasActiveOffer)
                                Row(
                                  children: [
                                    _Chip(
                                      icon: Icons.local_offer_outlined,
                                      text:
                                          '${merchant.availableOffers} offres',
                                      color: Colors.green[600]!,
                                    ),
                                    SizedBox(
                                      width: context.scaleXXS_XS_SM_MD * 1.5,
                                    ),
                                    Text(
                                      'Dès ${merchant.minPrice.toStringAsFixed(2)}€',
                                      style: TextStyle(
                                        fontSize: EcoPlatesDesignTokens
                                            .typography
                                            .text(context),
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  "Pas d'offre",
                                  style: TextStyle(
                                    fontSize:
                                        EcoPlatesDesignTokens.typography.hint(
                                          context,
                                        ) -
                                        2,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          );

                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                image,
                                SizedBox(height: context.scaleXS_SM_MD_LG),
                                infoColumn,
                              ],
                            );
                          }

                          return Row(
                            children: [
                              image,
                              SizedBox(width: context.scaleXS_SM_MD_LG),
                              Expanded(child: infoColumn),
                            ],
                          );
                        },
                      ),
                    ),

                    // Badge Favori en coin avec effet glassmorphism
                    if (isFavorite)
                      Positioned(
                        top: context.scaleXXS_XS_SM_MD,
                        left: context.scaleXXS_XS_SM_MD,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.sm,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: EcoPlatesDesignTokens.elevation.smallBlur,
                              sigmaY: EcoPlatesDesignTokens.elevation.smallBlur,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scaleXXS_XS_SM_MD,
                                vertical: context.scaleXXS_XS_SM_MD / 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink[100]!.withValues(
                                      alpha: EcoPlatesDesignTokens
                                          .opacity
                                          .almostOpaque,
                                    ),
                                    Colors.pink[50]!.withValues(
                                      alpha:
                                          EcoPlatesDesignTokens.opacity.subtle,
                                    ),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  EcoPlatesDesignTokens.radius.sm,
                                ),
                                border: Border.all(
                                  color: Colors.pink[300]!.withValues(
                                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size:
                                        EcoPlatesDesignTokens.size.icon(
                                          context,
                                        ) /
                                        2,
                                    color: Colors.pink[600],
                                  ),
                                  SizedBox(
                                    width: context.scaleXXS_XS_SM_MD / 2,
                                  ),
                                  Text(
                                    'Favori',
                                    style: TextStyle(
                                      fontSize:
                                          EcoPlatesDesignTokens.typography.hint(
                                            context,
                                          ) -
                                          2,
                                      color: Colors.pink[700],
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final r = rating.clamp(0, 5);
    return Row(
      children: [
        Icon(
          Icons.star,
          size: EcoPlatesDesignTokens.size.icon(context),
          color: Colors.amber[600],
        ),
        SizedBox(width: context.scaleXXS_XS_SM_MD / 4),
        Text(
          r.toStringAsFixed(1),
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.hint(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXXS_XS_SM_MD,
        vertical: context.scaleXXS_XS_SM_MD / 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
        border: Border.all(
          color: color.withValues(alpha: EcoPlatesDesignTokens.opacity.pressed),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: EcoPlatesDesignTokens.size.icon(context) / 2,
            color: color,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
          Text(
            text,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.hint(context) - 2,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
