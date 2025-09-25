import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/adaptive_widgets.dart';
import '../providers/stock_items_provider.dart';
import '../widgets/stock/stock_filter_chips.dart';
import '../widgets/stock/stock_list_view.dart';
import '../widgets/stock/stock_search_bar.dart';
import 'add_stock_item_page.dart';

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
      appBar: _buildAppBar(context, theme, stockCount, outOfStockCount),
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
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    int stockCount,
    int outOfStockCount,
  ) {
    return AdaptiveAppBar(
      title: const Text('Stock'),
      centerTitle: true,
      actions: [
        // Bouton d'ajout d'article
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Ajouter',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddStockItemPage(),
              ),
            );
          },
        ),

        // Badges d'information
        if (stockCount > 0)
          _buildStockBadge(theme, stockCount, outOfStockCount),
        
        const SizedBox(width: 8),
        
        // Menu d'actions (futur)
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(value),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
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
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 0.5,
          ),
        ),
      ),
      child: const Column(
        children: [
          // Barre de recherche
          StockSearchBar(),
          
          SizedBox(height: 16),
          
          // Chips de filtrage
          Align(
            alignment: Alignment.centerLeft,
            child: StockFilterChips(),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    // TODO: Implémenter les actions du menu
    switch (action) {
      case 'refresh':
        // L'actualisation est gérée par le pull-to-refresh dans StockListView
        break;
      case 'sort':
        // TODO: Afficher un modal de tri
        break;
      case 'export':
        // TODO: Implémenter l'export des données
        break;
    }
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