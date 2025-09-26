import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/analytics_stats.dart';

/// Provider pour la période d'analyse sélectionnée
final analyticsPeriodProvider = NotifierProvider<AnalyticsPeriodNotifier, AnalyticsPeriod>(
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
  final (revenueData, ordersData) = _generateTimeSeriesData(period, now);
  
  return AnalyticsStats(
    period: period,
    totalRevenue: _getTotalRevenue(period),
    totalOrders: _getTotalOrders(period),
    averageOrderValue: _getAverageOrderValue(period),
    conversionRate: _getConversionRate(period),
    revenueData: revenueData,
    ordersData: ordersData,
    topProducts: _generateTopProducts(),
    categoryBreakdown: _generateCategoryBreakdown(),
    previousPeriodComparison: _generatePeriodComparison(period),
  );
}

/// Génère des données de série temporelle pour les graphiques
(List<DataPoint>, List<DataPoint>) _generateTimeSeriesData(
  AnalyticsPeriod period,
  DateTime now,
) {
  final revenueData = <DataPoint>[];
  final ordersData = <DataPoint>[];
  
  switch (period) {
    case AnalyticsPeriod.day:
      // Données horaires pour aujourd'hui
      for (var i = 0; i < 24; i++) {
        final hour = now.subtract(Duration(hours: 23 - i));
        final revenue = 50.0 + (i * 15.0) + (i % 3 * 20.0);
        final orders = 2.0 + (i ~/ 4).toDouble() + (i % 2).toDouble();
        
        revenueData.add(DataPoint(
          label: '${hour.hour}h',
          value: revenue.toDouble(),
          date: hour,
        ));
        
        ordersData.add(DataPoint(
          label: '${hour.hour}h',
          value: orders.toDouble(),
          date: hour,
        ));
      }
      
    case AnalyticsPeriod.week:
      // Données journalières pour la semaine
      final weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      for (var i = 0; i < 7; i++) {
        final day = now.subtract(Duration(days: 6 - i));
        final revenue = 300.0 + (i * 50.0) + (i % 2 * 100.0);
        final orders = 15.0 + (i * 5.0) + (i % 3 * 3.0);
        
        revenueData.add(DataPoint(
          label: weekdays[i],
          value: revenue.toDouble(),
          date: day,
        ));
        
        ordersData.add(DataPoint(
          label: weekdays[i],
          value: orders.toDouble(),
          date: day,
        ));
      }
      
    case AnalyticsPeriod.month:
      // Données hebdomadaires pour le mois
      for (var i = 0; i < 4; i++) {
        final week = now.subtract(Duration(days: (3 - i) * 7));
        final revenue = 1200.0 + (i * 200.0) + (i % 2 * 300.0);
        final orders = 80.0 + (i * 15.0) + (i % 3 * 10.0);
        
        revenueData.add(DataPoint(
          label: 'S${i + 1}',
          value: revenue.toDouble(),
          date: week,
        ));
        
        ordersData.add(DataPoint(
          label: 'S${i + 1}',
          value: orders.toDouble(),
          date: week,
        ));
      }
      
    case AnalyticsPeriod.year:
      // Données mensuelles pour l'année
      final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
                     'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
      for (var i = 0; i < 12; i++) {
        final month = DateTime(now.year, i + 1);
        final revenue = 4000.0 + (i * 300.0) + (i % 4 * 500.0);
        final orders = 250.0 + (i * 20.0) + (i % 3 * 30.0);
        
        revenueData.add(DataPoint(
          label: months[i],
          value: revenue.toDouble(),
          date: month,
        ));
        
        ordersData.add(DataPoint(
          label: months[i],
          value: orders.toDouble(),
          date: month,
        ));
      }
  }
  
  return (revenueData, ordersData);
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

/// Génère les données des produits les plus vendus
List<TopProduct> _generateTopProducts() {
  return const [
    TopProduct(
      id: '1',
      name: 'Sandwich jambon-beurre',
      category: 'Sandwiches',
      quantity: 145,
      revenue: 725.0,
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop',
    ),
    TopProduct(
      id: '2',
      name: 'Salade César',
      category: 'Salades',
      quantity: 89,
      revenue: 623.0,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=100&h=100&fit=crop',
    ),
    TopProduct(
      id: '3',
      name: 'Croissant au chocolat',
      category: 'Viennoiseries',
      quantity: 234,
      revenue: 468.0,
      imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=100&h=100&fit=crop',
    ),
    TopProduct(
      id: '4',
      name: 'Pizza Margherita',
      category: 'Pizzas',
      quantity: 67,
      revenue: 670.0,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100&h=100&fit=crop',
    ),
    TopProduct(
      id: '5',
      name: 'Café latte',
      category: 'Boissons',
      quantity: 312,
      revenue: 936.0,
      imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=100&h=100&fit=crop',
    ),
  ];
}

/// Génère la répartition par catégories
List<CategoryData> _generateCategoryBreakdown() {
  return const [
    CategoryData(
      name: 'Sandwiches',
      value: 2450.0,
      percentage: 35.2,
      color: 0xFF4CAF50, // Vert EcoPlates
    ),
    CategoryData(
      name: 'Salades',
      value: 1890.0,
      percentage: 27.1,
      color: 0xFF8BC34A, // Vert clair
    ),
    CategoryData(
      name: 'Viennoiseries',
      value: 1234.0,
      percentage: 17.7,
      color: 0xFFFFEB3B, // Jaune
    ),
    CategoryData(
      name: 'Pizzas',
      value: 890.0,
      percentage: 12.8,
      color: 0xFFFF9800, // Orange
    ),
    CategoryData(
      name: 'Boissons',
      value: 506.0,
      percentage: 7.2,
      color: 0xFF2196F3, // Bleu
    ),
  ];
}

/// Génère la comparaison avec la période précédente
PeriodComparison _generatePeriodComparison(AnalyticsPeriod period) {
  // Générer des variations réalistes
  return const PeriodComparison(
    revenueGrowth: 12.5,
    ordersGrowth: 8.3,
    averageOrderGrowth: 3.8,
    conversionRateGrowth: -1.2, // Peut être négatif
  );
}