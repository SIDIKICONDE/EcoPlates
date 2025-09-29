import 'package:flutter/material.dart';

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
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
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
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                height: 24,
                width: 120,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Container(
                height: 16,
                width: 60,
                color: Colors.grey,
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
    final theme = Theme.of(context);
    final growthPercentage = config.getGrowth(analytics);
    final isPositiveGrowth = config.getIsPositive(analytics);

    return Container(
      height: 120,
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
        color: Colors.transparent,
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
                        color: Colors.white24,
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
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 14.0,
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
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 24.0,
                      color: Colors.white,
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
                      color: Colors.white24,
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
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${growthPercentage.abs().toStringAsFixed(1)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
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
