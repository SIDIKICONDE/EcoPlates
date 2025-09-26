import 'package:equatable/equatable.dart';

/// Entité représentant les statistiques d'analyse pour un commerçant
/// 
/// Contient toutes les données nécessaires pour afficher les KPIs
/// et graphiques sur la page d'analyse marchande
class AnalyticsStats extends Equatable {
  const AnalyticsStats({
    required this.period,
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.conversionRate,
    required this.totalCommissions,
    required this.revenueData,
    required this.ordersData,
    required this.commissionData,
    required this.topProducts,
    required this.categoryBreakdown,
    required this.customerSatisfactionData,
    required this.ratingDistribution,
    required this.totalReviews,
    this.previousPeriodComparison,
  });

  /// Période d'analyse (jour, semaine, mois, année)
  final AnalyticsPeriod period;

  /// Chiffre d'affaires total sur la période
  final double totalRevenue;

  /// Nombre total de commandes
  final int totalOrders;

  /// Panier moyen (CA / nombre de commandes)
  final double averageOrderValue;

  /// Taux de conversion (%)
  final double conversionRate;

  /// Total des commissions payées à la plateforme sur la période
  final double totalCommissions;

  /// Données de revenus pour les graphiques en ligne
  final List<DataPoint> revenueData;

  /// Données de commandes pour les graphiques en barres
  final List<DataPoint> ordersData;

  /// Données de commissions pour les graphiques
  final List<DataPoint> commissionData;

  /// Top 5 des produits les plus vendus
  final List<TopProduct> topProducts;

  /// Répartition par catégories pour le graphique en secteurs
  final List<CategoryData> categoryBreakdown;

  /// Évolution de la satisfaction client (notes moyennes)
  final List<DataPoint> customerSatisfactionData;

  /// Répartition des notes clients (1-5 étoiles)
  final List<RatingData> ratingDistribution;

  /// Nombre total d'avis clients
  final int totalReviews;

  /// Comparaison avec la période précédente (optionnel)
  final PeriodComparison? previousPeriodComparison;

  @override
  List<Object?> get props => [
        period,
        totalRevenue,
        totalOrders,
        averageOrderValue,
        conversionRate,
        totalCommissions,
        revenueData,
        ordersData,
        commissionData,
        topProducts,
        categoryBreakdown,
        customerSatisfactionData,
        ratingDistribution,
        totalReviews,
        previousPeriodComparison,
      ];
}

/// Énumération des périodes d'analyse disponibles
enum AnalyticsPeriod {
  day,
  week,
  month,
  year;

  /// Label affiché dans l'interface
  String get label {
    switch (this) {
      case AnalyticsPeriod.day:
        return "Aujourd'hui";
      case AnalyticsPeriod.week:
        return 'Cette semaine';
      case AnalyticsPeriod.month:
        return 'Ce mois';
      case AnalyticsPeriod.year:
        return 'Cette année';
    }
  }

  /// Label court pour les filtres
  String get shortLabel {
    switch (this) {
      case AnalyticsPeriod.day:
        return '24h';
      case AnalyticsPeriod.week:
        return '7j';
      case AnalyticsPeriod.month:
        return '30j';
      case AnalyticsPeriod.year:
        return '1an';
    }
  }
}

/// Point de données pour les graphiques
class DataPoint extends Equatable {
  const DataPoint({
    required this.label,
    required this.value,
    required this.date,
  });

  /// Label affiché (ex: "Lun", "Jan", etc.)
  final String label;

  /// Valeur numérique
  final double value;

  /// Date correspondante
  final DateTime date;

  @override
  List<Object> get props => [label, value, date];
}

/// Produit le plus vendu
class TopProduct extends Equatable {
  const TopProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.revenue,
    required this.imageUrl,
  });

  /// ID du produit
  final String id;

  /// Nom du produit
  final String name;

  /// Catégorie du produit
  final String category;

  /// Quantité vendue
  final int quantity;

  /// Chiffre d'affaires généré
  final double revenue;

  /// URL de l'image du produit
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name, category, quantity, revenue, imageUrl];
}

/// Données par catégorie pour le graphique en secteurs
class CategoryData extends Equatable {
  const CategoryData({
    required this.name,
    required this.value,
    required this.percentage,
    required this.color,
  });

  /// Nom de la catégorie
  final String name;

  /// Valeur (revenue ou quantity)
  final double value;

  /// Pourcentage du total
  final double percentage;

  /// Couleur pour l'affichage graphique
  final int color;

  @override
  List<Object> get props => [name, value, percentage, color];
}

/// Données de répartition des notes clients (1-5 étoiles)
class RatingData extends Equatable {
  const RatingData({
    required this.stars,
    required this.count,
    required this.percentage,
    required this.color,
  });

  /// Nombre d'étoiles (1-5)
  final int stars;

  /// Nombre d'avis pour cette note
  final int count;

  /// Pourcentage du total
  final double percentage;

  /// Couleur pour l'affichage
  final int color;

  @override
  List<Object> get props => [stars, count, percentage, color];
}

/// Comparaison avec la période précédente
class PeriodComparison extends Equatable {
  const PeriodComparison({
    required this.revenueGrowth,
    required this.ordersGrowth,
    required this.averageOrderGrowth,
    required this.conversionRateGrowth,
  });

  /// Croissance du chiffre d'affaires (%)
  final double revenueGrowth;

  /// Croissance du nombre de commandes (%)
  final double ordersGrowth;

  /// Croissance du panier moyen (%)
  final double averageOrderGrowth;

  /// Croissance du taux de conversion (%)
  final double conversionRateGrowth;

  /// Indique si la croissance est positive
  bool get isPositiveRevenue => revenueGrowth >= 0;
  bool get isPositiveOrders => ordersGrowth >= 0;
  bool get isPositiveAverageOrder => averageOrderGrowth >= 0;
  bool get isPositiveConversion => conversionRateGrowth >= 0;

  @override
  List<Object> get props => [
        revenueGrowth,
        ordersGrowth,
        averageOrderGrowth,
        conversionRateGrowth,
      ];
}
