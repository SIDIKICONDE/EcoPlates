import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_stats.dart';
import 'kpi_card.dart';

/// Configurations pour les 4 cartes KPI principales
class KpiConfigs {
  static List<KpiCardConfig> get all => [
    revenue,
    orders,
    averageOrder,
    conversionRate,
  ];

  static const KpiCardConfig revenue = KpiCardConfig(
    title: "Chiffre d'affaires",
    compactTitle: 'CA',
    icon: Icons.euro,
    primaryColor: Color(0xFF4CAF50), // Vert
    gradientColors: [
      Color(0xFF4CAF50),
      Color(0xFF66BB6A),
      Color(0xFF81C784),
    ],
    getValue: _formatCurrencyRevenue,
    getGrowth: _getRevenueGrowth,
    getIsPositive: _isRevenuePositive,
  );

  static const KpiCardConfig orders = KpiCardConfig(
    title: 'Commandes',
    icon: Icons.shopping_bag,
    primaryColor: Color(0xFF2196F3), // Bleu
    gradientColors: [
      Color(0xFF2196F3),
      Color(0xFF42A5F5),
      Color(0xFF64B5F6),
    ],
    getValue: _formatOrders,
    getGrowth: _getOrdersGrowth,
    getIsPositive: _isOrdersPositive,
  );

  static const KpiCardConfig averageOrder = KpiCardConfig(
    title: 'Panier moyen',
    compactTitle: 'Panier moy.',
    icon: Icons.shopping_cart,
    primaryColor: Color(0xFFFF9800), // Orange
    gradientColors: [
      Color(0xFFFF9800),
      Color(0xFFFFB74D),
      Color(0xFFFFCC80),
    ],
    getValue: _formatAverageOrder,
    getGrowth: _getAverageOrderGrowth,
    getIsPositive: _isAverageOrderPositive,
  );

  static const KpiCardConfig conversionRate = KpiCardConfig(
    title: 'Taux conversion',
    compactTitle: 'Conv.',
    icon: Icons.trending_up,
    primaryColor: Color(0xFF9C27B0), // Violet
    gradientColors: [
      Color(0xFF9C27B0),
      Color(0xFFBA68C8),
      Color(0xFFCE93D8),
    ],
    getValue: _formatConversionRate,
    getGrowth: _getConversionRateGrowth,
    getIsPositive: _isConversionRatePositive,
  );

  static String _formatCurrencyRevenue(AnalyticsStats analytics) {
    return _formatCurrency(analytics.totalRevenue);
  }

  static String _formatOrders(AnalyticsStats analytics) {
    return analytics.totalOrders.toString();
  }

  static String _formatAverageOrder(AnalyticsStats analytics) {
    return _formatCurrency(analytics.averageOrderValue);
  }

  static String _formatConversionRate(AnalyticsStats analytics) {
    return '${analytics.conversionRate.toStringAsFixed(1)}%';
  }

  static double? _getRevenueGrowth(AnalyticsStats analytics) {
    return analytics.previousPeriodComparison?.revenueGrowth;
  }

  static bool? _isRevenuePositive(AnalyticsStats analytics) {
    return analytics.previousPeriodComparison?.isPositiveRevenue;
  }

  static double? _getOrdersGrowth(AnalyticsStats analytics) {
    return analytics.previousPeriodComparison?.ordersGrowth;
  }

  static bool? _isOrdersPositive(AnalyticsStats analytics) {
    return analytics.previousPeriodComparison?.isPositiveOrders;
  }

  static double? _getAverageOrderGrowth(AnalyticsStats analytics) {
    return analytics.previousPeriodComparison?.averageOrderGrowth;
  }

  static bool? _isAverageOrderPositive(AnalyticsStats analytics) {
    return analytics.previousPeriodComparison?.isPositiveAverageOrder;
  }

  static double? _getConversionRateGrowth(AnalyticsStats analytics) {
    return analytics.previousPeriodComparison?.conversionRateGrowth;
  }

  static bool? _isConversionRatePositive(AnalyticsStats analytics) {
    return analytics.previousPeriodComparison?.isPositiveConversion;
  }

  static String _formatCurrency(double amount) {
    // Simple formatting - in real app you might want to use intl package
    return '${amount.toStringAsFixed(amount % 1 == 0 ? 0 : 2)} €';
  }
}
