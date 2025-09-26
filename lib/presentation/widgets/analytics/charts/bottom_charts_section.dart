import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_stats.dart';
import 'categories_chart.dart';
import 'top_products_chart.dart';

class BottomChartsSection extends StatelessWidget {
  const BottomChartsSection({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 768;

    if (isWide) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: TopProductsChart(analytics: analytics)),
            const SizedBox(width: 16),
            Expanded(child: CategoriesChart(analytics: analytics)),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          TopProductsChart(analytics: analytics),
          const SizedBox(height: 24),
          CategoriesChart(analytics: analytics),
        ],
      );
    }
  }
}
