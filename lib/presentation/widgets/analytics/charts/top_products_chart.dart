import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import '../../../../core/responsive/responsive.dart';
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
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              border: Border.all(
                color: theme.colorScheme.tertiary.withValues(
                  alpha: 0.3,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        8.0,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 24.0,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Text(
                        'Top Produits',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildChartContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 400.0,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.8,
            ),
            theme.colorScheme.surface.withValues(
              alpha: 0.6,
            ),
          ],
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: analytics.topProducts.map((product) {
            final rank = analytics.topProducts.indexOf(product) + 1;

            return Container(
              margin: EdgeInsets.only(
                bottom: 12.0,
              ),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(
                      alpha: 0.9,
                    ),
                    Colors.white.withValues(
                      alpha: 0.7,
                    ),
                  ],
                  stops: const [0.0, 1.0],
                ),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: _getRankColor(theme, rank).withValues(
                    alpha: 0.3,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getRankColor(theme, rank).withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getRankColor(theme, rank).withValues(
                            alpha: 0.8,
                          ),
                          _getRankColor(theme, rank).withValues(
                            alpha: 0.6,
                          ),
                          _getRankColor(theme, rank).withValues(
                            alpha: 0.4,
                          ),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      border: Border.all(
                        color: _getRankColor(theme, rank).withValues(
                          alpha: 0.5,
                        ),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getRankColor(theme, rank).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8.0,
                          offset: Offset(0, 2),
                          spreadRadius: 1.0,
                        ),
                        BoxShadow(
                          color: _getRankColor(theme, rank).withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 4.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            rank.toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: _getRankColor(theme, rank),
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.3,
                                  ),
                                  offset: Offset(0, 1),
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(
                                  product.category,
                                  theme,
                                ).withValues(
                                  alpha: 0.8,
                                ),
                                _getCategoryColor(
                                  product.category,
                                  theme,
                                ).withValues(
                                  alpha: 0.6,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              6.0,
                            ),
                            border: Border.all(
                              color: _getCategoryColor(product.category, theme)
                                  .withValues(
                                    alpha: 0.7,
                                  ),
                            ),
                          ),
                          child: Text(
                            product.category,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getCategoryColor(product.category, theme),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(
                                alpha: 0.8,
                              ),
                              theme.colorScheme.primary.withValues(
                                alpha: 0.6,
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        child: Text(
                          _formatCurrency(product.revenue),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            size: 16.0,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(
                                  alpha: 0.7,
                                ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '${product.quantity}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12.0,
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
    );
    return formatter.format(amount);
  }

  Color _getRankColor(ThemeData theme, int rank) {
    // Palette étendue de couleurs pour les rangs
    final rankColors = [
      Colors.amber,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    return rankColors[(rank - 1) % rankColors.length];
  }

  Color _getCategoryColor(String category, ThemeData theme) {
    // Couleurs par défaut pour les catégories
    final categoryColors = {
      'Plat principal': Colors.blue,
      'Dessert': Colors.pink,
      'Boisson': Colors.orange,
      'Entrée': Colors.green,
      'Accompagnement': Colors.purple,
    };
    return categoryColors[category] ?? theme.colorScheme.tertiary;
  }
}
