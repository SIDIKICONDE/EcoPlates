import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_stats.dart';

/// Section des statistiques clés du tunnel de conversion
class FunnelStatsSection extends StatelessWidget {
  const FunnelStatsSection({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            'Visiteurs',
            analytics.conversionFunnel.first.count.toString(),
            Icons.visibility,
            theme.colorScheme.primary,
          ),
          _buildStatDivider(theme),
          _buildStatItem(
            context,
            'Conversions',
            analytics.conversionFunnel.last.count.toString(),
            Icons.shopping_cart_checkout,
            theme.colorScheme.secondary,
          ),
          _buildStatDivider(theme),
          _buildStatItem(
            context,
            'Taux final',
            '${analytics.conversionFunnel.last.percentage.toStringAsFixed(1)}%',
            Icons.percent,
            theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24.0,
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(ThemeData theme) {
    return Container(
      width: 1.0,
      height: 40.0,
      color: theme.colorScheme.outline.withValues(alpha: 0.3),
    );
  }
}
