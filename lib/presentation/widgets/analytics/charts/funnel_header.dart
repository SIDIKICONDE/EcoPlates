import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';
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
          padding: const EdgeInsets.all(
            ConversionFunnelConstants.dropIndicatorPadding,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(
              ConversionFunnelConstants.stepBorderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(
                  alpha: ConversionFunnelConstants.headerPrimaryAlpha,
                ),
                blurRadius: ConversionFunnelConstants.headerShadowBlurRadius,
                offset: const Offset(
                  0,
                  ConversionFunnelConstants.headerShadowOffsetY,
                ),
              ),
            ],
          ),
          child: const Icon(
            Icons.insights,
            size: ConversionFunnelConstants.headerIconSize,
            color: ConversionFunnelConstants.white,
          ),
        ),
        const SizedBox(width: ConversionFunnelConstants.headerSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tunnel de Conversion',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: ConversionFunnelConstants.titleWeight,
                  fontSize: EcoPlatesDesignTokens.analyticsCharts
                      .chartTitleFontSize(context),
                ),
              ),
              const SizedBox(
                height: ConversionFunnelConstants.headerExpandedSpacing,
              ),
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size:
                        EcoPlatesDesignTokens.analyticsCharts.iconSize(
                          context,
                        ) *
                        0.75,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(
                    width: ConversionFunnelConstants.dropIndicatorSpacing,
                  ),
                  Text(
                    'Taux global: ${analytics.conversionRate.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: ConversionFunnelConstants.bodyWeight,
                      fontSize: EcoPlatesDesignTokens.analyticsCharts
                          .labelFontSize(context),
                    ),
                  ),
                  const SizedBox(
                    width: ConversionFunnelConstants.contentSpacing,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ConversionFunnelConstants
                          .headerPeriodPaddingHorizontal,
                      vertical:
                          ConversionFunnelConstants.headerPeriodPaddingVertical,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                        ConversionFunnelConstants.headerPeriodBorderRadius,
                      ),
                    ),
                    child: Text(
                      analytics.period.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: EcoPlatesDesignTokens.analyticsCharts
                            .counterFontSize(context),
                        fontWeight: ConversionFunnelConstants.labelWeight,
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
