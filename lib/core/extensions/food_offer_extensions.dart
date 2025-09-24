import 'package:flutter/material.dart';

import '../../domain/entities/food_offer.dart';

/// Extensions utilitaires pour FoodOffer
extension FoodOfferExtensions on FoodOffer {
  /// Vérifie si la boutique est actuellement fermée
  bool get isClosed {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    final startTime = TimeOfDay.fromDateTime(pickupStartTime);
    final endTime = TimeOfDay.fromDateTime(pickupEndTime);

    // Convertir en minutes pour faciliter la comparaison
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    return currentMinutes < startMinutes || currentMinutes > endMinutes;
  }

  /// Retourne l'heure de réouverture si la boutique est fermée
  String? get reopenTime {
    if (!isClosed) return null;

    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    final startTime = TimeOfDay.fromDateTime(pickupStartTime);

    // Convertir en minutes pour faciliter la comparaison
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;

    // Si on est avant l'ouverture, retourner l'heure d'ouverture
    if (currentMinutes < startMinutes) {
      return '${startTime.hour}h${startTime.minute.toString().padLeft(2, '0')}';
    }

    // Si on est après la fermeture, retourner l'heure d'ouverture du lendemain
    return '${startTime.hour}h${startTime.minute.toString().padLeft(2, '0')}';
  }

  /// Retourne l'heure de collecte formatée
  String get pickupTimeFormatted {
    final start = pickupStartTime;
    final end = pickupEndTime;
    return '${start.hour}h${start.minute.toString().padLeft(2, '0')} - ${end.hour}h${end.minute.toString().padLeft(2, '0')}';
  }

  /// Retourne l'URL d'une image de fond selon la catégorie
  String get backgroundImageUrl {
    switch (category.name.toLowerCase()) {
      case 'boulangerie':
        return 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=200&fit=crop&crop=center';
      case 'café':
        return 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&h=200&fit=crop&crop=center';
      case 'restaurant':
        return 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=200&fit=crop&crop=center';
      case 'asiatique':
        return 'https://images.unsplash.com/photo-1512058564366-c727a59b217a?w=400&h=200&fit=crop&crop=center';
      case 'italien':
        return 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=200&fit=crop&crop=center';
      default:
        return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=200&fit=crop&crop=center';
    }
  }

  /// Construit le label d'accessibilité
  String get semanticLabel {
    final buffer = StringBuffer()
      ..write('$title chez $merchantName. ')
      ..write('Prix: $priceText. ');

    if (isFree) {
      buffer.write('Offre gratuite. ');
    } else {
      buffer.write('Réduction de ${discountPercentage.toStringAsFixed(0)}%. ');
    }

    if (canPickup) {
      buffer.write('Collecte disponible. ');
    }

    return buffer.toString();
  }
}
