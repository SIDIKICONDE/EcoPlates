import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';
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
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.surfaceContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: DeepColorTokens.neutral600.withValues(alpha: 0.2),
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
            DeepColorTokens.primary,
          ),
          _buildStatDivider(),
          _buildStatItem(
            context,
            'Conversions',
            analytics.conversionFunnel.last.count.toString(),
            Icons.shopping_cart_checkout,
            DeepColorTokens.secondary,
          ),
          _buildStatDivider(),
          _buildStatItem(
            context,
            'Taux final',
            '${analytics.conversionFunnel.last.percentage.toStringAsFixed(1)}%',
            Icons.percent,
            DeepColorTokens.tertiary,
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
          style: TextStyle(
            fontSize: FontSizes.titleSmall.getSize(context),
            fontWeight: FontSizes.titleSmall.getFontWeight(),
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.caption.getSize(context),
            color: DeepColorTokens.neutral600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1.0,
      height: 40.0,
      color: DeepColorTokens.neutral600.withValues(alpha: 0.3),
    );
  }
}
