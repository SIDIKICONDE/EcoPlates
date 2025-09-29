import 'package:flutter/material.dart';

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
            size: 14.0,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          SizedBox(width: 4.0),
          Text(
            '${distance!.toStringAsFixed(1)} km',
            style: TextStyle(
              fontSize: 12.0,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(width: 12.0),
        ],
        Icon(
          Icons.schedule,
          size: 14.0,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        SizedBox(width: 4.0),
        Text(
          _formatPickupTime(),
          style: TextStyle(
            fontSize: 12.0,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
