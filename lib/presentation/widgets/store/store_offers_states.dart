import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';

/// État vide pour les offres
class StoreOffersEmptyState extends StatelessWidget {
  const StoreOffersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: EcoPlatesDesignTokens.size.icon(context) * 4,
            color: theme.colorScheme.onSurfaceVariant.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
          ),
          SizedBox(height: context.scaleMD_LG_XL_XXL),
          Text(
            'Aucune offre trouvée',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.scaleXXS_XS_SM_MD),
          Text(
            'Ajoutez votre première offre',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// État d'erreur pour les offres
class StoreOffersErrorState extends StatelessWidget {
  const StoreOffersErrorState({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: EcoPlatesDesignTokens.size.icon(context) * 3.5,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: context.scaleMD_LG_XL_XXL),
            Text('Erreur de chargement', style: theme.textTheme.titleLarge),
            SizedBox(height: context.scaleXXS_XS_SM_MD),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.scaleMD_LG_XL_XXL * 1.5),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
