import 'package:flutter/material.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget pour afficher l'état d'erreur du profil marchand
class ErrorProfileView extends StatelessWidget {
  const ErrorProfileView({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48.0,
              color: DeepColorTokens.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Erreur de chargement',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
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
