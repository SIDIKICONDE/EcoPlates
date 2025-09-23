import 'package:dartz/dartz.dart';
import '../../domain/entities/analytics.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/usecases/merchant/merchant_analytics_usecase.dart';
import '../../core/error/failures.dart';

/// Interface abstraite pour le repository des analytics
abstract class AnalyticsRepository {
  /// Récupérer les analytics pour une période
  Future<Either<Failure, Analytics>> getAnalytics({
    required String merchantId,
    required DateRange period,
  });
  
  /// Récupérer le dashboard temps réel
  Future<Either<Failure, RealtimeDashboard>> getRealtimeDashboard(String merchantId);
  
  /// Générer un rapport
  Future<Either<Failure, AnalyticsReport>> generateReport({
    required Analytics analytics,
    required ReportType type,
    required ReportFormat format,
    required Merchant merchant,
  });
  
  /// Exporter les données
  Future<Either<Failure, String>> exportData({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    required ExportFormat format,
    required List<ExportDataType> dataTypes,
  });
  
  /// Générer des insights
  Future<Either<Failure, List<Insight>>> generateInsights({
    required Analytics analytics,
    InsightType? type,
  });
  
  /// Générer des prédictions
  Future<Either<Failure, Predictions>> generatePredictions({
    required Analytics historicalData,
    required int daysAhead,
  });
  
  /// Récupérer les benchmarks du secteur
  Future<Either<Failure, SectorBenchmark>> getSectorBenchmark({
    required MerchantType merchantType,
    required String location,
  });
  
  /// Récupérer les métriques de performance
  Future<Either<Failure, PerformanceMetrics>> getPerformanceMetrics({
    required String merchantId,
    required DateRange period,
  });
  
  /// Récupérer les métriques de ventes
  Future<Either<Failure, SalesMetrics>> getSalesMetrics({
    required String merchantId,
    required DateRange period,
  });
  
  /// Récupérer les métriques écologiques
  Future<Either<Failure, EcologicalMetrics>> getEcologicalMetrics({
    required String merchantId,
    required DateRange period,
  });
  
  /// Récupérer les métriques clients
  Future<Either<Failure, CustomerMetrics>> getCustomerMetrics({
    required String merchantId,
    required DateRange period,
  });
  
  /// Récupérer les métriques d'inventaire
  Future<Either<Failure, InventoryMetrics>> getInventoryMetrics({
    required String merchantId,
  });
  
  /// Enregistrer un événement analytique
  Future<Either<Failure, void>> trackEvent({
    required String merchantId,
    required AnalyticsEvent event,
  });
  
  /// Enregistrer une vue de page
  Future<Either<Failure, void>> trackPageView({
    required String merchantId,
    required String pageName,
    Map<String, dynamic>? properties,
  });
  
  /// Enregistrer une conversion
  Future<Either<Failure, void>> trackConversion({
    required String merchantId,
    required ConversionType type,
    required double value,
    Map<String, dynamic>? properties,
  });
  
  /// Récupérer les KPIs principaux
  Future<Either<Failure, Map<String, dynamic>>> getKeyMetrics({
    required String merchantId,
    required DateTime date,
  });
  
  /// Récupérer l'historique d'un métrique spécifique
  Future<Either<Failure, List<MetricDataPoint>>> getMetricHistory({
    required String merchantId,
    required String metricName,
    required DateRange period,
    required MetricGranularity granularity,
  });
  
  /// Mettre en cache les analytics
  Future<void> cacheAnalytics({
    required String merchantId,
    required Analytics analytics,
    required DateRange period,
  });
  
  /// Récupérer les analytics depuis le cache
  Future<Either<Failure, Analytics>> getCachedAnalytics({
    required String merchantId,
    required DateRange period,
  });
  
  /// Vider le cache
  Future<void> clearCache({String? merchantId});
}

/// Événement analytique
class AnalyticsEvent {
  final String name;
  final String category;
  final Map<String, dynamic> properties;
  final DateTime timestamp;
  
  const AnalyticsEvent({
    required this.name,
    required this.category,
    required this.properties,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'properties': properties,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// Types de conversion
enum ConversionType {
  reservation,      // Réservation créée
  collection,       // Collecte effectuée
  signup,          // Inscription
  firstOrder,      // Première commande
  referral,        // Parrainage
}

/// Granularité des métriques
enum MetricGranularity {
  hour,
  day,
  week,
  month,
  quarter,
  year,
}

/// Point de données pour un métrique
class MetricDataPoint {
  final DateTime timestamp;
  final double value;
  final Map<String, dynamic>? metadata;
  
  const MetricDataPoint({
    required this.timestamp,
    required this.value,
    this.metadata,
  });
}

/// Configuration des alertes
class AlertConfiguration {
  final String id;
  final String name;
  final String metricName;
  final AlertCondition condition;
  final double threshold;
  final List<NotificationChannel> channels;
  final bool isActive;
  
  const AlertConfiguration({
    required this.id,
    required this.name,
    required this.metricName,
    required this.condition,
    required this.threshold,
    required this.channels,
    required this.isActive,
  });
}

/// Conditions d'alerte
enum AlertCondition {
  above,        // Au-dessus du seuil
  below,        // En dessous du seuil
  equals,       // Égal au seuil
  increases,    // Augmente de X%
  decreases,    // Diminue de X%
}

/// Canaux de notification pour les alertes
enum NotificationChannel {
  email,
  push,
  sms,
  inApp,
}

/// Extension pour la granularité
extension MetricGranularityExtension on MetricGranularity {
  String get displayName {
    switch (this) {
      case MetricGranularity.hour:
        return 'Heure';
      case MetricGranularity.day:
        return 'Jour';
      case MetricGranularity.week:
        return 'Semaine';
      case MetricGranularity.month:
        return 'Mois';
      case MetricGranularity.quarter:
        return 'Trimestre';
      case MetricGranularity.year:
        return 'Année';
    }
  }
  
  Duration get duration {
    switch (this) {
      case MetricGranularity.hour:
        return const Duration(hours: 1);
      case MetricGranularity.day:
        return const Duration(days: 1);
      case MetricGranularity.week:
        return const Duration(days: 7);
      case MetricGranularity.month:
        return const Duration(days: 30);
      case MetricGranularity.quarter:
        return const Duration(days: 90);
      case MetricGranularity.year:
        return const Duration(days: 365);
    }
  }
}