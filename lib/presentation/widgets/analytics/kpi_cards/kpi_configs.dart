import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
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
    primaryColor: DeepColorTokens.success, // Vert forêt profond
    gradientColors: [
      DeepColorTokens.success,
      DeepColorTokens.successLight,
      DeepColorTokens.successContainer,
    ],
    getValue: _formatCurrencyRevenue,
    getGrowth: _getRevenueGrowth,
    getIsPositive: _isRevenuePositive,
  );

  static const KpiCardConfig orders = KpiCardConfig(
    title: 'Commandes',
    icon: Icons.shopping_bag,
    primaryColor: DeepColorTokens.primary, // Bleu profond
    gradientColors: [
      DeepColorTokens.primary,
      DeepColorTokens.primaryLight,
      DeepColorTokens.primaryContainer,
    ],
    getValue: _formatOrders,
    getGrowth: _getOrdersGrowth,
    getIsPositive: _isOrdersPositive,
  );

  static const KpiCardConfig averageOrder = KpiCardConfig(
    title: 'Panier moyen',
    compactTitle: 'Panier moy.',
    icon: Icons.shopping_cart,
    primaryColor: DeepColorTokens.warning, // Orange brûlé profond
    gradientColors: [
      DeepColorTokens.warning,
      DeepColorTokens.warningLight,
      DeepColorTokens.warningContainer,
    ],
    getValue: _formatAverageOrder,
    getGrowth: _getAverageOrderGrowth,
    getIsPositive: _isAverageOrderPositive,
  );

  static const KpiCardConfig conversionRate = KpiCardConfig(
    title: 'Taux conversion',
    compactTitle: 'Conv.',
    icon: Icons.trending_up,
    primaryColor: DeepColorTokens.secondary, // Violet profond
    gradientColors: [
      DeepColorTokens.secondary,
      DeepColorTokens.secondaryLight,
      DeepColorTokens.secondaryContainer,
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
