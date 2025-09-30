import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
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
/// Le composant est entièrement responsive grâce au système ResponsiveUtils
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
    return Padding(
      padding: context.responsivePadding,
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
                    padding: EdgeInsets.all(context.borderRadius / 2),
                    decoration: BoxDecoration(
                      color: DeepColorTokens.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(context.borderRadius),
                    ),
                    child: Icon(
                      Icons.insights,
                      size: context.buttonHeight * 0.4,
                      color: DeepColorTokens.primary,
                    ),
                  ),
                  SizedBox(width: context.horizontalSpacing / 4),
                  Text(
                    'Business Insights',
                    style: TextStyle(
                      fontSize: FontSizes.titleMedium.getSize(context),
                      fontWeight: FontSizes.titleMedium.getFontWeight(),
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
                    fontSize: FontSizes.label.getSize(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: DeepColorTokens.secondaryContainer.withValues(
                  alpha: 0.3,
                ),
              ),
            ],
          ),

          SizedBox(height: context.verticalSpacing / 2.5),

          // Grille des KPIs
          _buildResponsiveKpiLayout(context, analytics),
        ],
      ),
    );
  }

  Widget _buildResponsiveKpiLayout(
    BuildContext context,
    AnalyticsStats analytics,
  ) {
    if (context.isMobile) {
      return _buildGridLayout(
        context,
        analytics,
        crossAxisCount: 2,
        spacing: 4.0,
      );
    } else {
      return _buildRowLayout(context, analytics, spacing: 5.0);
    }
  }

  Widget _buildRowLayout(
    BuildContext context,
    AnalyticsStats analytics, {
    required double spacing,
  }) {
    return Row(
      children: KpiConfigs.all.map((config) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: config != KpiConfigs.all.last ? spacing : 0,
            ),
            child: KpiCard(config: config, analytics: analytics),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGridLayout(
    BuildContext context,
    AnalyticsStats analytics, {
    required int crossAxisCount,
    required double spacing,
  }) {
    final rows = <Widget>[];
    final configs = KpiConfigs.all.toList();

    for (var i = 0; i < configs.length; i += crossAxisCount) {
      final rowConfigs = configs.skip(i).take(crossAxisCount).toList();

      rows.add(
        Row(
          children: rowConfigs.map((config) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: config != rowConfigs.last ? spacing : 0,
                ),
                child: KpiCard(config: config, analytics: analytics),
              ),
            );
          }).toList(),
        ),
      );

      if (i + crossAxisCount < configs.length) {
        rows.add(SizedBox(height: spacing));
      }
    }

    return Column(children: rows);
  }

  Widget _buildLoadingHeader(BuildContext context) {
    return Padding(
      padding: context.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: context.buttonHeight * 0.3,
            width: context.isMobile
                ? 120
                : context.isTablet
                ? 150
                : 180,
            decoration: BoxDecoration(
              color: DeepColorTokens.neutral200,
              borderRadius: BorderRadius.circular(context.borderRadius / 2),
            ),
          ),
          SizedBox(height: context.verticalSpacing / 2.5),
          _buildResponsiveKpiLoadingLayout(context),
        ],
      ),
    );
  }

  Widget _buildResponsiveKpiLoadingLayout(BuildContext context) {
    if (context.isMobile) {
      return _buildGridLoadingLayout(
        context,
        crossAxisCount: 2,
        spacing: 2.0,
      );
    } else {
      return _buildRowLoadingLayout(context, spacing: context.borderRadius);
    }
  }

  Widget _buildRowLoadingLayout(
    BuildContext context, {
    required double spacing,
  }) {
    return Row(
      children: KpiConfigs.all.map((config) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: config != KpiConfigs.all.last ? spacing : 0,
            ),
            child: const KpiCardShimmer(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGridLoadingLayout(
    BuildContext context, {
    required int crossAxisCount,
    required double spacing,
  }) {
    final rows = <Widget>[];
    final configs = KpiConfigs.all.toList();

    for (var i = 0; i < configs.length; i += crossAxisCount) {
      final rowConfigs = configs.skip(i).take(crossAxisCount).toList();

      rows.add(
        Row(
          children: rowConfigs.map((config) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: config != rowConfigs.last ? spacing : 0,
                ),
                child: const KpiCardShimmer(),
              ),
            );
          }).toList(),
        ),
      );

      if (i + crossAxisCount < configs.length) {
        rows.add(SizedBox(height: spacing));
      }
    }

    return Column(children: rows);
  }

  Widget _buildErrorHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: context.responsivePadding,
      child: Card(
        child: Padding(
          padding: context.responsivePadding,
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: context.buttonHeight * 1.2,
                color: DeepColorTokens.error,
              ),
              SizedBox(height: context.verticalSpacing / 2.5),
              Text(
                'Erreur de chargement',
                style: TextStyle(
                  fontSize: FontSizes.subtitleMedium.getSize(context),
                  fontWeight: FontSizes.subtitleMedium.getFontWeight(),
                ),
              ),
              SizedBox(height: context.verticalSpacing / 8),
              Text(
                'Impossible de charger les données analytiques',
                style: TextStyle(
                  fontSize: FontSizes.bodyMedium.getSize(context),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.verticalSpacing / 2.5),
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
