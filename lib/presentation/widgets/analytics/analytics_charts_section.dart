import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../domain/entities/analytics_stats.dart';
import '../../providers/analytics_provider.dart';
import 'charts/charts.dart';

/// Section contenant les graphiques d'analyse
///
/// Affiche :
/// - Graphique d'évolution des revenus, commandes et commissions (alignés horizontalement sur desktop)
/// - Top des produits les plus vendus, répartition par catégories et satisfaction client (disposition responsive)
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

        // Graphiques de revenus, commandes et commissions (alignés horizontalement sur desktop)
        _buildTopChartsSection(context, analytics),

        SizedBox(height: 16.0),

        // Top produits et catégories sur une ligne (responsive)
        BottomChartsSection(analytics: analytics),

        SizedBox(height: 16.0),
      ]),
    );
  }

  Widget _buildTopChartsSection(
    BuildContext context,
    AnalyticsStats analytics,
  ) {
    if (context.isDesktop) {
      // Sur desktop : aligner horizontalement les trois graphiques (revenus, commandes, commissions)
      return Row(
        children: [
          Expanded(
            child: RevenueChart(analytics: analytics),
          ),
          SizedBox(width: context.horizontalSpacing),
          Expanded(
            child: OrdersChart(analytics: analytics),
          ),
          SizedBox(width: context.horizontalSpacing),
          Expanded(
            child: CommissionsChart(analytics: analytics),
          ),
        ],
      );
    } else {
      // Sur mobile/tablette : empiler verticalement
      return Column(
        children: [
          RevenueChart(analytics: analytics),
          SizedBox(height: 16.0),
          OrdersChart(analytics: analytics),
          SizedBox(height: 16.0),
          CommissionsChart(analytics: analytics),
        ],
      );
    }
  }
}
