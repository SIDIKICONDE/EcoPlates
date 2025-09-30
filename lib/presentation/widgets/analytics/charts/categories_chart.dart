import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/analytics_stats.dart';

class CategoriesChart extends StatelessWidget {
  const CategoriesChart({
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
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: DeepColorTokens.tertiary.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: DeepColorTokens.tertiaryContainer.withValues(
                          alpha: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(
                        Icons.pie_chart,
                        size: 20.0,
                        color: DeepColorTokens.tertiary,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Text(
                        'Par catégories',
                        style: TextStyle(
                          fontSize: FontSizes.subtitleMedium.getSize(context),
                          fontWeight: FontSizes.subtitleMedium.getFontWeight(),
                          color: DeepColorTokens.neutral900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              _buildChartContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartContent(BuildContext context) {
    return Container(
      height: 200.0,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DeepColorTokens.surfaceContainer.withValues(alpha: 0.8),
            DeepColorTokens.surfaceElevated.withValues(alpha: 0.6),
            DeepColorTokens.surface.withValues(alpha: 0.4),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          // Diagramme circulaire stylisé
          Expanded(
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    DeepColorTokens.tertiaryLight.withValues(alpha: 0.8),
                    DeepColorTokens.tertiary.withValues(alpha: 0.4),
                  ],
                ),
                border: Border.all(
                  color: DeepColorTokens.tertiary.withValues(alpha: 0.6),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: DeepColorTokens.shadowMedium,
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _CategoryPiePainter(analytics.categoryBreakdown),
              ),
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          // Liste des catégories scrollable
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 120.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: analytics.categoryBreakdown.map((category) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Color(category.color).withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: Color(category.color),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    category.color,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 4.0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                fontSize: FontSizes.bodyMedium.getSize(context),
                                fontWeight: FontWeight.w500,
                                color: DeepColorTokens.neutral800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(
                                category.color,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              '${category.percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: FontSizes.bodySmall.getSize(context),
                                fontWeight: FontWeight.w700,
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
    final radius = size.width / 2 - 8.0;

    var startAngle = -3.141592653589793 / 2; // Commencer en haut

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
        ..color = Colors.white.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        borderPaint,
      );

      startAngle += sweepAngle;
    }

    // Cercle central blanc pour un effet "donut"
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, centerPaint);

    // Bordure du cercle central
    final centerBorderPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius * 0.6, centerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
