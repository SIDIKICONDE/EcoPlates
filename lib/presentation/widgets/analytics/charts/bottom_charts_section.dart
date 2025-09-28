import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../domain/entities/analytics_stats.dart';
import 'categories_chart.dart';
import 'customer_satisfaction_chart.dart';
import 'top_products_chart.dart';

class BottomChartsSection extends StatelessWidget {
  const BottomChartsSection({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout,
      tablet: _buildTabletLayout,
      desktop: _buildDesktopLayout,
      desktopLarge: _buildDesktopLayout,
    );
  }

  /// Layout mobile : disposition en colonne
  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
      child: Column(
        children: [
          TopProductsChart(analytics: analytics),
          SizedBox(
            height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
          ),
          CategoriesChart(analytics: analytics),
          SizedBox(
            height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
          ),
          RatingDistributionChart(analytics: analytics),
        ],
      ),
    );
  }

  /// Layout tablette : disposition en ligne pour 2 charts + 1 en dessous
  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: TopProductsChart(analytics: analytics)),
              SizedBox(
                width: EcoPlatesDesignTokens.spacing.responsive(context),
              ),
              Expanded(child: CategoriesChart(analytics: analytics)),
            ],
          ),
          SizedBox(
            height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
          ),
          // Chart de satisfaction centré
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.responsiveValue(
                mobile: double.infinity,
                tablet: 400,
                desktop: 500,
              ),
            ),
            child: RatingDistributionChart(analytics: analytics),
          ),
        ],
      ),
    );
  }

  /// Layout desktop : disposition en ligne pour les 3 charts
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: TopProductsChart(analytics: analytics)),
          SizedBox(width: EcoPlatesDesignTokens.spacing.responsive(context)),
          Expanded(child: CategoriesChart(analytics: analytics)),
          SizedBox(width: EcoPlatesDesignTokens.spacing.responsive(context)),
          Expanded(child: RatingDistributionChart(analytics: analytics)),
        ],
      ),
    );
  }
}
