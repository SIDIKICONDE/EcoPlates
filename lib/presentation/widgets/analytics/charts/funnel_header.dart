import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                DeepColorTokens.primary,
                DeepColorTokens.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: DeepColorTokens.shadowMedium,
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
                style: TextStyle(
                  fontSize: FontSizes.subtitleLarge.getSize(context),
                  fontWeight: FontSizes.subtitleLarge.getFontWeight(),
                  color: DeepColorTokens.neutral900,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 16.0 * 0.75,
                    color: DeepColorTokens.primary,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Taux global: ${analytics.conversionRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: FontSizes.bodySmall.getSize(context),
                      color: DeepColorTokens.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: DeepColorTokens.secondaryContainer.withValues(
                        alpha: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      analytics.period.label,
                      style: TextStyle(
                        fontSize: FontSizes.caption.getSize(context),
                        fontWeight: FontWeight.w500,
                        color: DeepColorTokens.neutral700,
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
