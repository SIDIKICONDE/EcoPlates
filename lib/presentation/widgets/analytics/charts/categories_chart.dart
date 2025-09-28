import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../domain/entities/analytics_stats.dart';

class CategoriesChart extends StatelessWidget {
  const CategoriesChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: EcoPlatesDesignTokens.analyticsCharts.chartPadding(context),
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.analyticsCharts.chartContentPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EcoPlatesDesignTokens.analyticsCharts.chartHeaderPadding,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .categoriesHeaderBackgroundAlpha,
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .chartHeaderBorderRadius,
                  ),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withValues(
                      alpha: EcoPlatesDesignTokens
                          .analyticsCharts
                          .categoriesHeaderBorderAlpha,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EcoPlatesDesignTokens
                          .analyticsCharts
                          .categoriesIconContainerPadding,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withValues(
                          alpha: EcoPlatesDesignTokens
                              .analyticsCharts
                              .categoriesIconContainerAlpha,
                        ),
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens
                              .analyticsCharts
                              .chartHeaderIconContainerSize,
                        ),
                      ),
                      child: Icon(
                        Icons.pie_chart,
                        size: EcoPlatesDesignTokens
                            .analyticsCharts
                            .chartHeaderIconSize,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(
                      width: EcoPlatesDesignTokens
                          .analyticsCharts
                          .chartHeaderIconSpacing,
                    ),
                    Expanded(
                      child: Text(
                        'Par catégories',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          fontSize: EcoPlatesDesignTokens.analyticsCharts
                              .chartTitleFontSize(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .chartHeaderContentSpacing,
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
      height: EcoPlatesDesignTokens.analyticsCharts.chartContentHeight(context),
      padding: EdgeInsets.all(
        EcoPlatesDesignTokens.analyticsCharts.chartContentPadding(context),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: EcoPlatesDesignTokens
                  .analyticsCharts
                  .categoriesChartSurfaceHighAlpha,
            ),
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: EcoPlatesDesignTokens
                  .analyticsCharts
                  .categoriesChartSurfaceMediumAlpha,
            ),
            theme.colorScheme.surface.withValues(
              alpha: EcoPlatesDesignTokens
                  .analyticsCharts
                  .categoriesChartSurfaceLowAlpha,
            ),
          ],
          stops: EcoPlatesDesignTokens
              .analyticsCharts
              .categoriesChartGradientStops,
        ),
        borderRadius: BorderRadius.circular(
          EcoPlatesDesignTokens.analyticsCharts.chartContentBorderRadius,
        ),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens
                .analyticsCharts
                .categoriesChartBorderAlpha,
          ),
        ),
      ),
      child: Row(
        children: [
          // Diagramme circulaire stylisé
          Expanded(
            flex: EcoPlatesDesignTokens.analyticsCharts.mobileFlexRatio(
              context,
            )[0],
            child: Container(
              height: EcoPlatesDesignTokens.analyticsCharts.pieChartSize(
                context,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.tertiary.withValues(
                      alpha: EcoPlatesDesignTokens
                          .analyticsCharts
                          .categoriesPieChartGradientHighAlpha,
                    ),
                    theme.colorScheme.tertiary.withValues(
                      alpha: EcoPlatesDesignTokens
                          .analyticsCharts
                          .categoriesPieChartGradientLowAlpha,
                    ),
                  ],
                ),
                border: Border.all(
                  color: theme.colorScheme.tertiary.withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .categoriesPieChartBorderAlpha,
                  ),
                  width:
                      EcoPlatesDesignTokens.analyticsCharts.pieChartBorderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.tertiary.withValues(
                      alpha: EcoPlatesDesignTokens
                          .analyticsCharts
                          .categoriesPieChartShadowAlpha,
                    ),
                    blurRadius: EcoPlatesDesignTokens
                        .analyticsCharts
                        .pieChartShadowBlurRadius,
                    offset: EcoPlatesDesignTokens
                        .analyticsCharts
                        .pieChartShadowOffset,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _CategoryPiePainter(analytics.categoryBreakdown),
              ),
            ),
          ),
          SizedBox(
            width: EcoPlatesDesignTokens.analyticsCharts.chartElementSpacing(
              context,
            ),
          ),
          // Liste des catégories scrollable
          Expanded(
            flex: EcoPlatesDesignTokens.analyticsCharts.mobileFlexRatio(
              context,
            )[1],
            child: Container(
              constraints: BoxConstraints(
                maxHeight: EcoPlatesDesignTokens.analyticsCharts
                    .legendMaxHeight(context),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: analytics.categoryBreakdown.map((category) {
                    return Container(
                      margin: EcoPlatesDesignTokens
                          .analyticsCharts
                          .legendItemMargin,
                      padding: EcoPlatesDesignTokens
                          .analyticsCharts
                          .legendItemPadding,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: EcoPlatesDesignTokens
                              .analyticsCharts
                              .categoriesLegendItemBackgroundAlpha,
                        ),
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens
                              .analyticsCharts
                              .legendItemBorderRadius,
                        ),
                        border: Border.all(
                          color: Color(category.color).withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .categoriesLegendItemBorderAlpha,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: EcoPlatesDesignTokens
                                .analyticsCharts
                                .legendColorIndicatorSize,
                            height: EcoPlatesDesignTokens
                                .analyticsCharts
                                .legendColorIndicatorSize,
                            decoration: BoxDecoration(
                              color: Color(category.color),
                              borderRadius: BorderRadius.circular(
                                EcoPlatesDesignTokens
                                    .analyticsCharts
                                    .legendColorIndicatorBorderRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Color(
                                        category.color,
                                      ).withValues(
                                        alpha: EcoPlatesDesignTokens
                                            .analyticsCharts
                                            .categoriesLegendIndicatorShadowAlpha,
                                      ),
                                  blurRadius: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .categoriesLegendIndicatorShadowBlurRadius,
                                  offset: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .categoriesLegendIndicatorShadowOffset,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: EcoPlatesDesignTokens
                                .analyticsCharts
                                .legendColorIndicatorSpacing,
                          ),
                          Expanded(
                            child: Text(
                              category.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: EcoPlatesDesignTokens.analyticsCharts
                                    .chartLegendFontSize(context),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EcoPlatesDesignTokens
                                .analyticsCharts
                                .legendBadgePadding,
                            decoration: BoxDecoration(
                              color:
                                  Color(
                                    category.color,
                                  ).withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .analyticsCharts
                                        .categoriesLegendBadgeBackgroundAlpha,
                                  ),
                              borderRadius: BorderRadius.circular(
                                EcoPlatesDesignTokens
                                    .analyticsCharts
                                    .legendBadgeBorderRadius,
                              ),
                            ),
                            child: Text(
                              '${category.percentage.toStringAsFixed(1)}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: EcoPlatesDesignTokens.analyticsCharts
                                    .chartBadgeFontSize(context),
                                color: Color(category.color),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPiePainter extends CustomPainter {
  const _CategoryPiePainter(this.categories);

  final List<CategoryData> categories;

  @override
  void paint(Canvas canvas, ui.Size size) {
    if (categories.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        size.width / 2 -
        EcoPlatesDesignTokens.analyticsCharts.pieChartInnerMargin;

    var startAngle = -90 * (3.141592653589793 / 180); // Commencer en haut

    for (final category in categories) {
      final sweepAngle = (category.percentage / 100) * 2 * 3.141592653589793;

      // Dessiner le secteur
      final paint = Paint()
        ..color = Color(category.color)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Bordure du secteur
      final borderPaint = Paint()
        ..color = Colors.white.withValues(
          alpha: EcoPlatesDesignTokens
              .analyticsCharts
              .categoriesPieSectorBorderAlpha,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth =
            EcoPlatesDesignTokens.analyticsCharts.pieChartSectorStrokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }

    // Cercle central blanc pour un effet "donut"
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius * EcoPlatesDesignTokens.analyticsCharts.donutCenterRatio,
      centerPaint,
    );

    // Bordure du cercle central
    final centerBorderPaint = Paint()
      ..color = Colors.grey.withValues(
        alpha: EcoPlatesDesignTokens
            .analyticsCharts
            .categoriesDonutCenterBorderAlpha,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          EcoPlatesDesignTokens.analyticsCharts.donutCenterStrokeWidth;

    canvas.drawCircle(
      center,
      radius * EcoPlatesDesignTokens.analyticsCharts.donutCenterRatio,
      centerBorderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
