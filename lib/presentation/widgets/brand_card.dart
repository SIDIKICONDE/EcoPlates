import 'package:flutter/material.dart';

import '../../core/responsive/design_tokens.dart';
import '../../core/services/image_cache_service.dart';
import '../../core/widgets/eco_cached_image.dart';
import '../../domain/entities/brand.dart';

/// Carte horizontale avec image de fond de nourriture
class BrandCard extends StatelessWidget {
  const BrandCard({required this.brand, super.key, this.onTap});
  final Brand brand;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: EcoPlatesDesignTokens.size.buttonHeight(context) * 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.subtle,
                    )
                  : Colors.black.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                    ),
              blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
              offset: EcoPlatesDesignTokens.elevation.standardOffset,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Image de fond de nourriture
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.md,
                ),
                child: EcoCachedImage(
                  imageUrl: _getFoodImageUrl(brand.category),
                  size: ImageSize.small,
                  placeholder: Container(
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
                  ),
                  errorWidget: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(
                        EcoPlatesDesignTokens.radius.md,
                      ),
                    ),
                    child: Icon(
                      Icons.fastfood,
                      size: EcoPlatesDesignTokens.size.icon(context) * 2,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),

            // Overlay gradient pour la lisibilité
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.md,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),

            // Contenu principal
            Padding(
              padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
              child: Stack(
                children: [
                  // Zone texte pleine largeur, avec marge basse pour le logo
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            EcoPlatesDesignTokens.size.icon(context) * 3 +
                            context.scaleXXS_XS_SM_MD,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Brand Name - Taille augmentée
                          Text(
                            brand.name,
                            style: TextStyle(
                              fontSize:
                                  EcoPlatesDesignTokens.typography.titleSize(
                                    context,
                                  ) +
                                  4, // Augmentation de la taille du titre
                              fontWeight: FontWeight.bold, // Plus gras
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius:
                                      EcoPlatesDesignTokens.elevation.smallBlur,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

                          // Pousse le sous-titre et les offres vers le bas
                          const Spacer(),

                          // Sous-titre et offres décalés vers la droite
                          Padding(
                            padding: EdgeInsets.only(
                              left:
                                  EcoPlatesDesignTokens.size.icon(context) * 3 +
                                  context.scaleXXS_XS_SM_MD,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category - Taille augmentée
                                Text(
                                  brand.category,
                                  style: TextStyle(
                                    fontSize: EcoPlatesDesignTokens.typography
                                        .text(
                                          context,
                                        ), // Changé de hint à text pour plus grand
                                    fontWeight:
                                        FontWeight.w500, // Ajout du poids
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shadows: [
                                      Shadow(
                                        blurRadius: EcoPlatesDesignTokens
                                            .elevation
                                            .smallBlur,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: context.scaleXXS_XS_SM_MD * 1.5,
                                ),

                                // Stats Row
                                Row(
                                  children: [
                                    // Offers
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.scaleXXS_XS_SM_MD,
                                        vertical: context.scaleXXS_XS_SM_MD / 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: EcoPlatesDesignTokens
                                              .opacity
                                              .pressed,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          EcoPlatesDesignTokens.radius.sm,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: EcoPlatesDesignTokens
                                                .opacity
                                                .subtle,
                                          ),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Text(
                                        '${brand.activeOffers} offres',
                                        style: TextStyle(
                                          fontSize: EcoPlatesDesignTokens
                                              .typography
                                              .hint(
                                                context,
                                              ),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: context.scaleXXS_XS_SM_MD,
                                    ),

                                    // Discount
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.scaleXXS_XS_SM_MD,
                                        vertical: context.scaleXXS_XS_SM_MD / 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade600,
                                        borderRadius: BorderRadius.circular(
                                          EcoPlatesDesignTokens.radius.sm,
                                        ),
                                      ),
                                      child: Text(
                                        '-${brand.averageDiscount.toInt()}%',
                                        style: TextStyle(
                                          fontSize: EcoPlatesDesignTokens
                                              .typography
                                              .hint(
                                                context,
                                              ),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    const Spacer(),

                                    // Arrow
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size:
                                          EcoPlatesDesignTokens.size.icon(
                                            context,
                                          ) /
                                          2,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Logo en bas à gauche
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: EcoPlatesDesignTokens.size.icon(context) * 3,
                      height: EcoPlatesDesignTokens.size.icon(context) * 3,
                      padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens.radius.sm,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: EcoCachedImage(
                              imageUrl: brand.logoUrl,
                              width:
                                  EcoPlatesDesignTokens.size.icon(context) * 2,
                              height:
                                  EcoPlatesDesignTokens.size.icon(context) * 2,
                              fit: BoxFit.contain,
                              size: ImageSize.thumbnail,
                              placeholder: SizedBox(
                                width: EcoPlatesDesignTokens.size.icon(context),
                                height: EcoPlatesDesignTokens.size.icon(
                                  context,
                                ),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.primaryColor.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                              errorWidget: Icon(
                                Icons.storefront_outlined,
                                size: EcoPlatesDesignTokens.size.icon(context),
                                color: theme.primaryColor,
                              ),
                            ),
                          ),

                          // Badge Premium/New
                          if (brand.isPremium || brand.isNew)
                            Positioned(
                              top: -context.scaleXXS_XS_SM_MD / 2,
                              right: -context.scaleXXS_XS_SM_MD / 2,
                              child: Container(
                                padding: EdgeInsets.all(
                                  context.scaleXXS_XS_SM_MD / 4,
                                ),
                                decoration: BoxDecoration(
                                  color: brand.isPremium
                                      ? Colors.amber.shade100
                                      : Colors.green.shade100,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Icon(
                                  brand.isPremium
                                      ? Icons.star
                                      : Icons.new_releases,
                                  size:
                                      EcoPlatesDesignTokens.size.icon(context) /
                                      3,
                                  color: brand.isPremium
                                      ? Colors.amber.shade700
                                      : Colors.green.shade700,
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
          ],
        ),
      ),
    );
  }

  /// Retourne l'URL d'une image de fond selon la catégorie
  String _getFoodImageUrl(String category) {
    switch (category.toLowerCase()) {
      case 'supermarché':
      case 'hypermarché':
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=200&fit=crop&crop=center';
      case 'boulangerie':
        return 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=200&fit=crop&crop=center';
      case 'café':
        return 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&h=200&fit=crop&crop=center';
      case 'restaurant':
        return 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=200&fit=crop&crop=center';
      case 'surgelés':
        return 'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?w=400&h=200&fit=crop&crop=center';
      default:
        return 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=200&fit=crop&crop=center';
    }
  }
}
