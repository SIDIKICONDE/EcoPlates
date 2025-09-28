import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';

/// Indicateur animé pour les offres urgentes
class TimeIndicator extends StatelessWidget {
  const TimeIndicator({required this.availableOffers, super.key});
  final int availableOffers;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.scaleMD_LG_XL_XXL,
      right: context.scaleMD_LG_XL_XXL,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.scaleMD_LG_XL_XXL,
          vertical: context.scaleXXS_XS_SM_MD,
        ),
        decoration: BoxDecoration(
          color: availableOffers <= 2
              ? EcoPlatesDesignTokens.colors.snackbarError
              : EcoPlatesDesignTokens.colors.snackbarWarning,
          borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xxl),
          boxShadow: [
            BoxShadow(
              color:
                  (availableOffers <= 2
                          ? EcoPlatesDesignTokens.colors.snackbarError
                          : EcoPlatesDesignTokens.colors.snackbarWarning)
                      .withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
              blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
              offset: EcoPlatesDesignTokens.elevation.standardOffset,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: EcoPlatesDesignTokens.urgentOffers.pulseBegin,
                end: EcoPlatesDesignTokens.urgentOffers.pulseEnd,
              ),
              duration: EcoPlatesDesignTokens.animation.slow,
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 2 * math.pi,
                  child: Icon(
                    Icons.timer,
                    size: EcoPlatesDesignTokens.size.indicator(context),
                    color: EcoPlatesDesignTokens.colors.textPrimary,
                  ),
                );
              },
            ),
            SizedBox(width: context.scaleXXS_XS_SM_MD),
            Text(
              availableOffers == 1
                  ? 'Dernière chance!'
                  : 'Plus que $availableOffers!',
              style: TextStyle(
                color: EcoPlatesDesignTokens.colors.textPrimary,
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
                fontWeight: EcoPlatesDesignTokens.typography.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
