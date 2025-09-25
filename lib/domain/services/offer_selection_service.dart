import '../entities/food_offer.dart';

/// Service utilitaire pour sélectionner et scorer les offres pour le feed d'accueil
class OfferSelectionService {
  /// Détermine si une offre est urgente selon des seuils simples
  /// - timeLeftThreshold: durée restante maximale pour être considérée urgente
  /// - quantityThreshold: quantité <= seuil -> urgente
  static bool isUrgent(
    FoodOffer offer, {
    Duration timeLeftThreshold = const Duration(minutes: 90),
    int quantityThreshold = 3,
  }) {
    // Doit être disponible et non expirée
    if (!offer.isAvailable || offer.timeRemaining.isNegative) return false;

    final timeLeft = offer.timeRemaining;
    final lowStock = offer.quantity <= quantityThreshold;
    final soon = timeLeft <= timeLeftThreshold;
    return soon || lowStock;
  }

  /// Score d'urgence (0..1). Plus élevé = plus urgent.
  /// Combine un score de temps restant et de stock restant.
  static double urgencyScore(
    FoodOffer offer, {
    Duration timeLeftThreshold = const Duration(minutes: 90),
    int quantityThreshold = 3,
  }) {
    final timeLeft = offer.timeRemaining;

    // Normaliser le score temps: 1 quand il reste 0, 0 quand >= threshold
    final timeScore = timeLeft.isNegative
        ? 1.0
        : (1.0 - (timeLeft.inSeconds / timeLeftThreshold.inSeconds))
            .clamp(0.0, 1.0);

    // Normaliser le score stock: 1 quand stock = 0, ~0 quand stock >> threshold
    final stock = offer.quantity;
    final stockScore =
        (quantityThreshold / (stock + quantityThreshold)).clamp(0.0, 1.0);

    // Pondération simple (peut être ajustée)
    const wTime = 0.65;
    const wStock = 0.35;
    return (wTime * timeScore) + (wStock * stockScore);
  }

  /// Détermine si une offre correspond à un repas complet (règle simple)
  static bool isMeal(FoodOffer offer) {
    return offer.type == OfferType.plat &&
        (offer.category == FoodCategory.dejeuner ||
            offer.category == FoodCategory.diner);
  }
}
