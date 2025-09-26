import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockCount = ref.watch(stockItemsCountProvider);
    final outOfStockCount = ref.watch(outOfStockItemsProvider).length;
    final screenWidth = MediaQuery.of(context).size.width;

    // Pour éviter l'overflow sur petits écrans
    final isSmallScreen = screenWidth < 400;

    return AdaptiveAppBar(
      leading: const _MerchantLogo(),
      title: const Text('Stock'),
      actions: [
        // Switch pour basculer entre les vues (masqué sur très petits écrans)
        if (!isSmallScreen) const _ViewModeSwitch(),

        // Bouton d'ajout d'article
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: 20,
          tooltip: 'Ajouter',
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
          onPressed: () => _navigateToStockItemForm(context),
        ),

        // Badges d'information (masqué sur très petits écrans)
        if (stockCount > 0 && !isSmallScreen)
          _StockBadge(stockCount: stockCount, outOfStockCount: outOfStockCount),

        // Menu d'actions compact
        const _ActionsMenu(),

        const SizedBox(width: 4),
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
      margin: const EdgeInsets.all(8),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundImage: const NetworkImage(merchantLogoUrl),
        onBackgroundImageError: (_, _) {
          // Fallback vers une icône si l'image ne charge pas
        },
        child: const Icon(Icons.store, size: 20, color: Colors.grey),
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
      padding: const EdgeInsets.only(right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompactView ? Icons.view_agenda : Icons.view_list,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stockCount > 999 ? '999+' : stockCount.toString(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),

          if (outOfStockCount > 0) ...[
            const SizedBox(width: 2),
            Container(
              width: 3,
              height: 3,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final stockCount = ref.watch(stockItemsCountProvider);
    final outOfStockCount = ref.watch(outOfStockItemsProvider).length;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      iconSize: 20,
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
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  '$stockCount articles${outOfStockCount > 0 ? ' (• $outOfStockCount ruptures)' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                      size: 18,
                    ),
                    title: Text(
                      isCompactView ? 'Vue détaillée' : 'Vue compacte',
                      style: const TextStyle(fontSize: 14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    dense: true,
                  );
                },
              ),
            ),

          // Séparateur si on a ajouté des éléments
          if (isSmallScreen) const PopupMenuDivider(),

          const PopupMenuItem(
            value: 'refresh',
            child: ListTile(
              leading: Icon(Icons.refresh, size: 18),
              title: Text('Actualiser', style: TextStyle(fontSize: 14)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              dense: true,
            ),
          ),
          const PopupMenuItem(
            value: 'sort',
            child: ListTile(
              leading: Icon(Icons.sort, size: 18),
              title: Text('Trier', style: TextStyle(fontSize: 14)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              dense: true,
            ),
          ),
          const PopupMenuItem(
            value: 'export',
            child: ListTile(
              leading: Icon(Icons.download, size: 18),
              title: Text('Exporter', style: TextStyle(fontSize: 14)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
