import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/analytics.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../domain/usecases/merchant/merchant_analytics_usecase.dart';
import '../../../data/repositories/analytics_repository.dart';
import '../../../data/repositories/analytics_repository_fake.dart';
import '../../../core/error/failures.dart';
import 'offers_management_provider.dart';

/// Provider pour le repository analytics
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return FakeAnalyticsRepository();
});

/// Provider pour le use case analytics
final merchantAnalyticsUseCaseProvider = Provider<MerchantAnalyticsUseCase>((
  ref,
) {
  final merchantRepository = ref.watch(merchantRepositoryProvider);
  final analyticsRepository = ref.watch(analyticsRepositoryProvider);

  return MerchantAnalyticsUseCase(
    merchantRepository: merchantRepository,
    analyticsRepository: analyticsRepository,
  );
});

/// Période sélectionnée pour les analytics
class AnalyticsPeriodSelection {
  final DateTime startDate;
  final DateTime endDate;
  final AnalyticsPeriod type;

  const AnalyticsPeriodSelection({
    required this.startDate,
    required this.endDate,
    required this.type,
  });

  /// Période du jour
  static AnalyticsPeriodSelection get today {
    final now = DateTime.now();
    return AnalyticsPeriodSelection(
      startDate: DateTime(now.year, now.month, now.day),
      endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
      type: AnalyticsPeriod.daily,
    );
  }

  /// Période de la semaine
  static AnalyticsPeriodSelection get thisWeek {
    final now = DateTime.now();
    final weekDay = now.weekday;
    final startOfWeek = now.subtract(Duration(days: weekDay - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return AnalyticsPeriodSelection(
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(
        endOfWeek.year,
        endOfWeek.month,
        endOfWeek.day,
        23,
        59,
        59,
      ),
      type: AnalyticsPeriod.weekly,
    );
  }

  /// Période du mois
  static AnalyticsPeriodSelection get thisMonth {
    final now = DateTime.now();
    return AnalyticsPeriodSelection(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
      type: AnalyticsPeriod.monthly,
    );
  }

  /// Période de l'année
  static AnalyticsPeriodSelection get thisYear {
    final now = DateTime.now();
    return AnalyticsPeriodSelection(
      startDate: DateTime(now.year, 1, 1),
      endDate: DateTime(now.year, 12, 31, 23, 59, 59),
      type: AnalyticsPeriod.yearly,
    );
  }
}

/// Provider pour la période sélectionnée
final analyticsPeriodProvider = StateProvider<AnalyticsPeriodSelection>((ref) {
  return AnalyticsPeriodSelection.thisMonth;
});

/// Provider pour les analytics générales
final merchantAnalyticsProvider = FutureProvider<Either<Failure, Analytics>>((
  ref,
) async {
  final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
  final merchantId = ref.watch(currentMerchantIdProvider);
  final period = ref.watch(analyticsPeriodProvider);

  if (merchantId == null) {
    return Left(AuthenticationFailure('Non authentifié'));
  }

  return await useCase.getAnalytics(
    merchantId: merchantId,
    startDate: period.startDate,
    endDate: period.endDate,
    periodType: period.type,
  );
});

/// Provider pour le dashboard temps réel
final realtimeDashboardProvider =
    FutureProvider<Either<Failure, RealtimeDashboard>>((ref) async {
      final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
      final merchantId = ref.watch(currentMerchantIdProvider);

      if (merchantId == null) {
        return Left(AuthenticationFailure('Non authentifié'));
      }

      return await useCase.getRealtimeDashboard(merchantId: merchantId);
    });

/// Provider pour les insights
final merchantInsightsProvider = FutureProvider<Either<Failure, List<Insight>>>(
  (ref) async {
    final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);

    if (merchantId == null) {
      return Left(AuthenticationFailure('Non authentifié'));
    }

    return await useCase.getInsights(merchantId: merchantId);
  },
);

/// Provider pour un type d'insight spécifique
final insightsByTypeProvider =
    FutureProvider.family<Either<Failure, List<Insight>>, InsightType>((
      ref,
      type,
    ) async {
      final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
      final merchantId = ref.watch(currentMerchantIdProvider);

      if (merchantId == null) {
        return Left(AuthenticationFailure('Non authentifié'));
      }

      return await useCase.getInsights(merchantId: merchantId, type: type);
    });

/// Provider pour les prédictions
final merchantPredictionsProvider =
    FutureProvider.family<Either<Failure, Predictions>, int>((
      ref,
      daysAhead,
    ) async {
      final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
      final merchantId = ref.watch(currentMerchantIdProvider);

      if (merchantId == null) {
        return Left(AuthenticationFailure('Non authentifié'));
      }

      return await useCase.getPredictions(
        merchantId: merchantId,
        daysAhead: daysAhead,
      );
    });

/// Provider pour les benchmarks secteur
final sectorBenchmarkProvider =
    FutureProvider<Either<Failure, SectorBenchmark>>((ref) async {
      final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
      final merchantId = ref.watch(currentMerchantIdProvider);

      if (merchantId == null) {
        return Left(AuthenticationFailure('Non authentifié'));
      }

      return await useCase.getSectorBenchmark(merchantId: merchantId);
    });

/// Provider pour comparer les performances
final performanceComparisonProvider =
    FutureProvider<Either<Failure, PerformanceComparison>>((ref) async {
      final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
      final merchantId = ref.watch(currentMerchantIdProvider);
      final period = ref.watch(analyticsPeriodProvider);

      if (merchantId == null) {
        return Left(AuthenticationFailure('Non authentifié'));
      }

      // Calculer la période précédente
      final duration = period.endDate.difference(period.startDate);
      final previousStart = period.startDate.subtract(duration);
      final previousEnd = period.endDate.subtract(duration);

      return await useCase.comparePerformance(
        merchantId: merchantId,
        currentStart: period.startDate,
        currentEnd: period.endDate,
        previousStart: previousStart,
        previousEnd: previousEnd,
      );
    });

/// Types de rapports disponibles
final selectedReportTypeProvider = StateProvider<ReportType>(
  (ref) => ReportType.complete,
);

/// Provider pour générer un rapport
final generateReportProvider =
    FutureProvider.family<Either<Failure, AnalyticsReport>, ReportFormat>((
      ref,
      format,
    ) async {
      final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
      final merchantId = ref.watch(currentMerchantIdProvider);
      final period = ref.watch(analyticsPeriodProvider);
      final reportType = ref.watch(selectedReportTypeProvider);

      if (merchantId == null) {
        return Left(AuthenticationFailure('Non authentifié'));
      }

      return await useCase.generateReport(
        merchantId: merchantId,
        type: reportType,
        startDate: period.startDate,
        endDate: period.endDate,
        format: format,
      );
    });

/// Provider pour exporter les données
final exportDataProvider =
    FutureProvider.family<
      Either<Failure, String>,
      ({ExportFormat format, List<ExportDataType> types})
    >((ref, params) async {
      final useCase = ref.watch(merchantAnalyticsUseCaseProvider);
      final merchantId = ref.watch(currentMerchantIdProvider);
      final period = ref.watch(analyticsPeriodProvider);

      if (merchantId == null) {
        return Left(AuthenticationFailure('Non authentifié'));
      }

      return await useCase.exportAnalytics(
        merchantId: merchantId,
        startDate: period.startDate,
        endDate: period.endDate,
        format: params.format,
        dataTypes: params.types,
      );
    });

/// Provider pour les métriques clés du jour
final todayKeyMetricsProvider = Provider<Map<String, dynamic>>((ref) {
  final dashboardAsync = ref.watch(realtimeDashboardProvider);

  return dashboardAsync.maybeWhen(
    data: (result) => result.fold(
      (_) => {},
      (dashboard) => {
        'activeOffers': dashboard.activeOffers,
        'pendingReservations': dashboard.pendingReservations,
        'todayPickups': dashboard.todayPickups,
        'todayRevenue': dashboard.todayRevenue,
        'lastUpdate': dashboard.lastUpdate,
      },
    ),
    orElse: () => {},
  );
});

/// Provider pour le score global de performance
final performanceScoreProvider = Provider<double>((ref) {
  final analyticsAsync = ref.watch(merchantAnalyticsProvider);

  return analyticsAsync.maybeWhen(
    data: (result) =>
        result.fold((_) => 0.0, (analytics) => analytics.globalScore),
    orElse: () => 0.0,
  );
});

/// Provider pour les métriques écologiques simplifiées
final ecoMetricsSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final analyticsAsync = ref.watch(merchantAnalyticsProvider);

