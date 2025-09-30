import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
import 'favorites_models.dart';

/// Tuile affichant un plat favori
class FavoriteDishTile extends StatelessWidget {
  const FavoriteDishTile({
    required this.dish,
    super.key,
    this.onToggleFavorite,
  });

  final FavoriteDish dish;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: DeepColorTokens.neutral0.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Image du plat (placeholder)
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: DeepColorTokens.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Icon(
              Icons.restaurant,
              color: DeepColorTokens.primary,
              size: 18.0,
            ),
          ),

          const SizedBox(width: 10.0),

          // Informations du plat
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  dish.restaurantName,
                  style: textTheme.bodySmall?.copyWith(
                    color: DeepColorTokens.neutral0.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 3.0),
                Row(
                  children: [
                    Text(
                      '${dish.price.toStringAsFixed(2)} €',
                      style: textTheme.labelLarge?.copyWith(
                        color: DeepColorTokens.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      'Commandé ${dish.orderCount}x',
                      style: textTheme.labelSmall?.copyWith(
                        color: DeepColorTokens.neutral0.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action
          IconButton(
            onPressed: onToggleFavorite ?? () {},
            icon: Icon(
              Icons.favorite,
              color: DeepColorTokens.error,
            ),
            iconSize: 18.0,
          ),
        ],
      ),
    );
  }
}
