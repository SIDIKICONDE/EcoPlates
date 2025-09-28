import 'package:flutter/material.dart';

import '../../core/responsive/design_tokens.dart';

/// Badge pour indiquer qu'une boutique est fermée
class ClosedBadge extends StatelessWidget {
  const ClosedBadge({super.key, this.reopenTime, this.size = BadgeSize.medium});

  final String? reopenTime;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == BadgeSize.small
            ? context.scaleXXS_XS_SM_MD
            : context.scaleXS_SM_MD_LG,
        vertical: size == BadgeSize.small
            ? context.scaleXXS_XS_SM_MD / 2
            : context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(
          size == BadgeSize.small
              ? EcoPlatesDesignTokens.radius.sm
              : EcoPlatesDesignTokens.radius.md,
        ),
        border: Border.all(
          color: Colors.white,
          width: size == BadgeSize.small ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: EcoPlatesDesignTokens.opacity.pressed,
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
            Icons.access_time_filled,
            size: size == BadgeSize.small
                ? EcoPlatesDesignTokens.size.icon(context) / 1.2
                : EcoPlatesDesignTokens.size.icon(context),
            color: Colors.white,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
          Text(
            reopenTime != null ? 'FERMÉ' : 'FERMÉ',
            style: TextStyle(
              fontSize: size == BadgeSize.small
                  ? EcoPlatesDesignTokens.typography.hint(context) - 1
                  : EcoPlatesDesignTokens.typography.hint(context) + 1,
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
        horizontal: size == BadgeSize.small
            ? context.scaleXXS_XS_SM_MD
            : context.scaleXS_SM_MD_LG,
        vertical: size == BadgeSize.small
            ? context.scaleXXS_XS_SM_MD / 2
            : context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
        borderRadius: BorderRadius.circular(
          size == BadgeSize.small
              ? EcoPlatesDesignTokens.radius.sm
              : EcoPlatesDesignTokens.radius.md,
        ),
        border: Border.all(
          color: Colors.white,
          width: size == BadgeSize.small ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: EcoPlatesDesignTokens.opacity.pressed,
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
            Icons.schedule,
            size: size == BadgeSize.small
                ? EcoPlatesDesignTokens.size.icon(context) / 1.2
                : EcoPlatesDesignTokens.size.icon(context),
            color: Colors.white,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
          Text(
            'Réouvre $reopenTime',
            style: TextStyle(
              fontSize: size == BadgeSize.small
                  ? EcoPlatesDesignTokens.typography.hint(context) - 1
                  : EcoPlatesDesignTokens.typography.hint(context) + 1,
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
