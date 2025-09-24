import 'dart:math' as math;

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/analytics.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/merchant_types.dart';
import '../../domain/usecases/merchant/merchant_analytics_usecase.dart';
import 'analytics_repository.dart';

/// Implémentation fake en mémoire pour éviter les erreurs et permettre l'UI d'afficher des données
class FakeAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<Either<Failure, Analytics>> getAnalytics({
    required String merchantId,
    required DateRange period,
  }) async {
    // Génère des données stables mais plausibles
    final performance = PerformanceMetrics(
      totalOffers: 42,
      activeOffers: 8,
      completedReservations: 120,
      cancelledReservations: 10,
      noShowReservations: 6,
      totalViews: 2500,
      completedPickups: 110,
      completionRate: 110 / 120 * 100,
      cancellationRate: 10 / 120 * 100,
      noShowRate: 6 / 120 * 100,
      avgPickupTime: const Duration(minutes: 18),
      efficiencyScore: 78.0,
      satisfactionScore: 86.0,
      repeatCustomerRate: 41.0,
      offersByHour: {for (var h = 8; h <= 20; h += 2) h: 5 + (h % 4)},
      offersByCategory: const {
        'Boulangerie': 14,
        'Déjeuner': 9,
        'Snack': 12,
        'Autre': 7,
      },
    );

    final sales = SalesMetrics(
      totalRevenue: 1840.5,
      averageBasketValue: 9.4,
      revenueGrowth: 12.3,
      totalTransactions: 210,
      conversionRate: 210 / 2500 * 100,
      dailyRevenue: {
        for (int i = 0; i < period.daysCount; i++)
          period.start.add(Duration(days: i)): 40 + math.max(0, math.sin(i / 2) * 30)
      },
      revenueByCategory: const {
        'Boulangerie': 520.0,
        'Déjeuner': 740.0,
        'Snack': 360.0,
        'Autre': 220.5,
      },
      topSellingItems: const [
        TopSellingItem(
          offerId: 'o1',
          offerTitle: 'Panier surprise boulangerie',
          quantity: 85,
          revenue: 510.0,
          percentageOfTotal: 27.7,
        ),
        TopSellingItem(
          offerId: 'o2',
          offerTitle: 'Menu du midi',
          quantity: 65,
          revenue: 650.0,
          percentageOfTotal: 35.3,
        ),
      ],
      priceAnalysis: PriceAnalysis(
        averageDiscount: 38.0,
        optimalPricePoint: 7.9,
        priceDistribution: <double, int>{5.0: 20, 6.0: 30, 7.0: 45, 8.0: 55, 9.0: 40},
        suggestions: const [
          PriceSuggestion(
            offerId: 'o1',
            currentPrice: 8.5,
            suggestedPrice: 7.9,
            reason: 'Améliore le taux de conversion sur le créneau 18h-19h',
            expectedImpact: 8.0,
          ),
        ],
      ),
    );

    final ecological = EcologicalMetrics(
      totalCo2Saved: 1240.0,
      mealsSaved: 620,
      waterSaved: 9500.0,
      plasticReduced: 42.0,
      foodWastePrevented: 310.0,
      sustainabilityScore: 74.0,
      impactByCategory: const {
        'Boulangerie': 320.0,
        'Déjeuner': 540.0,
        'Snack': 180.0,
        'Autre': 200.0,
      },
      monthlyImpact: const {},
      achievements: const [],
      carbonFootprint: const CarbonFootprint(
        baseline: 2200.0,
        saved: 1240.0,
        net: 960.0,
        breakdown: {'Food': 55.0, 'Delivery': 25.0, 'Packaging': 20.0},
      ),
    );

    final customers = CustomerMetrics(
      totalCustomers: 980,
      newCustomers: 210,
      returningCustomers: 180,
      activeCustomers: 420,
      retentionRate: 68.0,
      returnRate: 32.0,
      satisfactionScore: 88.0,
      averageRating: 4.5,
      totalReviews: 320,
      ratingDistribution: const {5: 180, 4: 90, 3: 35, 2: 10, 1: 5},
      segments: const [
        CustomerSegment(
          name: 'Fidèles',
          count: 120,
          percentage: 12.2,
          averageSpend: 10.5,
        ),
        CustomerSegment(
          name: 'Nouveaux',
          count: 210,
          percentage: 21.4,
          averageSpend: 7.8,
        ),
      ],
      behavior: const CustomerBehavior(
        pickupTimeDistribution: {12: 40, 13: 55, 18: 80, 19: 65},
        preferredCategories: {'Boulangerie': 45, 'Déjeuner': 35, 'Snack': 20},
        topProducts: ['Panier viennoiseries', 'Menu sandwich', 'Snack sucré'],
        averageAdvanceBooking: 2.5,
        repeatPurchaseRate: 28.0,
        avgBasketValue: 9.4,
        avgPurchaseFrequency: 1.8,
      ),
    );

    final inventory = InventoryMetrics(
      totalItems: 145,
      lowStockItems: 12,
      outOfStockItems: 3,
      turnoverRate: 2.1,
      wastePercentage: 3.2,
      stockByCategory: const {
        'Boulangerie': 40,
        'Déjeuner': 55,
        'Snack': 30,
        'Autre': 20,
      },
      alerts: const [],
      prediction: const StockPrediction(
        nextWeekNeeds: {'Baguette': 120, 'Croissant': 80, 'Snack': 60},
        reorderSuggestions: [],
        accuracy: 82.0,
      ),
    );

    final analytics = Analytics(
      merchantId: merchantId,
      period: period,
      performance: performance,
      sales: sales,
      ecological: ecological,
      customers: customers,
      inventory: inventory,
      trends: const [],
      generatedAt: DateTime.now(),
    );

    return Right(analytics);
  }

  @override
  Future<Either<Failure, RealtimeDashboard>> getRealtimeDashboard(String merchantId) async {
    final dashboard = RealtimeDashboard(
      activeOffers: 8,
      pendingReservations: 6,
      todayPickups: 32,
      todayRevenue: 142.5,
      recentActivities: [
        RecentActivity(
          id: 'a1',
          type: ActivityType.reservation,
          description: 'Nouvelle réservation - Panier surprise',
          timestamp: DateTime.now(),
        ),
        RecentActivity(
          id: 'a2',
          type: ActivityType.collection,
          description: 'Collecte effectuée - Viennoiseries',
          timestamp: DateTime.now(),
        ),
      ],
      liveMetrics: const {
        'conversionRate': 8.4,
        'activeUsers': 27,
      },
      lastUpdate: DateTime.now(),
    );
    return Right(dashboard);
  }

  @override
  Future<Either<Failure, AnalyticsReport>> generateReport({
    required Analytics analytics,
    required ReportType type,
    required ReportFormat format,
    required Merchant merchant,
  }) async {
    final report = AnalyticsReport(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      format: format,
      generatedAt: DateTime.now(),
      downloadUrl: 'https://example.com/reports/${analytics.merchantId}/${format.name}',
      sizeInBytes: 1024 * 1024,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
    return Right(report);
  }

  @override
  Future<Either<Failure, String>> exportData({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    required ExportFormat format,
    required List<ExportDataType> dataTypes,
  }) async {
    final url = 'https://example.com/exports/$merchantId/${format.name}?from=${startDate.toIso8601String()}&to=${endDate.toIso8601String()}';
    return Right(url);
  }

  @override
  Future<Either<Failure, List<Insight>>> generateInsights({
    required Analytics analytics,
    InsightType? type,
  }) async {
    final insights = <Insight>[
      Insight(
        id: 'i1',
        type: InsightType.pricing,
        title: 'Optimiser le prix du panier du soir',
        description: 'Un prix à 7,90€ augmenterait la conversion de 8% entre 18h-19h.',
        impactScore: 72.0,
        recommendation: 'Tester un A/B prix 7,90€ vs 8,50€ sur 7 jours.',
        createdAt: DateTime.now(),
      ),
      Insight(
        id: 'i2',
        type: InsightType.inventory,
        title: 'Anticiper une hausse de la demande mardi',
        description: 'La demande en viennoiseries est 20% plus élevée les mardis.',
        impactScore: 64.0,
        recommendation: 'Augmenter la production de 15-20% le mardi matin.',
        createdAt: DateTime.now(),
      ),
    ];
    return Right(insights.where((i) => type == null || i.type == type).toList());
  }

  @override
  Future<Either<Failure, SectorBenchmark>> getSectorBenchmark({
    required MerchantType merchantType,
    required String location,
  }) async {
    final benchmark = SectorBenchmark(
      sector: merchantType,
      location: location,
      metrics: {
        'avgRevenue': BenchmarkMetric(
          name: 'avgRevenue',
          average: 1800.0,
          median: 1750.0,
          percentile25: 1500.0,
          percentile75: 2100.0,
          userValue: 1840.5,
        ),
        'avgConversion': BenchmarkMetric(
          name: 'avgConversion',
          average: 9.2,
          median: 9.0,
          percentile25: 7.5,
          percentile75: 11.0,
          userValue: 8.4,
        ),
        'avgSatisfaction': BenchmarkMetric(
          name: 'avgSatisfaction',
          average: 4.3,
          median: 4.4,
          percentile25: 4.0,
          percentile75: 4.6,
          userValue: 4.5,
        ),
      },
      totalMerchants: 120,
      lastUpdate: DateTime.now(),
    );
    return Right(benchmark);
  }

  @override
  Future<Either<Failure, PerformanceMetrics>> getPerformanceMetrics({
    required String merchantId,
    required DateRange period,
  }) async {
    // Simplifier: renvoyer la même structure que dans getAnalytics
    final analytics = await getAnalytics(merchantId: merchantId, period: period);
    return analytics.fold(Left.new, (a) => Right(a.performance));
  }

  @override
  Future<Either<Failure, SalesMetrics>> getSalesMetrics({
    required String merchantId,
    required DateRange period,
  }) async {
    final analytics = await getAnalytics(merchantId: merchantId, period: period);
    return analytics.fold(Left.new, (a) => Right(a.sales));
  }

  @override
  Future<Either<Failure, EcologicalMetrics>> getEcologicalMetrics({
    required String merchantId,
    required DateRange period,
  }) async {
    final analytics = await getAnalytics(merchantId: merchantId, period: period);
    return analytics.fold(Left.new, (a) => Right(a.ecological));
  }

  @override
  Future<Either<Failure, CustomerMetrics>> getCustomerMetrics({
    required String merchantId,
    required DateRange period,
  }) async {
    final analytics = await getAnalytics(merchantId: merchantId, period: period);
    return analytics.fold(Left.new, (a) => Right(a.customers));
  }

  @override
  Future<Either<Failure, InventoryMetrics>> getInventoryMetrics({
    required String merchantId,
  }) async {
    final analytics = await getAnalytics(
      merchantId: merchantId,
      period: DateRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now(), type: AnalyticsPeriod.weekly),
    );
    return analytics.fold(Left.new, (a) => Right(a.inventory));
  }

  @override
  Future<Either<Failure, void>> trackEvent({
    required String merchantId,
    required AnalyticsEvent event,
  }) async => const Right(null);

  @override
  Future<Either<Failure, void>> trackPageView({
    required String merchantId,
    required String pageName,
    Map<String, dynamic>? properties,
  }) async => const Right(null);

  @override
  Future<Either<Failure, void>> trackConversion({
    required String merchantId,
    required ConversionType type,
    required double value,
    Map<String, dynamic>? properties,
  }) async => const Right(null);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getKeyMetrics({
    required String merchantId,
    required DateTime date,
  }) async => Right({
        'activeOffers': 8,
        'pendingReservations': 6,
        'todayRevenue': 142.5,
      });

  @override
  Future<Either<Failure, List<MetricDataPoint>>> getMetricHistory({
    required String merchantId,
    required String metricName,
    required DateRange period,
    required MetricGranularity granularity,
  }) async {
    // Remove unused variable
    final points = <MetricDataPoint>[];
    var cursor = period.start;
    while (cursor.isBefore(period.end) || cursor.isAtSameMomentAs(period.end)) {
      points.add(MetricDataPoint(timestamp: cursor, value: 10 + math.Random(cursor.millisecondsSinceEpoch).nextDouble() * 10));
      cursor = cursor.add(granularity.duration);
    }
    return Right(points);
  }

  @override
  Future<void> cacheAnalytics({
    required String merchantId,
    required Analytics analytics,
    required DateRange period,
  }) async {}

  @override
  Future<Either<Failure, Analytics>> getCachedAnalytics({
    required String merchantId,
    required DateRange period,
  }) async => const Left(CacheFailure('Pas de cache'));

  @override
  Future<void> clearCache({String? merchantId}) async {}

  @override
  Future<Either<Failure, Predictions>> generatePredictions({
    required Analytics historicalData,
    required int daysAhead,
  }) async {
    // Generate fake but plausible predictions based on historical data
    final predictions = <DateTime, PredictedMetrics>{};
    final baseRevenue = historicalData.sales.totalRevenue / historicalData.period.daysCount;
    final baseReservations = historicalData.performance.completedReservations ~/ historicalData.period.daysCount;
    final baseOffers = historicalData.performance.totalOffers;
    
    for (int i = 1; i <= daysAhead; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final dayOfWeek = date.weekday;
      // Simulate weekly patterns (higher on weekends)
      final weekendFactor = (dayOfWeek == 6 || dayOfWeek == 7) ? 1.2 : 1.0;
      
      predictions[date] = PredictedMetrics(
        date: date,
        expectedRevenue: baseRevenue * weekendFactor * (0.9 + math.Random(i).nextDouble() * 0.2),
        expectedReservations: (baseReservations * weekendFactor * (0.9 + math.Random(i + 1).nextDouble() * 0.2)).round(),
        expectedOffers: (baseOffers * (0.95 + math.Random(i + 2).nextDouble() * 0.1)).round(),
        confidence: 85.0 - (i * 1.5), // Confidence decreases with distance
      );
    }
    
    final trends = <PredictedTrend>[
      const PredictedTrend(
        metric: 'revenue',
        direction: TrendDirection.up,
        magnitude: 12.5,
        explanation: 'Croissance prévue basée sur la tendance des 3 derniers mois',
      ),
      const PredictedTrend(
        metric: 'reservations',
        direction: TrendDirection.stable,
        magnitude: 2.3,
        explanation: 'Demande stable avec légère variation saisonnière',
      ),
    ];
    
    return Right(Predictions(
      dailyPredictions: predictions,
      trends: trends,
      confidenceScore: 82.5,
      warnings: daysAhead > 14 ? ['Prédictions au-delà de 14 jours ont une fiabilité réduite'] : [],
    ));
  }
}
