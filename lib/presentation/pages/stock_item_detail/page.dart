import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
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
        padding: context.responsivePadding,
        child: ResponsiveLayout(
          mobile: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderCard(item: currentItem),
              VerticalGap(),
              _StatsCard(item: currentItem),
              if (currentItem.lowStockThreshold != null) ...[
                VerticalGap(),
                _AlertThresholdCard(item: currentItem),
              ],
              if (currentItem.description?.isNotEmpty ?? false) ...[
                VerticalGap(),
                _DescriptionCard(text: currentItem.description!),
              ],
              VerticalGap(),
              _ActionsSection(item: currentItem),
            ],
          ),
          tablet: ResponsiveCardGrid(
            tabletColumns: 2,
            desktopColumns: 2,
            spacing: context.horizontalSpacing,
            runSpacing: context.verticalSpacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _HeaderCard(item: currentItem),
              _StatsCard(item: currentItem),
              if (currentItem.lowStockThreshold != null)
                _AlertThresholdCard(item: currentItem),
              if (currentItem.description?.isNotEmpty ?? false)
                _DescriptionCard(text: currentItem.description!),
              _ActionsSection(item: currentItem),
            ],
          ),
          desktop: ResponsiveCardGrid(
            tabletColumns: 2,
            spacing: context.horizontalSpacing,
            runSpacing: context.verticalSpacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _HeaderCard(item: currentItem),
              _StatsCard(item: currentItem),
              if (currentItem.lowStockThreshold != null)
                _AlertThresholdCard(item: currentItem),
              if (currentItem.description?.isNotEmpty ?? false)
                _DescriptionCard(text: currentItem.description!),
              _ActionsSection(item: currentItem),
            ],
          ),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 3,
        vertical: context.verticalSpacing / 6,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral200,
        borderRadius: BorderRadius.circular(context.borderRadius / 3),
        border: Border.all(
          color: DeepColorTokens.neutral400.withValues(alpha: 0.1),
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
                    ResponsiveText(
                      item.name,
                      fontSize: FontSizes.titleSmall,
                    ),
                    VerticalGap(height: context.verticalSpacing / 4),
                    Wrap(
                      spacing: context.horizontalSpacing / 2,
                      runSpacing: context.verticalSpacing / 3,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _SkuChip(sku: item.sku),
                        _CategoryChip(category: item.category),
                      ],
                    ),
                  ],
                ),
              ),
              HorizontalGap(),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 3,
        vertical: context.verticalSpacing / 6,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral200,
        borderRadius: BorderRadius.circular(context.borderRadius / 3),
        border: Border.all(
          color: DeepColorTokens.neutral400.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ResponsiveLayout(
            mobile: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatTile(
                  label: 'Prix',
                  value: item.formattedPrice,
                  suffix: '/ ${item.unit}',
                  color: DeepColorTokens.primary,
                ),
                VerticalGap(height: context.verticalSpacing / 3),
                _StatTile(
                  label: 'Quantité',
                  value: item.formattedQuantity,
                  color: item.isOutOfStock
                      ? DeepColorTokens.error
                      : DeepColorTokens.secondary,
                ),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Prix',
                    value: item.formattedPrice,
                    suffix: '/ ${item.unit}',
                    color: DeepColorTokens.primary,
                  ),
                ),
                HorizontalGap(),
                Expanded(
                  child: _StatTile(
                    label: 'Quantité',
                    value: item.formattedQuantity,
                    color: item.isOutOfStock
                        ? DeepColorTokens.error
                        : DeepColorTokens.secondary,
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Prix',
                    value: item.formattedPrice,
                    suffix: '/ ${item.unit}',
                    color: DeepColorTokens.primary,
                  ),
                ),
                HorizontalGap(),
                Expanded(
                  child: _StatTile(
                    label: 'Quantité',
                    value: item.formattedQuantity,
                    color: item.isOutOfStock
                        ? DeepColorTokens.error
                        : DeepColorTokens.secondary,
                  ),
                ),
              ],
            ),
          ),
          VerticalGap(height: context.verticalSpacing / 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.update,
                size: FontSizes.caption.getSize(context),
                color: DeepColorTokens.neutral600.withValues(alpha: 0.6),
              ),
              HorizontalGap(width: context.horizontalSpacing / 6),
              Text(
                _formatLastUpdate(item.updatedAt),
                style: TextStyle(
                  fontSize: FontSizes.caption.getSize(context),
                  color: DeepColorTokens.neutral600.withValues(alpha: 0.6),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 3,
        vertical: context.verticalSpacing / 6,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral200,
        borderRadius: BorderRadius.circular(context.borderRadius / 3),
        border: Border.all(
          color: DeepColorTokens.primary.withValues(alpha: 0.3),
          width: context.responsive(mobile: 1.5, tablet: 2.0, desktop: 2.5),
        ),
      ),
      child: Row(
        children: [
          const StockAlertBadge(alertLevel: StockAlertLevel.low),
          HorizontalGap(width: context.horizontalSpacing / 2),
          Expanded(
            child: Text(
              'Une alerte sera déclenchée quand le stock atteint ${item.lowStockThreshold} ${item.unit}',
              style: TextStyle(
                fontSize: FontSizes.bodySmall.getSize(context),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 3,
        vertical: context.verticalSpacing / 6,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral200,
        borderRadius: BorderRadius.circular(context.borderRadius / 3),
        border: Border.all(
          color: DeepColorTokens.neutral400.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            'Description',
            fontSize: FontSizes.subtitleSmall,
          ),
          VerticalGap(height: context.verticalSpacing / 4),
          Text(
            text,
            style: TextStyle(
              fontSize: FontSizes.bodySmall.getSize(context),
              color: DeepColorTokens.neutral800,
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 3,
        vertical: context.verticalSpacing / 6,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral200,
        borderRadius: BorderRadius.circular(context.borderRadius / 3),
        border: Border.all(
          color: DeepColorTokens.neutral400.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResponsiveLayout(
            mobile: Column(
              children: [
                StockStatusToggle(item: item),
                VerticalGap(height: context.verticalSpacing / 3),
                StockQuantityAdjuster(item: item),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(child: StockStatusToggle(item: item)),
                HorizontalGap(),
                Expanded(child: StockQuantityAdjuster(item: item)),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(child: StockStatusToggle(item: item)),
                HorizontalGap(),
                Expanded(child: StockQuantityAdjuster(item: item)),
              ],
            ),
          ),
          VerticalGap(),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 2,
        vertical: context.verticalSpacing / 4,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral800,
        borderRadius: BorderRadius.circular(context.borderRadius / 2),
      ),
      child: Text(
        sku,
        style: TextStyle(
          fontSize: FontSizes.caption.getSize(context),
          color: DeepColorTokens.neutral600,
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 2,
        vertical: context.verticalSpacing / 4,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.primaryContainer,
        borderRadius: BorderRadius.circular(context.borderRadius / 2),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: FontSizes.caption.getSize(context),
          color: DeepColorTokens.primary,
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
    final color = status == StockItemStatus.active
        ? DeepColorTokens.primary
        : status == StockItemStatus.inactive
        ? DeepColorTokens.error
        : DeepColorTokens.secondary;

    return Container(
      width: FontSizes.caption.getSize(context),
      height: FontSizes.caption.getSize(context),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 2,
        vertical: context.verticalSpacing / 4,
      ),
      decoration: BoxDecoration(
        color: color?.withValues(alpha: 0.1) ?? DeepColorTokens.neutral800,
        borderRadius: BorderRadius.circular(context.borderRadius / 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: FontSizes.bodyMedium.getSize(context),
                  fontWeight: FontWeight.bold,
                  color: color ?? DeepColorTokens.neutral800,
                ),
              ),
              if (suffix != null) ...[
                HorizontalGap(width: context.horizontalSpacing / 6),
                Text(
                  suffix!,
                  style: TextStyle(
                    fontSize: FontSizes.caption.getSize(context),
                    color: color ?? DeepColorTokens.neutral600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          VerticalGap(height: context.verticalSpacing / 6),
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.caption.getSize(context),
              color: DeepColorTokens.neutral600,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
