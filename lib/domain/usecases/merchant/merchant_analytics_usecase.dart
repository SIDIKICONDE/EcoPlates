import '../../entities/analytics.dart';
import '../../entities/merchant.dart';
import '../../../data/repositories/merchant_repository.dart';
import '../../../data/repositories/analytics_repository.dart';
import '../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// Use case pour gérer les analytics et métriques d'un commerçant
class MerchantAnalyticsUseCase {
  final MerchantRepository merchantRepository;
  final AnalyticsRepository analyticsRepository;
  
  const MerchantAnalyticsUseCase({
    required this.merchantRepository,
    required this.analyticsRepository,
  });
  
  /// Récupérer les analytics pour une période donnée
  Future<Either<Failure, Analytics>> getAnalytics({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    AnalyticsPeriod? periodType,
  }) async {
    try {
      // Vérifier que le commerçant existe et est actif
      final merchantResult = await merchantRepository.getMerchant(merchantId);
      
      return merchantResult.fold(
        (failure) => Left(failure),
        (merchant) async {
          if (merchant.status != MerchantStatus.verified) {
            return Left(BusinessFailure('Compte non vérifié'));
          }
          
          // Validation des dates
          if (endDate.isBefore(startDate)) {
            return Left(ValidationFailure('La date de fin doit être après la date de début'));
          }
          
          final daysDiff = endDate.difference(startDate).inDays;
          if (daysDiff > 365) {
            return Left(ValidationFailure('La période ne peut pas dépasser 1 an'));
          }
          
          // Déterminer le type de période si non spécifié
          final period = periodType ?? _determinePeriodType(daysDiff);
          
          // Récupérer les analytics
          return await analyticsRepository.getAnalytics(
            merchantId: merchantId,
            period: DateRange(
              start: startDate,
              end: endDate,
              type: period,
            ),
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Récupérer le dashboard en temps réel
  Future<Either<Failure, RealtimeDashboard>> getRealtimeDashboard({
    required String merchantId,
  }) async {
    try {
      final merchantResult = await merchantRepository.getMerchant(merchantId);
      
      return merchantResult.fold(
        (failure) => Left(failure),
        (merchant) async {
          if (merchant.status != MerchantStatus.verified) {
            return Left(BusinessFailure('Compte non vérifié'));
          }
          
          return await analyticsRepository.getRealtimeDashboard(merchantId);
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Générer un rapport détaillé
  Future<Either<Failure, AnalyticsReport>> generateReport({
    required String merchantId,
    required ReportType type,
    required DateTime startDate,
    required DateTime endDate,
    ReportFormat format = ReportFormat.pdf,
  }) async {
    try {
      final merchantResult = await merchantRepository.getMerchant(merchantId);
      
      return merchantResult.fold(
        (failure) => Left(failure),
        (merchant) async {
          // Validation
          if (!merchant.isVerified) {
            return Left(BusinessFailure('Compte non vérifié'));
          }
          
          if (endDate.isBefore(startDate)) {
            return Left(ValidationFailure('Dates invalides'));
          }
          
          // Générer le rapport
          final analyticsResult = await getAnalytics(
            merchantId: merchantId,
            startDate: startDate,
            endDate: endDate,
          );
          
          return analyticsResult.fold(
            (failure) => Left(failure),
            (analytics) async {
              return await analyticsRepository.generateReport(
                analytics: analytics,
                type: type,
                format: format,
                merchant: merchant,
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Exporter les données analytics
  Future<Either<Failure, String>> exportAnalytics({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    required ExportFormat format,
    List<ExportDataType>? dataTypes,
  }) async {
    try {
      final merchantResult = await merchantRepository.getMerchant(merchantId);
      
      return merchantResult.fold(
        (failure) => Left(failure),
        (merchant) async {
          if (!merchant.isVerified) {
            return Left(BusinessFailure('Compte non vérifié'));
          }
          
          // Exporter les données
          return await analyticsRepository.exportData(
            merchantId: merchantId,
            startDate: startDate,
            endDate: endDate,
            format: format,
            dataTypes: dataTypes ?? ExportDataType.values,
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Récupérer les insights et recommandations
  Future<Either<Failure, List<Insight>>> getInsights({
    required String merchantId,
    InsightType? type,
  }) async {
    try {
      final merchantResult = await merchantRepository.getMerchant(merchantId);
      
      return merchantResult.fold(
        (failure) => Left(failure),
        (merchant) async {
          // Récupérer les analytics du dernier mois
          final endDate = DateTime.now();
          final startDate = endDate.subtract(const Duration(days: 30));
          
          final analyticsResult = await getAnalytics(
            merchantId: merchantId,
            startDate: startDate,
            endDate: endDate,
          );
          
          return analyticsResult.fold(
            (failure) => Left(failure),
            (analytics) async {
              // Générer les insights basés sur les données
              return await analyticsRepository.generateInsights(
                analytics: analytics,
                type: type,
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Comparer les performances avec d'autres périodes
  Future<Either<Failure, PerformanceComparison>> comparePerformance({
    required String merchantId,
    required DateTime currentStart,
    required DateTime currentEnd,
    DateTime? previousStart,
    DateTime? previousEnd,
  }) async {
    try {
      // Si pas de période précédente, prendre la même durée avant
      final duration = currentEnd.difference(currentStart);
      final prevStart = previousStart ?? currentStart.subtract(duration);
      final prevEnd = previousEnd ?? currentEnd.subtract(duration);
      
      // Récupérer les analytics des deux périodes
      final currentResult = await getAnalytics(
        merchantId: merchantId,
        startDate: currentStart,
        endDate: currentEnd,
      );
      
      final previousResult = await getAnalytics(
        merchantId: merchantId,
        startDate: prevStart,
        endDate: prevEnd,
      );
      
      // Combiner les résultats
      return currentResult.fold(
        (failure) => Left(failure),
        (current) {
          return previousResult.fold(
            (failure) => Left(failure),
            (previous) {
              return Right(PerformanceComparison(
                currentPeriod: current,
                previousPeriod: previous,
                changes: _calculateChanges(current, previous),
              ));
            },
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Obtenir les prédictions et tendances
  Future<Either<Failure, Predictions>> getPredictions({
    required String merchantId,
    required int daysAhead,
  }) async {
    try {
      if (daysAhead < 1 || daysAhead > 30) {
        return Left(ValidationFailure('Les prédictions sont limitées à 30 jours'));
      }
      
      final merchantResult = await merchantRepository.getMerchant(merchantId);
      
      return merchantResult.fold(
        (failure) => Left(failure),
        (merchant) async {
          // Récupérer l'historique pour la prédiction
          final endDate = DateTime.now();
          final startDate = endDate.subtract(const Duration(days: 90)); // 3 mois d'historique
          
          final analyticsResult = await getAnalytics(
            merchantId: merchantId,
            startDate: startDate,
            endDate: endDate,
          );
          
          return analyticsResult.fold(
            (failure) => Left(failure),
            (analytics) async {
              return await analyticsRepository.generatePredictions(
                historicalData: analytics,
                daysAhead: daysAhead,
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Récupérer les benchmarks du secteur
  Future<Either<Failure, SectorBenchmark>> getSectorBenchmark({
    required String merchantId,
  }) async {
    try {
      final merchantResult = await merchantRepository.getMerchant(merchantId);
      
      return merchantResult.fold(
        (failure) => Left(failure),
        (merchant) async {
          return await analyticsRepository.getSectorBenchmark(
            merchantType: merchant.type,
            location: merchant.address.city,
          );
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
  
  /// Déterminer automatiquement le type de période
  AnalyticsPeriod _determinePeriodType(int days) {
    if (days <= 1) return AnalyticsPeriod.daily;
    if (days <= 7) return AnalyticsPeriod.weekly;
    if (days <= 31) return AnalyticsPeriod.monthly;
    if (days <= 93) return AnalyticsPeriod.quarterly;
    if (days <= 365) return AnalyticsPeriod.yearly;
    return AnalyticsPeriod.custom;
  }
  
  /// Calculer les changements entre deux périodes
  Map<String, PerformanceChange> _calculateChanges(Analytics current, Analytics previous) {
    return {
      'revenue': PerformanceChange(
        metric: 'Chiffre d\'affaires',
        currentValue: current.sales.totalRevenue,
        previousValue: previous.sales.totalRevenue,
        changePercent: _calculatePercentChange(
          current.sales.totalRevenue, 
          previous.sales.totalRevenue
        ),
      ),
      'reservations': PerformanceChange(
        metric: 'Réservations',
        currentValue: current.performance.totalReservations.toDouble(),
        previousValue: previous.performance.totalReservations.toDouble(),
        changePercent: _calculatePercentChange(
          current.performance.totalReservations.toDouble(),
          previous.performance.totalReservations.toDouble()
        ),
      ),
      'completion_rate': PerformanceChange(
        metric: 'Taux de collecte',
        currentValue: current.performance.completionRate,
        previousValue: previous.performance.completionRate,
        changePercent: current.performance.completionRate - previous.performance.completionRate,
      ),
      'co2_saved': PerformanceChange(
        metric: 'CO₂ économisé',
        currentValue: current.ecological.totalCo2Saved,
        previousValue: previous.ecological.totalCo2Saved,
        changePercent: _calculatePercentChange(
          current.ecological.totalCo2Saved,
          previous.ecological.totalCo2Saved
        ),
      ),
    };
  }
  
  double _calculatePercentChange(double current, double previous) {
    if (previous == 0) return current > 0 ? 100 : 0;
    return ((current - previous) / previous) * 100;
  }
}

/// Dashboard temps réel
class RealtimeDashboard {
  final int activeOffers;
  final int pendingReservations;
  final int todayPickups;
  final double todayRevenue;
  final List<RecentActivity> recentActivities;
  final Map<String, dynamic> liveMetrics;
  final DateTime lastUpdate;
  
  const RealtimeDashboard({
    required this.activeOffers,
    required this.pendingReservations,
    required this.todayPickups,
    required this.todayRevenue,
    required this.recentActivities,
    required this.liveMetrics,
    required this.lastUpdate,
  });
}

/// Activité récente
class RecentActivity {
  final String id;
  final ActivityType type;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  
  const RecentActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    this.metadata = const {},
  });
}

enum ActivityType {
  reservation,
  collection,
  cancellation,
  offerCreated,
  offerUpdated,
  review,
}

/// Types de rapports
enum ReportType {
  performance,
  financial,
  ecological,
  customer,
  complete,
}

/// Formats de rapport
enum ReportFormat {
  pdf,
  excel,
  csv,
}

/// Rapport analytics
class AnalyticsReport {
  final String id;
  final ReportType type;
  final ReportFormat format;
  final DateTime generatedAt;
  final String downloadUrl;
  final int sizeInBytes;
  final DateTime expiresAt;
  
  const AnalyticsReport({
    required this.id,
    required this.type,
    required this.format,
    required this.generatedAt,
    required this.downloadUrl,
    required this.sizeInBytes,
    required this.expiresAt,
  });
}

/// Formats d'export
enum ExportFormat {
  json,
  csv,
  excel,
}

/// Types de données à exporter
enum ExportDataType {
  offers,
  reservations,
  customers,
  revenue,
  ecological,
}

/// Insight
class Insight {
  final String id;
  final InsightType type;
  final String title;
  final String description;
  final double impactScore; // 0-100
  final String recommendation;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  
  const Insight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.impactScore,
    required this.recommendation,
    this.data = const {},
    required this.createdAt,
  });
}

/// Types d'insights
enum InsightType {
  pricing,
  timing,
  inventory,
  customer,
  ecological,
}

/// Comparaison de performances
class PerformanceComparison {
  final Analytics currentPeriod;
  final Analytics previousPeriod;
  final Map<String, PerformanceChange> changes;
  
  const PerformanceComparison({
    required this.currentPeriod,
    required this.previousPeriod,
    required this.changes,
  });
  
  bool get isImproving => changes.values.where((c) => c.changePercent > 0).length > 
                          changes.values.where((c) => c.changePercent < 0).length;
}

/// Changement de performance
class PerformanceChange {
  final String metric;
  final double currentValue;
  final double previousValue;
  final double changePercent;
  
  const PerformanceChange({
    required this.metric,
    required this.currentValue,
    required this.previousValue,
    required this.changePercent,
  });
  
  bool get isPositive => changePercent > 0;
}

/// Prédictions
class Predictions {
  final Map<DateTime, PredictedMetrics> dailyPredictions;
  final List<PredictedTrend> trends;
  final double confidenceScore; // 0-100
  final List<String> warnings;
  
  const Predictions({
    required this.dailyPredictions,
    required this.trends,
    required this.confidenceScore,
    this.warnings = const [],
  });
}

/// Métriques prédites
class PredictedMetrics {
  final DateTime date;
  final double expectedRevenue;
  final int expectedReservations;
  final int expectedOffers;
  final double confidence;
  
  const PredictedMetrics({
    required this.date,
    required this.expectedRevenue,
    required this.expectedReservations,
    required this.expectedOffers,
    required this.confidence,
  });
}

/// Tendance prédite
class PredictedTrend {
  final String metric;
  final TrendDirection direction;
  final double magnitude; // Force de la tendance
  final String explanation;
  
  const PredictedTrend({
    required this.metric,
    required this.direction,
    required this.magnitude,
    required this.explanation,
  });
}

/// Benchmark du secteur
class SectorBenchmark {
  final MerchantType sector;
  final String location;
  final Map<String, BenchmarkMetric> metrics;
  final int totalMerchants;
  final DateTime lastUpdate;
  
  const SectorBenchmark({
    required this.sector,
    required this.location,
    required this.metrics,
    required this.totalMerchants,
    required this.lastUpdate,
  });
}

/// Métrique de benchmark
class BenchmarkMetric {
  final String name;
  final double average;
  final double median;
  final double percentile25;
  final double percentile75;
  final double userValue;
  
  const BenchmarkMetric({
    required this.name,
    required this.average,
    required this.median,
    required this.percentile25,
    required this.percentile75,
    required this.userValue,
  });
  
  /// Position relative (0-100)
  double get userPercentile {
    if (userValue <= percentile25) return 25;
    if (userValue >= percentile75) return 75;
    if (userValue <= median) {
      return 25 + ((userValue - percentile25) / (median - percentile25)) * 25;
    }
    return 50 + ((userValue - median) / (percentile75 - median)) * 25;
  }
}