import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/design_tokens.dart';
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
            maxWidth:
                EcoPlatesDesignTokens.analyticsCharts.loadingErrorMaxWidth,
          ),
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.analyticsCharts.loadingErrorPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorIconContainerSize,
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorIconContainerSize,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .loadingErrorBackgroundAlpha,
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .loadingErrorBorderRadius,
                  ),
                ),
                child: CircularProgressIndicator(
                  strokeWidth: EcoPlatesDesignTokens
                      .analyticsCharts
                      .loadingProgressStrokeWidth,
                ),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorLargeSpacing,
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
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorSmallSpacing,
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
            maxWidth:
                EcoPlatesDesignTokens.analyticsCharts.loadingErrorMaxWidth,
          ),
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.analyticsCharts.loadingErrorPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorIconContainerSize,
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorIconContainerSize,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .loadingErrorBackgroundAlpha,
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .loadingErrorBorderRadius,
                  ),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: EcoPlatesDesignTokens
                      .analyticsCharts
                      .loadingErrorIconSize,
                  color: theme.colorScheme.error,
                ),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorLargeSpacing,
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
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorSmallSpacing,
              ),
              Text(
                'Impossible de charger les graphiques',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .loadingErrorLargeSpacing,
              ),
              FilledButton.icon(
                onPressed: () => ref.refreshAnalytics(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
