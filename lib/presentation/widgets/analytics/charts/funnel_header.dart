import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_stats.dart';

/// Widget pour l'en-tête du graphique du tunnel de conversion
class FunnelHeader extends StatelessWidget {
  const FunnelHeader({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.24,
                ),
                blurRadius: 8.0,
                offset: const Offset(0, 4.0),
              ),
            ],
          ),
          child: const Icon(
            Icons.insights,
            size: 24.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tunnel de Conversion',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 16.0 * 0.75,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Taux global: ${analytics.conversionRate.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      analytics.period.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
