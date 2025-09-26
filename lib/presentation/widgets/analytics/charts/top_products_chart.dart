import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/analytics_stats.dart';

class TopProductsChart extends StatelessWidget {
  const TopProductsChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 14,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Top produits',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildChartContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.08),
            theme.colorScheme.surface.withValues(alpha: 0.05),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: analytics.topProducts.map((product) {
            final rank = analytics.topProducts.indexOf(product) + 1;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.4),
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.1),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _getRankColor(theme, rank).withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getRankColor(theme, rank).withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getRankColor(theme, rank).withValues(alpha: 0.9),
                          _getRankColor(theme, rank).withValues(alpha: 0.7),
                          _getRankColor(theme, rank).withValues(alpha: 0.5),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getRankColor(
                          theme,
                          rank,
                        ).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getRankColor(
                            theme,
                            rank,
                          ).withValues(alpha: 0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: _getRankColor(
                            theme,
                            rank,
                          ).withValues(alpha: 0.3),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            rank.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 1),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(
                                  product.category,
                                  theme,
                                ).withValues(alpha: 0.15),
                                _getCategoryColor(
                                  product.category,
                                  theme,
                                ).withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _getCategoryColor(
                                product.category,
                                theme,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            product.category,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getCategoryColor(product.category, theme),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                              theme.colorScheme.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Text(
                          _formatCurrency(product.revenue),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            size: 10,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(
                                  alpha: 0.6,
                                ),
                          ),
                          const SizedBox(width: 1),
                          Text(
                            '${product.quantity}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
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

  Color _getRankColor(ThemeData theme, int rank) {
    // Palette étendue de couleurs pour les rangs
    final rankColors = [
      const Color(0xFFFFD700), // Or pour le #1
      const Color(0xFFC0C0C0), // Argent pour le #2
      const Color(0xFFCD7F32), // Bronze pour le #3
      const Color(0xFF4CAF50), // Vert émeraude pour le #4
      const Color(0xFF2196F3), // Bleu pour le #5
      const Color(0xFF9C27B0), // Violet pour le #6
      const Color(0xFFFF9800), // Orange pour le #7
      const Color(0xFFE91E63), // Rose pour le #8
      const Color(0xFF00BCD4), // Cyan pour le #9
      const Color(0xFF8BC34A), // Vert clair pour le #10
      const Color(0xFF3F51B5), // Indigo pour le #11+
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];

    return rankColors[(rank - 1) % rankColors.length];
  }

  Color _getCategoryColor(String category, ThemeData theme) {
    // Palette de couleurs pour les catégories
    final categoryColors = {
      'Pizza': const Color(0xFFFF6B6B),
      'Burger': const Color(0xFF4ECDC4),
      'Pasta': const Color(0xFF45B7D1),
      'Salade': const Color(0xFF96CEB4),
      'Dessert': const Color(0xFFFECA57),
      'Boisson': const Color(0xFF74B9FF),
      'Entrée': const Color(0xFFA29BFE),
      'Plat': const Color(0xFFFD79A8),
      'Végétarien': const Color(0xFF00B894),
      'Viande': const Color(0xFFE17055),
      'Poisson': const Color(0xFF0984E3),
      'Asiatique': const Color(0xFFE84393),
      'Italien': const Color(0xFFD63031),
      'Français': const Color(0xFF6C5CE7),
    };

    return categoryColors[category] ?? theme.colorScheme.tertiary;
  }
}
