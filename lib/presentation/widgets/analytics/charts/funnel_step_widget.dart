import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      height: 80.0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Conteneur principal de l'étape
          Container(
            height: 80.0,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(step.color),
                  Color(step.color).withValues(
                    alpha: 0.8,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(
                16.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(
                    step.color,
                  ).withValues(alpha: 0.3),
                  blurRadius: 8.0,
                  offset: const Offset(
                    0,
                    4.0,
                  ),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  16.0,
                ),
                onTap: () async {
                  await StepDetailsDialog.show(context, step, dropRate);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      // Icône de l'étape
                      Container(
                        padding: const EdgeInsets.all(
                          12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getStepIcon(step.label),
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      // Label
                      Expanded(
                        child: Text(
                          step.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ),
                            ),
                            child: Text(
                              '${step.percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
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
      right: -40.0,
      top: -8.0,
      child: Container(
        padding: const EdgeInsets.all(
          8.0,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.error.withValues(
                alpha: 0.3,
              ),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.trending_down,
              color: Colors.white,
              size: 16.0,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              '-${dropRate.toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
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
