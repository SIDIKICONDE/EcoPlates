import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Badge affichant le temps restant pour collecter l'offre
class OfferTimeBadge extends StatelessWidget {
  const OfferTimeBadge({required this.timeRemaining, super.key});
  final Duration timeRemaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.warning,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.shadowLight,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 14.0,
            color: DeepColorTokens.neutral0,
          ),
          const SizedBox(width: 4.0),
          Text(
            _formatTimeRemaining(timeRemaining),
            style: TextStyle(
              color: DeepColorTokens.neutral0,
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
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
