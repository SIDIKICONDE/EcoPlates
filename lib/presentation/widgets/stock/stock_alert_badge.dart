import 'package:flutter/material.dart';

import '../../../domain/entities/stock_item.dart';

/// Badge pour afficher le niveau d'alerte d'un article de stock
class StockAlertBadge extends StatelessWidget {
  const StockAlertBadge({
    required this.alertLevel,
    this.showLabel = true,
    this.compact = false,
    super.key,
  });

  /// Niveau d'alerte à afficher
  final StockAlertLevel alertLevel;

  /// Afficher le label texte à côté de l'icône
  final bool showLabel;

  /// Mode compact (tailles réduites)
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (alertLevel == StockAlertLevel.normal && !showLabel) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final color = _getColor(theme);
    final icon = _getIcon();

    final iconSize = compact ? 14.0 : 16.0;
    final fontSize = compact ? 10.0 : 12.0;
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 4);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
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
            size: iconSize,
            color: color,
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              alertLevel.label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getColor(ThemeData theme) {
    switch (alertLevel) {
      case StockAlertLevel.normal:
        return theme.colorScheme.primary;
      case StockAlertLevel.low:
        return Colors.orange;
      case StockAlertLevel.outOfStock:
        return theme.colorScheme.error;
    }
  }

  IconData _getIcon() {
    switch (alertLevel) {
      case StockAlertLevel.normal:
        return Icons.check_circle_outline;
      case StockAlertLevel.low:
        return Icons.warning_outlined;
      case StockAlertLevel.outOfStock:
        return Icons.error_outline;
    }
  }
}

/// Indicateur de stock avec quantité et alerte
class StockIndicator extends StatelessWidget {
  const StockIndicator({
    required this.item,
    this.showQuantity = true,
    this.compact = false,
    super.key,
  });

  /// Article de stock
  final StockItem item;

  /// Afficher la quantité
  final bool showQuantity;

  /// Mode compact
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = compact ? 11.0 : 13.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showQuantity) ...[
          Text(
            item.formattedQuantity,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: item.isOutOfStock
                  ? theme.colorScheme.error
                  : item.isLowStock
                  ? Colors.orange
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
        ],
        StockAlertBadge(
          alertLevel: item.alertLevel,
          showLabel: false,
          compact: compact,
        ),
      ],
    );
  }
}
