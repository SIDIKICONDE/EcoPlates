import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/widgets/adaptive_widgets.dart';
import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';
import '../../widgets/stock/stock_alert_badge.dart';
import '../../widgets/stock/stock_quantity_adjuster.dart';
import '../../widgets/stock/stock_status_toggle.dart';
import '../stock_item_form/page.dart';

/// Page de détail d'un article de stock
/// Affiche les informations complètes, et permet d'ajuster la quantité
/// et de basculer le statut. Bouton d'édition dans l'AppBar.
class StockItemDetailPage extends ConsumerWidget {
  const StockItemDetailPage({required this.item, super.key});

  final StockItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute l'état courant pour refléter les mises à jour en direct
    final itemsAsync = ref.watch(stockItemsProvider);
    final currentItem = itemsAsync.maybeWhen(
      data: (items) => items.firstWhere(
        (i) => i.id == item.id,
        orElse: () => item,
      ),
      orElse: () => item,
    );

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(currentItem.name),
        actions: [
          IconButton(
            tooltip: 'Modifier',
            icon: const Icon(Icons.edit),
            onPressed: () {
              unawaited(
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StockItemFormPage(item: currentItem),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          EcoPlatesDesignTokens.spacing.dialogGap(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderCard(item: currentItem),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            ),
            _StatsCard(item: currentItem),
            if (currentItem.lowStockThreshold != null) ...[
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              _AlertThresholdCard(item: currentItem),
            ],
            if (currentItem.description?.isNotEmpty ?? false) ...[
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              _DescriptionCard(text: currentItem.description!),
            ],
            SizedBox(height: EcoPlatesDesignTokens.spacing.dialogGap(context)),
            _ActionsSection(item: currentItem),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.item});
  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.dialogGap(context)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
          width: EcoPlatesDesignTokens.layout.cardBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.titleSize(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: EcoPlatesDesignTokens.spacing.microGap(context),
                    ),
                    Wrap(
                      spacing: EcoPlatesDesignTokens.spacing.microGap(context),
                      runSpacing: EcoPlatesDesignTokens.spacing.microGap(
                        context,
                      ),
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _SkuChip(sku: item.sku),
                        _CategoryChip(category: item.category),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              _StatusDot(status: item.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.item});
  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.dialogGap(context)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
          width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            runSpacing: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            children: [
              _StatTile(
                label: 'Prix',
                value: item.formattedPrice,
                suffix: '/ ${item.unit}',
                color: theme.colorScheme.primary,
              ),
              _StatTile(
                label: 'Quantité',
                value: item.formattedQuantity,
                color: item.isOutOfStock
                    ? theme.colorScheme.error
                    : theme.colorScheme.secondary,
              ),
            ],
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.update,
                size: EcoPlatesDesignTokens.size.indicator(context),
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
              ),
              SizedBox(width: EcoPlatesDesignTokens.spacing.microGap(context)),
              Text(
                _formatLastUpdate(item.updatedAt),
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLastUpdate(DateTime updatedAt) {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inMinutes < 1) {
      return "À l'instant";
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
    }
  }
}

class _AlertThresholdCard extends StatelessWidget {
  const _AlertThresholdCard({required this.item});
  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.dialogGap(context)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
          width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_outlined,
            size: EcoPlatesDesignTokens.size.icon(context),
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: EcoPlatesDesignTokens.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Seuil d'alerte configuré",
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.text(context),
                    fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                Text(
                  'Une alerte sera déclenchée quand le stock atteint ${item.lowStockThreshold} ${item.unit}',
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.hint(context),
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: EcoPlatesDesignTokens.spacing.sm),
          StockAlertBadge(
            alertLevel: item.alertLevel,
            showLabel: false,
            compact: true,
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.dialogGap(context)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
          width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              fontWeight: EcoPlatesDesignTokens.typography.semiBold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
          Text(
            text,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              color: theme.colorScheme.onSurface,
              height: EcoPlatesDesignTokens.layout.textLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection({required this.item});
  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.dialogGap(context)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
          width: EcoPlatesDesignTokens.layout.cardBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            runSpacing: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              StockStatusToggle(
                item: item,
              ),
              StockQuantityAdjuster(
                item: item,
              ),
            ],
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),
          FilledButton.icon(
            onPressed: () {
              unawaited(
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StockItemFormPage(item: item),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit_square),
            label: const Text("Modifier l'article"),
          ),
        ],
      ),
    );
  }
}

class _SkuChip extends StatelessWidget {
  const _SkuChip({required this.sku});
  final String sku;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EcoPlatesDesignTokens.spacing.skuChipPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: EcoPlatesDesignTokens.opacity.subtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
      ),
      child: Text(
        sku,
        style: TextStyle(
          fontSize: EcoPlatesDesignTokens.typography.hint(context),
          color: theme.colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
          fontWeight: EcoPlatesDesignTokens.typography.regular,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});
  final String category;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EcoPlatesDesignTokens.spacing.categoryChipPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(
          alpha: EcoPlatesDesignTokens.opacity.pressed,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: EcoPlatesDesignTokens.opacity.pressed,
          ),
          width: EcoPlatesDesignTokens.layout.cardBorderWidth,
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: EcoPlatesDesignTokens.typography.hint(context),
          color: theme.colorScheme.primary,
          fontWeight: EcoPlatesDesignTokens.typography.medium,
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});
  final StockItemStatus status;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: EcoPlatesDesignTokens.layout.statusDotSize,
      height: EcoPlatesDesignTokens.layout.statusDotSize,
      decoration: BoxDecoration(
        color: status == StockItemStatus.active
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.suffix,
    this.color,
  });
  final String label;
  final String value;
  final String? suffix;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EcoPlatesDesignTokens.spacing.statTilePadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: EcoPlatesDesignTokens.opacity.pressed,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.button(context),
              fontWeight: EcoPlatesDesignTokens.typography.bold,
              color: color ?? theme.colorScheme.onSurface,
            ),
          ),
          if (suffix != null) ...[
            SizedBox(width: EcoPlatesDesignTokens.spacing.xxs),
            Text(
              suffix!,
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(width: EcoPlatesDesignTokens.spacing.microGap(context)),
          Text(
            label,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
