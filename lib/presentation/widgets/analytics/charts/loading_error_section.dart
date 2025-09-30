import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../providers/analytics_provider.dart';

class LoadingSection extends StatelessWidget {
  const LoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverFillRemaining(
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  color: DeepColorTokens.primaryContainer.withValues(
                    alpha: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Text(
                'Chargement des graphiques...',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Veuillez patienter',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorSection extends ConsumerWidget {
  const ErrorSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SliverFillRemaining(
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  color: DeepColorTokens.errorContainer.withValues(
                    alpha: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 32.0,
                  color: DeepColorTokens.error,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Text(
                'Erreur de chargement',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Impossible de charger les graphiques',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24.0,
              ),
              FilledButton.icon(
                onPressed: () => ref.refreshAnalytics(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: FilledButton.styleFrom(
                  backgroundColor: DeepColorTokens.error,
                  foregroundColor: DeepColorTokens.neutral0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
