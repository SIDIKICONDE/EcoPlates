import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';
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
      padding: const EdgeInsets.all(ConversionFunnelConstants.statsPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: ConversionFunnelConstants.surfaceContainerAlpha,
        ),
        borderRadius: BorderRadius.circular(
          ConversionFunnelConstants.statsBorderRadius,
        ),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: ConversionFunnelConstants.surfaceContainerBorderAlpha,
          ),
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
          size: ConversionFunnelConstants.statItemIconSize,
        ),
        const SizedBox(height: ConversionFunnelConstants.statItemSpacing),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: ConversionFunnelConstants.valueWeight,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: ConversionFunnelConstants.bodySmallFontSize,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(ThemeData theme) {
    return Container(
      width: ConversionFunnelConstants.statDividerWidth,
      height: ConversionFunnelConstants.statDividerHeight,
      color: theme.colorScheme.outline.withValues(
        alpha: ConversionFunnelConstants.outlineAlpha,
      ),
    );
  }
}
