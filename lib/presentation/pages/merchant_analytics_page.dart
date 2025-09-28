import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
import '../../core/widgets/adaptive_widgets.dart';
import '../providers/analytics_provider.dart';
import '../widgets/analytics/analytics_app_bar.dart';
import '../widgets/analytics/analytics_charts_section.dart';
import '../widgets/analytics/analytics_header.dart';
import '../widgets/analytics/analytics_period_filter_chips.dart';

// Méthodes responsives pour les espacements
double _analyticsHorizontalPadding(BuildContext context) =>
    EcoPlatesDesignTokens.spacing.dialogGap(context);
double _analyticsVerticalPadding(BuildContext context) =>
    EcoPlatesDesignTokens.spacing.interfaceGap(context);
const double _kDividerHeight = 1.0;
const double _kDividerThickness = 0.5;
double _dividerIndent(BuildContext context) =>
    EcoPlatesDesignTokens.spacing.dialogGap(context);

/// Widget pour la section des filtres de période avec espacement responsive
class _PeriodFilterSection extends StatelessWidget {
  const _PeriodFilterSection();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _analyticsHorizontalPadding(context),
          vertical: _analyticsVerticalPadding(context),
        ),
        child: const AnalyticsPeriodFilterChips(),
      ),
    );
  }
}

/// Widget pour le séparateur avec espacement responsive
class _DividerSection extends StatelessWidget {
  const _DividerSection();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Divider(
        height: _kDividerHeight,
        thickness: _kDividerThickness,
        indent: _dividerIndent(context),
        endIndent: _dividerIndent(context),
      ),
    );
  }
}

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
    final theme = Theme.of(context);

    return AdaptiveScaffold(
      appBar: const AnalyticsAppBar() as PreferredSizeWidget,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Fond subtil qui reflète les couleurs des cartes KPI
              theme.colorScheme.surface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.analyticsBackground,
              ),
              // Vert subtil (Revenue)
              const Color(
                0xFF4CAF50,
              ).withValues(alpha: EcoPlatesDesignTokens.opacity.verySubtle),
              // Bleu subtil (Orders)
              const Color(
                0xFF2196F3,
              ).withValues(alpha: EcoPlatesDesignTokens.opacity.verySubtle),
              // Orange subtil (Average Order)
              const Color(
                0xFFFF9800,
              ).withValues(alpha: EcoPlatesDesignTokens.opacity.verySubtle),
              // Violet subtil (Conversion)
              const Color(
                0xFF9C27B0,
              ).withValues(alpha: EcoPlatesDesignTokens.opacity.verySubtle),
              theme.colorScheme.surface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.analyticsBackground,
              ),
            ],
            stops: EcoPlatesDesignTokens.layout.analyticsGradientStops,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => ref.refreshAnalytics(),
          child: const CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              // En-tête avec KPIs principaux
              SliverToBoxAdapter(
                child: AnalyticsHeader(),
              ),

              // Filtres par période
              _PeriodFilterSection(),

              // Séparateur
              _DividerSection(),

              // Section des graphiques
              AnalyticsChartsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
