import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

/// Widget affichant la distance et l'horaire de collecte
class OfferLocationInfo extends StatelessWidget {
  const OfferLocationInfo({
    required this.showDistance,
    required this.pickupStartTime,
    required this.pickupEndTime,
    super.key,
    this.distance,
  });
  final bool showDistance;
  final double? distance;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showDistance && distance != null) ...[
          Icon(
            Icons.location_on,
            size: EcoPlatesDesignTokens.size.indicator(context),
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),
          Text(
            '${distance!.toStringAsFixed(1)} km',
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
            ),
          ),
          SizedBox(width: context.scaleMD_LG_XL_XXL),
        ],
        Icon(
          Icons.schedule,
          size: EcoPlatesDesignTokens.size.indicator(context),
          color: Theme.of(context).colorScheme.onSurface.withValues(
            alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
          ),
        ),
        SizedBox(width: context.scaleXXS_XS_SM_MD),
        Text(
          _formatPickupTime(),
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.text(context),
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
          ),
        ),
      ],
    );
  }

  String _formatPickupTime() {
    final start = pickupStartTime;
    final end = pickupEndTime;
    return '${start.hour.toString().padLeft(2, '0')}h${start.minute.toString().padLeft(2, '0')} - '
        '${end.hour.toString().padLeft(2, '0')}h${end.minute.toString().padLeft(2, '0')}';
  }
}
