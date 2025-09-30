import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
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

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: dense ? 8.0 : 16.0,
        vertical: 4.0,
      ),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(
          dense ? 8.0 : 12.0,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            dense ? 8.0 : 12.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(
              dense ? 8.0 : 12.0,
            ),
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
                                fontSize: dense ? 14.0 : 16.0,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          // Indicateur de stock avec alerte
                          StockAlertBadge(
                            alertLevel: item.alertLevel,
                            compact: dense,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: dense ? 2.0 : 4.0,
                      ),
                      // Prix et catégorie
                      Row(
                        children: [
                          Text(
                            item.formattedPrice,
                            style: TextStyle(
                              fontSize: dense ? 14.0 : 16.0,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            ' / ${item.unit}',
                            style: TextStyle(
                              fontSize: dense ? 12.0 : 14.0,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(
                            width: dense ? 4.0 : 8.0,
                          ),
                          Container(
                            width: 4.0,
                            height: 4.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: dense ? 4.0 : 8.0,
                          ),
                          Expanded(
                            child: Text(
                              item.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: dense ? 12.0 : 14.0,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
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
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: item.status == StockItemStatus.active
                            ? DeepColorTokens.success
                            : DeepColorTokens.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    // Menu action
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20.0,
                      ),
                      onSelected: (value) =>
                          _handleMenuAction(context, ref, value),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(
                              Icons.edit,
                              size: 20.0,
                            ),
                            title: const Text('Modifier'),
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
                              size: 20.0,
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
        unawaited(
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => StockItemFormPage(item: item),
            ),
          ),
        );
      case 'toggle':
        unawaited(_toggleStatus(context, ref));
    }
  }

  Future<void> _toggleStatus(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(stockItemsProvider.notifier).toggleStatus(item.id);
    } on Exception catch (error) {
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
