import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/spacing_tokens.dart';

/// Widget affiché quand il n'y a aucun favori
class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(
        context.responsiveValue(
          mobile: EcoSpacing.xl,
          tablet: EcoSpacing.xxl,
          desktop: EcoSpacing.xxxl,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite_border,
            size: context.responsiveValue(
              mobile: EcoPlatesDesignTokens.size.minTouchTarget,
              tablet: EcoPlatesDesignTokens.size.minTouchTarget * 1.33,
              desktop: EcoPlatesDesignTokens.size.minTouchTarget * 1.67,
            ),
            color: colors.onSurface.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
          ),
          Text(
            'Aucun favori pour le moment',
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
            ),
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: 6,
              tablet: 8,
              desktop: 10,
            ),
          ),
          Text(
            'Explorez nos restaurants et ajoutez vos plats préférés !',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.disabled,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
