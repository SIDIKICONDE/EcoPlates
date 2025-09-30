import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/responsive/responsive_utils.dart';
import '../../../../domain/entities/analytics_stats.dart';
import 'customer_satisfaction_chart.dart';
import 'top_products_chart.dart';

/// Configurations centralisées pour les sections de charts analytiques
/// Permet d'appliquer des dispositions cohérentes selon les écrans
class AnalyticsChartsConfigs {
  /// Configuration responsive basée sur la largeur de l'écran
  static AnalyticsChartsConfig responsive(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: _mobileConfig,
      tablet: _tabletConfig,
      desktop: _desktopConfig,
      desktopLarge: _desktopLargeConfig,
    );
  }

  /// Configuration mobile : disposition en colonne
  static const _mobileConfig = AnalyticsChartsConfig(
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.start,
    chartAlignment: AnalyticsChartAlignment.fullWidth,
  );

  /// Configuration tablette : charts en pleine largeur pour meilleure lisibilité
  static const _tabletConfig = AnalyticsChartsConfig(
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.start,
    chartAlignment: AnalyticsChartAlignment.fullWidth,
  );

  /// Configuration desktop : disposition en ligne
  static const _desktopConfig = AnalyticsChartsConfig(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    chartAlignment: AnalyticsChartAlignment.equalColumns,
  );

  /// Configuration desktop large : même que desktop mais optimisée
  static const _desktopLargeConfig = AnalyticsChartsConfig(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    chartAlignment: AnalyticsChartAlignment.equalColumns,
  );
}

/// Configuration pour la disposition des charts analytiques
class AnalyticsChartsConfig {
  const AnalyticsChartsConfig({
    required this.direction,
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.chartAlignment,
  });

  /// Direction principale de disposition (vertical/horizontal)
  final Axis direction;

  /// Alignement transversal
  final CrossAxisAlignment crossAxisAlignment;

  /// Alignement principal
  final MainAxisAlignment mainAxisAlignment;

  /// Type d'alignement des charts
  final AnalyticsChartAlignment chartAlignment;
}

/// Types d'alignement possibles pour les charts
enum AnalyticsChartAlignment {
  /// Tous les charts en pleine largeur
  fullWidth,

  /// Deux charts en colonnes, un centré en dessous
  twoColumnsWithCenter,

  /// Charts répartis équitablement en colonnes
  equalColumns,
}

class BottomChartsSection extends StatelessWidget {
  const BottomChartsSection({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    final config = AnalyticsChartsConfigs.responsive(context);

    return Padding(
      padding: context.responsivePadding,
      child: Flex(
        direction: config.direction,
        crossAxisAlignment: config.crossAxisAlignment,
        mainAxisAlignment: config.mainAxisAlignment,
        children: _buildCharts(context, config),
      ),
    );
  }

  /// Construit la liste des charts selon la configuration
  List<Widget> _buildCharts(
    BuildContext context,
    AnalyticsChartsConfig config,
  ) {
    switch (config.chartAlignment) {
      case AnalyticsChartAlignment.fullWidth:
        return [
          TopProductsChart(analytics: analytics),
          SizedBox(height: context.verticalSpacing),
          CustomerSatisfactionChart(analytics: analytics),
        ];

      case AnalyticsChartAlignment.twoColumnsWithCenter:
        return [
          TopProductsChart(analytics: analytics),
          SizedBox(height: context.verticalSpacing),
          // Chart de satisfaction centré
          ConstrainedBox(
            constraints: BoxConstraints(),
            child: CustomerSatisfactionChart(analytics: analytics),
          ),
        ];

      case AnalyticsChartAlignment.equalColumns:
        return [
          Expanded(child: TopProductsChart(analytics: analytics)),
          SizedBox(width: context.horizontalSpacing),
          Expanded(child: CustomerSatisfactionChart(analytics: analytics)),
        ];
    }
  }
}
