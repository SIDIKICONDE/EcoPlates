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
        horizontal: size == BadgeSize.small ? 6 : 8,
        vertical: size == BadgeSize.small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(size == BadgeSize.small ? 8 : 12),
        border: Border.all(
          color: Colors.white,
          width: size == BadgeSize.small ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_filled,
            size: size == BadgeSize.small ? 10 : 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            reopenTime != null ? 'FERMÉ' : 'FERMÉ',
            style: TextStyle(
              fontSize: size == BadgeSize.small ? 9 : 11,
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
        horizontal: size == BadgeSize.small ? 6 : 8,
        vertical: size == BadgeSize.small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
        borderRadius: BorderRadius.circular(size == BadgeSize.small ? 8 : 12),
        border: Border.all(
          color: Colors.white,
          width: size == BadgeSize.small ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: size == BadgeSize.small ? 10 : 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            'Réouvre $reopenTime',
            style: TextStyle(
              fontSize: size == BadgeSize.small ? 9 : 11,
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
