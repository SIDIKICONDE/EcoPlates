import 'package:flutter/material.dart';

/// Badge animé pour afficher le pourcentage de réduction avec accessibilité WCAG
class DiscountBadge extends StatelessWidget {
  const DiscountBadge({
    required this.discountPercentage,
    super.key,
    this.animationsEnabled = true,
  });
  final int discountPercentage;
  final bool animationsEnabled;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final shouldAnimate = animationsEnabled && !mediaQuery.disableAnimations;

    // Couleurs accessibles WCAG
    const backgroundColor = Colors.red;
    const textColor = Colors.white;

    final badge = Semantics(
      label: 'Réduction de $discountPercentage pourcent',
      button: false,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 8.0,
              offset: Offset(0, 4.0),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.discount,
              size: 14.0,
              color: textColor,
            ),
            SizedBox(width: 4.0),
            Text(
              '-$discountPercentage%',
              style: TextStyle(
                color: textColor,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    if (!shouldAnimate) {
      return badge;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.8,
        end: 1.0,
      ),
      duration: Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: badge);
      },
    );
  }
}
