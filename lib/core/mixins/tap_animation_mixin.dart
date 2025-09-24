import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Mixin pour ajouter des animations de tap aux widgets
mixin TapAnimationMixin<T extends StatefulWidget> on State<T> implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'created by $this');
  }
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _elevationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Animation de scale pour le tap
  Animation<double> get scaleAnimation => _scaleAnimation;

  /// Animation d'elevation pour le tap
  Animation<double> get elevationAnimation => _elevationAnimation;

  /// Contrôleur d'animation
  AnimationController get animationController => _controller;

  /// Gestionnaire pour onTapDown
  void handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  /// Gestionnaire pour onTapUp
  void handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  /// Gestionnaire pour onTapCancel
  void handleTapCancel() {
    _controller.reverse();
  }
}
