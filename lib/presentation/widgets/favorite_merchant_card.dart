import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Stack(
        children: [
          // Effet glassmorphism
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 128,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.7),
                      Colors.white.withValues(alpha: 0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
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
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Contenu principal
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // Image carré
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              merchant.imageUrl,
                              width: 92,
                              height: 92,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 92,
                                height: 92,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.store,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Infos
                          Expanded(
                            child: Column(
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
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            merchant.cuisineType,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
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

                                        // Animation de feedback
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
                                          size: 20,
                                          color: isFavorite
                                              ? Colors.red[500]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 32,
                                        minHeight: 32,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                // Rating + distance
                                Row(
                                  children: [
                                    _StarRating(rating: merchant.rating),
                                    const SizedBox(width: 8),
                                    _Chip(
                                      icon: Icons.place_outlined,
                                      text: merchant.distanceText,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

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
                                      const SizedBox(width: 6),
                                      Text(
                                        'Dès ${merchant.minPrice.toStringAsFixed(2)}€',
                                        style: const TextStyle(
                                          fontSize: 13,
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
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Badge Favori en coin avec effet glassmorphism
                    if (isFavorite)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink[100]!.withValues(alpha: 0.8),
                                    Colors.pink[50]!.withValues(alpha: 0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.pink[300]!.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 12,
                                    color: Colors.pink[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Favori',
                                    style: TextStyle(
                                      fontSize: 11,
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
        Icon(Icons.star, size: 16, color: Colors.amber[600]),
        const SizedBox(width: 2),
        Text(
          r.toStringAsFixed(1),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
