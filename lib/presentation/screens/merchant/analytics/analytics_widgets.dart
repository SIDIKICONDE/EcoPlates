import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

import '../../../../domain/entities/analytics.dart'
    show PerformanceMetrics, CustomerSegment, Analytics;

/// Widget pour le funnel de conversion
class ConversionFunnelWidget extends StatelessWidget {
  final Analytics analytics;

  const ConversionFunnelWidget({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final performance = analytics.performance;
    final stages = [
      FunnelStage('Vues', performance.totalViews.toDouble(), Colors.blue[300]!),
      FunnelStage(
        'Réservations',
        performance.totalReservations.toDouble(),
        Colors.orange[300]!,
      ),
      FunnelStage(
        'Collectes',
        performance.completedPickups.toDouble(),
        Colors.green[300]!,
      ),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Funnel de conversion',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: CustomPaint(
                size: Size(double.infinity, 200.h),
                painter: FunnelPainter(stages: stages),
              ),
            ),
            SizedBox(height: 16.h),
            _buildConversionRates(performance),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionRates(PerformanceMetrics performance) {
    return Column(
      children: [
        _buildRateRow(
          'Taux de réservation',
          performance.totalViews > 0
              ? (performance.totalReservations / performance.totalViews * 100)
              : 0,
          Colors.orange,
        ),
        SizedBox(height: 8.h),
        _buildRateRow(
          'Taux de collecte',
          performance.totalReservations > 0
              ? (performance.completedPickups /
                    performance.totalReservations *
                    100)
              : 0,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildRateRow(String label, double rate, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            '${rate.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget pour la distribution horaire des offres
class OffersByHourChart extends StatelessWidget {
  final Map<int, int> offersByHour;

  const OffersByHourChart({super.key, required this.offersByHour});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribution des offres par heure',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 180.h,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: offersByHour.values.reduce(math.max).toDouble() * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${group.x.toInt()}h\n${rod.toY.toInt()} offres',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() % 3 == 0) {
                            return Text(
                              '${value.toInt()}h',
                              style: TextStyle(fontSize: 10.sp),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 10.sp),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(24, (hour) {
                    final count = offersByHour[hour] ?? 0;
                    return BarChartGroupData(
                      x: hour,
                      barRods: [
                        BarChartRodData(
                          toY: count.toDouble(),
                          color: theme.primaryColor,
                          width: 8,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4.r),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour le score de durabilité
class SustainabilityScoreWidget extends StatelessWidget {
  final double score;

  const SustainabilityScoreWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.green[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.eco, color: Colors.green, size: 24.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Score de Durabilité',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _getSustainabilityLabel(score),
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16.h),
                  LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getSustainabilityColor(score),
                    ),
                    minHeight: 8.h,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getSustainabilityColor(score).withValues(alpha: 0.2),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      score.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: _getSustainabilityColor(score),
                      ),
                    ),
                    Text(
                      '/100',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSustainabilityLabel(double score) {
    if (score >= 80) return 'Impact écologique excellent';
    if (score >= 60) return 'Bonne performance environnementale';
    if (score >= 40) return 'Des améliorations sont possibles';
    return 'Actions urgentes recommandées';
  }

  Color _getSustainabilityColor(double score) {
    if (score >= 80) return Colors.green[700]!;
    if (score >= 60) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}

/// Widget pour les métriques écologiques
class EcoMetricsGrid extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const EcoMetricsGrid({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          'CO₂ économisé',
          '${(metrics['co2Saved'] ?? 0).toStringAsFixed(1)} kg',
          Icons.cloud_queue,
          Colors.blue,
        ),
        _buildMetricCard(
          'Repas sauvés',
          '${metrics['mealsSaved'] ?? 0}',
          Icons.restaurant,
          Colors.orange,
        ),
        _buildMetricCard(
          'Eau économisée',
          '${(metrics['waterSaved'] ?? 0).toStringAsFixed(0)} L',
          Icons.water_drop,
          Colors.cyan,
        ),
        _buildMetricCard(
          'Déchets évités',
          '${(metrics['wasteAvoided'] ?? 0).toStringAsFixed(1)} kg',
          Icons.delete_outline,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget pour les équivalences écologiques
class EcoEquivalencesWidget extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const EcoEquivalencesWidget({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final co2Saved = metrics['co2Saved'] ?? 0;
    final equivalences = _calculateEquivalences(co2Saved);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Équivalences',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            ...equivalences.map((equiv) => _buildEquivalenceRow(equiv)),
          ],
        ),
      ),
    );
  }

  Widget _buildEquivalenceRow(Equivalence equiv) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: equiv.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(equiv.icon, color: equiv.color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  equiv.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  equiv.description,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Equivalence> _calculateEquivalences(double co2Kg) {
    return [
      Equivalence(
        icon: Icons.directions_car,
        value: '${(co2Kg * 8.3).toStringAsFixed(0)} km',
        description: 'en voiture évités',
        color: Colors.blue,
      ),
      Equivalence(
        icon: Icons.forest,
        value: (co2Kg / 22).toStringAsFixed(1),
        description: 'arbres plantés équivalent',
        color: Colors.green,
      ),
      Equivalence(
        icon: Icons.bolt,
        value: '${(co2Kg * 2.3).toStringAsFixed(0)} kWh',
        description: 'd\'électricité économisée',
        color: Colors.orange,
      ),
    ];
  }
}

/// Widget pour la distribution des notes clients
class RatingDistributionChart extends StatelessWidget {
  final Map<int, int> distribution;

  const RatingDistributionChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    final totalRatings = distribution.values.fold(
      0,
      (sum, count) => sum + count,
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Distribution des notes',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_calculateAverageRating(distribution).toStringAsFixed(1)} ★',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...List.generate(5, (index) {
              final rating = 5 - index;
              final count = distribution[rating] ?? 0;
              final percentage = totalRatings > 0
                  ? (count / totalRatings * 100).toDouble()
                  : 0.0;

              return _buildRatingRow(rating, count, percentage);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(int rating, int count, double percentage) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Row(
              children: [
                Text('$rating', style: TextStyle(fontSize: 14.sp)),
                Icon(Icons.star, size: 14.sp, color: Colors.orange),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: _getRatingColor(rating),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 50.w,
            child: Text(
              '$count (${percentage.toStringAsFixed(0)}%)',
              style: TextStyle(fontSize: 12.sp),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAverageRating(Map<int, int> distribution) {
    int totalRatings = 0;
    int weightedSum = 0;

    distribution.forEach((rating, count) {
      totalRatings += count;
      weightedSum += rating * count;
    });

    return totalRatings > 0 ? weightedSum / totalRatings : 0;
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return Colors.green;
    if (rating >= 3) return Colors.orange;
    return Colors.red;
  }
}

/// Widget pour les segments clients
class CustomerSegmentsWidget extends StatelessWidget {
  final List<CustomerSegment> segments;

  const CustomerSegmentsWidget({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Segments clients',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: PieChart(
                PieChartData(
                  sections: segments.map((segment) {
                    return PieChartSectionData(
                      value: segment.percentage,
                      title: '${segment.percentage.toStringAsFixed(0)}%',
                      color: _getSegmentColor(segment.name),
                      radius: 60,
                      titleStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ...segments.map((segment) => _buildSegmentLegend(segment)),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentLegend(CustomerSegment segment) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: _getSegmentColor(segment.name),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(segment.name, style: TextStyle(fontSize: 14.sp)),
                Text(
                  '${segment.averageSpend.toStringAsFixed(0)}€ panier moyen',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '${segment.count} clients',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getSegmentColor(String segmentName) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
    ];
    final hash = segmentName.hashCode.abs();
    return colors[hash % colors.length];
  }
}

// Classes de support

class FunnelStage {
  final String name;
  final double value;
  final Color color;

  FunnelStage(this.name, this.value, this.color);
}

class FunnelPainter extends CustomPainter {
  final List<FunnelStage> stages;

  FunnelPainter({required this.stages});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final maxValue = stages.map((s) => s.value).reduce(math.max);
    final stageHeight = size.height / stages.length;

    for (int i = 0; i < stages.length; i++) {
      final stage = stages[i];
      final width = (stage.value / maxValue) * size.width;
      final top = i * stageHeight;

      // Dessiner le rectangle
      paint.color = stage.color;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH((size.width - width) / 2, top, width, stageHeight * 0.8),
        Radius.circular(8),
      );
      canvas.drawRRect(rect, paint);

      // Dessiner le texte
      textPainter.text = TextSpan(
        text: '${stage.name}\n${stage.value.toInt()}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      final textOffset = Offset(
        (size.width - textPainter.width) / 2,
        top + (stageHeight * 0.8 - textPainter.height) / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Equivalence {
  final IconData icon;
  final String value;
  final String description;
  final Color color;

  Equivalence({
    required this.icon,
    required this.value,
    required this.description,
    required this.color,
  });
}
