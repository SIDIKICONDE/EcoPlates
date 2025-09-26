import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/analytics_stats.dart';

/// Provider pour la période d'analyse sélectionnée
final analyticsPeriodProvider =
    NotifierProvider<AnalyticsPeriodNotifier, AnalyticsPeriod>(
      AnalyticsPeriodNotifier.new,
    );

class AnalyticsPeriodNotifier extends Notifier<AnalyticsPeriod> {
  @override
  AnalyticsPeriod build() => AnalyticsPeriod.week;

  void update(AnalyticsPeriod period) => state = period;
}

/// Provider pour les statistiques d'analyse
/// Charge les données en fonction de la période sélectionnée
final analyticsStatsProvider = FutureProvider<AnalyticsStats>((ref) async {
  final period = ref.watch(analyticsPeriodProvider);

  // Simuler un appel API avec délai
  await Future<void>.delayed(const Duration(milliseconds: 800));

  // TODO(analytics): Remplacer par l'appel réel à l'API
  return _generateMockData(period);
});

/// Extension pour rafraîchir les analytics
extension AnalyticsRefresh on WidgetRef {
  /// Rafraîchit les données d'analytics
  Future<void> refreshAnalytics() async {
    invalidate(analyticsStatsProvider);
  }
}

/// Génère des données mockées pour le développement
///
/// [period] - La période d'analyse sélectionnée
/// Retourne des [AnalyticsStats] avec des données simulées
AnalyticsStats _generateMockData(AnalyticsPeriod period) {
  final now = DateTime.now();

  // Générer des données en fonction de la période
  final (revenueData, ordersData, commissionData) = _generateTimeSeriesData(
    period,
    now,
  );

  return AnalyticsStats(
    period: period,
    totalRevenue: _getTotalRevenue(period),
    totalOrders: _getTotalOrders(period),
    averageOrderValue: _getAverageOrderValue(period),
    conversionRate: _getConversionRate(period),
    totalCommissions: _getTotalCommissions(period),
    revenueData: revenueData,
    ordersData: ordersData,
    commissionData: commissionData,
    topProducts: _generateTopProducts(),
    categoryBreakdown: _generateCategoryBreakdown(),
    customerSatisfactionData: _generateCustomerSatisfactionData(period, now),
    ratingDistribution: _generateRatingDistribution(),
    totalReviews: _getTotalReviews(period),
    conversionFunnel: _generateConversionFunnel(),
    previousPeriodComparison: _generatePeriodComparison(period),
  );
}

/// Génère des données de série temporelle pour les graphiques
(List<DataPoint>, List<DataPoint>, List<DataPoint>) _generateTimeSeriesData(
  AnalyticsPeriod period,
  DateTime now,
) {
  final revenueData = <DataPoint>[];
  final ordersData = <DataPoint>[];
  final commissionData = <DataPoint>[];

  switch (period) {
    case AnalyticsPeriod.day:
      // Données horaires pour aujourd'hui
      for (var i = 0; i < 24; i++) {
        final hour = now.subtract(Duration(hours: 23 - i));
        final revenue = 50.0 + (i * 15.0) + (i % 3 * 20.0);
        final orders = 2.0 + (i ~/ 4) + (i % 2);
        final commission = revenue * 0.15; // 15% de commission

        revenueData.add(
          DataPoint(
            label: '${hour.hour}h',
            value: revenue,
            date: hour,
          ),
        );

        ordersData.add(
          DataPoint(
            label: '${hour.hour}h',
            value: orders,
            date: hour,
          ),
        );

        commissionData.add(
          DataPoint(
            label: '${hour.hour}h',
            value: commission,
            date: hour,
          ),
        );
      }

    case AnalyticsPeriod.week:
      // Données journalières pour la semaine
      final weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      for (var i = 0; i < 7; i++) {
        final day = now.subtract(Duration(days: 6 - i));
        final revenue = 300.0 + (i * 50.0) + (i % 2 * 100.0);
        final orders = 15.0 + (i * 5.0) + (i % 3 * 3.0);
        final commission = revenue * 0.15; // 15% de commission

        revenueData.add(
          DataPoint(
            label: weekdays[i],
            value: revenue,
            date: day,
          ),
        );

        ordersData.add(
          DataPoint(
            label: weekdays[i],
            value: orders,
            date: day,
          ),
        );

        commissionData.add(
          DataPoint(
            label: weekdays[i],
            value: commission,
            date: day,
          ),
        );
      }

    case AnalyticsPeriod.month:
      // Données hebdomadaires pour le mois
      for (var i = 0; i < 4; i++) {
        final week = now.subtract(Duration(days: (3 - i) * 7));
        final revenue = 1200.0 + (i * 200.0) + (i % 2 * 300.0);
        final orders = 80.0 + (i * 15.0) + (i % 3 * 10.0);
        final commission = revenue * 0.15; // 15% de commission

        revenueData.add(
          DataPoint(
            label: 'Sem ${i + 1}',
            value: revenue,
            date: week,
          ),
        );

        ordersData.add(
          DataPoint(
            label: 'Sem ${i + 1}',
            value: orders,
            date: week,
          ),
        );

        commissionData.add(
          DataPoint(
            label: 'Sem ${i + 1}',
            value: commission,
            date: week,
          ),
        );
      }

    case AnalyticsPeriod.year:
      // Données mensuelles pour l'année
      final months = [
        'Jan',
        'Fév',
        'Mar',
        'Avr',
        'Mai',
        'Jun',
        'Jul',
        'Aoû',
        'Sep',
        'Oct',
        'Nov',
        'Déc',
      ];
      for (var i = 0; i < 12; i++) {
        final month = DateTime(now.year, i + 1);
        final revenue = 4000.0 + (i * 300.0) + (i % 4 * 500.0);
        final orders = 250.0 + (i * 20.0) + (i % 3 * 30.0);
        final commission = revenue * 0.15; // 15% de commission

        revenueData.add(
          DataPoint(
            label: months[i],
            value: revenue,
            date: month,
          ),
        );

        ordersData.add(
          DataPoint(
            label: months[i],
            value: orders,
            date: month,
          ),
        );

        commissionData.add(
          DataPoint(
            label: months[i],
            value: commission,
            date: month,
          ),
        );
      }
  }

  return (revenueData, ordersData, commissionData);
}

