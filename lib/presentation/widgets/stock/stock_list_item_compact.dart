import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/stock_item.dart';
import '../../pages/stock_item_form/page.dart';
import '../../providers/stock_items_provider.dart';
import 'stock_alert_badge.dart';

/// Version compacte et simplifiée d'un item de stock
///
/// Affiche uniquement les informations essentielles
class StockListItemCompact extends ConsumerWidget {
  const StockListItemCompact({
    required this.item,
    super.key,
    this.onTap,
    this.dense = false,
  });

  final StockItem item;
  final VoidCallback? onTap;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final pad = dense ? 8.0 : 12.0;
    final radius = dense ? 10.0 : 12.0;
    final titleSize = dense ? 15.0 : 16.0;
    final priceSize = dense ? 13.0 : 14.0;
    final unitSize = dense ? 11.0 : 12.0;
    final metaSize = dense ? 11.0 : 12.0;
    final hSpacing = dense ? 6.0 : 8.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: dense ? 12 : 16, vertical: 4),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        elevation: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: EdgeInsets.all(pad),
            child: Row(
              children: [
                // Informations principales
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom et quantité
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: hSpacing),
                          // Indicateur de stock avec alerte
                          StockIndicator(
                            item: item,
                            showQuantity: true,
                            compact: dense,
                          ),
                        ],
                      ),
                      SizedBox(height: dense ? 3 : 4),
                      // Prix et catégorie
                      Row(
                        children: [
                          Text(
                            item.formattedPrice,
                            style: TextStyle(
                              fontSize: priceSize,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            ' / ${item.unit}',
                            style: TextStyle(
                              fontSize: unitSize,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: dense ? 8 : 12),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: dense ? 8 : 12),
                          Text(
                            item.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: metaSize,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Statut et action
                Row(
                  children: [
                    // Indicateur de statut
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: item.status == StockItemStatus.active
                            ? Colors.green
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Menu action
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onSelected: (value) =>
                          _handleMenuAction(context, ref, value),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit, size: 20),
                            title: Text('Modifier'),
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle',
                          child: ListTile(
                            leading: Icon(
                              item.status == StockItemStatus.active
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 20,
                            ),
                            title: Text(
                              item.status == StockItemStatus.active
                                  ? 'Désactiver'
                                  : 'Activer',
                            ),
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => StockItemFormPage(item: item),
          ),
        );
      case 'toggle':
        _toggleStatus(context, ref);
    }
  }

  Future<void> _toggleStatus(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(stockItemsProvider.notifier).toggleStatus(item.id);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(StockErrorMessages.getErrorMessage(error)),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
