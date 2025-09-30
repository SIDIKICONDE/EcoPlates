import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final isSmallScreen = MediaQuery.of(context).size.width < 768;

    return AdaptiveAppBar(
      leading: const _MerchantLogo(),
      title: const Text('Stock'),
      actions: [
        // Switch pour basculer entre les vues (masqué sur très petits écrans)
        if (!isSmallScreen) const _ViewModeSwitch(),

        // Bouton d'ajout d'article
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: 20.0,
          tooltip: 'Ajouter',
          padding: EdgeInsets.all(12.0),
          constraints: const BoxConstraints(),
          onPressed: () => _navigateToStockItemForm(context),
        ),

        // Badges d'information (masqué sur très petits écrans)
        if (stockCount > 0 && !isSmallScreen)
          _StockBadge(stockCount: stockCount, outOfStockCount: outOfStockCount),

        // Menu d'actions compact
        const _ActionsMenu(),

        SizedBox(width: 4.0),
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
      margin: EdgeInsets.all(12.0),
      child: CircleAvatar(
        radius: 8.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundImage: const NetworkImage(merchantLogoUrl),
        onBackgroundImageError: (_, _) {
          // Fallback vers une icône si l'image ne charge pas
        },
        child: Icon(
          Icons.store,
          size: 20.0,
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
    final theme = Theme.of(context);
    final isCompactView = ref.watch(stockViewModeProvider);

    return Padding(
      padding: EdgeInsets.only(right: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompactView ? Icons.view_agenda : Icons.view_list,
            size: 20.0,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 4.0),
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
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 4.0,
      ),
      margin: EdgeInsets.only(right: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stockCount > 999 ? '999+' : stockCount.toString(),
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),

          if (outOfStockCount > 0) ...[
            SizedBox(width: 4.0),
            Container(
              width: 4.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
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
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    final stockCount = ref.watch(stockItemsCountProvider);
    final outOfStockCount = ref.watch(outOfStockItemsProvider).length;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      iconSize: 20.0,
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
                  size: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  '$stockCount articles${outOfStockCount > 0 ? ' (• $outOfStockCount ruptures)' : ''}',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.0,
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
                      size: 20.0,
                    ),
                    title: Text(
                      isCompactView ? 'Vue détaillée' : 'Vue compacte',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
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
                size: 20.0,
              ),
              title: Text(
                'Actualiser',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              dense: true,
            ),
          ),
          PopupMenuItem(
            value: 'sort',
            child: ListTile(
              leading: Icon(
                Icons.sort,
                size: 20.0,
              ),
              title: Text(
                'Trier',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              dense: true,
            ),
          ),
          PopupMenuItem(
            value: 'export',
            child: ListTile(
              leading: Icon(
                Icons.download,
                size: 20.0,
              ),
              title: Text(
                'Exporter',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.0,
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