/// Calcule le chiffre d'affaires total pour la période
double _getTotalRevenue(AnalyticsPeriod period) {
  switch (period) {
    case AnalyticsPeriod.day:
      return 1247.50;
    case AnalyticsPeriod.week:
      return 8734.20;
    case AnalyticsPeriod.month:
      return 34567.80;
    case AnalyticsPeriod.year:
      return 425890.45;
  }
}

/// Calcule le nombre total de commandes pour la période
int _getTotalOrders(AnalyticsPeriod period) {
  switch (period) {
    case AnalyticsPeriod.day:
      return 67;
    case AnalyticsPeriod.week:
      return 456;
    case AnalyticsPeriod.month:
      return 1834;
    case AnalyticsPeriod.year:
      return 22456;
  }
}

/// Calcule le panier moyen pour la période
double _getAverageOrderValue(AnalyticsPeriod period) {
  final revenue = _getTotalRevenue(period);
  final orders = _getTotalOrders(period);
  return revenue / orders;
}

/// Calcule le taux de conversion pour la période
double _getConversionRate(AnalyticsPeriod period) {
  switch (period) {
    case AnalyticsPeriod.day:
      return 3.2;
    case AnalyticsPeriod.week:
      return 4.1;
    case AnalyticsPeriod.month:
      return 3.8;
    case AnalyticsPeriod.year:
      return 3.9;
  }
}

/// Calcule le total des commissions pour la période (15% du CA)
double _getTotalCommissions(AnalyticsPeriod period) {
  return _getTotalRevenue(period) * 0.15;
}

/// Génère les données des produits les plus vendus
List<TopProduct> _generateTopProducts() {
  return const [
    TopProduct(
      id: '1',
      name: 'Sandwich jambon-beurre',
      category: 'Sandwiches',
      quantity: 145,
      revenue: 725,
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop',
    ),
    TopProduct(
      id: '2',
      name: 'Salade César',
      category: 'Salades',
      quantity: 89,
      revenue: 623,
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=100&h=100&fit=crop',
    ),
    TopProduct(
      id: '3',
      name: 'Croissant au chocolat',
      category: 'Viennoiseries',
      quantity: 234,
      revenue: 468,
      imageUrl:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=100&h=100&fit=crop',
    ),
    TopProduct(
      id: '4',
      name: 'Pizza Margherita',
      category: 'Pizzas',
      quantity: 67,
      revenue: 670,
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100&h=100&fit=crop',
    ),
    TopProduct(
      id: '5',
      name: 'Café latte',
      category: 'Boissons',
      quantity: 312,
      revenue: 936,
      imageUrl:
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=100&h=100&fit=crop',
    ),
  ];
}

/// Génère la répartition par catégories
List<CategoryData> _generateCategoryBreakdown() {
  return const [
    CategoryData(
      name: 'Sandwiches',
      value: 2450,
      percentage: 35.2,
      color: 0xFF4CAF50, // Vert EcoPlates
    ),
    CategoryData(
      name: 'Salades',
      value: 1890,
      percentage: 27.1,
      color: 0xFF8BC34A, // Vert clair
    ),
    CategoryData(
      name: 'Viennoiseries',
      value: 1234,
      percentage: 17.7,
      color: 0xFFFFEB3B, // Jaune
    ),
    CategoryData(
      name: 'Pizzas',
      value: 890,
      percentage: 12.8,
      color: 0xFFFF9800, // Orange
    ),
    CategoryData(
      name: 'Boissons',
      value: 506,
      percentage: 7.2,
      color: 0xFF2196F3, // Bleu
    ),
  ];
}

