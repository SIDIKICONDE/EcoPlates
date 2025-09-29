import 'package:flutter/material.dart';

import '../../core/constants/categories.dart';
import '../../domain/entities/food_offer.dart';

/// Utilitaires pour formater les données des offres
class OfferFormatters {
  /// Formate le type d'offre en texte français
  static String formatOfferType(OfferType type) {
    switch (type) {
      case OfferType.panier:
        return 'Panier surprise';
      case OfferType.plat:
        return 'Plat spécifique';
      case OfferType.boulangerie:
        return 'Boulangerie';
      case OfferType.fruits:
        return 'Fruits et légumes';
      case OfferType.epicerie:
        return 'Épicerie';
      case OfferType.autre:
        return 'Autre';
    }
  }

  /// Formate la catégorie alimentaire en texte français (centralisé)
  static String formatFoodCategory(FoodCategory category) {
    return Categories.labelOf(category);
  }

  /// Formate le statut de l'offre en texte français
  static String formatOfferStatus(OfferStatus status) {
    switch (status) {
      case OfferStatus.draft:
        return 'Brouillon';
      case OfferStatus.available:
        return 'Disponible';
      case OfferStatus.reserved:
        return 'Réservée';
      case OfferStatus.collected:
        return 'Collectée';
      case OfferStatus.expired:
        return 'Expirée';
      case OfferStatus.cancelled:
        return 'Annulée';
    }
  }

  /// Formate la date de création en texte relatif
  static String formatCreatedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui";
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Il y a $weeks semaine${weeks > 1 ? 's' : ''}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Formate l'heure de collecte
  static String formatPickupTime(FoodOffer offer) {
    final start = offer.pickupStartTime;
    final end = offer.pickupEndTime;
    final now = DateTime.now();

    var day = '';
    if (start.day == now.day) {
      day = "Aujourd'hui";
    } else if (start.day == now.day + 1) {
      day = 'Demain';
    } else {
      day = '${start.day}/${start.month}';
    }

    return '$day de ${start.hour.toString().padLeft(2, '0')}h${start.minute.toString().padLeft(2, '0')} '
        'à ${end.hour.toString().padLeft(2, '0')}h${end.minute.toString().padLeft(2, '0')}';
  }

  /// Formate le temps restant
  static String formatTimeRemaining(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} jour${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} heure${duration.inHours > 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} min';
    } else {
      return 'Urgent';
    }
  }

  /// Retourne la couleur appropriée pour un statut
  static Color getStatusColor(OfferStatus status) {
    switch (status) {
      case OfferStatus.draft:
        return Colors.grey;
      case OfferStatus.available:
        return Colors.green;
      case OfferStatus.reserved:
        return Colors.orange;
      case OfferStatus.collected:
        return Colors.blue;
      case OfferStatus.expired:
        return Colors.red;
      case OfferStatus.cancelled:
        return Colors.red;
    }
  }
}
