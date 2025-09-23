/// Entité représentant les analytics et métriques pour un commerçant
class Analytics {
  final String merchantId;
  final DateRange period;
  final PerformanceMetrics performance;
  final SalesMetrics sales;
  final EcologicalMetrics ecological;
  final CustomerMetrics customers;
  final InventoryMetrics inventory;
  final List<Trend> trends;
  final DateTime generatedAt;

  const Analytics({
    required this.merchantId,
    required this.period,
    required this.performance,
    required this.sales,
    required this.ecological,
    required this.customers,
    required this.inventory,
    this.trends = const [],
    required this.generatedAt,
  });

  /// Score de performance global (0-100)
  double get globalScore {
    final scores = [
      performance.efficiencyScore,
      sales.conversionRate,
      ecological.sustainabilityScore,
      customers.satisfactionScore,
    ];
    return scores.reduce((a, b) => a + b) / scores.length;
  }
}

/// Période d'analyse
class DateRange {
  final DateTime start;
  final DateTime end;
  final AnalyticsPeriod type;

  const DateRange({required this.start, required this.end, required this.type});

  int get daysCount => end.difference(start).inDays + 1;
}

/// Types de périodes
enum AnalyticsPeriod { daily, weekly, monthly, quarterly, yearly, custom }

/// Métriques de performance
class PerformanceMetrics {
  final int totalOffers;
  final int activeOffers;
  final int completedReservations;
  final int cancelledReservations;
  final int noShowReservations;
  final int totalViews;
  final int completedPickups;
  final double completionRate;
  final double cancellationRate;
  final double noShowRate;
  final Duration avgPickupTime;
  final double efficiencyScore; // 0-100
  final double satisfactionScore; // 0-100
  final double repeatCustomerRate; // %
  final Map<int, int> offersByHour; // Heure -> Nombre d'offres
  final Map<String, int> offersByCategory;

  const PerformanceMetrics({
    required this.totalOffers,
    required this.activeOffers,
    required this.completedReservations,
    required this.cancelledReservations,
    required this.noShowReservations,
    required this.totalViews,
    required this.completedPickups,
    required this.completionRate,
    required this.cancellationRate,
    required this.noShowRate,
    required this.avgPickupTime,
    required this.efficiencyScore,
    required this.satisfactionScore,
    required this.repeatCustomerRate,
    this.offersByHour = const {},
    this.offersByCategory = const {},
  });

  int get totalReservations =>
      completedReservations + cancelledReservations + noShowReservations;
}

/// Métriques de ventes
class SalesMetrics {
  final double totalRevenue;
  final double averageBasketValue;
  final double revenueGrowth; // % vs période précédente
  final int totalTransactions;
  final double conversionRate; // Vues -> Réservations
  final Map<DateTime, double> dailyRevenue;
  final Map<String, double> revenueByCategory;
  final List<TopSellingItem> topSellingItems;
  final PriceAnalysis priceAnalysis;

  const SalesMetrics({
    required this.totalRevenue,
    required this.averageBasketValue,
    required this.revenueGrowth,
    required this.totalTransactions,
    required this.conversionRate,
    this.dailyRevenue = const {},
    this.revenueByCategory = const {},
    this.topSellingItems = const [],
    required this.priceAnalysis,
  });
}

/// Article le plus vendu
class TopSellingItem {
  final String offerId;
  final String offerTitle;
  final int quantity;
  final double revenue;
  final double percentageOfTotal;

  const TopSellingItem({
    required this.offerId,
    required this.offerTitle,
    required this.quantity,
    required this.revenue,
    required this.percentageOfTotal,
  });
}

/// Analyse des prix
class PriceAnalysis {
  final double averageDiscount;
  final double optimalPricePoint;
  final Map<double, int> priceDistribution; // Prix -> Nombre de ventes
  final List<PriceSuggestion> suggestions;

  const PriceAnalysis({
    required this.averageDiscount,
    required this.optimalPricePoint,
    this.priceDistribution = const {},
    this.suggestions = const [],
  });
}

/// Suggestion de prix
class PriceSuggestion {
  final String offerId;
  final double currentPrice;
  final double suggestedPrice;
  final String reason;
  final double expectedImpact; // % d'augmentation des ventes

  const PriceSuggestion({
    required this.offerId,
    required this.currentPrice,
    required this.suggestedPrice,
    required this.reason,
    required this.expectedImpact,
  });
}

/// Métriques écologiques
class EcologicalMetrics {
  final double totalCo2Saved; // kg
  final int mealsSaved;
  final double waterSaved; // litres
  final double plasticReduced; // kg
  final double foodWastePrevented; // kg
  final double sustainabilityScore; // 0-100
  final Map<String, double> impactByCategory;
  final Map<String, Map<String, double>>
  monthlyImpact; // Mois -> {co2Saved, mealsSaved, etc.}
  final List<EcoAchievement> achievements;
  final CarbonFootprint carbonFootprint;

  const EcologicalMetrics({
    required this.totalCo2Saved,
    required this.mealsSaved,
    required this.waterSaved,
    required this.plasticReduced,
    required this.foodWastePrevented,
    required this.sustainabilityScore,
    this.impactByCategory = const {},
    this.monthlyImpact = const {},
    this.achievements = const [],
    required this.carbonFootprint,
  });

