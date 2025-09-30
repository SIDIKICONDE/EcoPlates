import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/analytics_stats.dart';

/// Widget de chargement avec effet shimmer pour les cartes KPI
class KpiCardShimmer extends StatefulWidget {
  const KpiCardShimmer({super.key});

  @override
  State<KpiCardShimmer> createState() => _KpiCardShimmerState();
}

class _KpiCardShimmerState extends State<KpiCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(_shimmerController);

    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                DeepColorTokens.neutral300,
                DeepColorTokens.neutral200,
                DeepColorTokens.neutral300,
              ],
              stops: [
                0.0,
                _shimmerAnimation.value,
                1.0,
              ],
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: DeepColorTokens.neutral400,
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 12,
                    width: 80,
                    color: DeepColorTokens.neutral400,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                height: 24,
                width: 120,
                color: DeepColorTokens.neutral400,
              ),
              SizedBox(height: 8),
              Container(
                height: 16,
                width: 60,
                color: DeepColorTokens.neutral400,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Configuration pour une carte KPI
class KpiCardConfig {
  const KpiCardConfig({
    required this.title,
    required this.getValue,
    required this.icon,
    required this.getGrowth,
    required this.getIsPositive,
    required this.primaryColor,
    required this.gradientColors,
    this.compactTitle,
  });

  final String title;
  final String? compactTitle;
  final String Function(AnalyticsStats) getValue;
  final IconData icon;
  final double? Function(AnalyticsStats) getGrowth;
  final bool? Function(AnalyticsStats) getIsPositive;
  final Color primaryColor;
  final List<Color> gradientColors;
}

/// Carte KPI réutilisable avec design simplifié
class KpiCard extends StatelessWidget {
  const KpiCard({
    required this.config,
    required this.analytics,
    super.key,
  });

  final KpiCardConfig config;
  final AnalyticsStats analytics;

  @override
  Widget build(BuildContext context) {
    final growthPercentage = config.getGrowth(analytics);
    final isPositiveGrowth = config.getIsPositive(analytics);

    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: config.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: config.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: DeepColorTokens.neutral1000.withValues(alpha: 0.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec icône et titre
                Row(
                  children: [
                    // Icône avec cercle coloré
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: DeepColorTokens.neutral0.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        config.icon,
                        size: 16.0,
                        color: config.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        _getTitle(context),
                        style: TextStyle(
                          color: DeepColorTokens.neutral0,
                          fontSize: FontSizes.caption.getSize(context),
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12.0),

                // Valeur principale
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    config.getValue(analytics),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: FontSizes.bodyLarge.getSize(context),
                      color: DeepColorTokens.neutral0,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // Indicateur de croissance
                if (growthPercentage != null && isPositiveGrowth != null) ...[
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: DeepColorTokens.neutral0.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositiveGrowth
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 14.0,
                          color: DeepColorTokens.neutral0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${growthPercentage.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: DeepColorTokens.neutral0,
                            fontWeight: FontWeight.w600,
                            fontSize: FontSizes.caption.getSize(context) * 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth <= 600;
    return isCompact && config.compactTitle != null
        ? config.compactTitle!
        : config.title;
  }
}
