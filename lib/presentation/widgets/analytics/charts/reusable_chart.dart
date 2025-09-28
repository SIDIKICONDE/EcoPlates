import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
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
        horizontal: EcoPlatesDesignTokens.analyticsCharts.chartPadding(context),
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.analyticsCharts.headerElementPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec titre, icône et compteur
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: EcoPlatesDesignTokens.analyticsCharts
                      .headerElementPadding(context),
                  vertical:
                      EcoPlatesDesignTokens.analyticsCharts
                          .headerElementPadding(context) -
                      EcoPlatesDesignTokens
                          .analyticsCharts
                          .headerVerticalPaddingAdjustment,
                ),
                decoration: BoxDecoration(
                  color: widget.config.iconColor.withValues(
                    alpha: EcoPlatesDesignTokens.analyticsCharts.tertiaryAlpha,
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.analyticsCharts.defaultBorderRadius,
                  ),
                  border: Border.all(
                    color: widget.config.iconColor.withValues(
                      alpha: EcoPlatesDesignTokens.analyticsCharts.surfaceAlpha,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        EcoPlatesDesignTokens.analyticsCharts
                                .headerElementPadding(context) -
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .iconPaddingAdjustment,
                      ),
                      decoration: BoxDecoration(
                        color: widget.config.iconColor.withValues(
                          alpha:
                              EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .surfaceAlpha -
                              EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .surfaceAlphaAdjustmentSmall,
                        ),
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .defaultBorderRadius -
                              EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .iconBorderRadiusAdjustment,
                        ),
                      ),
                      child: Icon(
                        widget.config.icon,
                        size: EcoPlatesDesignTokens.analyticsCharts.iconSize(
                          context,
                        ),
                        color: widget.config.iconColor,
                      ),
                    ),
                    SizedBox(
                      width: EcoPlatesDesignTokens.analyticsCharts
                          .iconTextSpacing(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.config.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          fontSize: EcoPlatesDesignTokens.analyticsCharts
                              .titleFontSize(context),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            EcoPlatesDesignTokens.analyticsCharts
                                .headerElementPadding(context) -
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .counterHorizontalPaddingAdjustment,
                        vertical:
                            EcoPlatesDesignTokens.analyticsCharts
                                .headerElementPadding(context) -
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .counterVerticalPaddingAdjustment,
                      ),
                      decoration: BoxDecoration(
                        color: widget.config.iconColor.withValues(
                          alpha:
                              EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .surfaceAlpha -
                              EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .surfaceAlphaAdjustmentSmall,
                        ),
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens
                              .analyticsCharts
                              .defaultBorderRadius,
                        ),
                        border: Border.all(
                          color: widget.config.iconColor.withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .secondaryBorderAlpha,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.config.valueFormatter(widget.config.totalValue),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: widget.config.iconColor,
                          fontWeight: FontWeight.w800,
                          fontSize: EcoPlatesDesignTokens.analyticsCharts
                              .counterFontSize(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height:
                    EcoPlatesDesignTokens.analyticsCharts.gridToLabelsSpacing,
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
        height: EcoPlatesDesignTokens.analyticsCharts.chartContainerHeight(
          context,
        ),
        alignment: Alignment.center,
        child: Text(
          EcoPlatesDesignTokens.analyticsCharts.noDataText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Container(
      height: EcoPlatesDesignTokens.analyticsCharts.chartContainerHeight(
        context,
      ),
      padding: EdgeInsets.all(
        EcoPlatesDesignTokens.analyticsCharts.chartVerticalPadding(context),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: EcoPlatesDesignTokens.analyticsCharts.surfaceAlpha,
            ),
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: EcoPlatesDesignTokens.analyticsCharts.surfaceHighAlpha,
            ),
            theme.colorScheme.surface.withValues(
              alpha: EcoPlatesDesignTokens.analyticsCharts.tertiaryAlpha,
            ),
          ],
          stops: EcoPlatesDesignTokens.analyticsCharts.gradientStops,
        ),
        borderRadius: BorderRadius.circular(
          EcoPlatesDesignTokens.analyticsCharts.chartBorderRadius,
        ),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.analyticsCharts.outlineAlpha,
          ),
          width: EcoPlatesDesignTokens.analyticsCharts.chartBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: EcoPlatesDesignTokens.analyticsCharts.shadowAlpha,
            ),
            blurRadius: EcoPlatesDesignTokens.analyticsCharts.shadowBlurRadius,
            offset: EcoPlatesDesignTokens.analyticsCharts.shadowOffset,
            spreadRadius:
                EcoPlatesDesignTokens.analyticsCharts.chartShadowSpreadRadius,
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: EcoPlatesDesignTokens.analyticsCharts.tertiaryAlpha,
            ),
            blurRadius:
                EcoPlatesDesignTokens.analyticsCharts.secondaryShadowBlurRadius,
            offset: EcoPlatesDesignTokens.analyticsCharts.secondaryShadowOffset,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculer la largeur dynamique en fonction du nombre de points
          final calculatedWidth = EcoPlatesDesignTokens.analyticsCharts
              .calculateTotalWidthResponsive(points.length, context);
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
                                  : EcoPlatesDesignTokens.analyticsCharts
                                            .barSpacing(context) /
                                        2,
                              connectionPointRadius: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .connectionPointRadius(context),
                              connectionPointBackgroundRadius:
                                  EcoPlatesDesignTokens.analyticsCharts
                                      .connectionPointBackgroundRadius(context),
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
                              horizontal:
                                  EcoPlatesDesignTokens.analyticsCharts
                                      .barSpacing(context) /
                                  2,
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
                    height: EcoPlatesDesignTokens
                        .analyticsCharts
                        .gridToLabelsSpacing,
                  ),
                  if (chartWidth > calculatedWidth)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: points
                          .map(
                            (point) => Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      EcoPlatesDesignTokens.analyticsCharts
                                          .barWidth(context) +
                                      EcoPlatesDesignTokens
                                          .analyticsCharts
                                          .labelConstraintExtraWidth,
                                ),
                                child: Text(
                                  point.label,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: EcoPlatesDesignTokens
                                        .analyticsCharts
                                        .labelFontSize(context),
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
                        horizontal:
                            EcoPlatesDesignTokens.analyticsCharts.barSpacing(
                              context,
                            ) /
                            2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: points
                            .map(
                              (point) => SizedBox(
                                width: EcoPlatesDesignTokens.analyticsCharts
                                    .barWidth(context),
                                child: Text(
                                  point.label,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: EcoPlatesDesignTokens
                                        .analyticsCharts
                                        .labelFontSize(context),
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
    final barHeight =
        normalizedHeight *
        EcoPlatesDesignTokens.analyticsCharts.maxBarHeight(context);

    // Palette de couleurs variées pour chaque barre
    final barColors = [
      theme.colorScheme.secondary,
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
      ...EcoPlatesDesignTokens.analyticsCharts.barColorsHex.map(Color.new),
    ];

    final barColor = barColors[pointIndex % barColors.length];

    // Calculer si la barre est suffisamment haute pour afficher le texte au-dessus
    final clampedBarHeight = barHeight.clamp(
      EcoPlatesDesignTokens.analyticsCharts.minBarHeight,
      EcoPlatesDesignTokens.analyticsCharts.maxBarHeight(context),
    );
    final availableSpaceForText =
        EcoPlatesDesignTokens.analyticsCharts.chartContainerHeight(context) -
        EcoPlatesDesignTokens.analyticsCharts.chartVerticalPadding(context) *
            EcoPlatesDesignTokens
                .analyticsCharts
                .chartVerticalPaddingMultiplier -
        EcoPlatesDesignTokens.analyticsCharts.gridToLabelsSpacing -
        clampedBarHeight -
        EcoPlatesDesignTokens.analyticsCharts.valueToBarSpacing;

    // Ne montrer le texte que s'il y a au moins le seuil minimal d'espace disponible
    final showValueText =
        availableSpaceForText >=
        EcoPlatesDesignTokens.analyticsCharts.minSpaceForValueText;

    return SizedBox(
      width: EcoPlatesDesignTokens.analyticsCharts.barWidth(context),
      child: Stack(
        clipBehavior: Clip.none, // Permet le débordement
        alignment: Alignment.bottomCenter,
        children: [
          // Colonne contenant la barre
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Espace pour la valeur
              if (showValueText)
                SizedBox(
                  height: EcoPlatesDesignTokens.analyticsCharts
                      .valueTextReservedHeight(context),
                ),
              // Barre verticale avec dégradé
              Container(
                width: EcoPlatesDesignTokens.analyticsCharts.barWidth(context),
                height: clampedBarHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      barColor.withValues(
                        alpha:
                            EcoPlatesDesignTokens.analyticsCharts.surfaceAlpha +
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .barGradientAlpha1,
                      ),
                      barColor.withValues(
                        alpha:
                            EcoPlatesDesignTokens.analyticsCharts.surfaceAlpha +
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .barGradientAlpha2,
                      ),
                      barColor.withValues(
                        alpha:
                            EcoPlatesDesignTokens.analyticsCharts.surfaceAlpha +
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .barGradientAlpha3,
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.analyticsCharts.barBorderRadius,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: barColor.withValues(
                        alpha:
                            EcoPlatesDesignTokens.analyticsCharts.surfaceAlpha +
                            EcoPlatesDesignTokens
                                .analyticsCharts
                                .barShadowAlpha,
                      ),
                      blurRadius: EcoPlatesDesignTokens
                          .analyticsCharts
                          .barShadowBlurRadius,
                      offset:
                          EcoPlatesDesignTokens.analyticsCharts.barShadowOffset,
                    ),
                  ],
                  border: Border.all(
                    color: barColor.withValues(
                      alpha:
                          EcoPlatesDesignTokens.analyticsCharts.surfaceAlpha +
                          EcoPlatesDesignTokens.analyticsCharts.barBorderAlpha,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Valeur positionnée au-dessus de la barre
          if (showValueText)
            Positioned(
              bottom:
                  clampedBarHeight +
                  EcoPlatesDesignTokens.analyticsCharts.valueToBarSpacing,
              child: Container(
                padding:
                    EcoPlatesDesignTokens.analyticsCharts.valueContainerPadding,
                decoration: BoxDecoration(
                  color: EcoPlatesDesignTokens
                      .analyticsCharts
                      .valueContainerBackgroundColor
                      .withValues(
                        alpha: EcoPlatesDesignTokens
                            .analyticsCharts
                            .valueContainerBackgroundAlpha,
                      ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .valueContainerBorderRadius,
                  ),
                ),
                child: Text(
                  widget.config.valueFormatter(point.value),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: EcoPlatesDesignTokens.analyticsCharts
                        .valueFontSize(context),
                    fontWeight: FontWeight.w700,
                    color: EcoPlatesDesignTokens.analyticsCharts.valueTextColor,
                    letterSpacing: EcoPlatesDesignTokens
                        .analyticsCharts
                        .valueTextLetterSpacing,
                    shadows: [
                      Shadow(
                        color: EcoPlatesDesignTokens
                            .analyticsCharts
                            .valueTextShadowColor
                            .withValues(
                              alpha: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .valueTextShadowAlpha,
                            ),
                        offset: EcoPlatesDesignTokens
                            .analyticsCharts
                            .valueTextShadowOffset,
                        blurRadius: EcoPlatesDesignTokens
                            .analyticsCharts
                            .valueTextShadowBlurRadius,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: false, // Empêche le retour à la ligne
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
  void paint(Canvas canvas, ui.Size size) {
    // Peinture pour les lignes principales
    final majorGridPaint = Paint()
      ..color = theme.colorScheme.outline.withValues(
        alpha: EcoPlatesDesignTokens.analyticsCharts.surfaceAlpha,
      )
      ..strokeWidth =
          EcoPlatesDesignTokens.analyticsCharts.majorGridStrokeWidth;

    // Peinture pour les lignes secondaires (plus subtiles)
    final minorGridPaint = Paint()
      ..color = theme.colorScheme.outline.withValues(
        alpha: EcoPlatesDesignTokens.analyticsCharts.surfaceHighAlpha,
      )
      ..strokeWidth =
          EcoPlatesDesignTokens.analyticsCharts.minorGridStrokeWidth;

    // Lignes horizontales principales
    for (
      var i = 1;
      i <= EcoPlatesDesignTokens.analyticsCharts.majorGridLines;
      i++
    ) {
      final y =
          (size.height / EcoPlatesDesignTokens.analyticsCharts.majorGridLines) *
          i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), majorGridPaint);

      // Ajouter des lignes mineures entre les principales
      if (i < EcoPlatesDesignTokens.analyticsCharts.majorGridLines) {
        final midY =
            y +
            (size.height /
                    EcoPlatesDesignTokens.analyticsCharts.majorGridLines) /
                2;
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
          alpha:
              EcoPlatesDesignTokens.analyticsCharts.tertiaryAlpha -
              EcoPlatesDesignTokens
                  .analyticsCharts
                  .backgroundGradientAdjustment1,
        ),
        theme.colorScheme.secondary.withValues(
          alpha:
              EcoPlatesDesignTokens.analyticsCharts.tertiaryAlpha -
              EcoPlatesDesignTokens
                  .analyticsCharts
                  .backgroundGradientAdjustment2,
        ),
        EcoPlatesDesignTokens.analyticsCharts.transparentColor,
      ],
      stops: EcoPlatesDesignTokens.analyticsCharts.gradientStops,
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
        alpha: EcoPlatesDesignTokens.analyticsCharts.tertiaryAlpha,
      )
      ..style = PaintingStyle.fill;

    // Points aux intersections de la grille
    for (
      var i = 1;
      i <= EcoPlatesDesignTokens.analyticsCharts.majorGridLines;
      i++
    ) {
      final y =
          (size.height /
              EcoPlatesDesignTokens.analyticsCharts.chartGridLinesDivisor) *
          i;
      for (var j = 0; j <= pointCount; j++) {
        final x = (size.width / pointCount) * j;
        canvas.drawCircle(
          Offset(x, y),
          EcoPlatesDesignTokens.analyticsCharts.gridDotRadius,
          dotPaint,
        );
      }
    }
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
    this.connectionPointRadius = 5.0,
    this.connectionPointBackgroundRadius = 7.0,
  });

  final List<DataPoint> data;
  final Color baseColor;
  final bool useSpaceEvenly;
  final double horizontalPadding;
  final double connectionPointRadius;
  final double connectionPointBackgroundRadius;

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
    final lineGradient = LinearGradient(
      colors: [
        EcoPlatesDesignTokens.analyticsCharts.connectionLineColor1.withValues(
          alpha: EcoPlatesDesignTokens.analyticsCharts.connectionLineAlpha1,
        ),
        EcoPlatesDesignTokens.analyticsCharts.connectionLineColor2.withValues(
          alpha: EcoPlatesDesignTokens.analyticsCharts.connectionLineAlpha2,
        ),
        EcoPlatesDesignTokens.analyticsCharts.connectionLineColor3.withValues(
          alpha: EcoPlatesDesignTokens.analyticsCharts.connectionLineAlpha3,
        ),
      ],
      stops: EcoPlatesDesignTokens.analyticsCharts.connectionLineGradientStops,
    );

    final linePaint = Paint()
      ..strokeWidth =
          EcoPlatesDesignTokens.analyticsCharts.connectionLineStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = lineGradient.createShader(
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      );

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
        ...EcoPlatesDesignTokens.analyticsCharts.connectionPointColorsHex.map(
          Color.new,
        ),
      ];

      final pointColor = pointColors[i % pointColors.length];

      // Ombre noire pour meilleur contraste
      final shadowPaint = Paint()
        ..color = EcoPlatesDesignTokens
            .analyticsCharts
            .connectionPointShadowColor
            .withValues(
              alpha: EcoPlatesDesignTokens
                  .analyticsCharts
                  .connectionPointShadowAlpha,
            )
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          EcoPlatesDesignTokens.analyticsCharts.connectionPointShadowBlurRadius,
        );
      canvas.drawCircle(
        Offset(
          x,
          y +
              EcoPlatesDesignTokens
                  .analyticsCharts
                  .connectionPointShadowOffsetY,
        ),
        connectionPointBackgroundRadius,
        shadowPaint,
      );

      // Cercle blanc de fond pour visibilité
      final whitePaint = Paint()
        ..color =
            EcoPlatesDesignTokens.analyticsCharts.connectionPointBackgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(x, y),
        connectionPointBackgroundRadius,
        whitePaint,
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
        ..color = pointColor.withValues(
          alpha:
              EcoPlatesDesignTokens.analyticsCharts.connectionPointBorderAlpha,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = EcoPlatesDesignTokens
            .analyticsCharts
            .connectionPointBorderStrokeWidth;
      canvas.drawCircle(
        Offset(x, y),
        connectionPointRadius,
        borderPaint,
      );
    }

    // Ajouter un effet d'ombre subtile sous la ligne
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(
        alpha: EcoPlatesDesignTokens.analyticsCharts.connectionLineShadowAlpha,
      )
      ..strokeWidth =
          EcoPlatesDesignTokens.analyticsCharts.connectionLineShadowStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        EcoPlatesDesignTokens.analyticsCharts.connectionLineShadowBlurRadius,
      );

    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
