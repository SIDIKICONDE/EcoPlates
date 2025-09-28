import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../core/utils/accessibility_helper.dart';

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
    const backgroundColor = AccessibleColors.dangerRed;
    const textColor = Colors.white;

    final badge = Semantics(
      label: 'Réduction de $discountPercentage pourcent',
      button: false,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.scaleMD_LG_XL_XXL,
          vertical: context.scaleXXS_XS_SM_MD,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
            ],
          ),
          borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xxl),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
              blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
              offset: EcoPlatesDesignTokens.elevation.standardOffset,
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            width: EcoPlatesDesignTokens.layout.cardBorderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              color: textColor,
              size: EcoPlatesDesignTokens.size.indicator(context),
              semanticLabel: 'Offre spéciale',
            ),
            SizedBox(width: context.scaleXXS_XS_SM_MD),
            Text(
              '-$discountPercentage%',
              style: TextStyle(
                color: textColor,
                fontSize: AccessibleFontSizes.normal,
                fontWeight: EcoPlatesDesignTokens.typography.bold,
                letterSpacing: EcoPlatesDesignTokens.typography
                    .titleLetterSpacing(context),
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
        begin: EcoPlatesDesignTokens.urgentOffers.pulseBegin,
        end: EcoPlatesDesignTokens.urgentOffers.pulseEnd,
      ),
      duration: EcoPlatesDesignTokens.animation.normal,
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: badge);
      },
    );
  }
}
