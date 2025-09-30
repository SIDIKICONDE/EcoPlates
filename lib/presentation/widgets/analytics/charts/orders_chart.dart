import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/analytics_stats.dart';
import 'reusable_chart.dart';

class OrdersChart extends StatelessWidget {
  const OrdersChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return ReusableChart(
      config: ChartConfig(
        title: 'Commandes par période',
        icon: Icons.bar_chart,
        iconColor: DeepColorTokens.secondary,
        totalValue: analytics.totalOrders.toDouble(),
        data: analytics.ordersData,
        valueFormatter: (value) => '${value.toInt()} cmd',
      ),
    );
  }
}
