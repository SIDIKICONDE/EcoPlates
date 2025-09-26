import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Alertes de stock',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (outOfStockItems.isNotEmpty)
                _buildAlertChip(
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
                  theme: theme,
                  count: lowStockItems.length,
                  label: lowStockItems.length == 1
                      ? 'article stock faible'
                      : 'articles stock faible',
                  color: Colors.orange,
                  icon: Icons.warning_outlined,
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAlertChip({
    required ThemeData theme,
    required int count,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
