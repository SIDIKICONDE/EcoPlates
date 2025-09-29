import 'package:flutter/material.dart';

/// Badge pour indiquer qu'une boutique est fermée
class ClosedBadge extends StatelessWidget {
  const ClosedBadge({super.key, this.reopenTime, this.size = BadgeSize.medium});

  final String? reopenTime;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == BadgeSize.small ? 8.0 : 12.0,
        vertical: size == BadgeSize.small ? 4.0 : 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(
          size == BadgeSize.small ? 4.0 : 8.0,
        ),
        border: Border.all(
          color: Colors.white,
          width: size == BadgeSize.small ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.16,
            ),
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_filled,
            size: size == BadgeSize.small ? 20.0 : 24.0,
            color: Colors.white,
          ),
          SizedBox(width: 4.0),
          Text(
            reopenTime != null ? 'FERMÉ' : 'FERMÉ',
            style: TextStyle(
              fontSize: size == BadgeSize.small ? 10.0 : 12.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge pour indiquer qu'une boutique est fermée avec heure de réouverture
class ClosedBadgeWithTime extends StatelessWidget {
  const ClosedBadgeWithTime({
    required this.reopenTime,
    super.key,
    this.size = BadgeSize.medium,
  });

  final String reopenTime;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == BadgeSize.small ? 8.0 : 12.0,
        vertical: size == BadgeSize.small ? 4.0 : 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
        borderRadius: BorderRadius.circular(
          size == BadgeSize.small ? 4.0 : 8.0,
        ),
        border: Border.all(
          color: Colors.white,
          width: size == BadgeSize.small ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.16,
            ),
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: size == BadgeSize.small ? 20.0 : 24.0,
            color: Colors.white,
          ),
          SizedBox(width: 4.0),
          Text(
            'Réouvre $reopenTime',
            style: TextStyle(
              fontSize: size == BadgeSize.small ? 10.0 : 12.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tailles disponibles pour les badges
enum BadgeSize { small, medium, large }
