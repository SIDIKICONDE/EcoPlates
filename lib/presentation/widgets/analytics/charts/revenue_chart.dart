import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/analytics_stats.dart';
import 'reusable_chart.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return ReusableChart(
      config: ChartConfig(
        title: 'Évolution des revenus',
        icon: Icons.trending_up,
        iconColor: Theme.of(context).colorScheme.primary,
        totalValue: analytics.totalRevenue,
        data: analytics.revenueData,
        valueFormatter: _formatCurrency,
        showLine: true,
        lineColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
      decimalDigits: amount % 1 == 0 ? 0 : 2,
    );
    return formatter.format(amount);
  }
}
