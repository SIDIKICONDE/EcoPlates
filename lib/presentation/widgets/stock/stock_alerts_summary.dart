import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../providers/stock_items_provider.dart';

/// Widget affichant un résumé des alertes de stock
class StockAlertsSummary extends ConsumerWidget {
  const StockAlertsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lowStockItems = ref.watch(lowStockItemsProvider);
    final outOfStockItems = ref.watch(outOfStockItemsProvider);

    // Ne rien afficher s'il n'y a pas d'alertes
    if (lowStockItems.isEmpty && outOfStockItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing,
        vertical: context.verticalSpacing * 0.5,
      ),
      padding: context.responsivePadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.15,
        ),
        borderRadius: BorderRadius.circular(
          context.borderRadius,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ResponsiveIcon(
                Icons.notifications_active_outlined,
                color: theme.colorScheme.primary,
              ),
              HorizontalGap(),
              ResponsiveText(
                'Alertes de stock',
                fontSize: FontSizes.subtitleSmall,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          VerticalGap(),

          Wrap(
            spacing: context.horizontalSpacing,
            runSpacing: context.verticalSpacing * 0.3,
            children: [
              if (outOfStockItems.isNotEmpty)
                _buildAlertChip(
                  context,
                  theme: theme,
                  count: outOfStockItems.length,
                  label: outOfStockItems.length == 1
                      ? 'article en rupture'
                      : 'articles en rupture',
                  color: theme.colorScheme.error,
                  icon: Icons.error_outline,
                ),

              if (lowStockItems.isNotEmpty)
                _buildAlertChip(
                  context,
                  theme: theme,
                  count: lowStockItems.length,
                  label: lowStockItems.length == 1
                      ? 'article stock faible'
                      : 'articles stock faible',
                  color: DeepColorTokens.warning,
                  icon: Icons.warning_outlined,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertChip(
    BuildContext context, {
    required ThemeData theme,
    required int count,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing * 0.5,
        vertical: context.verticalSpacing * 0.25,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          context.borderRadius,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResponsiveIcon(
            icon,
            color: color,
            size: 20.0,
          ),
          HorizontalGap(multiplier: 0.25),
          ResponsiveText(
            '$count',
            fontSize: FontSizes.bodyMedium,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          HorizontalGap(multiplier: 0.25),
          ResponsiveText(
            label,
            fontSize: FontSizes.bodyMedium,
            style: TextStyle(
              color: color.withValues(
                alpha: 0.85,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
