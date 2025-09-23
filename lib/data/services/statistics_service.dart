import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/reservation.dart';

/// Service pour gérer les statistiques utilisateur
class StatisticsService {
  static const String _boxName = 'user_statistics';
  static const String _statsKey = 'stats_data';

  late Box _box;

  /// Initialise le service de statistiques
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Récupère les statistiques stockées
  UserStatistics getStoredStatistics() {
    final dynamic stored = _box.get(_statsKey);
    if (stored is Map) {
      return UserStatistics.fromMap(Map<String, dynamic>.from(stored));
    }
    return UserStatistics.empty();
  }

  /// Sauvegarde les statistiques
  Future<void> saveStatistics(UserStatistics stats) async {
    await _box.put(_statsKey, stats.toMap());
  }

  /// Calcule les statistiques basées sur les réservations
  UserStatistics calculateStatistics(List<Reservation> reservations) {
    int mealsSaved = 0;
    double moneySaved = 0;
    double co2Saved = 0;
    int freeMeals = 0;
    int totalReservations = 0;

    final Map<String, int> categoryCount = {};
    final Map<String, double> merchantSavings = {};
    final List<DateTime> reservationDates = [];

    for (final reservation in reservations) {
      if (reservation.status == ReservationStatus.collected) {
        mealsSaved += reservation.quantity;

        // Calculer les économies (estimations basées sur des moyennes)
        // Pour une implémentation complète, ces données viendraient des offres
        const avgOriginalPrice = 15.0; // Prix moyen original estimé
        const avgDiscountedPrice = 8.0; // Prix moyen réduit estimé
        final savings =
            (avgOriginalPrice - avgDiscountedPrice) * reservation.quantity;
        moneySaved += savings;

        // Calculer le CO2 économisé (estimation : 2.5 kg CO2 par repas)
        co2Saved += reservation.quantity * 2.5;

        // Compter les repas gratuits (estimation : 10% des repas sont gratuits)
        if (savings >= avgOriginalPrice * reservation.quantity * 0.8) {
          freeMeals += reservation.quantity;
        }

        // Statistiques par catégorie (utiliser offerId comme approximation)
        final category =
            'unknown'; // Sans accès aux offres, on ne peut pas déterminer la catégorie
        categoryCount[category] =
            (categoryCount[category] ?? 0) + reservation.quantity;

        // Économies par commerçant (utiliser merchantId comme clé)
        merchantSavings[reservation.merchantId] =
            (merchantSavings[reservation.merchantId] ?? 0) + savings;

        // Dates des réservations
        reservationDates.add(reservation.reservedAt);
      }

      totalReservations++;
    }

    // Calculer les streaks
    final streak = _calculateStreak(reservationDates);
    final longestStreak = _calculateLongestStreak(reservationDates);

    // Calculer les moyennes
    final avgSavingsPerMeal = mealsSaved > 0 ? moneySaved / mealsSaved : 0.0;
    final avgCo2PerMeal = mealsSaved > 0 ? co2Saved / mealsSaved : 0.0;

    // Trouver la catégorie favorite
    String? favoriteCategory;
    if (categoryCount.isNotEmpty) {
      favoriteCategory = categoryCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    // Trouver le commerçant favori
    String? favoriteMerchant;
    if (merchantSavings.isNotEmpty) {
      favoriteMerchant = merchantSavings.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    return UserStatistics(
      totalMealsSaved: mealsSaved,
      totalMoneySaved: moneySaved,
      totalCo2Saved: co2Saved,
      totalFreeMeals: freeMeals,
      totalReservations: totalReservations,
      currentStreak: streak,
      longestStreak: longestStreak,
      avgSavingsPerMeal: avgSavingsPerMeal,
      avgCo2PerMeal: avgCo2PerMeal,
      favoriteCategory: favoriteCategory,
      favoriteMerchant: favoriteMerchant,
      categoryBreakdown: categoryCount,
      merchantSavings: merchantSavings,
      lastUpdated: DateTime.now(),
    );
  }

  /// Calcule le streak actuel (jours consécutifs)
  int _calculateStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    dates.sort();
    final today = DateTime.now();
    int streak = 0;
    DateTime currentDate = today;

    for (int i = dates.length - 1; i >= 0; i--) {
      final date = DateTime(dates[i].year, dates[i].month, dates[i].day);
      final compareDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );

      if (date == compareDate ||
          date == compareDate.subtract(const Duration(days: 1))) {
        streak++;
        currentDate = dates[i];
      } else {
        break;
      }
    }

    return streak;
  }

