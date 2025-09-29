import 'package:flutter/material.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < 600) {
          return _buildMobileLayout(context);
        } else if (width < 1200) {
          return _buildTabletLayout(context);
        } else {
          return _buildDesktopLayout(context);
        }
      },
    );
  }

  /// Layout mobile : disposition en colonne
  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TopProductsChart(analytics: analytics),
          SizedBox(
            height: 24.0,
          ),
          CategoriesChart(analytics: analytics),
          SizedBox(
            height: 24.0,
          ),
          CustomerSatisfactionChart(analytics: analytics),
        ],
      ),
    );
  }

  /// Layout tablette : disposition en ligne pour 2 charts + 1 en dessous
  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: TopProductsChart(analytics: analytics)),
              SizedBox(
                width: 16.0,
              ),
              Expanded(child: CategoriesChart(analytics: analytics)),
            ],
          ),
          SizedBox(
            height: 24.0,
          ),
          // Chart de satisfaction centré
          ConstrainedBox(
            constraints: BoxConstraints(
              
            ),
            child: CustomerSatisfactionChart(analytics: analytics),
          ),
        ],
      ),
    );
  }

  /// Layout desktop : disposition en ligne pour les 3 charts
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: TopProductsChart(analytics: analytics)),
          SizedBox(width: 16.0),
          Expanded(child: CategoriesChart(analytics: analytics)),
          SizedBox(width: 16.0),
          Expanded(child: CustomerSatisfactionChart(analytics: analytics)),
        ],
      ),
    );
  }
}
