import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/analytics_stats.dart';
import '../../providers/analytics_provider.dart';
import 'kpi_cards/kpi_cards.dart';

/// Header de la page d'analytics avec les KPIs principaux
///
/// Affiche 4 cartes avec les métriques principales :
/// - Chiffre d'affaires total
/// - Nombre de commandes
/// - Panier moyen
/// - Taux de conversion
///
/// Chaque carte montre l'évolution par rapport à la période précédente
class AnalyticsHeader extends ConsumerWidget {
  const AnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsStatsProvider);

    return analyticsAsync.when(
      data: (analytics) => _buildHeader(context, analytics),
      loading: () => _buildLoadingHeader(context),
      error: (error, stack) => _buildErrorHeader(context, ref),
    );
  }

  Widget _buildHeader(BuildContext context, AnalyticsStats analytics) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 768.0;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec période
          Row(
            children: [
              // Icône et titre amélioré
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      2.0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(
                            alpha: 0.3,
                          ),
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Icon(
                      Icons.insights,
                      size: 18.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 6.0),
                  Text(
                    'Business Insights',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Chip(
                label: Text(
                  analytics.period.label,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withValues(
                      alpha: 0.3,
                    ),
              ),
            ],
          ),

          SizedBox(height: 10.0),

          // Grille des KPIs
          if (isWide)
            _buildWideLayout(context, analytics)
          else
            _buildCompactLayout(context, analytics),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, AnalyticsStats analytics) {
    return Row(
      children: KpiConfigs.all.map((config) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: config != KpiConfigs.all.last ? 6.0 : 0,
            ),
            child: KpiCard(
              config: config,
              analytics: analytics,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompactLayout(BuildContext context, AnalyticsStats analytics) {
    final firstRow = KpiConfigs.all.take(2);
    final secondRow = KpiConfigs.all.skip(2);

    return Column(
      children: [
        Row(
          children: firstRow.map((config) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: config != firstRow.last ? 6.0 : 0,
                ),
                child: KpiCard(
                  config: config,
                  analytics: analytics,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 6.0),
        Row(
          children: secondRow.map((config) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: config != secondRow.last ? 6.0 : 0,
                ),
                child: KpiCard(
                  config: config,
                  analytics: analytics,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLoadingHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 768.0;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton du titre
          Container(
            height: 16.0,
            width: 150.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                4.0,
              ),
            ),
          ),

          SizedBox(height: 10.0),

          // Skeleton des cartes KPI avec shimmer
          if (isWide)
            Row(
              children: KpiConfigs.all.map((config) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: config != KpiConfigs.all.last ? 6.0 : 0,
                    ),
                    child: const KpiCardShimmer(),
                  ),
                );
              }).toList(),
            )
          else
            Column(
              children: [
                Row(
                  children: KpiConfigs.all.take(2).map((config) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: config != KpiConfigs.all.take(2).last
                              ? 6.0
                              : 0,
                        ),
                        child: const KpiCardShimmer(),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 6.0),
                Row(
                  children: KpiConfigs.all.skip(2).map((config) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: config != KpiConfigs.all.skip(2).last
                              ? 6.0
                              : 0,
                        ),
                        child: const KpiCardShimmer(),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildErrorHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48.0,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: 10.0),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 2.0),
              Text(
                'Impossible de charger les données analytiques',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              FilledButton.icon(
                onPressed: () => ref.refreshAnalytics(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
