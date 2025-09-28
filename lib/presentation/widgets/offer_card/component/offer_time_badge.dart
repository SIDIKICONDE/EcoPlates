import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

/// Badge affichant le temps restant pour collecter l'offre
class OfferTimeBadge extends StatelessWidget {
  const OfferTimeBadge({required this.timeRemaining, super.key});
  final Duration timeRemaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleMD_LG_XL_XXL,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: EcoPlatesDesignTokens.colors.snackbarError,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xxl),
        boxShadow: [
          BoxShadow(
            color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: EcoPlatesDesignTokens.size.indicator(context),
            color: EcoPlatesDesignTokens.colors.textPrimary,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),
          Text(
            _formatTimeRemaining(timeRemaining),
            style: TextStyle(
              color: EcoPlatesDesignTokens.colors.textPrimary,
              fontWeight: EcoPlatesDesignTokens.typography.bold,
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRemaining(Duration duration) {
    // Arrondir à l'unité supérieure pour éviter 0min quand il reste du temps
    if (duration.isNegative) return 'Éxpirée';

    final totalSeconds = duration.inSeconds;
    final roundedMinutes = (totalSeconds / 60).ceil();
    final roundedHours = (roundedMinutes / 60).floor();

    if (roundedMinutes <= 0) return '1min';

    if (roundedMinutes < 60) {
      return '${roundedMinutes}min';
    }

    if (roundedHours < 24) {
      final minutesRemainder = roundedMinutes % 60;
      if (minutesRemainder == 0) {
        return '${roundedHours}h';
      }
      return '${roundedHours}h ${minutesRemainder}min';
    }

    final days = (roundedHours / 24).floor();
    final hoursRemainder = roundedHours % 24;
    if (hoursRemainder == 0) {
      return '${days}j';
    }
    return '${days}j ${hoursRemainder}h';
  }
}
