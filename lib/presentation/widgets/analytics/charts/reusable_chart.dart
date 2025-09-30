import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/analytics_stats.dart';

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
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec titre, icône et compteur
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: widget.config.iconColor.withValues(
                    alpha: 0.1,
                  ),
                  border: Border.all(
                    color: widget.config.iconColor.withValues(
                      alpha: 0.2,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: widget.config.iconColor.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Icon(
                        widget.config.icon,
                        size: 16.0,
                        color: widget.config.iconColor,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.config.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: widget.config.iconColor.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                          color: widget.config.iconColor.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.config.valueFormatter(widget.config.totalValue),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: widget.config.iconColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.0,
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
    final theme = Theme.of(context);
    final points = widget.config.data;

    if (points.isEmpty) {
      return Container(
        height: 200.0,
        alignment: Alignment.center,
        child: Text(
          'Aucune donnée disponible',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return Container(
      height: 300.0,
      padding: EdgeInsets.all(
        16.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.8,
            ),
            theme.colorScheme.surface.withValues(
              alpha: 0.6,
            ),
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.2,
          ),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculer la largeur dynamique en fonction du nombre de points
          final calculatedWidth = points.length * 60.0;
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
              child: Column(
                children: [
                  // Grille de fond avec barres et ligne optionnelle
                  Expanded(
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
                              useSpaceEvenly: chartWidth > calculatedWidth,
                              horizontalPadding: chartWidth > calculatedWidth
                                  ? 0
                                  : 8.0,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0 / 2,
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
                  // Labels des périodes en bas
                  SizedBox(
                    height: 40.0,
                  ),
                  if (chartWidth > calculatedWidth)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: points
                          .map(
                            (point) => Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 80.0,
                                ),
                                child: Text(
                                  point.label,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 12.0,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0 / 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: points
                            .map(
                              (point) => SizedBox(
                                width: 16.0,
                                child: Text(
                                  point.label,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 12.0,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataPoint(DataPoint point, ThemeData theme) {
    final points = widget.config.data;
    final pointIndex = points.indexOf(point);
    final maxValue = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final normalizedHeight = point.value / maxValue;
    final barHeight = normalizedHeight * 200.0;

    // Palette de couleurs variées pour chaque barre
    final barColors = [
      theme.colorScheme.secondary,
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
    ];

    final barColor = barColors[pointIndex % barColors.length];

    // Calculer si la barre est suffisamment haute pour afficher le texte au-dessus
    final clampedBarHeight = barHeight.clamp(20.0, 200.0);
    final showValueText = clampedBarHeight > 40.0;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Barre verticale avec dégradé
        Container(
          width: 16.0,
          height: clampedBarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                barColor.withValues(alpha: 0.8),
                barColor.withValues(alpha: 1.0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: barColor.withValues(alpha: 0.3),
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        // Valeur positionnée au-dessus de la barre
        if (showValueText)
          Positioned(
            bottom: clampedBarHeight + 8.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: DeepColorTokens.shadowLight,
                    offset: Offset(0, 1),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: Text(
                widget.config.valueFormatter(point.value),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                  color: barColor,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                softWrap: false,
              ),
            ),
          ),
      ],
    );
  }
}

/// Peintre pour la grille du graphique
class _ChartGridPainter extends CustomPainter {
  const _ChartGridPainter(this.theme, this.pointCount);

  final ThemeData theme;
  final int pointCount;

  @override
  void paint(Canvas canvas, ui.Size size) {
    // Peinture pour les lignes principales
    final majorGridPaint = Paint()
      ..color = theme.colorScheme.outline.withValues(alpha: 0.3);

    final minorGridPaint = Paint()
      ..color = theme.colorScheme.outline.withValues(alpha: 0.1);

    // Lignes horizontales principales
    for (var i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), majorGridPaint);
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
        theme.colorScheme.primary.withValues(alpha: 0.02),
        DeepColorTokens.neutral1000.withValues(alpha: 0.0),
      ],
    );

    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Peintre pour la ligne de connexion des points
class _RevenueLinePainter extends CustomPainter {
  const _RevenueLinePainter(
    this.data,
    this.baseColor, {
    this.useSpaceEvenly = false,
    this.horizontalPadding = 0,
  });

  final List<DataPoint> data;
  final Color baseColor;
  final bool useSpaceEvenly;
  final double horizontalPadding;
  final double connectionPointRadius = 4.0;
  final double connectionPointBackgroundRadius = 6.0;

  @override
  void paint(Canvas canvas, ui.Size size) {
    if (data.length < 2) return;

    final maxValue = data.map((p) => p.value).reduce((a, b) => a > b ? a : b);

    // Créer le chemin de la ligne
    final path = Path();
    for (var i = 0; i < data.length; i++) {
      double x;
      if (useSpaceEvenly) {
        // Pour spaceEvenly: chaque élément prend 1/n de l'espace
        final itemWidth = size.width / data.length;
        x = itemWidth * i + itemWidth / 2;
      } else {
        // Pour spaceBetween avec padding
        final availableWidth = size.width - (2 * horizontalPadding);
        if (data.length == 1) {
          x = size.width / 2;
        } else {
          final spacing = availableWidth / (data.length - 1);
          x = horizontalPadding + (spacing * i);
        }
      }

      final y = size.height - (data[i].value / maxValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Dessiner la ligne avec une couleur grise subtile pour meilleure lisibilité
    final linePaint = Paint()
      ..color = baseColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Ajouter des points colorés sur la ligne
    for (var i = 0; i < data.length; i++) {
      double x;
      if (useSpaceEvenly) {
        // Pour spaceEvenly: chaque élément prend 1/n de l'espace
        final itemWidth = size.width / data.length;
        x = itemWidth * i + itemWidth / 2;
      } else {
        // Pour spaceBetween avec padding
        final availableWidth = size.width - (2 * horizontalPadding);
        if (data.length == 1) {
          x = size.width / 2;
        } else {
          final spacing = availableWidth / (data.length - 1);
          x = horizontalPadding + (spacing * i);
        }
      }

      final y = size.height - (data[i].value / maxValue * size.height);

      // Palette de couleurs pour les points (correspond aux barres)
      final pointColors = [
        baseColor,
        baseColor.withValues(alpha: 0.8),
        baseColor.withValues(alpha: 0.6),
      ];

      final pointColor = pointColors[i % pointColors.length];

      // Ombre profonde pour meilleur contraste
      final shadowPaint = Paint()
        ..color = DeepColorTokens.shadowMedium
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0);

      canvas.drawCircle(
        Offset(x, y),
        connectionPointBackgroundRadius,
        shadowPaint,
      );

      // Cercle neutre de fond pour visibilité
      final backgroundPaint = Paint()
        ..color = DeepColorTokens.neutral0
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(x, y),
        connectionPointBackgroundRadius,
        backgroundPaint,
      );

      // Cercle principal coloré
      final pointPaint = Paint()
        ..color = pointColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(x, y),
        connectionPointRadius,
        pointPaint,
      );

      // Bordure du point pour définition
      final borderPaint = Paint()
        ..color = pointColor.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(
        Offset(x, y),
        connectionPointRadius,
        borderPaint,
      );
    }

    // Ajouter un effet d'ombre subtile sous la ligne
    final lineShadowPaint = Paint()
      ..color = DeepColorTokens.shadowLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0);

    canvas.drawPath(path, lineShadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
