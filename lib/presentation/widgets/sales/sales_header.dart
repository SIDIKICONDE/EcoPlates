import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
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
          margin: EdgeInsets.all(context.scaleSM_MD_LG_XL),
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleMD_LG_XL_XXL,
            vertical: context.scaleXS_SM_MD_LG,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(
              alpha: DesignConstants.opacityVeryTransparent,
            ),
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.lg,
            ),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(
                alpha: DesignConstants.opacitySubtle,
              ),
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
                SizedBox(height: context.scaleSM_MD_LG_XL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Économies compactes
                    if (todaySavings > 0)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleSM_MD_LG_XL,
                            vertical: context.scaleXXS_XS_SM_MD,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(
                              alpha: DesignConstants.opacityVeryTransparent,
                            ),
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.md,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.eco,
                                size: context.scaleXXS_XS_SM_MD,
                                color: Colors.green,
                              ),
                              SizedBox(width: context.scaleXXS_XS_SM_MD),
                              Flexible(
                                child: Text(
                                  '${totalSavings.toStringAsFixed(0)}€ économisés',
                                  style: TextStyle(
                                    fontSize: EcoPlatesDesignTokens.typography
                                        .hint(context),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scaleXXS_XS_SM_MD,
                          vertical: context.scaleXXS_XS_SM_MD,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outlineVariant.withValues(
                            alpha: DesignConstants.opacitySubtle,
                          ),
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.xs,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_alt,
                              size: context.scaleXXS_XS_SM_MD,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: context.scaleXXS_XS_SM_MD),
                            Text(
                              'Filtres',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: EcoPlatesDesignTokens.typography.hint(
                                  context,
                                ),
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
      height: context.applyPattern([70.0, 80.0, 90.0, 100.0]),
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleMD_LG_XL_XXL,
        vertical: context.scaleXS_SM_MD_LG,
      ),
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
          ? EdgeInsets.symmetric(
              horizontal: context.scaleSM_MD_LG_XL,
              vertical: context.scaleXXS_XS_SM_MD,
            )
          : null,
      decoration: isHighlight
          ? BoxDecoration(
              color: color.withValues(
                alpha: DesignConstants.opacityVeryTransparent,
              ),
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.xs,
              ),
              border: Border.all(
                color: color.withValues(alpha: DesignConstants.opacitySubtle),
              ),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: context.scaleIconStandard),
          SizedBox(height: context.scaleXXS_XS_SM_MD),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: EcoPlatesDesignTokens.typography.modalTitle(context),
            ),
          ),
          SizedBox(height: context.scaleXXS_XS_SM_MD),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
            ),
          ),
        ],
      ),
    );
  }
}
