import 'package:flutter/material.dart';

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
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              0.0,
              0.6,
              curve: Curves.easeOut,
            ),
          ),
        );

    _scaleAnimation =
        Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              0.2,
              0.8,
              curve: Curves.elasticOut,
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
      begin: -50.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          0.6 + index * 0.2,
          curve: Curves.easeOutBack,
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
