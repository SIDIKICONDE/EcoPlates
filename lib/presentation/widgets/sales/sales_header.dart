import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/sale.dart';
import '../../providers/sales_provider.dart';

/// Header affichant les statistiques importantes pour le commerçant
class SalesHeader extends ConsumerWidget {
  const SalesHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          margin: const EdgeInsets.all(12.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          decoration: BoxDecoration(
            color: DeepColorTokens.primary.withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(16.0),
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
                    color: DeepColorTokens.primary,
                  ),
                  _StatItem(
                    icon: Icons.euro,
                    value: '${totalRevenue.toStringAsFixed(0)}€',
                    label: 'CA\n$periodLabel',
                    color: DeepColorTokens.success,
                  ),
                  _StatItem(
                    icon: Icons.hourglass_empty,
                    value: pendingSales.toString(),
                    label: 'En attente',
                    color: DeepColorTokens.warning,
                    isHighlight: pendingSales > 0,
                  ),
                ],
              ),

              // Ligne secondaire compacte pour économies et filtres
              if (todaySavings > 0 ||
                  filters.status != null ||
                  filters.searchQuery.isNotEmpty) ...[
                SizedBox(height: context.verticalSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Économies compactes
                    if (todaySavings > 0)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.horizontalSpacing / 2,
                            vertical: context.verticalSpacing / 3,
                          ),
                          decoration: BoxDecoration(
                            color: DeepColorTokens.success.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(
                              context.borderRadius,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: context.horizontalSpacing / 3),
                              Flexible(
                                child: Text(
                                  '${totalSavings.toStringAsFixed(0)}€ économisés',
                                  style: TextStyle(
                                    fontSize: FontSizes.bodySmall.getSize(
                                      context,
                                    ),
                                    color: DeepColorTokens.success,
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
                          horizontal: 6.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: DeepColorTokens.neutral300.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(
                            context.borderRadius,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: context.horizontalSpacing / 3),
                            Text(
                              'Filtres',
                              style: TextStyle(
                                fontSize: FontSizes.bodySmall.getSize(context),
                                color: DeepColorTokens.neutral600,
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
      height: context.buttonHeight * 2,
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing,
        vertical: context.verticalSpacing,
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
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

    return Container(
      padding: isHighlight
          ? const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            )
          : null,
      decoration: BoxDecoration(
        color: isHighlight ? color.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(context.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: ResponsiveUtils.getIconSize(context)),
          SizedBox(height: context.verticalSpacing / 3),
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizes.titleMedium.getSize(context),
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.neutral900,
            ),
          ),
          SizedBox(height: context.verticalSpacing / 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSizes.caption.getSize(context),
              color: DeepColorTokens.neutral600,
            ),
          ),
        ],
      ),
    );
  }
}
