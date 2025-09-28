import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import 'favorites_models.dart';

/// Tuile affichant un plat favori
class FavoriteDishTile extends StatelessWidget {
  const FavoriteDishTile({
    required this.dish, super.key,
    this.onToggleFavorite,
  });

  final FavoriteDish dish;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(
        context.responsiveValue(
          mobile: 10,
          tablet: 12,
          desktop: 14,
        ),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            mobile: 6,
            tablet: 8,
            desktop: 10,
          ),
        ),
        border: Border.all(
          color: colors.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Image du plat (placeholder)
          Container(
            width: context.responsiveValue(
              mobile: 40,
              tablet: 50,
              desktop: 60,
            ),
            height: context.responsiveValue(
              mobile: 40,
              tablet: 50,
              desktop: 60,
            ),
            decoration: BoxDecoration(
              color: colors.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(
                context.responsiveValue(
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                ),
              ),
            ),
            child: Icon(
              Icons.restaurant,
              color: colors.primary,
              size: context.responsiveValue(
                mobile: 18,
                tablet: 24,
                desktop: 28,
              ),
            ),
          ),

          SizedBox(
            width: context.responsiveValue(
              mobile: 10,
              tablet: 12,
              desktop: 14,
            ),
          ),

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
                SizedBox(
                  height: context.responsiveValue(
                    mobile: 2,
                    tablet: 2,
                    desktop: 3,
                  ),
                ),
                Text(
                  dish.restaurantName,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: context.responsiveValue(
                    mobile: 3,
                    tablet: 4,
                    desktop: 5,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${dish.price.toStringAsFixed(2)} €',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: context.responsiveValue(
                        mobile: 6,
                        tablet: 8,
                        desktop: 10,
                      ),
                    ),
                    Text(
                      'Commandé ${dish.orderCount}x',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurface.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.disabled,
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
              color: colors.error,
            ),
            iconSize: context.responsiveValue(
              mobile: 18,
              tablet: 20,
              desktop: 24,
            ),
          ),
        ],
      ),
    );
  }
}
