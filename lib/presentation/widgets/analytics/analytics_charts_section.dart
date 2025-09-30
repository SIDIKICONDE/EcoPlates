import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../domain/entities/analytics_stats.dart';
import '../../providers/analytics_provider.dart';
import 'charts/charts.dart';

/// Configurations centralisées pour les sections de charts du haut (revenus, commandes, commissions)
/// Permet d'appliquer des dispositions cohérentes selon les écrans
class TopChartsConfigs {
  /// Configuration responsive basée sur la largeur de l'écran
  static TopChartsConfig responsive(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: _mobileConfig,
      tablet: _tabletConfig,
      desktop: _desktopConfig,
      desktopLarge: _desktopLargeConfig,
    );
  }

  /// Configuration mobile : disposition en colonne
  static const _mobileConfig = TopChartsConfig(
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.start,
    spacing: 16.0,
  );

  /// Configuration tablette : disposition en colonne avec espacement
  static const _tabletConfig = TopChartsConfig(
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.start,
    spacing: 16.0,
  );

  /// Configuration desktop : disposition en ligne
  static const _desktopConfig = TopChartsConfig(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    spacing: null, // Utilise horizontalSpacing du contexte
  );

  /// Configuration desktop large : disposition en ligne optimisée
  static const _desktopLargeConfig = TopChartsConfig(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    spacing: null, // Utilise horizontalSpacing du contexte
  );
}

/// Configuration pour la disposition des charts du haut
class TopChartsConfig {
  const TopChartsConfig({
    required this.direction,
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.spacing,
  });

  /// Direction principale de disposition (vertical/horizontal)
  final Axis direction;

  /// Alignement transversal
  final CrossAxisAlignment crossAxisAlignment;

  /// Alignement principal
  final MainAxisAlignment mainAxisAlignment;

  /// Espacement entre les charts (null = utilise horizontalSpacing du contexte)
  final double? spacing;
}

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
    final config = TopChartsConfigs.responsive(context);

    return Flex(
      direction: config.direction,
      crossAxisAlignment: config.crossAxisAlignment,
      mainAxisAlignment: config.mainAxisAlignment,
      children: [
        if (config.direction == Axis.horizontal) ...[
          Expanded(child: RevenueChart(analytics: analytics)),
          SizedBox(width: config.spacing ?? context.horizontalSpacing),
          Expanded(child: OrdersChart(analytics: analytics)),
          SizedBox(width: config.spacing ?? context.horizontalSpacing),
          Expanded(child: CommissionsChart(analytics: analytics)),
        ] else ...[
          RevenueChart(analytics: analytics),
          SizedBox(height: config.spacing ?? 16.0),
          OrdersChart(analytics: analytics),
          SizedBox(height: config.spacing ?? 16.0),
          CommissionsChart(analytics: analytics),
        ],
      ],
    );
  }
}
