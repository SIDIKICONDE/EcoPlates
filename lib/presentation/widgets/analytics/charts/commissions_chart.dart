import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/analytics_stats.dart';
import 'reusable_chart.dart';

/// Widget pour afficher le graphique d'évolution des commissions
///
/// Utilise le composant [ReusableChart] avec une configuration spécifique
/// pour afficher les commissions payées par le commerçant à la plateforme
class CommissionsChart extends StatelessWidget {
  const CommissionsChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return ReusableChart(
      config: ChartConfig(
        title: 'Commissions payées',
        icon: Icons.account_balance_wallet,
        iconColor: Theme.of(context).colorScheme.tertiary,
        totalValue: analytics.totalCommissions,
        data: analytics.commissionData,
        valueFormatter: _formatCurrency,
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