/// Génère les données d'évolution de la satisfaction client
List<DataPoint> _generateCustomerSatisfactionData(
  AnalyticsPeriod period,
  DateTime now,
) {
  final points = <DataPoint>[];
  final count = period == AnalyticsPeriod.day
      ? 24
      : period == AnalyticsPeriod.week
      ? 7
      : period == AnalyticsPeriod.month
      ? 30
      : 12;

  for (var i = 0; i < count; i++) {
    final date = period == AnalyticsPeriod.day
        ? DateTime(now.year, now.month, now.day, i)
        : period == AnalyticsPeriod.week
        ? now.subtract(Duration(days: count - 1 - i))
        : period == AnalyticsPeriod.month
        ? now.subtract(Duration(days: count - 1 - i))
        : DateTime(now.year, i + 1);

    // Note moyenne entre 3.8 et 4.8 avec variations réalistes
    final baseRating = 4.2;
    final variation = (i % 3 - 1) * 0.3; // Variation périodique
    final rating = (baseRating + variation + (i * 0.1) % 0.6).clamp(3.5, 4.8);

    points.add(
      DataPoint(
        label: period == AnalyticsPeriod.day
            ? '${i}h'
            : period == AnalyticsPeriod.week
            ? 'J${i + 1}'
            : period == AnalyticsPeriod.month
            ? '${i + 1}'
            : _getMonthName(i + 1),
        value: rating,
        date: date,
      ),
    );
  }

  return points;
}

/// Génère la répartition des notes clients (1-5 étoiles)
List<RatingData> _generateRatingDistribution() {
  const total = 2847; // Nombre total d'avis simulé

  return const [
    RatingData(
      stars: 5,
      count: 1842,
      percentage: 64.7,
      color: 0xFF4CAF50, // Vert
    ),
    RatingData(
      stars: 4,
      count: 654,
      percentage: 23.0,
      color: 0xFF8BC34A, // Vert clair
    ),
    RatingData(
      stars: 3,
      count: 234,
      percentage: 8.2,
      color: 0xFFFF9800, // Orange
    ),
    RatingData(
      stars: 2,
      count: 78,
      percentage: 2.7,
      color: 0xFFFF5722, // Rouge-orange
    ),
    RatingData(
      stars: 1,
      count: 39,
      percentage: 1.4,
      color: 0xFFF44336, // Rouge
    ),
  ];
}

/// Génère les données du funnel de conversion
List<FunnelStep> _generateConversionFunnel() {
  return const [
    FunnelStep(
      step: 1,
      label: 'Visiteurs App/Web',
      count: 15420,
      percentage: 100.0,
      color: 0xFF9E9E9E, // Gris
    ),
    FunnelStep(
      step: 2,
      label: 'Consultation menu',
      count: 12336,
      percentage: 80.0,
      color: 0xFF2196F3, // Bleu
    ),
    FunnelStep(
      step: 3,
      label: 'Ajout au panier',
      count: 4928,
      percentage: 40.0,
      color: 0xFFFF9800, // Orange
    ),
    FunnelStep(
      step: 4,
      label: 'Validation commande',
      count: 2957,
      percentage: 60.0,
      color: 0xFFFF6F00, // Orange foncé
    ),
    FunnelStep(
      step: 5,
      label: 'Paiement réussi',
      count: 2650,
      percentage: 89.6,
      color: 0xFF4CAF50, // Vert
    ),
    FunnelStep(
      step: 6,
      label: 'Livraison terminée',
      count: 2385,
      percentage: 90.0,
      color: 0xFF2E7D32, // Vert foncé
    ),
  ];
}

/// Calcule le nombre total d'avis pour la période
int _getTotalReviews(AnalyticsPeriod period) {
  switch (period) {
    case AnalyticsPeriod.day:
      return 47;
    case AnalyticsPeriod.week:
      return 234;
    case AnalyticsPeriod.month:
      return 892;
    case AnalyticsPeriod.year:
      return 2847;
  }
}

/// Helper pour obtenir le nom du mois
String _getMonthName(int month) {
  const months = [
    'Jan',
    'Fév',
    'Mar',
    'Avr',
    'Mai',
    'Jun',
    'Jul',
    'Aoû',
    'Sep',
    'Oct',
    'Nov',
    'Déc',
  ];
  return months[month - 1];
}

PeriodComparison _generatePeriodComparison(AnalyticsPeriod period) {
  // Générer des variations réalistes
  return const PeriodComparison(
    revenueGrowth: 12.5,
    ordersGrowth: 8.3,
    averageOrderGrowth: 3.8,
    conversionRateGrowth: -1.2, // Peut être négatif
  );
}
