import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
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
        horizontal: dense
            ? context.scaleXS_SM_MD_LG
            : context.scaleMD_LG_XL_XXL,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(
          dense
              ? EcoPlatesDesignTokens.radius.sm
              : EcoPlatesDesignTokens.radius.md,
        ),
        elevation: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            dense
                ? EcoPlatesDesignTokens.radius.sm
                : EcoPlatesDesignTokens.radius.md,
          ),
          child: Padding(
            padding: EdgeInsets.all(
              dense ? context.scaleXS_SM_MD_LG : context.scaleSM_MD_LG_XL,
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
                                fontSize: dense
                                    ? EcoPlatesDesignTokens.typography.hint(
                                        context,
                                      )
                                    : EcoPlatesDesignTokens.typography.text(
                                        context,
                                      ),
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: context.scaleXXS_XS_SM_MD),
                          // Indicateur de stock avec alerte
                          StockIndicator(
                            item: item,
                            compact: dense,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: dense
                            ? context.scaleXXS_XS_SM_MD / 2
                            : context.scaleXXS_XS_SM_MD,
                      ),
                      // Prix et catégorie
                      Row(
                        children: [
                          Text(
                            item.formattedPrice,
                            style: TextStyle(
                              fontSize: dense
                                  ? EcoPlatesDesignTokens.typography.hint(
                                      context,
                                    )
                                  : EcoPlatesDesignTokens.typography.text(
                                      context,
                                    ),
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            ' / ${item.unit}',
                            style: TextStyle(
                              fontSize: EcoPlatesDesignTokens.typography.hint(
                                context,
                              ),
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(
                            width: dense
                                ? context.scaleXXS_XS_SM_MD
                                : context.scaleXS_SM_MD_LG,
                          ),
                          Container(
                            width:
                                EcoPlatesDesignTokens.size.indicator(context) /
                                2,
                            height:
                                EcoPlatesDesignTokens.size.indicator(context) /
                                2,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: dense
                                ? context.scaleXXS_XS_SM_MD
                                : context.scaleXS_SM_MD_LG,
                          ),
                          Text(
                            item.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: EcoPlatesDesignTokens.typography.hint(
                                context,
                              ),
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
                      width: EcoPlatesDesignTokens.layout.statusDotSize,
                      height: EcoPlatesDesignTokens.layout.statusDotSize,
                      margin: EdgeInsets.only(right: context.scaleXXS_XS_SM_MD),
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
                        size: EcoPlatesDesignTokens.size.icon(context),
                      ),
                      onSelected: (value) =>
                          _handleMenuAction(context, ref, value),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(
                              Icons.edit,
                              size: EcoPlatesDesignTokens.size.icon(context),
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
                              size: EcoPlatesDesignTokens.size.icon(context),
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
