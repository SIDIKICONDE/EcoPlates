import 'package:flutter/material.dart';

/// Gestionnaire d'animations pour les offres urgentes
class UrgentOffersAnimationManager {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isInitialized = false;

  AnimationController get animationController {
    assert(
      _isInitialized,
      'UrgentOffersAnimationManager must be initialized first',
    );
    return _animationController;
  }

  Animation<double> get pulseAnimation {
    assert(
      _isInitialized,
      'UrgentOffersAnimationManager must be initialized first',
    );
    return _pulseAnimation;
  }

  /// Initialise les animations (ne peut être appelée qu'une seule fois)
  void initializeAnimations(TickerProvider vsync) {
    if (_isInitialized) return; // Évite la double initialisation

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    )..repeat(reverse: true).ignore();

    _pulseAnimation =
        Tween<double>(
          begin: 0.9,
          end: 1.1,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _isInitialized = true;
  }

  /// Dispose des ressources d'animation
  void dispose() {
    if (_isInitialized) {
      _animationController.dispose();
    }
  }

  /// Widget animé avec pulsation pour les éléments urgents
  Widget buildPulsingWidget({
    required Widget child,
    required Animation<double> animation,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
    );
  }
}
