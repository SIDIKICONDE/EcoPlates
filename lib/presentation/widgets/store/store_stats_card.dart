import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Titre
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                SizedBox(width: 8),
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
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 
                      0.7,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

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
              SizedBox(height: 8),
              // Alerte stock faible
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${stats.lowStockCount} stock faible',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (stats.averageDiscount > 0) ...[
              SizedBox(height: 4),
              // Réduction moyenne
              Text(
                'Réduction moy. : ${stats.averageDiscount.toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
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
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
