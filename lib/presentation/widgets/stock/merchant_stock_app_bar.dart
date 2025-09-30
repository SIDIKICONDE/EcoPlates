import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../core/widgets/adaptive_widgets.dart';
import '../../controllers/merchant_stock_controller.dart';
import '../../pages/stock_item_form/page.dart';
import '../../providers/stock_items_provider.dart';

/// Barre d'app bar pour la page de gestion de stock des marchands
///
/// Gère l'affichage du titre, du logo marchand, du switch de vue,
/// des badges d'information et du menu d'actions.
class MerchantStockAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const MerchantStockAppBar({super.key});

  @override
  ui.Size get preferredSize => ui.Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockCount = ref.watch(stockItemsCountProvider);
    final outOfStockCount = ref.watch(outOfStockItemsProvider).length;

    // Utiliser le système de breakpoints EcoPlates
    final isSmallScreen = context.isMobile;

    return AdaptiveAppBar(
      leading: const _MerchantLogo(),
      title: const Text('Stock'),
      actions: [
        // Switch pour basculer entre les vues (masqué sur très petits écrans)
        if (!isSmallScreen) const _ViewModeSwitch(),

        // Bouton d'ajout d'article
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: ResponsiveUtils.getIconSize(context),
          tooltip: 'Ajouter',
          padding: EdgeInsets.all(
            ResponsiveUtils.getHorizontalSpacing(context) * 0.5,
          ),
          constraints: const BoxConstraints(),
          onPressed: () => _navigateToStockItemForm(context),
        ),

        // Badges d'information (masqué sur très petits écrans)
        if (stockCount > 0 && !isSmallScreen)
          _StockBadge(stockCount: stockCount, outOfStockCount: outOfStockCount),

        // Menu d'actions compact
        const _ActionsMenu(),

        SizedBox(width: ResponsiveUtils.getHorizontalSpacing(context) * 0.15),
      ],
    );
  }

  void _navigateToStockItemForm(BuildContext context) {
    unawaited(
      Navigator.of(
        context,
      ).push(
        MaterialPageRoute<void>(builder: (_) => const StockItemFormPage()),
      ),
    );
  }
}

/// Logo du marchand dans la barre d'app bar
class _MerchantLogo extends StatelessWidget {
  const _MerchantLogo();

  @override
  Widget build(BuildContext context) {
    const merchantLogoUrl =
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop&crop=center';

    return Container(
      margin: EdgeInsets.all(
        ResponsiveUtils.getHorizontalSpacing(context) * 0.5,
      ),
      child: CircleAvatar(
        radius: ResponsiveUtils.getIconSize(context) * 0.4,
        backgroundColor: DeepColorTokens.neutral0,
        backgroundImage: const NetworkImage(merchantLogoUrl),
        onBackgroundImageError: (_, _) {
          // Fallback vers une icône si l'image ne charge pas
        },
        child: Icon(
          Icons.store,
          size: ResponsiveUtils.getIconSize(context),
          color: DeepColorTokens.neutral600,
        ),
      ),
    );
  }
}

