import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/adaptive_widgets.dart';
import '../providers/analytics_provider.dart';
import '../widgets/analytics/analytics_app_bar.dart';
import '../widgets/analytics/analytics_charts_section.dart';
import '../widgets/analytics/analytics_header.dart';
import '../widgets/analytics/analytics_period_filter_chips.dart';

/// Page principale d'analyse pour les commerçants
/// 
/// Affiche un dashboard complet avec :
/// - KPIs principaux (chiffre d'affaires, commandes, panier moyen)
/// - Filtres par période (jour, semaine, mois, année)  
/// - Graphiques d'évolution (revenus, ventes)
/// - Top produits et répartition par catégories
/// - Comparaison avec la période précédente
class MerchantAnalyticsPage extends ConsumerWidget {
  const MerchantAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      appBar: const AnalyticsAppBar(),
      body: RefreshIndicator(
        onRefresh: () => ref.refreshAnalytics(),
        child: const CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            // En-tête avec KPIs principaux
            SliverToBoxAdapter(
              child: AnalyticsHeader(),
            ),
            
            // Filtres par période
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AnalyticsPeriodFilterChips(),
              ),
            ),
            
            // Séparateur
            SliverToBoxAdapter(
              child: Divider(
                height: 1,
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
              ),
            ),
            
            // Section des graphiques
            AnalyticsChartsSection(),
          ],
        ),
      ),
    );
  }
}