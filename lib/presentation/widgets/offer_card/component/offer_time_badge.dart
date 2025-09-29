import 'package:flutter/material.dart';

/// Badge affichant le temps restant pour collecter l'offre
class OfferTimeBadge extends StatelessWidget {
  const OfferTimeBadge({required this.timeRemaining, super.key});
  final Duration timeRemaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 14.0,
            color: Colors.white,
          ),
          SizedBox(width: 4.0),
          Text(
            _formatTimeRemaining(timeRemaining),
            style: TextStyle(
              color: Colors.white,
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
