import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
import '../../core/widgets/adaptive_widgets.dart';
import '../providers/sales_provider.dart';
import '../widgets/sales/sales_app_bar.dart';
import '../widgets/sales/sales_filter_chips.dart';
import '../widgets/sales/sales_header.dart';
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
            // Header avec statistiques
            SliverToBoxAdapter(
              child: SalesHeader(),
            ),

            // Filtres
            _SalesFiltersSection(),

            // Liste des ventes
            _SalesListSection(),
          ],
        ),
      ),
    );
  }
}

/// Widget pour la section des filtres avec espacement responsive
class _SalesFiltersSection extends StatelessWidget {
  const _SalesFiltersSection();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(
          EcoPlatesDesignTokens.spacing.dialogGap(context),
        ),
        child: const SalesFilterChips(),
      ),
    );
  }
}

/// Widget pour la section de liste des ventes avec espacement responsive
class _SalesListSection extends StatelessWidget {
  const _SalesListSection();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        EcoPlatesDesignTokens.spacing.dialogGap(context),
        0,
        EcoPlatesDesignTokens.spacing.dialogGap(context),
        EcoPlatesDesignTokens.spacing.dialogGap(context),
      ),
      sliver: const SalesListView(),
    );
  }
}
