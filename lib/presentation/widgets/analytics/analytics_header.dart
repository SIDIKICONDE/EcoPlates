import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/analytics_stats.dart';
import '../../providers/analytics_provider.dart';

/// Header de la page d'analytics avec les KPIs principaux
///
/// Affiche 4 cartes avec les métriques principales :
/// - Chiffre d'affaires total
/// - Nombre de commandes
/// - Panier moyen
/// - Taux de conversion
///
/// Chaque carte montre l'évolution par rapport à la période précédente
class AnalyticsHeader extends ConsumerWidget {
  const AnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsStatsProvider);

    return analyticsAsync.when(
      data: (analytics) => _buildHeader(context, analytics),
      loading: () => _buildLoadingHeader(context),
      error: (error, stack) => _buildErrorHeader(context, ref),
    );
  }

  Widget _buildHeader(BuildContext context, AnalyticsStats analytics) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 768;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec période
          Row(
            children: [
              Text(
                'Performances',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Chip(
                label: Text(
                  analytics.period.label,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Grille des KPIs
          if (isWide) _buildWideLayout(context, analytics) else _buildCompactLayout(context, analytics),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, AnalyticsStats analytics) {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            context,
            "Chiffre d'affaires",
            _formatCurrency(analytics.totalRevenue),
            Icons.euro,
            analytics.previousPeriodComparison?.revenueGrowth,
            analytics.previousPeriodComparison?.isPositiveRevenue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            context,
            'Commandes',
            analytics.totalOrders.toString(),
            Icons.shopping_bag,
            analytics.previousPeriodComparison?.ordersGrowth,
            analytics.previousPeriodComparison?.isPositiveOrders,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            context,
            'Panier moyen',
            _formatCurrency(analytics.averageOrderValue),
            Icons.shopping_cart,
            analytics.previousPeriodComparison?.averageOrderGrowth,
            analytics.previousPeriodComparison?.isPositiveAverageOrder,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            context,
            'Taux conversion',
            '${analytics.conversionRate.toStringAsFixed(1)}%',
            Icons.trending_up,
            analytics.previousPeriodComparison?.conversionRateGrowth,
            analytics.previousPeriodComparison?.isPositiveConversion,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, AnalyticsStats analytics) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                context,
                'CA',
                _formatCurrency(analytics.totalRevenue),
                Icons.euro,
                analytics.previousPeriodComparison?.revenueGrowth,
                analytics.previousPeriodComparison?.isPositiveRevenue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKpiCard(
                context,
                'Commandes',
                analytics.totalOrders.toString(),
                Icons.shopping_bag,
                analytics.previousPeriodComparison?.ordersGrowth,
                analytics.previousPeriodComparison?.isPositiveOrders,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                context,
                'Panier moy.',
                _formatCurrency(analytics.averageOrderValue),
                Icons.shopping_cart,
                analytics.previousPeriodComparison?.averageOrderGrowth,
                analytics.previousPeriodComparison?.isPositiveAverageOrder,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKpiCard(
                context,
                'Conv.',
                '${analytics.conversionRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                analytics.previousPeriodComparison?.conversionRateGrowth,
                analytics.previousPeriodComparison?.isPositiveConversion,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    double? growthPercentage,
    bool? isPositiveGrowth,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            if (growthPercentage != null && isPositiveGrowth != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isPositiveGrowth ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: isPositiveGrowth ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${growthPercentage.abs().toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isPositiveGrowth ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton du titre
          Container(
            height: 28,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 16),

          // Skeleton des cartes KPI
          Row(
            children: List.generate(
              2,
              (index) => Expanded(
                child: Card(
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 24,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: List.generate(
              2,
              (index) => Expanded(
                child: Card(
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 24,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Impossible de charger les données analytiques',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.refreshAnalytics(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
      decimalDigits: amount % 1 == 0 ? 0 : 2,
    );
    return formatter.format(amount);
  }
}
