import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
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
    final isWide = screenWidth > DesignConstants.tabletBreakpoint;

    return Padding(
      padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
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
                      context.scaleXXS_XS_SM_MD,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(
                            alpha: EcoPlatesDesignTokens.opacity.subtle,
                          ),
                      borderRadius: BorderRadius.circular(
                        context.scaleFieldRadius,
                      ),
                    ),
                    child: Icon(
                      Icons.insights,
                      size: context.scaleIconStandard,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: context.scaleSM_MD_LG_XL),
                  Text(
                    'Business Insights',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: EcoPlatesDesignTokens
                          .analyticsCharts
                          .kpiCardValueLetterSpacing,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Chip(
                label: Text(
                  analytics.period.label,
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.hint(context),
                    fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                  ),
                ),
                backgroundColor:
                    Theme.of(
                      context,
                    ).colorScheme.secondaryContainer.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
                    ),
                side: BorderSide(
                  color:
                      Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.subtle,
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.scaleMD_LG_XL_XXL),

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
              right: config != KpiConfigs.all.last
                  ? context.scaleSM_MD_LG_XL
                  : 0,
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
                  right: config != firstRow.last ? context.scaleSM_MD_LG_XL : 0,
                ),
                child: KpiCard(
                  config: config,
                  analytics: analytics,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: context.scaleSM_MD_LG_XL),
        Row(
          children: secondRow.map((config) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: config != secondRow.last
                      ? context.scaleSM_MD_LG_XL
                      : 0,
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
    final isWide = screenWidth > DesignConstants.tabletBreakpoint;

    return Padding(
      padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton du titre
          Container(
            height: EcoPlatesDesignTokens.size.buttonHeight(context),
            width: DesignConstants.hundred + DesignConstants.fifty,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.xs,
              ),
            ),
          ),

          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // Skeleton des cartes KPI avec shimmer
          if (isWide)
            Row(
              children: KpiConfigs.all.map((config) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: config != KpiConfigs.all.last
                          ? context.scaleSM_MD_LG_XL
                          : 0,
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
                              ? context.scaleSM_MD_LG_XL
                              : 0,
                        ),
                        child: const KpiCardShimmer(),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: context.scaleSM_MD_LG_XL),
                Row(
                  children: KpiConfigs.all.skip(2).map((config) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: config != KpiConfigs.all.skip(2).last
                              ? context.scaleSM_MD_LG_XL
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
      padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(context.scaleLG_XL_XXL_XXXL),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: EcoPlatesDesignTokens.size.minTouchTarget,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: context.scaleMD_LG_XL_XXL),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: context.scaleXXS_XS_SM_MD),
              Text(
                'Impossible de charger les données analytiques',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.scaleMD_LG_XL_XXL),
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
