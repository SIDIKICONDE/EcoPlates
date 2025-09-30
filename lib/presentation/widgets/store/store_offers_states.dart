import 'package:flutter/material.dart';

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
            size: 64.0,
            color: theme.colorScheme.onSurfaceVariant.withValues(
              alpha: 16.0,
            ),
          ),
          Text(
            'Aucune offre trouvée',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Ajoutez votre première offre',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: 16.0,
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
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 56.0,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 16.0),
            Text('Erreur de chargement', style: theme.textTheme.titleLarge),
            SizedBox(height: 8.0),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
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