  /// Calcule le plus long streak
  int _calculateLongestStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    dates.sort();
    int maxStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else if (diff > 1) {
        currentStreak = 1;
      }
    }

    return maxStreak;
  }

  /// Ajoute une réservation aux statistiques
  Future<void> addReservationToStats(Reservation reservation) async {
    if (reservation.status != ReservationStatus.collected) return;

    final stats = getStoredStatistics();

    // Utiliser des estimations pour les données non disponibles
    const avgOriginalPrice = 15.0;
    const avgDiscountedPrice = 8.0;
    final savings =
        (avgOriginalPrice - avgDiscountedPrice) * reservation.quantity;
    final isFree = savings >= avgOriginalPrice * reservation.quantity * 0.8;

    final updatedStats = UserStatistics(
      totalMealsSaved: stats.totalMealsSaved + reservation.quantity,
      totalMoneySaved: stats.totalMoneySaved + savings,
      totalCo2Saved: stats.totalCo2Saved + (reservation.quantity * 2.5),
      totalFreeMeals:
          stats.totalFreeMeals + (isFree ? reservation.quantity : 0),
      totalReservations: stats.totalReservations + 1,
      currentStreak: stats.currentStreak, // Recalculer si nécessaire
      longestStreak: stats.longestStreak,
      avgSavingsPerMeal: 0, // Recalculer
      avgCo2PerMeal: 0, // Recalculer
      favoriteCategory: stats.favoriteCategory,
      favoriteMerchant: stats.favoriteMerchant,
      categoryBreakdown: stats.categoryBreakdown,
      merchantSavings: stats.merchantSavings,
      lastUpdated: DateTime.now(),
    );

    await saveStatistics(updatedStats);
  }
}

/// Statistiques utilisateur
class UserStatistics {
  final int totalMealsSaved;
  final double totalMoneySaved;
  final double totalCo2Saved;
  final int totalFreeMeals;
  final int totalReservations;
  final int currentStreak;
  final int longestStreak;
  final double avgSavingsPerMeal;
  final double avgCo2PerMeal;
  final String? favoriteCategory;
  final String? favoriteMerchant;
  final Map<String, int> categoryBreakdown;
  final Map<String, double> merchantSavings;
  final DateTime lastUpdated;

  UserStatistics({
    required this.totalMealsSaved,
    required this.totalMoneySaved,
    required this.totalCo2Saved,
    required this.totalFreeMeals,
    required this.totalReservations,
    required this.currentStreak,
    required this.longestStreak,
    required this.avgSavingsPerMeal,
    required this.avgCo2PerMeal,
    this.favoriteCategory,
    this.favoriteMerchant,
    required this.categoryBreakdown,
    required this.merchantSavings,
    required this.lastUpdated,
  });

  factory UserStatistics.empty() {
    return UserStatistics(
      totalMealsSaved: 0,
      totalMoneySaved: 0,
      totalCo2Saved: 0,
      totalFreeMeals: 0,
      totalReservations: 0,
      currentStreak: 0,
      longestStreak: 0,
      avgSavingsPerMeal: 0,
      avgCo2PerMeal: 0,
      categoryBreakdown: {},
      merchantSavings: {},
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMealsSaved': totalMealsSaved,
      'totalMoneySaved': totalMoneySaved,
      'totalCo2Saved': totalCo2Saved,
      'totalFreeMeals': totalFreeMeals,
      'totalReservations': totalReservations,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'avgSavingsPerMeal': avgSavingsPerMeal,
      'avgCo2PerMeal': avgCo2PerMeal,
      'favoriteCategory': favoriteCategory,
      'favoriteMerchant': favoriteMerchant,
      'categoryBreakdown': categoryBreakdown,
      'merchantSavings': merchantSavings,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory UserStatistics.fromMap(Map<String, dynamic> map) {
    return UserStatistics(
      totalMealsSaved: map['totalMealsSaved'] ?? 0,
      totalMoneySaved: (map['totalMoneySaved'] ?? 0).toDouble(),
      totalCo2Saved: (map['totalCo2Saved'] ?? 0).toDouble(),
      totalFreeMeals: map['totalFreeMeals'] ?? 0,
      totalReservations: map['totalReservations'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      avgSavingsPerMeal: (map['avgSavingsPerMeal'] ?? 0).toDouble(),
      avgCo2PerMeal: (map['avgCo2PerMeal'] ?? 0).toDouble(),
      favoriteCategory: map['favoriteCategory'],
      favoriteMerchant: map['favoriteMerchant'],
      categoryBreakdown: Map<String, int>.from(map['categoryBreakdown'] ?? {}),
      merchantSavings: Map<String, double>.from(map['merchantSavings'] ?? {}),
      lastUpdated: DateTime.parse(
        map['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Obtient un accomplissement basé sur les statistiques
  String getAchievement() {
    if (totalMealsSaved >= 100) return 'Héros de l\'anti-gaspi 🦸';
    if (totalMealsSaved >= 50) return 'Protecteur de la planète 🌍';
    if (totalMealsSaved >= 20) return 'Éco-guerrier 🌱';
    if (totalMealsSaved >= 10) return 'Apprenti sauveur 🌿';
    if (totalMealsSaved >= 5) return 'Débutant engagé 🍃';
    return 'Nouveau membre 🌾';
  }

  /// Calcule le niveau de l'utilisateur
  int getUserLevel() {
    return (totalMealsSaved / 10).floor() + 1;
  }

  /// Calcule le pourcentage vers le prochain niveau
  double getProgressToNextLevel() {
    return (totalMealsSaved % 10) / 10.0;
  }
}

/// Provider pour le service de statistiques
final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return StatisticsService();
});

/// Provider pour initialiser le service
final statisticsInitProvider = FutureProvider<void>((ref) async {
  final service = ref.read(statisticsServiceProvider);
  await service.init();
});
