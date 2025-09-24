/// Statistiques d'une offre spécifique
class OfferStats {
  final int views;              // Nombre de vues de l'offre
  final int reservations;       // Nombre de réservations
  final int completedPickups;   // Nombre de récupérations complétées
  final double conversionRate;  // Taux de conversion (réservations/vues)
  final double averageRating;   // Note moyenne
  final int totalReviews;       // Nombre d'avis
  final double revenue;         // Chiffre d'affaires généré
  final double co2Saved;        // CO2 économisé en grammes
  final DateTime lastUpdated;   // Dernière mise à jour des stats

  const OfferStats({
    required this.views,
    required this.reservations,
    required this.completedPickups,
    required this.conversionRate,
    required this.averageRating,
    required this.totalReviews,
    required this.revenue,
    required this.co2Saved,
    required this.lastUpdated,
  });

  /// Taux de succès (récupérations/réservations)
  double get successRate {
    if (reservations == 0) return 0.0;
    return (completedPickups / reservations) * 100;
  }

  /// Impact environnemental (CO2 par récupération)
  double get co2ImpactPerPickup {
    if (completedPickups == 0) return 0.0;
    return co2Saved / completedPickups;
  }

  /// Performance globale (note composite)
  double get performanceScore {
    // Score basé sur plusieurs critères (0-100)
    final viewScore = views > 0 ? 25.0 : 0.0;
    final conversionScore = conversionRate * 25.0; // Max 25 points
    final ratingScore = (averageRating / 5.0) * 25.0; // Max 25 points
    final successScore = (successRate / 100.0) * 25.0; // Max 25 points
    
    return viewScore + conversionScore + ratingScore + successScore;
  }

  @override
  String toString() {
    return 'OfferStats(views: $views, reservations: $reservations, '
           'completedPickups: $completedPickups, conversionRate: $conversionRate%, '
           'rating: $averageRating/5, revenue: ${revenue.toStringAsFixed(2)}€)';
  }
}