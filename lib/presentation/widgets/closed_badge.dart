import 'package:flutter/material.dart';

import '../../core/themes/tokens/deep_color_tokens.dart';

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
        color: DeepColorTokens.error,
        borderRadius: BorderRadius.circular(
          size == BadgeSize.small ? 4.0 : 8.0,
        ),
        border: Border.all(
          color: DeepColorTokens.neutral0,
          width: size == BadgeSize.small ? 1 : 1.5,
        ),
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
            Icons.access_time_filled,
            size: size == BadgeSize.small ? 20.0 : 24.0,
            color: DeepColorTokens.neutral0,
          ),
          SizedBox(width: 4.0),
          Text(
            reopenTime != null ? 'FERMÉ' : 'FERMÉ',
            style: TextStyle(
              fontSize: size == BadgeSize.small ? 10.0 : 12.0,
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.neutral0,
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
        color: DeepColorTokens.warning,
        borderRadius: BorderRadius.circular(
          size == BadgeSize.small ? 4.0 : 8.0,
        ),
        border: Border.all(
          color: DeepColorTokens.neutral0,
          width: size == BadgeSize.small ? 1 : 1.5,
        ),
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
            Icons.schedule,
            size: size == BadgeSize.small ? 20.0 : 24.0,
            color: DeepColorTokens.neutral0,
          ),
          SizedBox(width: 4.0),
          Text(
            'Réouvre $reopenTime',
            style: TextStyle(
              fontSize: size == BadgeSize.small ? 10.0 : 12.0,
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.neutral0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tailles disponibles pour les badges
enum BadgeSize { small, medium, large }