  /// Équivalent en arbres plantés
  double get treesEquivalent =>
      totalCo2Saved / 21; // 1 arbre absorbe ~21kg CO2/an

  /// Équivalent en km de voiture évités
  double get carKmEquivalent => totalCo2Saved / 0.12; // Moyenne 120g CO2/km
}

/// Empreinte carbone
class CarbonFootprint {
  final double baseline; // Empreinte de base
  final double saved; // CO2 économisé
  final double net; // Empreinte nette
  final Map<String, double> breakdown; // Répartition par catégorie

  const CarbonFootprint({
    required this.baseline,
    required this.saved,
    required this.net,
    this.breakdown = const {},
  });
}

/// Accomplissement écologique
class EcoAchievement {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final DateTime unlockedAt;
  final int level; // Bronze: 1, Silver: 2, Gold: 3

  const EcoAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.unlockedAt,
    required this.level,
  });
}

/// Métriques clients
class CustomerMetrics {
  final int totalCustomers;
  final int newCustomers;
  final int returningCustomers;
  final int activeCustomers;
  final double retentionRate;
  final double returnRate;
  final double satisfactionScore; // 0-100
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // 1-5 étoiles
  final List<CustomerSegment> segments;
  final CustomerBehavior behavior;

  const CustomerMetrics({
    required this.totalCustomers,
    required this.newCustomers,
    required this.returningCustomers,
    required this.activeCustomers,
    required this.retentionRate,
    required this.returnRate,
    required this.satisfactionScore,
    required this.averageRating,
    required this.totalReviews,
    this.ratingDistribution = const {},
    this.segments = const [],
    required this.behavior,
  });
}

/// Segment de clients
class CustomerSegment {
  final String name;
  final int count;
  final double percentage;
  final double averageSpend;
  final List<String> characteristics;

  const CustomerSegment({
    required this.name,
    required this.count,
    required this.percentage,
    required this.averageSpend,
    this.characteristics = const [],
  });
}

/// Comportement client
class CustomerBehavior {
  final Map<int, int> pickupTimeDistribution; // Heure -> Nombre
  final Map<String, int> preferredCategories;
  final List<String> topProducts;
  final double averageAdvanceBooking; // heures
  final double repeatPurchaseRate;
  final double avgBasketValue;
  final double avgPurchaseFrequency;

  const CustomerBehavior({
    this.pickupTimeDistribution = const {},
    this.preferredCategories = const {},
    this.topProducts = const [],
    required this.averageAdvanceBooking,
    required this.repeatPurchaseRate,
    required this.avgBasketValue,
    required this.avgPurchaseFrequency,
  });
}

/// Métriques d'inventaire
class InventoryMetrics {
  final int totalItems;
  final int lowStockItems;
  final int outOfStockItems;
  final double turnoverRate;
  final double wastePercentage;
  final Map<String, int> stockByCategory;
  final List<InventoryAlert> alerts;
  final StockPrediction prediction;

  const InventoryMetrics({
    required this.totalItems,
    required this.lowStockItems,
    required this.outOfStockItems,
    required this.turnoverRate,
    required this.wastePercentage,
    this.stockByCategory = const {},
    this.alerts = const [],
    required this.prediction,
  });
}

/// Alerte d'inventaire
class InventoryAlert {
  final String itemId;
  final String itemName;
  final InventoryAlertType type;
  final String message;
  final DateTime createdAt;
  final bool isResolved;

  const InventoryAlert({
    required this.itemId,
    required this.itemName,
    required this.type,
    required this.message,
    required this.createdAt,
    this.isResolved = false,
  });
}

/// Types d'alertes inventaire
enum InventoryAlertType { lowStock, outOfStock, expiringSoon, overstocked }

/// Prédiction de stock
class StockPrediction {
  final Map<String, int> nextWeekNeeds;
  final List<ReorderSuggestion> reorderSuggestions;
  final double accuracy; // % de précision des prédictions passées

  const StockPrediction({
    this.nextWeekNeeds = const {},
    this.reorderSuggestions = const [],
    required this.accuracy,
  });
}

/// Suggestion de réapprovisionnement
class ReorderSuggestion {
  final String itemId;
  final String itemName;
  final int currentStock;
  final int suggestedQuantity;
  final DateTime suggestedOrderDate;
  final String reason;

  const ReorderSuggestion({
    required this.itemId,
    required this.itemName,
    required this.currentStock,
    required this.suggestedQuantity,
    required this.suggestedOrderDate,
    required this.reason,
  });
}

/// Tendance
class Trend {
  final TrendType type;
  final String metric;
  final double currentValue;
  final double previousValue;
  final double changePercentage;
  final TrendDirection direction;
  final String insight;

  const Trend({
    required this.type,
    required this.metric,
    required this.currentValue,
    required this.previousValue,
    required this.changePercentage,
    required this.direction,
    required this.insight,
  });
}

/// Types de tendances
enum TrendType { sales, customers, ecological, inventory, performance }

/// Direction de la tendance
enum TrendDirection { up, down, stable }
