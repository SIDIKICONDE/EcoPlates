import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

/// Mixin pour gérer les animations du tunnel de conversion
mixin FunnelAnimationMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  AnimationController get animationController => _animationController;
  Animation<double> get fadeAnimation => _fadeAnimation;
  Animation<double> get scaleAnimation => _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialisation SYNCHRONE pour éviter LateInitializationError
    _animationController = AnimationController(
      duration: ConversionFunnelConstants.animationDuration,
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(
          begin: ConversionFunnelConstants.fadeBegin,
          end: ConversionFunnelConstants.fadeEnd,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              ConversionFunnelConstants.fadeIntervalBegin,
              ConversionFunnelConstants.fadeIntervalEnd,
              curve: ConversionFunnelConstants.fadeCurve,
            ),
          ),
        );

    _scaleAnimation =
        Tween<double>(
          begin: ConversionFunnelConstants.scaleBegin,
          end: ConversionFunnelConstants.scaleEnd,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              ConversionFunnelConstants.scaleIntervalBegin,
              ConversionFunnelConstants.scaleIntervalEnd,
              curve: ConversionFunnelConstants.scaleCurve,
            ),
          ),
        );

    // Démarrer après le premier frame pour éviter le jank
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  /// Crée une animation de slide pour une étape spécifique
  Animation<double> createStepSlideAnimation(int index) {
    return Tween<double>(
      begin: ConversionFunnelConstants.slideBegin,
      end: ConversionFunnelConstants.slideEnd,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * ConversionFunnelConstants.stepAnimationDelay,
          ConversionFunnelConstants.fadeIntervalEnd +
              index * ConversionFunnelConstants.stepAnimationDelay,
          curve: ConversionFunnelConstants.slideCurve,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
