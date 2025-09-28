import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/design_tokens.dart';
import '../../../../domain/entities/analytics_stats.dart';
import 'step_details_dialog.dart';

/// Widget pour une étape individuelle du tunnel de conversion
class FunnelStepWidget extends StatelessWidget {
  const FunnelStepWidget({
    required this.step,
    required this.index,
    required this.isLast,
    required this.analytics,
    required this.width,
    super.key,
  });

  final FunnelStep step;
  final int index;
  final bool isLast;
  final AnalyticsStats analytics;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFirst = index == 0;
    final dropRate = isFirst
        ? 0.0
        : analytics.conversionFunnel[index - 1].percentage - step.percentage;

    return SizedBox(
      height: ConversionFunnelConstants.stepHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Conteneur principal de l'étape
          Container(
            height: ConversionFunnelConstants.stepHeight,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(step.color),
                  Color(step.color).withValues(
                    alpha: ConversionFunnelConstants.stepGradientAlpha,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(
                ConversionFunnelConstants.stepBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(
                    step.color,
                  ).withValues(alpha: ConversionFunnelConstants.stepColorAlpha),
                  blurRadius: ConversionFunnelConstants.stepShadowBlurRadius,
                  offset: const Offset(
                    0,
                    ConversionFunnelConstants.shadowOffsetY,
                  ),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  ConversionFunnelConstants.stepBorderRadius,
                ),
                onTap: () async {
                  await StepDetailsDialog.show(context, step, dropRate);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ConversionFunnelConstants.stepPaddingHorizontal,
                  ),
                  child: Row(
                    children: [
                      // Icône de l'étape
                      Container(
                        padding: const EdgeInsets.all(
                          ConversionFunnelConstants.stepIconPadding,
                        ),
                        decoration: BoxDecoration(
                          color: ConversionFunnelConstants.white.withValues(
                            alpha:
                                ConversionFunnelConstants.iconBackgroundAlpha,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getStepIcon(step.label),
                          color: ConversionFunnelConstants.white,
                          size: ConversionFunnelConstants.stepIconSize,
                        ),
                      ),
                      const SizedBox(
                        width: ConversionFunnelConstants.stepStatsSpacing,
                      ),
                      // Label
                      Expanded(
                        child: Text(
                          step.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: ConversionFunnelConstants.white,
                            fontWeight:
                                ConversionFunnelConstants.stepLabelWeight,
                          ),
                        ),
                      ),
                      // Statistiques
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            NumberFormat.compact(
                              locale: 'fr_FR',
                            ).format(step.count),
                            style: TextStyle(
                              color: ConversionFunnelConstants.white,
                              fontWeight:
                                  ConversionFunnelConstants.stepCountWeight,
                              fontSize: EcoPlatesDesignTokens.analyticsCharts
                                  .valueFontSize(context),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ConversionFunnelConstants
                                  .stepStatsPaddingHorizontal,
                              vertical: ConversionFunnelConstants
                                  .stepStatsPaddingVertical,
                            ),
                            decoration: BoxDecoration(
                              color: ConversionFunnelConstants.white.withValues(
                                alpha: ConversionFunnelConstants
                                    .statsBackgroundAlpha,
                              ),
                              borderRadius: BorderRadius.circular(
                                ConversionFunnelConstants.stepStatsBorderRadius,
                              ),
                            ),
                            child: Text(
                              '${step.percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: ConversionFunnelConstants.white,
                                fontWeight: ConversionFunnelConstants
                                    .stepPercentageWeight,
                                fontSize: EcoPlatesDesignTokens.analyticsCharts
                                    .counterFontSize(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Indicateur de taux d'abandon
          if (!isFirst && dropRate > 0)
            _buildDropIndicator(theme, dropRate, context),
        ],
      ),
    );
  }

  Widget _buildDropIndicator(
    ThemeData theme,
    double dropRate,
    BuildContext context,
  ) {
    return Positioned(
      right: ConversionFunnelConstants.dropIndicatorOffsetX,
      top: ConversionFunnelConstants.dropIndicatorOffsetY,
      child: Container(
        padding: const EdgeInsets.all(
          ConversionFunnelConstants.dropIndicatorPadding,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.error.withValues(
                alpha: ConversionFunnelConstants.dropIndicatorShadowAlpha,
              ),
              blurRadius:
                  ConversionFunnelConstants.dropIndicatorShadowBlurRadius,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.trending_down,
              color: ConversionFunnelConstants.white,
              size: ConversionFunnelConstants.dropIndicatorIconSize,
            ),
            const SizedBox(
              width: ConversionFunnelConstants.dropIndicatorSpacing,
            ),
            Text(
              '-${dropRate.toStringAsFixed(1)}%',
              style: TextStyle(
                color: ConversionFunnelConstants.white,
                fontSize: EcoPlatesDesignTokens.analyticsCharts.counterFontSize(
                  context,
                ),
                fontWeight: ConversionFunnelConstants.dropRateWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStepIcon(String label) {
    switch (label.toLowerCase()) {
      case 'visiteurs':
      case 'visites':
        return Icons.visibility;
      case 'paniers':
      case 'ajout panier':
        return Icons.shopping_basket;
      case 'commandes':
      case 'checkout':
        return Icons.shopping_cart;
      case 'paiements':
      case 'paiement':
        return Icons.payment;
      case 'livraisons':
      case 'livraison':
        return Icons.local_shipping;
      default:
        return Icons.circle;
    }
  }
}
