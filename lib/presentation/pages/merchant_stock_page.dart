import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/adaptive_widgets.dart';
import '../../domain/entities/stock_item.dart';
import '../widgets/stock/merchant_stock_app_bar.dart';
import '../widgets/stock/stock_category_floating_menu.dart';
import '../widgets/stock/stock_filter_chips.dart';
import '../widgets/stock/stock_list_view.dart';
import '../widgets/stock/stock_search_bar.dart';
import 'stock_item_detail/page.dart';

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
    return AdaptiveScaffold(
      appBar: MerchantStockAppBar(),
      body: const Column(
        children: [
          // En-tête avec recherche et filtres
          _StockHeader(),

          // Liste des articles
          Expanded(child: _StockList()),
        ],
      ),
      floatingActionButton: const StockCategoryFloatingMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// Widget pour l'en-tête de recherche et filtres
class _StockHeader extends StatelessWidget {
  const _StockHeader();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Barre de recherche
            StockSearchBar(),

            SizedBox(height: 16),

            // Chips de filtrage
            Align(alignment: Alignment.centerLeft, child: StockFilterChips()),
          ],
        ),
      ),
    );
  }
}

/// Widget pour la liste des articles de stock
class _StockList extends ConsumerWidget {
  const _StockList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StockListView(onItemTap: (item) => _showItemDetails(context, item));
  }

  void _showItemDetails(BuildContext context, StockItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => StockItemDetailPage(item: item)),
    );
  }
}
