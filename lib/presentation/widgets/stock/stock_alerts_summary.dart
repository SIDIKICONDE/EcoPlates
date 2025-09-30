import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        horizontal: 20.0,
        vertical: 12.0,
      ),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.15,
        ),
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 24.0,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 12.0),
              Text(
                'Alertes de stock',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0),

          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
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
        horizontal: 12.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20.0,
            color: color,
          ),
          SizedBox(width: 6.0),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: 6.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
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
