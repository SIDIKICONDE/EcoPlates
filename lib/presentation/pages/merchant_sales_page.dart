import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/adaptive_widgets.dart';
import '../providers/sales_provider.dart';
import '../widgets/sales/sales_app_bar.dart';
import '../widgets/sales/sales_filter_chips.dart';
import '../widgets/sales/sales_list_view.dart';
import '../widgets/sales/sales_stats_card.dart';
import '../widgets/sales/sales_summary_card.dart';

/// Page principale de gestion des ventes pour les marchands
///
/// Affiche :
/// - Les statistiques de ventes
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
            // En-tête avec statistiques
            SliverToBoxAdapter(
              child: _SalesHeader(),
            ),
            
            // Filtres
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SalesFilterChips(),
              ),
            ),
            
            // Liste des ventes
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SalesListView(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour l'en-tête avec les statistiques
class _SalesHeader extends ConsumerWidget {
  const _SalesHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Carte de résumé principal
        const Padding(
          padding: EdgeInsets.all(16),
          child: SalesSummaryCard(),
        ),
        
        // Cartes de statistiques
        Container(
          height: 120,
          padding: const EdgeInsets.only(bottom: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              SalesStatsCard(
                title: 'Ventes du jour',
                value: '12',
                subtitle: '+15% vs hier',
                icon: Icons.today,
                color: Colors.blue,
              ),
              SizedBox(width: 12),
              SalesStatsCard(
                title: 'CA du jour',
                value: '156€',
                subtitle: '+22% vs hier',
                icon: Icons.euro,
                color: Colors.green,
              ),
              SizedBox(width: 12),
              SalesStatsCard(
                title: 'Panier moyen',
                value: '13€',
                subtitle: '+5% vs mois',
                icon: Icons.shopping_basket,
                color: Colors.orange,
              ),
              SizedBox(width: 12),
              SalesStatsCard(
                title: 'Taux conversion',
                value: '68%',
                subtitle: 'Stable',
                icon: Icons.trending_up,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }
}