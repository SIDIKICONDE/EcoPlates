import 'package:flutter/material.dart';
import '../../../core/utils/accessibility_helper.dart';

/// Badge animé pour afficher le pourcentage de réduction avec accessibilité WCAG
class DiscountBadge extends StatelessWidget {
  final int discountPercentage;
  final bool animationsEnabled;
  
  const DiscountBadge({
    super.key,
    required this.discountPercentage,
    this.animationsEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final shouldAnimate = animationsEnabled && !mediaQuery.disableAnimations;
    
    // Couleurs accessibles WCAG
    final backgroundColor = AccessibleColors.dangerRed;
    const textColor = Colors.white;
    
    final badge = Semantics(
      label: 'Réduction de $discountPercentage pourcent',
      button: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              color: textColor,
              size: 16,
              semanticLabel: 'Offre spéciale',
            ),
            const SizedBox(width: 4),
            Text(
              '-$discountPercentage%',
              style: TextStyle(
                color: textColor,
                fontSize: AccessibleFontSizes.normal,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
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
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: badge,
        );
      },
    );
  }
}