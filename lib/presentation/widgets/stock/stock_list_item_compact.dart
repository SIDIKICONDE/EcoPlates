import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/stock_item.dart';
import '../../pages/stock_item_form/page.dart';
import '../../providers/stock_items_provider.dart';
import '../offer_card/offer_card_configs.dart';
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
    // Utiliser la configuration responsive d'OfferCardConfigs selon le contexte
    final config = _getResponsiveConfig(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: dense
            ? ResponsiveUtils.getHorizontalSpacing(context) / 2
            : ResponsiveUtils.getHorizontalSpacing(context),
        vertical: dense
            ? ResponsiveUtils.getVerticalSpacing(context) / 4
            : ResponsiveUtils.getVerticalSpacing(context) / 2,
      ),
      child: Material(
        color: DeepColorTokens.surface,
        borderRadius:
            config.imageBorderRadius ??
            BorderRadius.circular(
              dense
                  ? ResponsiveUtils.getVerticalSpacing(context)
                  : ResponsiveUtils.getVerticalSpacing(context) * 1.5,
            ),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              config.imageBorderRadius ??
              BorderRadius.circular(
                dense
                    ? ResponsiveUtils.getVerticalSpacing(context)
                    : ResponsiveUtils.getVerticalSpacing(context) * 1.5,
              ),
          child: Padding(
            padding: EdgeInsets.all(
              dense
                  ? ResponsiveUtils.getVerticalSpacing(context)
                  : ResponsiveUtils.getVerticalSpacing(context) * 1.5,
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
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  dense ? 14.0 : 16.0,
                                ),
                                fontWeight: FontWeight.w500,
                                color: DeepColorTokens.neutral0,
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
                        height: dense
                            ? ResponsiveUtils.getVerticalSpacing(context) / 4
                            : ResponsiveUtils.getVerticalSpacing(context) / 2,
                      ),
                      // Prix et catégorie
                      Row(
                        children: [
                          Text(
                            item.formattedPrice,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                dense ? 14.0 : 16.0,
                              ),
                              fontWeight: FontWeight.w600,
                              color: DeepColorTokens.primary,
                            ),
                          ),
                          Text(
                            ' / ${item.unit}',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                dense ? 12.0 : 14.0,
                              ),
                              color: DeepColorTokens.neutral600,
                            ),
                          ),
                          SizedBox(
                            width: dense
                                ? ResponsiveUtils.getHorizontalSpacing(
                                        context,
                                      ) /
                                      4
                                : ResponsiveUtils.getHorizontalSpacing(
                                        context,
                                      ) /
                                      2,
                          ),
                          Container(
                            width: ResponsiveUtils.getIconSize(
                              context,
                              baseSize: 4.0,
                            ),
                            height: ResponsiveUtils.getIconSize(
                              context,
                              baseSize: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: DeepColorTokens.neutral600.withValues(
                                alpha: 0.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: dense
                                ? ResponsiveUtils.getHorizontalSpacing(
                                        context,
                                      ) /
                                      4
                                : ResponsiveUtils.getHorizontalSpacing(
                                        context,
                                      ) /
                                      2,
                          ),
                          Expanded(
                            child: Text(
                              item.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  dense ? 12.0 : 14.0,
                                ),
                                color: DeepColorTokens.neutral600,
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
                      width: ResponsiveUtils.getIconSize(
                        context,
                        baseSize: 8.0,
                      ),
                      height: ResponsiveUtils.getIconSize(
                        context,
                        baseSize: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: item.status == StockItemStatus.active
                            ? DeepColorTokens.success
                            : DeepColorTokens.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getHorizontalSpacing(context) / 4,
                    ),
                    // Menu action
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: DeepColorTokens.neutral600,
                        size: ResponsiveUtils.getIconSize(
                          context,
                          baseSize: 20.0,
                        ),
                      ),
                      onSelected: (value) =>
                          _handleMenuAction(context, ref, value),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(
                              Icons.edit,
                              size: ResponsiveUtils.getIconSize(
                                context,
                                baseSize: 20.0,
                              ),
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
                              size: ResponsiveUtils.getIconSize(
                                context,
                                baseSize: 20.0,
                              ),
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

  /// Obtient la configuration responsive appropriée selon le contexte
  OfferCardPageConfig _getResponsiveConfig(BuildContext context) {
    // Utiliser la configuration par défaut d'OfferCardConfigs
    // qui applique déjà la responsivité via ResponsiveUtils.responsiveValue
    return OfferCardConfigs.defaultConfig;
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
            backgroundColor: DeepColorTokens.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
