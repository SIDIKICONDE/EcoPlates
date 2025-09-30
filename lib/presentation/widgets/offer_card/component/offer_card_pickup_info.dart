import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/food_offer.dart';

/// Widget spécialisé pour afficher les informations de récupération
/// Inclut la date/heure et la distance optionnelle
class OfferCardPickupInfo extends StatelessWidget {
  const OfferCardPickupInfo({
    required this.offer,
    this.showDistance = false,
    this.distance,
    this.compact = false,
    super.key,
  });

  final FoodOffer offer;
  final bool showDistance;
  final double? distance;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactPickupWithDistance(context);
    }

    return Text(
      'Récupération: ${_formatPickupTime()}',
      style: TextStyle(
        fontSize: 10.0, // Valeur fixe
        color: DeepColorTokens.neutral700.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildCompactPickupWithDistance(BuildContext context) {
    final pickupText = _getSmartPickupText();
    final timeText = _formatPickupTime();
    final distanceText = distance != null
        ? ' • ${distance!.toStringAsFixed(1)}km'
        : '';

    return Text(
      '$pickupText • $timeText$distanceText',
      style: TextStyle(
        fontSize: 9.0, // Valeur fixe
        color: DeepColorTokens.neutral700.withValues(alpha: 0.7),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _formatPickupTime() {
    try {
      final start =
          '${offer.pickupStartTime.hour.toString().padLeft(2, '0')}:${offer.pickupStartTime.minute.toString().padLeft(2, '0')}';
      final end =
          '${offer.pickupEndTime.hour.toString().padLeft(2, '0')}:${offer.pickupEndTime.minute.toString().padLeft(2, '0')}';
      return '$start - $end';
    } on Exception catch (_) {
      return 'Horaire à définir';
    }
  }

  String _getSmartPickupText() {
    final now = DateTime.now();
    final startTime = offer.pickupStartTime;
    final endTime = offer.pickupEndTime;

    // Si la récupération est déjà passée
    if (endTime.isBefore(now)) {
      return 'Éxpirée';
    }

    // Si la récupération a déjà commencé
    if (startTime.isBefore(now) && endTime.isAfter(now)) {
      final remainingHours = endTime.difference(now).inHours;
      if (remainingHours < 1) {
        return 'Dernière chance';
      } else {
        return 'Disponible maintenant';
      }
    }

    // Déterminer si c'est aujourd'hui, demain, etc.
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(startTime.year, startTime.month, startTime.day);
    final daysDifference = startDay.difference(today).inDays;

    // Aujourd'hui
    if (daysDifference == 0) {
      if (startTime.hour < 12) {
        return 'À récupérer ce matin';
      } else if (startTime.hour < 18) {
        return 'À récupérer cet après-midi';
      } else {
        return 'À récupérer ce soir';
      }
    }
    // Demain
    else if (daysDifference == 1) {
      if (startTime.hour < 12) {
        return 'À récupérer demain matin';
      } else if (startTime.hour < 18) {
        return 'À récupérer demain après-midi';
      } else {
        return 'À récupérer demain soir';
      }
    }
    // Dans plusieurs jours
    else if (daysDifference <= 7) {
      final weekdays = [
        'lundi',
        'mardi',
        'mercredi',
        'jeudi',
        'vendredi',
        'samedi',
        'dimanche',
      ];
      final weekday = weekdays[startTime.weekday - 1];
      return 'À récupérer $weekday';
    }
    // Plus loin dans le futur
    else {
      return 'À récupérer le ${startTime.day}/${startTime.month}';
    }
  }
}
