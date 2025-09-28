import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';
import '../../../../domain/entities/analytics_stats.dart';
import 'funnel_animation_mixin.dart';
import 'funnel_header.dart';
import 'funnel_stats_section.dart';
import 'funnel_step_widget.dart';

/// Graphique du funnel de conversion - visualisation unique et innovante
/// Affiche le parcours client de la visite à la conversion avec des animations
class ConversionFunnelChart extends StatefulWidget {
  const ConversionFunnelChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  State<ConversionFunnelChart> createState() => _ConversionFunnelChartState();
}

class _ConversionFunnelChartState extends State<ConversionFunnelChart>
    with
        SingleTickerProviderStateMixin,
        FunnelAnimationMixin<ConversionFunnelChart> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: ConversionFunnelConstants.containerMargin,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primaryContainer.withValues(
                      alpha: ConversionFunnelConstants.primaryContainerAlpha,
                    ),
                    theme.colorScheme.secondaryContainer.withValues(
                      alpha: ConversionFunnelConstants.secondaryContainerAlpha,
                    ),
                    theme.colorScheme.tertiaryContainer.withValues(
                      alpha: ConversionFunnelConstants.tertiaryContainerAlpha,
                    ),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  ConversionFunnelConstants.containerBorderRadius,
                ),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(
                    alpha: ConversionFunnelConstants.outlineAlpha,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(
                      alpha: ConversionFunnelConstants.primaryShadowAlpha,
                    ),
                    blurRadius: ConversionFunnelConstants.shadowBlurRadius,
                    offset: const Offset(
                      0,
                      ConversionFunnelConstants.shadowOffsetY,
                    ),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  ConversionFunnelConstants.containerBorderRadius,
                ),
                child: Container(
                  padding: const EdgeInsets.all(
                    ConversionFunnelConstants.headerPadding,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ConversionFunnelConstants.white.withValues(
                          alpha: ConversionFunnelConstants.whiteOverlayAlpha1,
                        ),
                        ConversionFunnelConstants.white.withValues(
                          alpha: ConversionFunnelConstants.whiteOverlayAlpha2,
                        ),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      FunnelHeader(analytics: widget.analytics),

                      const SizedBox(
                        height: ConversionFunnelConstants.contentSpacing,
                      ),

                      // Funnel visuel avec animations
                      const _FunnelVisualization(),

                      const SizedBox(
                        height: ConversionFunnelConstants.contentSpacing,
                      ),

                      // Statistiques clés
                      FunnelStatsSection(analytics: widget.analytics),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget privé pour la visualisation du funnel
class _FunnelVisualization extends StatelessWidget {
  const _FunnelVisualization();
  @override
  Widget build(BuildContext context) {
    final analytics = context
        .findAncestorStateOfType<_ConversionFunnelChartState>()!
        .widget
        .analytics;
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            constraints.maxWidth -
            ConversionFunnelConstants.funnelChartHorizontalPadding;
        final maxWidth = availableWidth.clamp(
          ConversionFunnelConstants.maxWidthClamped,
          ConversionFunnelConstants.maxWidthDefault,
        );
        const minWidth = ConversionFunnelConstants.minWidth;

        return SizedBox(
          height:
              analytics.conversionFunnel.length *
                  ConversionFunnelConstants.funnelHeight +
              ConversionFunnelConstants.funnelSpacing,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Ligne centrale de guidage
              Positioned(
                top: ConversionFunnelConstants.centerLineTop,
                bottom: ConversionFunnelConstants.centerLineBottom,
                child: Container(
                  width: ConversionFunnelConstants.centerLineWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.primary.withValues(
                          alpha:
                              ConversionFunnelConstants.primaryContainerAlpha,
                        ),
                        theme.colorScheme.primary.withValues(
                          alpha:
                              ConversionFunnelConstants.tertiaryContainerAlpha,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Étapes du funnel
              ...analytics.conversionFunnel.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                final stepWidth =
                    maxWidth -
                    (index *
                        (maxWidth - minWidth) /
                        (analytics.conversionFunnel.length - 1));

                return Positioned(
                  top: index * ConversionFunnelConstants.funnelHeight,
                  left: (availableWidth - stepWidth) / 2,
                  right: (availableWidth - stepWidth) / 2,
                  child: FunnelStepWidget(
                    step: step,
                    index: index,
                    isLast: index == analytics.conversionFunnel.length - 1,
                    analytics: analytics,
                    width: stepWidth,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