  return analyticsAsync.maybeWhen(
    data: (result) => result.fold(
      (_) => {},
      (analytics) => {
        'co2Saved': analytics.ecological.totalCo2Saved,
        'mealsSaved': analytics.ecological.mealsSaved,
        'waterSaved': analytics.ecological.waterSaved,
        'treesEquivalent': analytics.ecological.treesEquivalent,
        'carKmEquivalent': analytics.ecological.carKmEquivalent,
        'sustainabilityScore': analytics.ecological.sustainabilityScore,
      },
    ),
    orElse: () => {},
  );
});

/// StateNotifier pour gérer les filtres analytics
class AnalyticsFilters {
  final List<FoodCategory>? categories;
  final List<OfferType>? offerTypes;
  final bool includeExpired;

  const AnalyticsFilters({
    this.categories,
    this.offerTypes,
    this.includeExpired = false,
  });

  AnalyticsFilters copyWith({
    List<FoodCategory>? categories,
    List<OfferType>? offerTypes,
    bool? includeExpired,
  }) {
    return AnalyticsFilters(
      categories: categories ?? this.categories,
      offerTypes: offerTypes ?? this.offerTypes,
      includeExpired: includeExpired ?? this.includeExpired,
    );
  }
}

class AnalyticsFiltersNotifier extends StateNotifier<AnalyticsFilters> {
  AnalyticsFiltersNotifier() : super(const AnalyticsFilters());

  void setCategories(List<FoodCategory>? categories) {
    state = state.copyWith(categories: categories);
  }

  void setOfferTypes(List<OfferType>? types) {
    state = state.copyWith(offerTypes: types);
  }

  void toggleIncludeExpired() {
    state = state.copyWith(includeExpired: !state.includeExpired);
  }

  void reset() {
    state = const AnalyticsFilters();
  }
}

/// Provider pour les filtres analytics
final analyticsFiltersProvider =
    StateNotifierProvider<AnalyticsFiltersNotifier, AnalyticsFilters>((ref) {
      return AnalyticsFiltersNotifier();
    });

/// Provider pour les activités récentes
final recentActivitiesProvider = Provider<List<RecentActivity>>((ref) {
  final dashboardAsync = ref.watch(realtimeDashboardProvider);

  return dashboardAsync.maybeWhen(
    data: (result) =>
        result.fold((_) => [], (dashboard) => dashboard.recentActivities),
    orElse: () => [],
  );
});

/// Provider pour suivre si le commerçant s'améliore
final isImprovingProvider = Provider<bool>((ref) {
  final comparisonAsync = ref.watch(performanceComparisonProvider);

  return comparisonAsync.maybeWhen(
    data: (result) =>
        result.fold((_) => false, (comparison) => comparison.isImproving),
    orElse: () => false,
  );
});
