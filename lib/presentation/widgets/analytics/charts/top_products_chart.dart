import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/analytics_stats.dart';

class TopProductsChart extends StatelessWidget {
  const TopProductsChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: DeepColorTokens.tertiaryContainer.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              border: Border.all(
                color: DeepColorTokens.tertiary.withValues(
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
                        color: DeepColorTokens.tertiaryContainer.withValues(
                          alpha: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 24.0,
                        color: DeepColorTokens.tertiary,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Text(
                        'Top Produits',
                        style: TextStyle(
                          fontSize: FontSizes.subtitleLarge.getSize(context),
                          fontWeight: FontSizes.subtitleLarge.getFontWeight(),
                          color: DeepColorTokens.neutral900,
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
    return Container(
      height: 400.0,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DeepColorTokens.surfaceContainer.withValues(
              alpha: 0.8,
            ),
            DeepColorTokens.surface.withValues(
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
                  color: _getRankColor(rank).withValues(
                    alpha: 0.3,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getRankColor(rank).withValues(
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
                          _getRankColor(rank).withValues(
                            alpha: 0.8,
                          ),
                          _getRankColor(rank).withValues(
                            alpha: 0.6,
                          ),
                          _getRankColor(rank).withValues(
                            alpha: 0.4,
                          ),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      border: Border.all(
                        color: _getRankColor(rank).withValues(
                          alpha: 0.5,
                        ),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getRankColor(rank).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8.0,
                          offset: Offset(0, 2),
                          spreadRadius: 1.0,
                        ),
                        BoxShadow(
                          color: _getRankColor(rank).withValues(
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
                              color: _getRankColor(rank),
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
                          style: TextStyle(
                            fontSize: FontSizes.bodyLarge.getSize(context),
                            fontWeight: FontWeight.w600,
                            color: DeepColorTokens.neutral900,
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
                                ).withValues(
                                  alpha: 0.8,
                                ),
                                _getCategoryColor(
                                  product.category,
                                ).withValues(
                                  alpha: 0.6,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              6.0,
                            ),
                            border: Border.all(
                              color: _getCategoryColor(product.category)
                                  .withValues(
                                    alpha: 0.7,
                                  ),
                            ),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: FontSizes.caption.getSize(context),
                              fontWeight: FontWeight.w500,
                              color: _getCategoryColor(product.category),
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
                              DeepColorTokens.primary.withValues(
                                alpha: 0.8,
                              ),
                              DeepColorTokens.primary.withValues(
                                alpha: 0.6,
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                          border: Border.all(
                            color: DeepColorTokens.primary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        child: Text(
                          _formatCurrency(product.revenue),
                          style: TextStyle(
                            fontSize: FontSizes.bodyMedium.getSize(context),
                            fontWeight: FontWeight.bold,
                            color: DeepColorTokens.primary,
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
                            color: DeepColorTokens.neutral600.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '${product.quantity}',
                            style: TextStyle(
                              fontSize: FontSizes.caption.getSize(context),
                              fontWeight: FontWeight.w500,
                              color: DeepColorTokens.neutral600,
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

  Color _getRankColor(int rank) {
    // Palette étendue de couleurs profondes pour les rangs
    final rankColors = [
      DeepColorTokens.accent,
      DeepColorTokens.primary,
      DeepColorTokens.secondary,
      DeepColorTokens.tertiary,
      DeepColorTokens.error,
      DeepColorTokens.info,
      DeepColorTokens.warning,
      DeepColorTokens.premium,
      DeepColorTokens.trust,
      DeepColorTokens.professional,
    ];
    return rankColors[(rank - 1) % rankColors.length];
  }

  Color _getCategoryColor(String category) {
    // Couleurs profondes par défaut pour les catégories
    final categoryColors = {
      'Plat principal': DeepColorTokens.primary,
      'Dessert': DeepColorTokens.secondary,
      'Boisson': DeepColorTokens.tertiary,
      'Entrée': DeepColorTokens.success,
      'Accompagnement': DeepColorTokens.accent,
    };
    return categoryColors[category] ?? DeepColorTokens.neutral600;
  }
}
