import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/themes/tokens/deep_color_tokens.dart';
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
      appBar: const AnalyticsAppBar() as PreferredSizeWidget,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Fond subtil qui reflète les couleurs des cartes KPI
              DeepColorTokens.surface.withValues(alpha: 0.1),
              DeepColorTokens.primary.withValues(alpha: 0.1),
              DeepColorTokens.secondary.withValues(alpha: 0.1),
              DeepColorTokens.tertiary.withValues(alpha: 0.1),
              DeepColorTokens.accent.withValues(alpha: 0.1),
            ],
            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.refreshAnalytics();
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: const [
              // En-tête avec KPIs principaux
              SliverToBoxAdapter(
                child: AnalyticsHeader(),
              ),

              // Section des filtres de période
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnalyticsPeriodFilterChips(),
                ),
              ),

              // Section des graphiques
              AnalyticsChartsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
