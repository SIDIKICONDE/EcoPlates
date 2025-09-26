import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/sale.dart';
import '../../providers/sales_provider.dart';

/// Header affichant les statistiques importantes pour le commerçant
class SalesHeader extends ConsumerWidget {
  const SalesHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final salesAsync = ref.watch(salesProvider);
    final filters = ref.watch(salesFilterProvider);

    return salesAsync.when(
      data: (sales) {
        final now = DateTime.now();

        // Les 'sales' sont déjà filtrées par le provider selon les critères actifs

        // Ventes du jour (parmi les ventes filtrées)
        final todaySales = sales
            .where(
              (s) =>
                  s.createdAt.day == now.day &&
                  s.createdAt.month == now.month &&
                  s.createdAt.year == now.year,
            )
            .toList();

        // Ventes en attente (parmi les ventes filtrées)
        final pendingSales = sales
            .where((s) => s.status == SaleStatus.pending)
            .length;

        // CA total des ventes filtrées
        final totalRevenue = sales.fold(
          0.0,
          (sum, sale) => sum + sale.finalAmount,
        );

        // Économies totales sur les ventes filtrées
        final totalSavings = sales.fold(
          0.0,
          (sum, sale) => sum + sale.discountAmount,
        );

        // Économies du jour
        final todaySavings = todaySales.fold(
          0.0,
          (sum, sale) => sum + sale.discountAmount,
        );

        // Calcul du libellé de la période affichée
        final periodLabel = _getPeriodLabel(filters);

        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ligne principale avec stats importantes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    icon: Icons.shopping_cart,
                    value: sales.length.toString(),
                    label: 'Commandes\n$periodLabel',
                    color: theme.colorScheme.primary,
                  ),
                  _StatItem(
                    icon: Icons.euro,
                    value: '${totalRevenue.toStringAsFixed(0)}€',
                    label: 'CA\n$periodLabel',
                    color: Colors.green,
                  ),
                  _StatItem(
                    icon: Icons.hourglass_empty,
                    value: pendingSales.toString(),
                    label: 'En attente',
                    color: Colors.orange,
                    isHighlight: pendingSales > 0,
                  ),
                ],
              ),

              // Ligne secondaire compacte pour économies et filtres
              if (todaySavings > 0 ||
                  filters.status != null ||
                  filters.searchQuery.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Économies compactes
                    if (todaySavings > 0)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.eco,
                                size: 12,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${totalSavings.toStringAsFixed(0)}€ économisés',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Indicateur de filtre compact
                    if (filters.status != null ||
                        filters.searchQuery.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_alt,
                              size: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Filtres',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
      loading: () => _buildShimmer(context),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  String _getPeriodLabel(SalesFilterState filters) {
    switch (filters.period) {
      case SalesPeriodFilter.today:
        return "aujourd'hui";
      case SalesPeriodFilter.week:
        return 'cette semaine';
      case SalesPeriodFilter.month:
        return 'ce mois';
      case SalesPeriodFilter.custom:
        return 'période sélectionnée';
    }
  }
}

/// Widget pour afficher une statistique
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isHighlight = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: isHighlight
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : null,
      decoration: isHighlight
          ? BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
