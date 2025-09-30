import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/themes/tokens/deep_color_tokens.dart';
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
    final isFavorite = ref.watch(isMerchantFavoriteProvider(merchant.id));

    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DeepColorTokens.neutral0.withValues(alpha: 0.7),
                  DeepColorTokens.neutral0.withValues(alpha: 0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: DeepColorTokens.secondary.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: DeepColorTokens.primary.withValues(alpha: 0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 320;
                  const targetSide = 72.0;
                  final imageSide = math.max(
                    40.0,
                    math.min(
                      targetSide,
                      constraints.maxWidth * (isNarrow ? 0.28 : 0.30),
                    ),
                  );

                  final Widget image = ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: EcoCachedImage(
                      imageUrl: merchant.imageUrl,
                      width: imageSide,
                      height: imageSide,
                      errorWidget: Container(
                        width: imageSide,
                        height: imageSide,
                        color: DeepColorTokens.neutral200,
                        child: Icon(
                          Icons.store,
                          color: DeepColorTokens.neutral500,
                          size: 24.0,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  merchant.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    color: DeepColorTokens.neutral800,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  merchant.cuisineType,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: DeepColorTokens.neutral700,
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
                                  .read(favoriteMerchantIdsProvider.notifier)
                                  .toggleFavorite(merchant.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? 'Retiré des favoris'
                                          : 'Ajouté aux favoris',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: isFavorite
                                        ? DeepColorTokens.neutral700
                                        : DeepColorTokens.success,
                                  ),
                                );
                              }
                            },
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey(isFavorite),
                                size: 16.0,
                                color: isFavorite
                                    ? DeepColorTokens.error
                                    : DeepColorTokens.neutral600,
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 48.0,
                              minHeight: 48.0,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.0),

                      // Rating + distance
                      Row(
                        children: [
                          _StarRating(rating: merchant.rating),
                          SizedBox(width: 8.0),
                          _Chip(
                            icon: Icons.place_outlined,
                            text: merchant.distanceText,
                            color: DeepColorTokens.primary,
                          ),
                        ],
                      ),

                      SizedBox(height: 4.0),

                      // Offre / prix minimum
                      if (merchant.hasActiveOffer)
                        Row(
                          children: [
                            _Chip(
                              icon: Icons.local_offer_outlined,
                              text: '${merchant.availableOffers} offres',
                              color: DeepColorTokens.success,
                            ),
                            SizedBox(width: 12.0),
                            Text(
                              'Dès ${merchant.minPrice.toStringAsFixed(2)}€',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: DeepColorTokens.neutral800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          "Pas d'offre",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: DeepColorTokens.neutral600,
                          ),
                        ),
                    ],
                  );

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        image,
                        SizedBox(height: 12.0),
                        infoColumn,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      image,
                      SizedBox(width: 12.0),
                      Expanded(child: infoColumn),
                    ],
                  );
                },
              ),
            ),
          ),
          // Badge Favori en coin avec effet glassmorphism
          if (isFavorite)
            Positioned(
              top: 8.0,
              left: 8.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        DeepColorTokens.secondary.withValues(alpha: 0.8),
                        DeepColorTokens.secondaryContainer.withValues(
                          alpha: 0.6,
                        ),
                      ],
                    ),
                    border: Border.all(
                      color: DeepColorTokens.secondary.withValues(alpha: 0.6),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.favorite,
                        size: 12.0,
                        color: DeepColorTokens.secondaryDark,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        'Favori',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: DeepColorTokens.secondaryDark,
                          fontWeight: FontWeight.w700,
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
          size: 16.0,
          color: DeepColorTokens.warning,
        ),
        SizedBox(width: 2.0),
        Text(
          r.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 14.0,
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
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.0,
            color: color,
          ),
          SizedBox(width: 4.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.0,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
