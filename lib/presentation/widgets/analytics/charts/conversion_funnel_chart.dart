import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_stats.dart';

/// Graphique du funnel de conversion - visualisation unique et innovante
class ConversionFunnelChart extends StatelessWidget {
  const ConversionFunnelChart({
    required this.analytics,
    super.key,
  });

  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE3F2FD).withValues(alpha: 0.8), // Bleu très clair
            const Color(0xFFF3E5F5).withValues(alpha: 0.6), // Violet très clair
            const Color(0xFFFFF3E0).withValues(alpha: 0.4), // Orange très clair
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.filter_alt,
                  size: 20,
                  color: Color(0xFF2196F3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Funnel de Conversion',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Parcours client de la visite à la livraison',
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

          const SizedBox(height: 24),

          // Funnel visuel
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth =
                  constraints.maxWidth - 40; // Soustraire le padding
              final maxWidth = availableWidth.clamp(
                200.0,
                280.0,
              ); // Limiter entre 200 et 280
              const minWidth = 60.0;

              return SizedBox(
                height: 250, // Réduire la hauteur pour éviter l'overflowr
                child: Stack(
                  alignment: Alignment.center,
                  children: analytics.conversionFunnel.reversed.map((step) {
                    final index = analytics.conversionFunnel.indexOf(step);
                    final reversedIndex =
                        analytics.conversionFunnel.length - 1 - index;
                    final stepWidth =
                        maxWidth -
                        (reversedIndex *
                            (maxWidth - minWidth) /
                            (analytics.conversionFunnel.length - 1));

                    return Positioned(
                      top:
                          reversedIndex * 35.0, // Réduire l'espacement vertical
                      child: _buildFunnelStep(
                        step,
                        stepWidth,
                        index ==
                            analytics.conversionFunnel.length -
                                1, // Dernière étape
                        context,
                        availableWidth,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Légende des couleurs
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: analytics.conversionFunnel.map((step) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(step.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    step.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFunnelStep(
    FunnelStep step,
    double width,
    bool isLast,
    BuildContext context,
    double maxWidth,
  ) {
    final isFirst = step.step == 1;

    return SizedBox(
      width: maxWidth + 40, // Ajuster la largeur du container
      child: Column(
        children: [
          // Étape du funnel
          Stack(
            alignment: Alignment.center,
            children: [
              // Forme trapézoïdale pour le funnel
              Container(
                width: width,
                height: 28, // Réduire la hauteur des étapes
                decoration: BoxDecoration(
                  color: Color(step.color).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Color(step.color).withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Bordure supérieure pour créer l'effet funnel
                    if (!isFirst)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Color(step.color).withValues(alpha: 0.9),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    // Contenu centré
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            step.count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${step.percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Ligne de connexion vers l'étape suivante (sauf dernière)
              if (!isLast)
                Positioned(
                  bottom: -12,
                  child: Container(
                    width: 2,
                    height: 12,
                    color: Color(step.color).withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),

          // Label supprimé selon la demande
        ],
      ),
    );
  }
}
