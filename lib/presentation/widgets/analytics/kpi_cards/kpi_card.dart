import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart' hide Animation;
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
      duration: EcoPlatesDesignTokens.analyticsCharts.kpiCardShimmerDuration,
      vsync: this,
    )..repeat();

    _shimmerAnimation =
        Tween<double>(
          begin: EcoPlatesDesignTokens
              .analyticsCharts
              .kpiCardShimmerAnimationBegin,
          end: EcoPlatesDesignTokens.analyticsCharts.kpiCardShimmerAnimationEnd,
        ).animate(
          CurvedAnimation(
            parent: _shimmerController,
            curve: Curves.easeInOut,
          ),
        );
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  EcoPlatesDesignTokens.analyticsCharts.kpiCardShimmerColors,
              stops: [
                0.0,
                _shimmerAnimation.value.abs(),
                1.0,
              ],
            ),
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.analyticsCharts.kpiCardShimmerBorderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerShadowColor
                    .withValues(
                      alpha: EcoPlatesDesignTokens
                          .analyticsCharts
                          .kpiCardShimmerShadowAlpha,
                    ),
                blurRadius: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerShadowBlurRadius,
                offset: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerShadowOffset,
              ),
            ],
          ),
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.analyticsCharts.kpiCardPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShimmerIconSize,
                    height: EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShimmerIconHeight,
                    decoration: BoxDecoration(
                      color: EcoPlatesDesignTokens
                          .analyticsCharts
                          .kpiCardShimmerIconBackgroundColor
                          .withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .kpiCardShimmerIconBackgroundAlpha,
                          ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShimmerHeaderHorizontalSpacing,
                  ),
                  Container(
                    height: EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShimmerTitleHeight,
                    width: EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShimmerTitleWidth,
                    decoration: BoxDecoration(
                      color: EcoPlatesDesignTokens
                          .analyticsCharts
                          .kpiCardShimmerIconBackgroundColor
                          .withValues(
                            alpha: EcoPlatesDesignTokens
                                .analyticsCharts
                                .kpiCardShimmerBarBackgroundAlpha,
                          ),
                      borderRadius: BorderRadius.circular(
                        EcoPlatesDesignTokens
                            .analyticsCharts
                            .kpiCardShimmerTitleBorderRadius,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerVerticalSpacing,
              ),
              Container(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerValueHeight,
                width: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerValueWidth,
                decoration: BoxDecoration(
                  color: EcoPlatesDesignTokens
                      .analyticsCharts
                      .kpiCardShimmerIconBackgroundColor
                      .withValues(
                        alpha: EcoPlatesDesignTokens
                            .analyticsCharts
                            .kpiCardShimmerBarBackgroundAlpha,
                      ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShimmerValueBorderRadius,
                  ),
                ),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerVerticalSpacingSmall,
              ),
              Container(
                height: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerGrowthHeight,
                width: EcoPlatesDesignTokens
                    .analyticsCharts
                    .kpiCardShimmerGrowthWidth,
                decoration: BoxDecoration(
                  color: EcoPlatesDesignTokens
                      .analyticsCharts
                      .kpiCardShimmerIconBackgroundColor
                      .withValues(
                        alpha: EcoPlatesDesignTokens
                            .analyticsCharts
                            .kpiCardShimmerBarBackgroundAlphaLow,
                      ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShimmerGrowthBorderRadius,
                  ),
                ),
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

/// Carte KPI réutilisable avec design amélioré
class KpiCard extends StatefulWidget {
  const KpiCard({
    required this.config,
    required this.analytics,
    super.key,
  });

  final KpiCardConfig config;
  final AnalyticsStats analytics;

  @override
  State<KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<KpiCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: EcoPlatesDesignTokens.analyticsCharts.kpiCardAnimationDuration,
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(
          begin:
              EcoPlatesDesignTokens.analyticsCharts.kpiCardScaleAnimationBegin,
          end: EcoPlatesDesignTokens.analyticsCharts.kpiCardScaleAnimationEnd,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
          ),
        );

    _glowAnimation =
        Tween<double>(
          begin:
              EcoPlatesDesignTokens.analyticsCharts.kpiCardGlowAnimationBegin,
          end: EcoPlatesDesignTokens.analyticsCharts.kpiCardGlowAnimationEnd,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    unawaited(_animationController.forward());
  }

  void _onTapUp(TapUpDetails details) {
    unawaited(_animationController.reverse());
  }

  void _onTapCancel() {
    unawaited(_animationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final growthPercentage = widget.config.getGrowth(widget.analytics);
    final isPositiveGrowth = widget.config.getIsPositive(widget.analytics);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.config.gradientColors,
              ),
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.analyticsCharts.kpiCardBorderRadius(
                  context,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.config.primaryColor.withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShadowPrimaryAlpha,
                  ),
                  blurRadius:
                      EcoPlatesDesignTokens
                          .analyticsCharts
                          .kpiCardShadowPrimaryBlurRadius +
                      _glowAnimation.value,
                  offset: EcoPlatesDesignTokens
                      .analyticsCharts
                      .kpiCardShadowPrimaryOffset,
                  spreadRadius: _glowAnimation.value / 2,
                ),
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(
                    alpha: EcoPlatesDesignTokens
                        .analyticsCharts
                        .kpiCardShadowSecondaryAlpha,
                  ),
                  blurRadius: EcoPlatesDesignTokens
                      .analyticsCharts
                      .kpiCardShadowSecondaryBlurRadius,
                  offset: EcoPlatesDesignTokens
                      .analyticsCharts
                      .kpiCardShadowSecondaryOffset,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.analyticsCharts.kpiCardBorderRadius(
                    context,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    EcoPlatesDesignTokens.analyticsCharts.kpiCardPadding(
                      context,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.analyticsCharts.kpiCardBorderRadius(
                        context,
                      ),
                    ),
                    border: Border.all(
                      color: widget.config.primaryColor.withValues(
                        alpha: EcoPlatesDesignTokens
                            .analyticsCharts
                            .kpiCardBorderAlpha,
                      ),
                      width: EcoPlatesDesignTokens
                          .analyticsCharts
                          .kpiCardBorderWidth,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header avec icône et titre
                      Row(
                        children: [
                          // Icône avec cercle coloré
                          Container(
                            padding: EdgeInsets.all(
                              EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .kpiCardIconPadding,
                            ),
                            decoration: BoxDecoration(
                              color: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .kpiCardTitleColor
                                  .withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .analyticsCharts
                                        .kpiCardIconBackgroundAlpha,
                                  ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.config.primaryColor.withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .analyticsCharts
                                        .kpiCardIconShadowAlpha,
                                  ),
                                  blurRadius: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .kpiCardIconShadowBlurRadius,
                                  offset: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .kpiCardIconShadowOffset,
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.config.icon,
                              size: EcoPlatesDesignTokens.analyticsCharts
                                  .kpiCardIconSize(context),
                              color: widget.config.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: EcoPlatesDesignTokens.analyticsCharts
                                .kpiCardHeaderHorizontalSpacing(context),
                          ),
                          Expanded(
                            child: Text(
                              _getTitle(context),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: EcoPlatesDesignTokens
                                    .analyticsCharts
                                    .kpiCardTitleColor
                                    .withValues(
                                      alpha: EcoPlatesDesignTokens
                                          .analyticsCharts
                                          .kpiCardTitleAlpha,
                                    ),
                                fontSize: EcoPlatesDesignTokens.analyticsCharts
                                    .kpiCardTitleFontSize(context),
                                fontWeight: EcoPlatesDesignTokens
                                    .analyticsCharts
                                    .kpiCardTitleWeight,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: EcoPlatesDesignTokens.analyticsCharts
                            .kpiCardHeaderVerticalSpacing(context),
                      ),

                      // Valeur principale
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.config.getValue(widget.analytics),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: EcoPlatesDesignTokens
                                .analyticsCharts
                                .kpiCardValueWeight,
                            fontSize: EcoPlatesDesignTokens.analyticsCharts
                                .kpiCardValueFontSize(context),
                            color: EcoPlatesDesignTokens
                                .analyticsCharts
                                .kpiCardValueColor
                                .withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .kpiCardValueAlpha,
                                ),
                            letterSpacing: EcoPlatesDesignTokens
                                .analyticsCharts
                                .kpiCardValueLetterSpacing,
                          ),
                        ),
                      ),

                      // Indicateur de croissance
                      if (growthPercentage != null &&
                          isPositiveGrowth != null) ...[
                        SizedBox(
                          height: EcoPlatesDesignTokens.analyticsCharts
                              .kpiCardValueVerticalSpacing(context),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: EcoPlatesDesignTokens.analyticsCharts
                                .kpiCardGrowthHorizontalPadding(context),
                            vertical: EcoPlatesDesignTokens.analyticsCharts
                                .kpiCardGrowthVerticalPadding(context),
                          ),
                          decoration: BoxDecoration(
                            color: EcoPlatesDesignTokens
                                .analyticsCharts
                                .kpiCardGrowthBackgroundColor
                                .withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .kpiCardGrowthBackgroundAlpha,
                                ),
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .kpiCardGrowthBorderRadius,
                            ),
                            border: Border.all(
                              color: EcoPlatesDesignTokens
                                  .analyticsCharts
                                  .kpiCardGrowthBorderColor
                                  .withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .analyticsCharts
                                        .kpiCardGrowthBorderAlpha,
                                  ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPositiveGrowth
                                    ? Icons.trending_up
                                    : Icons.trending_down,
                                size: EcoPlatesDesignTokens.analyticsCharts
                                    .kpiCardTrendIconSize(context),
                                color: EcoPlatesDesignTokens
                                    .analyticsCharts
                                    .kpiCardGrowthTextColor
                                    .withValues(
                                      alpha: EcoPlatesDesignTokens
                                          .analyticsCharts
                                          .kpiCardGrowthAlpha,
                                    ),
                              ),
                              SizedBox(
                                width: EcoPlatesDesignTokens.analyticsCharts
                                    .kpiCardGrowthInnerSpacing(context),
                              ),
                              Text(
                                '${growthPercentage.abs().toStringAsFixed(1)}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .kpiCardGrowthTextColor
                                      .withValues(
                                        alpha: EcoPlatesDesignTokens
                                            .analyticsCharts
                                            .kpiCardGrowthAlpha,
                                      ),
                                  fontWeight: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .kpiCardGrowthWeight,
                                  fontSize: EcoPlatesDesignTokens
                                      .analyticsCharts
                                      .kpiCardGrowthFontSize(context),
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
          ),
        );
      },
    );
  }

  String _getTitle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact =
        screenWidth <=
        EcoPlatesDesignTokens.analyticsCharts.kpiCardCompactTitleBreakpoint;
    return isCompact && widget.config.compactTitle != null
        ? widget.config.compactTitle!
        : widget.config.title;
  }
}
