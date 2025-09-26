import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_stats.dart';
import 'constants.dart';

/// Configuration pour un graphique réutilisable
class ChartConfig {
  const ChartConfig({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.totalValue,
    required this.data,
    required this.valueFormatter,
    this.showLine = false,
    this.lineColor,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final double totalValue;
  final List<DataPoint> data;
  final String Function(double) valueFormatter;
  final bool showLine;
  final Color? lineColor;
}

/// Widget graphique réutilisable pour les analyses
class ReusableChart extends StatefulWidget {
  const ReusableChart({
    required this.config,
    super.key,
  });

  final ChartConfig config;

  @override
  State<ReusableChart> createState() => _ReusableChartState();
}

class _ReusableChartState extends State<ReusableChart> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ChartConstants.chartHorizontalPadding,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(ChartConstants.headerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec titre, icône et compteur
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ChartConstants.headerElementPadding,
                  vertical: ChartConstants.headerElementPadding - 2,
                ),
                decoration: BoxDecoration(
                  color: widget.config.iconColor.withValues(
                    alpha: ChartConstants.tertiaryAlpha,
                  ),
                  borderRadius: BorderRadius.circular(
                    ChartConstants.defaultBorderRadius,
                  ),
                  border: Border.all(
                    color: widget.config.iconColor.withValues(
                      alpha: ChartConstants.surfaceAlpha,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                        ChartConstants.headerElementPadding - 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.config.iconColor.withValues(
                          alpha: ChartConstants.surfaceAlpha - 0.05,
                        ),
                        borderRadius: BorderRadius.circular(
                          ChartConstants.defaultBorderRadius - 4,
                        ),
                      ),
                      child: Icon(
                        widget.config.icon,
                        size: 16,
                        color: widget.config.iconColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.config.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          fontSize: ChartConstants.titleFontSize,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ChartConstants.headerElementPadding - 2,
                        vertical: ChartConstants.headerElementPadding - 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.config.iconColor.withValues(
                          alpha: ChartConstants.surfaceAlpha - 0.05,
                        ),
                        borderRadius: BorderRadius.circular(
                          ChartConstants.defaultBorderRadius,
                        ),
                        border: Border.all(
                          color: widget.config.iconColor.withValues(
                            alpha: ChartConstants.secondaryBorderAlpha,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.config.valueFormatter(widget.config.totalValue),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: widget.config.iconColor,
                          fontWeight: FontWeight.w800,
                          fontSize: ChartConstants.counterFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ChartConstants.headerVerticalSpacing),
              _buildChartContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartContent(BuildContext context) {
    final theme = Theme.of(context);
    final points = widget.config.data;

    if (points.isEmpty) {
      return Container(
        height: ChartConstants.chartContainerHeight,
        alignment: Alignment.center,
        child: Text(
          'Aucune donnée disponible',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Container(
      height: ChartConstants.chartContainerHeight,
      padding: const EdgeInsets.all(ChartConstants.chartVerticalPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: ChartConstants.surfaceAlpha,
            ),
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: ChartConstants.surfaceHighAlpha,
            ),
            theme.colorScheme.surface.withValues(
              alpha: ChartConstants.tertiaryAlpha,
            ),
          ],
          stops: ChartConstants.gradientStops,
        ),
        borderRadius: BorderRadius.circular(ChartConstants.chartBorderRadius),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: ChartConstants.outlineAlpha,
          ),
          width: ChartConstants.chartBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: ChartConstants.shadowAlpha,
            ),
            blurRadius: ChartConstants.shadowBlurRadius,
            offset: ChartConstants.shadowOffset,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: ChartConstants.tertiaryAlpha,
            ),
            blurRadius: ChartConstants.secondaryShadowBlurRadius,
            offset: ChartConstants.secondaryShadowOffset,
          ),
        ],
      ),
      child: Column(
        children: [
          // Grille de fond avec barres et ligne optionnelle
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculer la largeur dynamique en fonction du nombre de points
                final calculatedWidth = ChartConstants.calculateTotalWidth(points.length);
                // Utiliser la largeur du conteneur si elle est plus grande
                final chartWidth = calculatedWidth > constraints.maxWidth 
                    ? calculatedWidth 
                    : constraints.maxWidth;
                
                return SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: chartWidth > constraints.maxWidth 
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    width: chartWidth,
                    child: Stack(
                      children: [
                        // Grille de fond
                        CustomPaint(
                          painter: _ChartGridPainter(theme, points.length),
                          child: const SizedBox.expand(),
                        ),
                        // Ligne de connexion si activée
                        if (widget.config.showLine)
                          CustomPaint(
                            painter: _RevenueLinePainter(
                              points,
                              widget.config.lineColor ??
                                  widget.config.iconColor,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        // Barres de données
                        if (chartWidth > calculatedWidth)
                          // Si on a plus d'espace, répartir uniformément
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: points
                                .map((point) => _buildDataPoint(point, theme))
                                .toList(),
                          )
                        else
                          // Sinon, utiliser l'espacement fixe
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ChartConstants.barSpacing / 2,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: points
                                  .map((point) => _buildDataPoint(point, theme))
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Labels des périodes en bas
          const SizedBox(height: ChartConstants.gridToLabelsSpacing),
          LayoutBuilder(
            builder: (context, constraints) {
              // Utiliser la même largeur que le graphique au-dessus
              final calculatedWidth = ChartConstants.calculateTotalWidth(points.length);
              final chartWidth = calculatedWidth > constraints.maxWidth 
                  ? calculatedWidth 
                  : constraints.maxWidth;
              
              return SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: chartWidth > constraints.maxWidth 
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: chartWidth,
                  child: chartWidth > calculatedWidth
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: points
                              .map(
                                (point) => SizedBox(
                                  width: ChartConstants.barWidth + 20,
                                  child: Text(
                                    point.label,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: ChartConstants.labelFontSize,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ChartConstants.barSpacing / 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: points
                                .map(
                                  (point) => SizedBox(
                                    width: ChartConstants.barWidth,
                                    child: Text(
                                      point.label,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: ChartConstants.labelFontSize,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataPoint(DataPoint point, ThemeData theme) {
    final points = widget.config.data;
    final pointIndex = points.indexOf(point);
    final maxValue = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final normalizedHeight = point.value / maxValue;
    final barHeight = normalizedHeight * ChartConstants.maxBarHeight;

    // Palette de couleurs variées pour chaque barre
    final barColors = [
      theme.colorScheme.secondary,
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
      ...ChartConstants.barColorsHex.map(Color.new),
    ];

    final barColor = barColors[pointIndex % barColors.length];

    return SizedBox(
      width: ChartConstants.barWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Valeur au-dessus de la barre
          Text(
            widget.config.valueFormatter(point.value),
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: ChartConstants.valueFontSize,
              fontWeight: FontWeight.w600,
              color: barColor,
            ),
          ),
          const SizedBox(height: ChartConstants.valueToBarSpacing),
          // Barre verticale avec dégradé
          Container(
            width: ChartConstants.barWidth - ChartConstants.barSpacing,
            height: barHeight.clamp(
              ChartConstants.minBarHeight,
              ChartConstants.maxBarHeight,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  barColor.withValues(
                    alpha: ChartConstants.surfaceAlpha + 0.75,
                  ),
                  barColor.withValues(
                    alpha: ChartConstants.surfaceAlpha + 0.55,
                  ),
                  barColor.withValues(
                    alpha: ChartConstants.surfaceAlpha + 0.35,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(
                ChartConstants.barBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: barColor.withValues(
                    alpha: ChartConstants.surfaceAlpha + 0.25,
                  ),
                  blurRadius: ChartConstants.barShadowBlurRadius,
                  offset: ChartConstants.barShadowOffset,
                ),
              ],
              border: Border.all(
                color: barColor.withValues(
                  alpha: ChartConstants.surfaceAlpha + 0.15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Peintre pour la grille du graphique
class _ChartGridPainter extends CustomPainter {
  const _ChartGridPainter(this.theme, this.pointCount);

  final ThemeData theme;
  final int pointCount;

  @override
  void paint(Canvas canvas, Size size) {
    // Peinture pour les lignes principales
    final majorGridPaint = Paint()
      ..color = theme.colorScheme.outline.withValues(
        alpha: ChartConstants.surfaceAlpha,
      )
      ..strokeWidth = ChartConstants.majorGridStrokeWidth;

    // Peinture pour les lignes secondaires (plus subtiles)
    final minorGridPaint = Paint()
      ..color = theme.colorScheme.outline.withValues(
        alpha: ChartConstants.surfaceHighAlpha,
      )
      ..strokeWidth = ChartConstants.minorGridStrokeWidth;

    // Lignes horizontales principales
    for (var i = 1; i <= ChartConstants.majorGridLines; i++) {
      final y = (size.height / 5) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), majorGridPaint);

      // Ajouter des lignes mineures entre les principales
      if (i < ChartConstants.majorGridLines) {
        final midY = y + (size.height / 5) / 2;
        canvas.drawLine(
          Offset(0, midY),
          Offset(size.width, midY),
          minorGridPaint,
        );
      }
    }

    // Lignes verticales espacées pour les points de données
    for (var i = 0; i <= pointCount; i++) {
      final x = (size.width / pointCount) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minorGridPaint);
    }

    // Ajouter un effet de dégradé subtil en arrière-plan
    final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.colorScheme.primary.withValues(
          alpha: ChartConstants.tertiaryAlpha - 0.02,
        ),
        theme.colorScheme.secondary.withValues(
          alpha: ChartConstants.tertiaryAlpha - 0.04,
        ),
        Colors.transparent,
      ],
      stops: ChartConstants.gradientStops,
    );

    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Ajouter des points décoratifs subtils
    final dotPaint = Paint()
      ..color = theme.colorScheme.outline.withValues(
        alpha: ChartConstants.tertiaryAlpha,
      )
      ..style = PaintingStyle.fill;

    // Points aux intersections de la grille
    for (var i = 1; i <= ChartConstants.majorGridLines; i++) {
      final y = (size.height / 5) * i;
      for (var j = 0; j <= pointCount; j++) {
        final x = (size.width / pointCount) * j;
        canvas.drawCircle(Offset(x, y), ChartConstants.gridDotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Peintre pour la ligne de connexion des points
class _RevenueLinePainter extends CustomPainter {
  const _RevenueLinePainter(this.data, this.baseColor);

  final List<DataPoint> data;
  final Color baseColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final maxValue = data.map((p) => p.value).reduce((a, b) => a > b ? a : b);

    // Créer le chemin de la ligne
    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].value / maxValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Dessiner la ligne avec un dégradé
    final lineGradient = LinearGradient(
      colors: [
        baseColor.withValues(alpha: 0.8),
        baseColor.withValues(alpha: 0.6),
        baseColor.withValues(alpha: 0.4),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final linePaint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = lineGradient.createShader(
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      );

    canvas.drawPath(path, linePaint);

    // Ajouter des points colorés sur la ligne
    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].value / maxValue * size.height);

      // Palette de couleurs pour les points (correspond aux barres)
      final pointColors = [
        baseColor,
        const Color(0xFF03DAC6), // Teal
        const Color(0xFFFF4081), // Pink
        const Color(0xFF4CAF50), // Vert
        const Color(0xFFFF9800), // Orange
        const Color(0xFF9C27B0), // Violet
        const Color(0xFF00BCD4), // Cyan
        const Color(0xFF8BC34A), // Light Green
      ];

      final pointColor = pointColors[i % pointColors.length];

      // Cercle principal coloré
      final pointPaint = Paint()
        ..color = pointColor
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(x, y), 6, pointPaint);

      // Bordure blanche
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(Offset(x, y), 6, borderPaint);

      // Petit centre coloré
      final centerPaint = Paint()..color = pointColor;
      canvas.drawCircle(Offset(x, y), 3, centerPaint);
    }

    // Ajouter un effet de lueur sous la ligne
    final glowPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.2)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
