import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/adaptive_widgets.dart';
import '../providers/sales_provider.dart';
import '../widgets/sales/sales_app_bar.dart';
import '../widgets/sales/sales_filter_chips.dart';
import '../widgets/sales/sales_list_view.dart';

/// Page principale de gestion des ventes pour les marchands
///
/// Affiche :
/// - La liste des ventes/commandes
/// - Les filtres par période et statut
class MerchantSalesPage extends ConsumerWidget {
  const MerchantSalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      appBar: const SalesAppBar(),
      body: RefreshIndicator(
        onRefresh: () => ref.read(salesProvider.notifier).refresh(),
        child: const CustomScrollView(
          slivers: [
            // Filtres
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SalesFilterChips(),
              ),
            ),
            
            // Liste des ventes
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SalesListView(),
            ),
          ],
        ),
      ),
    );
  }
}