/// Switch pour basculer entre les modes de vue liste/détaillé
class _ViewModeSwitch extends ConsumerWidget {
  const _ViewModeSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompactView = ref.watch(stockViewModeProvider);

    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveUtils.getHorizontalSpacing(context) * 0.15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompactView ? Icons.view_agenda : Icons.view_list,
            size: ResponsiveUtils.getIconSize(context),
            color: DeepColorTokens.neutral700,
          ),
          SizedBox(width: ResponsiveUtils.getHorizontalSpacing(context) * 0.15),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isCompactView,
              onChanged: (value) {
                ref
                    .read(stockViewModeProvider.notifier)
                    .setCompact(isCompact: value);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge compact affichant le nombre d'articles en stock et les articles en rupture
class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stockCount, required this.outOfStockCount});

  final int stockCount;
  final int outOfStockCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getHorizontalSpacing(context) * 0.15,
        vertical: ResponsiveUtils.getVerticalSpacing(context) * 0.15,
      ),
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getHorizontalSpacing(context) * 0.15,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.secondaryContainer,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stockCount > 999 ? '999+' : stockCount.toString(),
            style: TextStyle(
              fontSize: FontSizes.buttonSmall.getSize(context),
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.onSecondaryContainer,
            ),
          ),

          if (outOfStockCount > 0) ...[
            SizedBox(
              width: ResponsiveUtils.getHorizontalSpacing(context) * 0.15,
            ),
            Container(
              width: ResponsiveUtils.getHorizontalSpacing(context) * 0.15,
              height: ResponsiveUtils.getVerticalSpacing(context) * 0.15,
              decoration: BoxDecoration(
                color: DeepColorTokens.error,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Menu d'actions compact (actualiser, trier, exporter)
class _ActionsMenu extends ConsumerWidget {
  const _ActionsMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSmallScreen = context.isMobile;
    final stockCount = ref.watch(stockItemsCountProvider);
    final outOfStockCount = ref.watch(outOfStockItemsProvider).length;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      iconSize: ResponsiveUtils.getIconSize(context),
      tooltip: 'Actions',
      onSelected: (value) => _handleMenuAction(context, ref, value),
      itemBuilder: (context) {
        return [
          // Affichage des statistiques sur petits écrans
          if (isSmallScreen && stockCount > 0)
            PopupMenuItem(
              enabled: false,
              child: ListTile(
                leading: Icon(
                  Icons.inventory,
                  size: ResponsiveUtils.getIconSize(context),
                  color: DeepColorTokens.primary,
                ),
                title: Text(
                  '$stockCount articles${outOfStockCount > 0 ? ' (• $outOfStockCount ruptures)' : ''}',
                  style: TextStyle(
                    fontSize: FontSizes.label.getSize(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal:
                      ResponsiveUtils.getHorizontalSpacing(context) * 0.5,
                ),
                dense: true,
              ),
            ),

          // Switch de vue sur petits écrans
          if (isSmallScreen)
            PopupMenuItem(
              value: 'toggle_view',
              child: Consumer(
                builder: (context, ref, _) {
                  final isCompactView = ref.watch(stockViewModeProvider);
                  return ListTile(
                    leading: Icon(
                      isCompactView ? Icons.view_agenda : Icons.view_list,
                      size: ResponsiveUtils.getIconSize(context),
                    ),
                    title: Text(
                      isCompactView ? 'Vue détaillée' : 'Vue compacte',
                      style: TextStyle(
                        fontSize: FontSizes.buttonMedium.getSize(context),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal:
                          ResponsiveUtils.getHorizontalSpacing(context) * 0.5,
                    ),
                    dense: true,
                  );
                },
              ),
            ),

          // Séparateur si on a ajouté des éléments
          if (isSmallScreen) const PopupMenuDivider(),

          PopupMenuItem(
            value: 'refresh',
            child: ListTile(
              leading: Icon(
                Icons.refresh,
                size: ResponsiveUtils.getIconSize(context),
              ),
              title: Text(
                'Actualiser',
                style: TextStyle(
                  fontSize: FontSizes.buttonMedium.getSize(context),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(context) * 0.5,
              ),
              dense: true,
            ),
          ),
          PopupMenuItem(
            value: 'sort',
            child: ListTile(
              leading: Icon(
                Icons.sort,
                size: ResponsiveUtils.getIconSize(context),
              ),
              title: Text(
                'Trier',
                style: TextStyle(
                  fontSize: FontSizes.buttonMedium.getSize(context),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(context) * 0.5,
              ),
              dense: true,
            ),
          ),
          PopupMenuItem(
            value: 'export',
            child: ListTile(
              leading: Icon(
                Icons.download,
                size: ResponsiveUtils.getIconSize(context),
              ),
              title: Text(
                'Exporter',
                style: TextStyle(
                  fontSize: FontSizes.buttonMedium.getSize(context),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(context) * 0.5,
              ),
              dense: true,
            ),
          ),
        ];
      },
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    if (action == 'toggle_view') {
      // Basculer le mode de vue
      final currentMode = ref.read(stockViewModeProvider);
      ref
          .read(stockViewModeProvider.notifier)
          .setCompact(isCompact: !currentMode);
    } else {
      ref
          .read(merchantStockControllerProvider)
          .handleMenuAction(context, ref, action);
    }
  }
}
