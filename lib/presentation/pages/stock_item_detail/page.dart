import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderCard(item: currentItem),
            SizedBox(
              height: 16.0,
            ),
            _StatsCard(item: currentItem),
            if (currentItem.lowStockThreshold != null) ...[
              SizedBox(
                height: 16.0,
              ),
              _AlertThresholdCard(item: currentItem),
            ],
            if (currentItem.description?.isNotEmpty ?? false) ...[
              SizedBox(
                height: 16.0,
              ),
              _DescriptionCard(text: currentItem.description!),
            ],
            SizedBox(height: 16.0),
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _SkuChip(sku: item.sku),
                        _CategoryChip(category: item.category),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
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
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.update,
                size: 16.0,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4.0),
              Text(
                _formatLastUpdate(item.updatedAt),
                style: TextStyle(
                  fontSize: 12.0,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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

class _AlertThresholdCard extends StatelessWidget {
  const _AlertThresholdCard({required this.item});
  final StockItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          const StockAlertBadge(alertLevel: StockAlertLevel.low),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              'Une alerte sera déclenchée quand le stock atteint ${item.lowStockThreshold} ${item.unit}',
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.0,
              color: theme.colorScheme.onSurface,
              height: 1.5,
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
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
          const SizedBox(height: 16.0),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        sku,
        style: TextStyle(
          fontSize: 12.0,
          color: theme.colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12.0,
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
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
    final color = status == StockItemStatus.active
        ? theme.colorScheme.primary
        : status == StockItemStatus.inactive
        ? theme.colorScheme.error
        : theme.colorScheme.secondary;

    return Container(
      width: 12.0,
      height: 12.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
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
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color:
            color?.withValues(alpha: 0.1) ??
            theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: color ?? theme.colorScheme.onSurface,
            ),
          ),
          if (suffix != null) ...[
            const SizedBox(width: 4.0),
            Text(
              suffix!,
              style: TextStyle(
                fontSize: 14.0,
                color: color ?? theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(width: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
