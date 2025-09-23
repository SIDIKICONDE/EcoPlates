import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/analytics.dart';

/// Interface abstraite pour le repository des analytics
abstract class AnalyticsRepository {
  /// Récupère les analytics d'un commerçant pour une période
  Future<Either<Failure, Analytics>> getMerchantAnalytics(
    String merchantId, {
    DateTime? startDate,
    DateTime? endDate,
    AnalyticsPeriod? period,
  });

  /// Récupère le dashboard temps réel
  Future<Either<Failure, RealtimeDashboard>> getRealtimeDashboard(
    String merchantId,
  );

  /// Récupère les insights et recommandations
  Future<Either<Failure, List<Insight>>> getInsights(String merchantId);

  /// Génère un rapport d'analytics
  Future<Either<Failure, AnalyticsReport>> generateReport(
    String merchantId,
    ReportFormat format, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Format du rapport
enum ReportFormat { pdf, csv, excel }

/// Dashboard temps réel
class RealtimeDashboard {
  final int pendingReservations;
  final double todayRevenue;
  final int todayPickups;
  final int activeOffers;
  final int lowStockOffers;

  const RealtimeDashboard({
    required this.pendingReservations,
    required this.todayRevenue,
    required this.todayPickups,
    required this.activeOffers,
    required this.lowStockOffers,
  });
}

/// Insight et recommandation
class Insight {
  final String id;
  final String title;
  final String description;
  final InsightType type;
  final InsightPriority priority;
  final DateTime createdAt;

  const Insight({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.createdAt,
  });
}

enum InsightType { revenue, customer, inventory, performance, ecological }

enum InsightPriority { low, medium, high, critical }

/// Rapport d'analytics
class AnalyticsReport {
  final String merchantId;
  final AnalyticsPeriod period;
  final ReportFormat format;
  final String url;
  final DateTime generatedAt;

  const AnalyticsReport({
    required this.merchantId,
    required this.period,
    required this.format,
    required this.url,
    required this.generatedAt,
  });
}
