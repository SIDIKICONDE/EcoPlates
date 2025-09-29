import 'package:flutter/material.dart';

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
        const SizedBox(height: 12.0),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: colors.surface.withValues(alpha: 0.5),
          valueColor: AlwaysStoppedAnimation<Color>(
            ConsumerTierUtils.getTierColor(
              nextTier ?? currentTier,
              brightness: Theme.of(context).brightness,
            ),
          ),
          minHeight: 8.0,
        ),
        const SizedBox(height: 8.0),
        if (nextTier != null)
          Text(
            'Encore ${nextTierThreshold - currentScore} points pour débloquer le niveau ${ConsumerTierUtils.getTierLabel(nextTier)}',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }
}
