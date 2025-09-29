import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_stats.dart';

/// Graphique d'évolution de la satisfaction client
class CustomerSatisfactionChart extends StatelessWidget {
  const CustomerSatisfactionChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8.0,
                      offset: Offset(0.0, 2.0),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20.0,
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Satisfaction Client',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${_calculateAverageRating().toStringAsFixed(1)} ⭐ sur ${analytics.totalReviews} avis',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.0),

          // Simple bar chart representation
          Container(
            height: 120.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildRatingBar(5, _getRatingCount(5), Colors.green),
                SizedBox(width: 4.0),
                _buildRatingBar(4, _getRatingCount(4), Colors.lightGreen),
                SizedBox(width: 4.0),
                _buildRatingBar(3, _getRatingCount(3), Colors.yellow),
                SizedBox(width: 4.0),
                _buildRatingBar(2, _getRatingCount(2), Colors.orange),
                SizedBox(width: 4.0),
                _buildRatingBar(1, _getRatingCount(1), Colors.red),
              ],
            ),
          ),

          SizedBox(height: 16.0),

          // Summary
          Center(
            child: Text(
              'Évolution sur les 30 derniers jours',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAverageRating() {
    if (analytics.ratingDistribution.isEmpty || analytics.totalReviews == 0) {
      return 0.0;
    }

    double weightedSum = 0.0;
    for (final rating in analytics.ratingDistribution) {
      weightedSum += rating.stars * rating.count;
    }

    return weightedSum / analytics.totalReviews;
  }

  int _getRatingCount(int stars) {
    final ratings = analytics.ratingDistribution.where((r) => r.stars == stars);
    return ratings.isNotEmpty ? ratings.first.count : 0;
  }

  Widget _buildRatingBar(int stars, int count, Color color) {
    final maxCount = analytics.ratingDistribution
        .map((rating) => rating.count)
        .reduce((a, b) => a > b ? a : b);

    final height = maxCount > 0 ? (count / maxCount) * 80.0 : 0.0;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            height: height.clamp(4.0, 80.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              stars,
              (index) => Icon(
                Icons.star,
                size: 10.0,
                color: Colors.amber,
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Graphique de répartition des avis
class RatingDistributionChart extends StatelessWidget {
  const RatingDistributionChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
            Colors.pink.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 8.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.2),
                      blurRadius: 8.0,
                      offset: Offset(0.0, 2.0),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.pie_chart,
                  size: 20.0,
                  color: Colors.purple,
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Répartition des Avis',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${analytics.totalReviews} avis',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.0),

          // Rating bars
          ...[5, 4, 3, 2, 1].map((stars) {
            final count = _getRatingCount(stars);
            final percentage = analytics.totalReviews > 0
                ? (count / analytics.totalReviews) * 100
                : 0.0;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: _buildRatingBar(stars, count, percentage),
            );
          }),
        ],
      ),
    );
  }

  int _getRatingCount(int stars) {
    final ratings = analytics.ratingDistribution.where((r) => r.stars == stars);
    return ratings.isNotEmpty ? ratings.first.count : 0;
  }

  Widget _buildRatingBar(int stars, int count, double percentage) {
    return Row(
      children: [
        // Stars
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < stars ? Icons.star : Icons.star_border,
              size: 14.0,
              color: index < stars ? Colors.amber : Colors.grey.shade300,
            ),
          ),
        ),

        SizedBox(width: 12.0),

        // Progress bar
        Expanded(
          child: Container(
            height: 8.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (percentage / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _getRatingColor(stars),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.0),

        // Percentage and count
        SizedBox(
          width: 50.0,
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: _getRatingColor(stars),
            ),
            textAlign: TextAlign.right,
          ),
        ),

        SizedBox(width: 8.0),

        SizedBox(
          width: 40.0,
          child: Text(
            '($count)',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Color _getRatingColor(int stars) {
    switch (stars) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow.shade700;
      case 2:
        return Colors.orange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
