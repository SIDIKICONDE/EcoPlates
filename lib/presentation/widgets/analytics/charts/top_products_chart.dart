import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/responsive.dart';
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
        horizontal: EcoPlatesDesignTokens
            .analyticsCharts
            .topProductsChartHorizontalPadding,
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.analyticsCharts.topProductsChartCardPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: EcoPlatesDesignTokens
                      .analyticsCharts
                      .topProductsHeaderHorizontalPadding,
                  vertical: EcoPlatesDesignTokens
                      .analyticsCharts
                      .topProductsHeaderVerticalPadding,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsHeaderBackgroundAlpha,
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsHeaderBorderRadius,
                  ),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withValues(
                      alpha: EcoPlatesDesignTokens
                          .analyticsCharts
                          .topProductsHeaderBorderAlpha,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        EcoPlatesDesignTokens
                            .analyticsCharts
                            .topProductsHeaderIconPadding,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withValues(
                          alpha: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsHeaderIconBackgroundAlpha,
                        ),
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsHeaderIconBorderRadius,
                        ),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: EcoPlatesDesignTokens
                            .analyticsCharts
                            .topProductsHeaderIconSize,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(
                      width: EcoPlatesDesignTokens
                          .analyticsCharts
                          .topProductsHeaderIconSpacing,
                    ),
                    Expanded(
                      child: Text(
                        EcoPlatesDesignTokens.analyticsCharts.topProductsTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsHeaderTitleWeight,
                          color: theme.colorScheme.onSurface,
                          fontSize: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsHeaderTitleFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .topProductsHeaderVerticalSpacing,
              ),
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
      height: EcoPlatesDesignTokens.analyticsCharts.topProductsChartHeight(
        context,
      ),
      padding: EdgeInsets.all(
        EcoPlatesDesignTokens.analyticsCharts.topProductsChartContentPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: EcoPlatesDesignTokens
                  .analyticsCharts
                  .topProductsChartSurfaceHighAlpha,
            ),
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: EcoPlatesDesignTokens
                  .analyticsCharts
                  .topProductsChartSurfaceMediumAlpha,
            ),
            theme.colorScheme.surface.withValues(
              alpha: EcoPlatesDesignTokens
                  .analyticsCharts
                  .topProductsChartSurfaceLowAlpha,
            ),
          ],
          stops: EcoPlatesDesignTokens
              .analyticsCharts
              .topProductsChartGradientStops,
        ),
        borderRadius: BorderRadius.circular(
          EcoPlatesDesignTokens.analyticsCharts.topProductsChartBorderRadius,
        ),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens
                .analyticsCharts
                .topProductsChartBorderAlpha,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: analytics.topProducts.map((product) {
            final rank = analytics.topProducts.indexOf(product) + 1;

            return Container(
              margin: EdgeInsets.only(
                bottom: EcoPlatesDesignTokens
                    .analyticsCharts
                    .topProductsProductVerticalMargin,
              ),
              padding: EdgeInsets.all(
                EcoPlatesDesignTokens.analyticsCharts.topProductsProductPadding,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsRankInnerBackgroundColor
                        .withValues(
                          alpha: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsProductBackgroundHighAlpha,
                        ),
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsRankInnerBackgroundColor
                        .withValues(
                          alpha: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsProductBackgroundMediumAlpha,
                        ),
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsRankInnerBackgroundColor
                        .withValues(
                          alpha: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsProductBackgroundLowAlpha,
                        ),
                  ],
                  stops: EcoPlatesDesignTokens
                      .analyticsCharts
                      .topProductsProductGradientStops,
                ),
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens
                      .analyticsCharts
                      .topProductsProductBorderRadius,
                ),
                border: Border.all(
                  color: _getRankColor(theme, rank).withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsProductBorderAlpha,
                  ),
                  width: EcoPlatesDesignTokens
                      .analyticsCharts
                      .topProductsProductBorderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getRankColor(theme, rank).withValues(
                      alpha: EcoPlatesDesignTokens
                          .analyticsCharts
                          .topProductsProductShadowAlpha,
                    ),
                    blurRadius: EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsProductShadowBlurRadius,
                    offset: EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsProductShadowOffset,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: EcoPlatesDesignTokens.analyticsCharts
                        .topProductsRankBadgeSize(context),
                    height: EcoPlatesDesignTokens.analyticsCharts
                        .topProductsRankBadgeHeight(context),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getRankColor(theme, rank).withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRankGradientHighAlpha,
                          ),
                          _getRankColor(theme, rank).withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRankGradientMediumAlpha,
                          ),
                          _getRankColor(theme, rank).withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRankGradientLowAlpha,
                          ),
                        ],
                        stops: EcoPlatesDesignTokens
                            .analyticsCharts
                            .topProductsRankGradientStops,
                      ),
                      borderRadius: BorderRadius.circular(
                        EcoPlatesDesignTokens
                            .analyticsCharts
                            .topProductsRankBadgeBorderRadius,
                      ),
                      border: Border.all(
                        color: _getRankColor(theme, rank).withValues(
                          alpha: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRankBorderAlpha,
                        ),
                        width: EcoPlatesDesignTokens
                            .analyticsCharts
                            .topProductsRankBorderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getRankColor(theme, rank).withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRankShadowPrimaryAlpha,
                          ),
                          blurRadius: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRankShadowPrimaryBlurRadius,
                          offset: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRankShadowPrimaryOffset,
                          spreadRadius: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRankBadgeShadowSpreadRadius,
                        ),
                        BoxShadow(
                          color: _getRankColor(theme, rank).withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRankShadowSecondaryAlpha,
                          ),
                          blurRadius: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRankShadowSecondaryBlurRadius,
                          offset: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRankShadowSecondaryOffset,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: EcoPlatesDesignTokens.analyticsCharts
                            .topProductsRankInnerSize(context),
                        height: EcoPlatesDesignTokens.analyticsCharts
                            .topProductsRankInnerHeight(context),
                        decoration: BoxDecoration(
                          color: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRankInnerBackgroundColor
                              .withValues(
                                alpha: EcoPlatesDesignTokens
                                    .analyticsCharts
                                    .topProductsRankInnerBackgroundAlpha,
                              ),
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRankInnerBorderRadius,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            rank.toString(),
                            style: TextStyle(
                              fontSize: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsRankFontSize,
                              fontWeight: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsRankWeight,
                              color: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsRankTextColor,
                              letterSpacing: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsRankLetterSpacing,
                              shadows: [
                                Shadow(
                                  color: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .topProductsRankTextShadowColor
                                      .withValues(
                                        alpha: EcoPlatesDesignTokens
                                            .analyticsCharts
                                            .topProductsRankTextShadowAlpha,
                                      ),
                                  offset: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .topProductsRankTextShadowOffset,
                                  blurRadius: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .topProductsRankTextShadowBlurRadius,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsProductHorizontalSpacing,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsProductNameWeight,
                            color: theme.colorScheme.onSurface,
                            fontSize: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsProductNameFontSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsProductVerticalSpacing,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsCategoryHorizontalPadding,
                            vertical: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsCategoryVerticalPadding,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(
                                  product.category,
                                  theme,
                                ).withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .topProductsCategoryBackgroundHighAlpha,
                                ),
                                _getCategoryColor(
                                  product.category,
                                  theme,
                                ).withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .topProductsCategoryBackgroundLowAlpha,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsCategoryBorderRadius,
                            ),
                            border: Border.all(
                              color: _getCategoryColor(product.category, theme)
                                  .withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .analyticsCharts
                                        .topProductsCategoryBorderAlpha,
                                  ),
                            ),
                          ),
                          child: Text(
                            product.category,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getCategoryColor(product.category, theme),
                              fontSize: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsCategoryFontSize,
                              fontWeight: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsCategoryWeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: EcoPlatesDesignTokens
                        .analyticsCharts
                        .topProductsProductHorizontalSpacing,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRevenueHorizontalPadding,
                          vertical: EcoPlatesDesignTokens
                              .analyticsCharts
                              .topProductsRevenueVerticalPadding,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(
                                alpha: EcoPlatesDesignTokens
                                    .analyticsCharts
                                    .topProductsRevenueBackgroundHighAlpha,
                              ),
                              theme.colorScheme.primary.withValues(
                                alpha: EcoPlatesDesignTokens
                                    .analyticsCharts
                                    .topProductsRevenueBackgroundLowAlpha,
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRevenueBorderRadius,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsRevenueBorderAlpha,
                            ),
                          ),
                        ),
                        child: Text(
                          _formatCurrency(product.revenue),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRevenueWeight,
                            color: theme.colorScheme.primary,
                            fontSize: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsRevenueFontSize,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: EcoPlatesDesignTokens
                            .analyticsCharts
                            .topProductsStatsVerticalSpacing,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            size: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsQuantityIconSize,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .topProductsQuantityIconAlpha,
                                ),
                          ),
                          SizedBox(
                            width: EcoPlatesDesignTokens
                                .analyticsCharts
                                .topProductsQuantityIconSpacing,
                          ),
                          Text(
                            '${product.quantity}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsQuantityFontSize,
                              fontWeight: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .topProductsQuantityWeight,
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
      locale: EcoPlatesDesignTokens.analyticsCharts.topProductsCurrencyLocale,
      symbol: EcoPlatesDesignTokens.analyticsCharts.topProductsCurrencySymbol,
      decimalDigits: amount % 1 == 0
          ? 0
          : EcoPlatesDesignTokens
                .analyticsCharts
                .topProductsCurrencyMaxDecimalDigits,
    );
    return formatter.format(amount);
  }

  Color _getRankColor(ThemeData theme, int rank) {
    // Palette étendue de couleurs pour les rangs
    final rankColors = [
      ...EcoPlatesDesignTokens.analyticsCharts.topProductsRankColors,
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];

    return rankColors[(rank - 1) % rankColors.length];
  }

  Color _getCategoryColor(String category, ThemeData theme) {
    return EcoPlatesDesignTokens
            .analyticsCharts
            .topProductsCategoryColors[category] ??
        theme.colorScheme.tertiary;
  }
}
