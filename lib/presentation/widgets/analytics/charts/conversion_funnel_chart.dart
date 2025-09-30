import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
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
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    DeepColorTokens.primaryContainer.withValues(alpha: 0.8),
                    DeepColorTokens.secondaryContainer.withValues(alpha: 0.6),
                    DeepColorTokens.tertiaryContainer.withValues(alpha: 0.4),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: DeepColorTokens.neutral400.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: DeepColorTokens.shadowLight,
                    blurRadius: 12.0,
                    offset: const Offset(0, 4.0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      FunnelHeader(analytics: widget.analytics),

                      const SizedBox(height: 16.0),

                      // Funnel visuel avec animations
                      const _FunnelVisualization(),

                      const SizedBox(height: 16.0),

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - 32.0;
        final maxWidth = availableWidth.clamp(200.0, 400.0);
        const minWidth = 80.0;

        return SizedBox(
          height: analytics.conversionFunnel.length * 60.0 + 20.0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Ligne centrale de guidage
              Positioned(
                top: 20.0,
                bottom: 20.0,
                child: Container(
                  width: 2.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        DeepColorTokens.primary.withValues(alpha: 0.8),
                        DeepColorTokens.primary.withValues(alpha: 0.4),
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
                  top: index * 60.0,
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
