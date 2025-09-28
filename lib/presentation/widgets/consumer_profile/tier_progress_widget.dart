import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/spacing_tokens.dart';
import '../../../domain/entities/user.dart';
import 'consumer_tier_utils.dart';

/// Widget affichant la progression vers le prochain niveau de consommateur
class TierProgressWidget extends StatelessWidget {
  const TierProgressWidget({
    required this.currentTier,
    required this.currentScore,
    super.key,
  });

  final ConsumerTier currentTier;
  final int currentScore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final nextTier = ConsumerTierUtils.getNextTier(currentTier);
    final nextTierThreshold = ConsumerTierUtils.getTierThreshold(
      nextTier ?? currentTier,
    );
    final currentTierThreshold = ConsumerTierUtils.getTierThreshold(
      currentTier,
    );
    final progress = nextTier != null
        ? (currentScore - currentTierThreshold) /
              (nextTierThreshold - currentTierThreshold)
        : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nextTier != null
              ? 'Progression vers ${ConsumerTierUtils.getTierLabel(nextTier)}'
              : 'Niveau Maximum Atteint !',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: context.responsiveValue(
            mobile: EcoSpacing.xs,
            tablet: EcoSpacing.sm,
            desktop: EcoSpacing.md,
          ),
        ),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: colors.surface.withValues(alpha: 0.5),
          valueColor: AlwaysStoppedAnimation<Color>(
            ConsumerTierUtils.getTierColor(
              nextTier ?? currentTier,
              brightness: Theme.of(context).brightness,
            ),
          ),
          minHeight: context.responsiveValue(
            mobile: 6,
            tablet: 8,
            desktop: 10,
          ),
        ),
        SizedBox(
          height: context.responsiveValue(
            mobile: 2,
            tablet: 4,
            desktop: 6,
          ),
        ),
        if (nextTier != null)
          Text(
            'Encore ${nextTierThreshold - currentScore} points pour débloquer le niveau ${ConsumerTierUtils.getTierLabel(nextTier)}',
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }
}
