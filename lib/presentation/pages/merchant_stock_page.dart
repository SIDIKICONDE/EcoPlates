import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/adaptive_widgets.dart';
import '../providers/stock_items_provider.dart';
import '../widgets/stock/stock_filter_chips.dart';
import '../widgets/stock/stock_list_view.dart';
import '../widgets/stock/stock_category_floating_menu.dart';

import '../../domain/repositories/stock_repository.dart';
import '../widgets/stock/stock_search_bar.dart';
import 'stock_item_form/page.dart';

/// Page principale de gestion de stock pour les marchands
///
/// Affiche la liste des articles avec possibilité de :
/// - Rechercher par nom ou SKU
/// - Filtrer par statut (actif/inactif)
/// - Ajuster les quantités
/// - Basculer le statut des articles
class MerchantStockPage extends ConsumerWidget {
  const MerchantStockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stockCount = ref.watch(stockItemsCountProvider);
    final outOfStockCount = ref.watch(outOfStockItemsProvider).length;

    return AdaptiveScaffold(
      appBar: _buildAppBar(context, ref, theme, stockCount, outOfStockCount),
      body: Column(
        children: [
          // En-tête avec recherche et filtres
          _buildHeader(),

          // Liste des articles
          Expanded(
            child: StockListView(
              onItemTap: (item) => _showItemDetails(context, item),
            ),
          ),
        ],
      ),
      floatingActionButton: const StockCategoryFloatingMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    int stockCount,
    int outOfStockCount,
  ) {
    return AdaptiveAppBar(
      leading: _buildMerchantLogo(theme),
      title: const Text('Stock'),
      actions: [
        // Bouton d'ajout d'article
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Ajouter',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const StockItemFormPage(),
              ),
            );
          },
        ),

        // Badges d'information
        if (stockCount > 0)
          _buildStockBadge(theme, stockCount, outOfStockCount),

        const SizedBox(width: 8),

        // Menu d'actions
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(context, ref, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Actualiser'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'sort',
              child: ListTile(
                leading: Icon(Icons.sort),
                title: Text('Trier'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: Icon(Icons.download),
                title: Text('Exporter'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStockBadge(
    ThemeData theme,
    int stockCount,
    int outOfStockCount,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stockCount.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),

          if (outOfStockCount > 0) ...[
            const SizedBox(width: 4),
            Container(
              width: 4,
              height: 4,
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: const Column(
        children: [
          // Barre de recherche
          StockSearchBar(),

          SizedBox(height: 16),

          // Chips de filtrage
          Align(alignment: Alignment.centerLeft, child: StockFilterChips()),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'refresh':
        // L'actualisation est gérée par le pull-to-refresh dans StockListView
        break;
      case 'sort':
        _showSortSheet(context, ref);
      case 'export':
        // À venir
        break;
    }
  }

  Future<void> _showSortSheet(BuildContext context, WidgetRef ref) async {
    final current = ref.read(stockFiltersProvider);

    final selected = await showModalBottomSheet<StockSortOption>(
      context: context,
      builder: (ctx) {
        const options = StockSortOption.values;
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(title: Text('Trier par')),
              ...options.map(
                (opt) => ListTile(
                  title: Text(opt.label),
                  leading: Icon(
                    opt == current.sortBy
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: opt == current.sortBy
                        ? Theme.of(ctx).colorScheme.primary
                        : null,
                  ),
                  onTap: () => Navigator.of(ctx).pop(opt),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null && selected != current.sortBy) {
      // Mettre à jour filtre
      final notifier = ref.read(stockFiltersProvider.notifier);
      notifier.state = current.copyWith(sortBy: selected);

      // Persister
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('stock_sort_option', selected.name);

      // Rafraîchir la liste
      await ref.read(stockItemsProvider.notifier).refresh();
    }
  }

  Widget _buildMerchantLogo(ThemeData theme) {
    // Pour cette démo, on utilise le logo du premier marchand
    // En production, ceci devrait venir du profil de l'utilisateur connecté
    const merchantLogoUrl =
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop&crop=center';

    return Container(
      margin: const EdgeInsets.all(8),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: theme.colorScheme.surface,
        backgroundImage: const NetworkImage(merchantLogoUrl),
        onBackgroundImageError: (_, __) {
          // Fallback vers une icône si l'image ne charge pas
        },
        child: const Icon(Icons.store, size: 20, color: Colors.grey),
      ),
    );
  }

  void _showItemDetails(BuildContext context, dynamic item) {
    // TODO: Implémenter la vue détail d'un article
    // Pour l'instant, on affiche juste un snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails de : ${item.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
