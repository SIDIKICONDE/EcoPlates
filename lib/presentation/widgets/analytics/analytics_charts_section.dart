import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/analytics_stats.dart';
import '../../providers/analytics_provider.dart';
import 'charts/charts.dart';

/// Section contenant les graphiques d'analyse
///
/// Affiche :
/// - Graphique d'évolution des revenus
/// - Graphique des ventes par période
/// - Graphique des commissions payées
/// - Top des produits les plus vendus
/// - Répartition par catégories
class AnalyticsChartsSection extends ConsumerWidget {
  const AnalyticsChartsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsStatsProvider);

    return analyticsAsync.when(
      data: (analytics) => _buildChartsSection(context, analytics),
      loading: () => const LoadingSection(),
      error: (error, stack) => const ErrorSection(),
    );
  }

  Widget _buildChartsSection(BuildContext context, AnalyticsStats analytics) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 16.0),

        // Graphique d'évolution des revenus
        RevenueChart(analytics: analytics),

        SizedBox(height: 16.0),

        // Graphique des commandes
        OrdersChart(analytics: analytics),

        SizedBox(height: 16.0),

        // Graphique des commissions
        CommissionsChart(analytics: analytics),

        SizedBox(height: 16.0),

        // Graphique de satisfaction client
        CustomerSatisfactionChart(analytics: analytics),

        SizedBox(height: 16.0),

        // Graphique du funnel de conversion
        ConversionFunnelChart(analytics: analytics),

        SizedBox(height: 16.0),

        // Top produits et catégories sur une ligne (responsive)
        BottomChartsSection(analytics: analytics),

        SizedBox(height: 16.0),
      ]),
    );
  }
}
