import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

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

    // Tailles responsives
    final horizontalPadding =
        ResponsiveUtils.getHorizontalSpacing(context) * 0.5;
    final verticalPadding = ResponsiveUtils.getVerticalSpacing(context) * 0.25;
    final iconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
    final fontSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
    final spacing = ResponsiveUtils.getHorizontalSpacing(context) * 0.17;

    // Couleurs accessibles WCAG
    const backgroundColor = DeepColorTokens.error;
    const textColor = DeepColorTokens.neutral0;

    final badge = Semantics(
      label: 'Réduction de $discountPercentage pourcent',
      button: false,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 8.0,
              offset: const Offset(0, 4.0),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.discount,
              size: iconSize,
              color: textColor,
            ),
            SizedBox(width: spacing),
            Text(
              '-$discountPercentage%',
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
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
