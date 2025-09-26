import 'package:flutter/material.dart';

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
        iconColor: const Color(0xFFFFD700), // Or
        totalValue: analytics.customerSatisfactionData.isNotEmpty
            ? analytics.customerSatisfactionData.last.value
            : 0.0,
        data: analytics.customerSatisfactionData,
        valueFormatter: (value) => '${value.toStringAsFixed(1)} ⭐',
        showLine: true,
        lineColor: const Color(0xFFFFD700),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFD700).withValues(alpha: 0.1),
            const Color(0xFFFFA000).withValues(alpha: 0.1),
            const Color(0xFFFF6F00).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec icône et titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pie_chart,
                  size: 20,
                  color: Color(0xFFFFD700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Répartition des Avis',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${analytics.totalReviews} avis',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Distribution des notes
          ...analytics.ratingDistribution.map((rating) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildRatingBar(rating, context),
          )),
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
            5,
            (index) => Icon(
              index < rating.stars ? Icons.star : Icons.star_border,
              size: 14,
              color: index < rating.stars
                  ? Color(rating.color)
                  : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Barre de progression
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: rating.percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(rating.color),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Pourcentage et nombre
        SizedBox(
          width: 60,
          child: Text(
            '${rating.percentage.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Color(rating.color),
              fontSize: 11,
            ),
            textAlign: TextAlign.right,
          ),
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 35,
          child: Text(
            '(${rating.count})',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
