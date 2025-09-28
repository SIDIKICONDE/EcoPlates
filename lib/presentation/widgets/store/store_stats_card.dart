import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../providers/store_offers_provider.dart';

/// Carte affichant les statistiques rapides de la boutique
class StoreStatsCard extends ConsumerWidget {
  const StoreStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stats = ref.watch(storeStatsProvider);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.scaleMD_LG_XL_XXL,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(
              alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
        child: Column(
          children: [
            // Titre
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                SizedBox(width: context.scaleXXS_XS_SM_MD),
                Text(
                  "Vue d'ensemble",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "Aujourd'hui",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.scaleXXS_XS_SM_MD),

            // Statistiques principales
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.restaurant_menu,
                    label: 'Actives',
                    value: stats.activeOffers.toString(),
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.local_offer,
                    label: 'Promos',
                    value: stats.promotionsCount.toString(),
                    color: theme.colorScheme.error,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.euro,
                    label: 'Revenus',
                    value: '${stats.potentialRevenue.toStringAsFixed(0)}€',
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),

            if (stats.lowStockCount > 0) ...[
              SizedBox(height: context.scaleXXS_XS_SM_MD),
              // Alerte stock faible
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleXXS_XS_SM_MD,
                  vertical: context.scaleXXS_XS_SM_MD / 2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xs,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      size: EcoPlatesDesignTokens.size.indicator(context),
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
                    Text(
                      '${stats.lowStockCount} stock faible',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                        fontSize: EcoPlatesDesignTokens.typography.hint(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (stats.averageDiscount > 0) ...[
              SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
              // Réduction moyenne
              Text(
                'Réduction moy. : ${stats.averageDiscount.toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                  ),
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget pour un élément de statistique
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD / 2),
          decoration: BoxDecoration(
            color: color.withValues(
              alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: EcoPlatesDesignTokens.size.icon(context),
            color: color,
          ),
        ),
        SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
            fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
            fontSize: EcoPlatesDesignTokens.typography.hint(context) - 2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
