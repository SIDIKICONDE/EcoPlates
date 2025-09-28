import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../domain/entities/analytics_stats.dart';
import 'reusable_chart.dart';

/// Graphique d'évolution de la satisfaction client
class CustomerSatisfactionChart extends StatelessWidget {
  const CustomerSatisfactionChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return ReusableChart(
      config: ChartConfig(
        title: 'Satisfaction Client',
        icon: Icons.star,
        iconColor: EcoPlatesDesignTokens.analyticsCharts.satisfactionGoldColor,
        totalValue: analytics.customerSatisfactionData.isNotEmpty
            ? analytics.customerSatisfactionData.last.value
            : 0.0,
        data: analytics.customerSatisfactionData,
        valueFormatter: (value) => '${value.toStringAsFixed(1)} ⭐',
        showLine: true,
        lineColor: EcoPlatesDesignTokens.analyticsCharts.satisfactionGoldColor,
      ),
    );
  }
}

/// Graphique de répartition des notes clients (1-5 étoiles)
class RatingDistributionChart extends StatelessWidget {
  const RatingDistributionChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: EcoPlatesDesignTokens.analyticsCharts.chartPadding(context),
      ),
      padding: EdgeInsets.all(
        EcoPlatesDesignTokens.analyticsCharts.chartContentPadding(context),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EcoPlatesDesignTokens.analyticsCharts.satisfactionGoldColor
                .withValues(
                  alpha: EcoPlatesDesignTokens
                      .analyticsCharts
                      .satisfactionGradientAlpha,
                ),
            EcoPlatesDesignTokens.analyticsCharts.satisfactionGoldLightColor
                .withValues(
                  alpha: EcoPlatesDesignTokens
                      .analyticsCharts
                      .satisfactionGradientAlpha,
                ),
            EcoPlatesDesignTokens.analyticsCharts.satisfactionGoldDarkColor
                .withValues(
                  alpha: EcoPlatesDesignTokens
                      .analyticsCharts
                      .satisfactionGradientAlpha,
                ),
          ],
        ),
        borderRadius: BorderRadius.circular(
          EcoPlatesDesignTokens.analyticsCharts.chartBorderRadius,
        ),
        border: Border.all(
          color: EcoPlatesDesignTokens.analyticsCharts.satisfactionGoldColor
              .withValues(
                alpha: EcoPlatesDesignTokens
                    .analyticsCharts
                    .satisfactionBorderAlpha,
              ),
          width: EcoPlatesDesignTokens.analyticsCharts.chartBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec icône et titre
          Row(
            children: [
              Container(
                padding:
                    EcoPlatesDesignTokens.analyticsCharts.chartHeaderPadding,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .satisfactionHeaderBackgroundAlpha,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: EcoPlatesDesignTokens
                          .analyticsCharts
                          .satisfactionGoldColor
                          .withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .satisfactionShadowAlpha,
                          ),
                      blurRadius: EcoPlatesDesignTokens
                          .analyticsCharts
                          .satisfactionHeaderShadowBlurRadius,
                      offset: EcoPlatesDesignTokens
                          .analyticsCharts
                          .satisfactionHeaderShadowOffset,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.pie_chart,
                  size: EcoPlatesDesignTokens.analyticsCharts.iconSize(context),
                  color: EcoPlatesDesignTokens
                      .analyticsCharts
                      .satisfactionGoldColor,
                ),
              ),
              SizedBox(
                width: EcoPlatesDesignTokens.analyticsCharts.iconTextSpacing(
                  context,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Répartition des Avis',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: EcoPlatesDesignTokens.analyticsCharts
                            .chartTitleFontSize(context),
                      ),
                    ),
                    Text(
                      '${analytics.totalReviews} avis',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: EcoPlatesDesignTokens.analyticsCharts
                            .labelFontSize(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: EcoPlatesDesignTokens.analyticsCharts.chartVerticalPadding(
              context,
            ),
          ),

          // Distribution des notes
          ...analytics.ratingDistribution.map(
            (rating) => Padding(
              padding: EcoPlatesDesignTokens.analyticsCharts.legendItemMargin,
              child: _buildRatingBar(rating, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(RatingData rating, BuildContext context) {
    return Row(
      children: [
        // Étoiles
        Row(
          children: List.generate(
            EcoPlatesDesignTokens.analyticsCharts.ratingStarsCount,
            (index) => Icon(
              index < rating.stars ? Icons.star : Icons.star_border,
              size: EcoPlatesDesignTokens
                  .analyticsCharts
                  .legendColorIndicatorSize,
              color: index < rating.stars
                  ? Color(rating.color)
                  : Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(
                      alpha: EcoPlatesDesignTokens
                          .analyticsCharts
                          .satisfactionUnfilledStarAlpha,
                    ),
            ),
          ),
        ),

        SizedBox(
          width:
              EcoPlatesDesignTokens.analyticsCharts.legendColorIndicatorSpacing,
        ),

        // Barre de progression
        Expanded(
          child: Container(
            height: EcoPlatesDesignTokens.analyticsCharts.barWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.analyticsCharts.barBorderRadius,
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: rating.percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(rating.color),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.analyticsCharts.barBorderRadius,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          width: EcoPlatesDesignTokens.analyticsCharts.chartElementSpacing(
            context,
          ),
        ),

        // Pourcentage et nombre
        SizedBox(
          width: EcoPlatesDesignTokens.analyticsCharts.labelWidth(context),
          child: Text(
            '${rating.percentage.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Color(rating.color),
              fontSize: EcoPlatesDesignTokens.analyticsCharts.valueFontSize(
                context,
              ),
            ),
            textAlign: TextAlign.right,
          ),
        ),

        SizedBox(
          width: EcoPlatesDesignTokens.analyticsCharts.chartElementSpacing(
            context,
          ),
        ),

        SizedBox(
          width:
              EcoPlatesDesignTokens.analyticsCharts.counterFontSize(context) *
              4,
          child: Text(
            '(${rating.count})',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: EcoPlatesDesignTokens.analyticsCharts.counterFontSize(
                context,
              ),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
