import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dartz/dartz.dart';
import 'dart:math' as math;

import '../../../../core/widgets/adaptive_widgets.dart';
import '../../../../core/error/merchant_error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/analytics.dart';
import '../../../../domain/usecases/merchant/merchant_analytics_usecase.dart';
import '../../../providers/merchant/analytics_provider.dart';
import 'analytics_widgets.dart';

/// Dashboard analytics pour les commerçants
class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends ConsumerState<AnalyticsDashboardScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Analytics'),
        actions: [
          // Sélecteur de période
          _buildPeriodSelector(),
          // Export
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _showExportOptions,
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: theme.primaryColor,
        tabs: const [
          Tab(text: 'Vue d\'ensemble'),
          Tab(text: 'Performance'),
          Tab(text: 'Impact écologique'),
          Tab(text: 'Clients'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildPerformanceTab(),
          _buildEcologicalTab(),
          _buildCustomersTab(),
        ],
      ),
    );
  }
  
  Widget _buildPeriodSelector() {
    return Consumer(
      builder: (context, ref, child) {
        final period = ref.watch(analyticsPeriodProvider);
        
        return PopupMenuButton<AnalyticsPeriodSelection>(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20.sp),
                SizedBox(width: 8.w),
                Text(_getPeriodLabel(period.type)),
                Icon(Icons.arrow_drop_down, size: 20.sp),
              ],
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: AnalyticsPeriodSelection.today,
              child: const Text('Aujourd\'hui'),
            ),
            PopupMenuItem(
              value: AnalyticsPeriodSelection.thisWeek,
              child: const Text('Cette semaine'),
            ),
            PopupMenuItem(
              value: AnalyticsPeriodSelection.thisMonth,
              child: const Text('Ce mois'),
            ),
            PopupMenuItem(
              value: AnalyticsPeriodSelection.thisYear,
              child: const Text('Cette année'),
            ),
          ],
          onSelected: (selection) {
            ref.read(analyticsPeriodProvider.notifier).state = selection;
          },
        );
      },
    );
  }
  
  /// Onglet Vue d'ensemble
  Widget _buildOverviewTab() {
    return Consumer(
      builder: (context, ref, child) {
        final analyticsAsync = ref.watch(merchantAnalyticsProvider);
        final realtimeDashboard = ref.watch(realtimeDashboardProvider);
        final performanceScore = ref.watch(performanceScoreProvider);
        
        return analyticsAsync.when(
          data: (result) => result.fold(
            (failure) => _buildErrorState(failure),
            (analytics) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(merchantAnalyticsProvider);
                ref.invalidate(realtimeDashboardProvider);
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Score global
                    _buildGlobalScoreCard(performanceScore),
                    SizedBox(height: 16.h),
                    
                    // Métriques temps réel
                    _buildRealtimeMetrics(realtimeDashboard),
                    SizedBox(height: 16.h),
                    
                    // Graphique des revenus
                    _buildRevenueChart(analytics),
                    SizedBox(height: 16.h),
                    
                    // Top insights
                    _buildInsights(),
                    SizedBox(height: 16.h),
                    
                    // Comparaison avec période précédente
                    _buildComparisonCards(),
                  ],
                ),
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(
            MerchantErrorHandler.handleError(error),
          ),
        );
      },
    );
  }
  
  /// Onglet Performance
  Widget _buildPerformanceTab() {
    return Consumer(
      builder: (context, ref, child) {
        final analyticsAsync = ref.watch(merchantAnalyticsProvider);
        
        return analyticsAsync.when(
          data: (result) => result.fold(
            (failure) => _buildErrorState(failure),
            (analytics) => SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Taux de conversion
                  _buildConversionFunnel(analytics),
                  SizedBox(height: 16.h),
                  
                  // Distribution des offres par heure
                  _buildOffersByHourChart(analytics.performance.offersByHour),
                  SizedBox(height: 16.h),
                  
                  // Métriques de performance détaillées
                  _buildPerformanceMetrics(analytics.performance),
                  SizedBox(height: 16.h),
                  
                  // Prédictions
                  _buildPredictionsSection(),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(
            MerchantErrorHandler.handleError(error),
          ),
        );
      },
    );
  }
  
  /// Onglet Impact écologique
  Widget _buildEcologicalTab() {
    return Consumer(
      builder: (context, ref, child) {
        final ecoMetrics = ref.watch(ecoMetricsSummaryProvider);
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Score de durabilité
              _buildSustainabilityScore(ecoMetrics['sustainabilityScore'] ?? 0),
              SizedBox(height: 16.h),
              
              // Métriques écologiques principales
              _buildEcoMetricsGrid(ecoMetrics),
              SizedBox(height: 16.h),
              
              // Équivalences visuelles
              _buildEcoEquivalences(ecoMetrics),
              SizedBox(height: 16.h),
              
              // Graphique d'impact dans le temps
              _buildEcoImpactChart(),
              SizedBox(height: 16.h),
              
              // Achievements écologiques
              _buildEcoAchievements(),
            ],
          ),
        );
      },
    );
  }
  
  /// Onglet Clients
  Widget _buildCustomersTab() {
    return Consumer(
      builder: (context, ref, child) {
        final analyticsAsync = ref.watch(merchantAnalyticsProvider);
        
        return analyticsAsync.when(
          data: (result) => result.fold(
            (failure) => _buildErrorState(failure),
            (analytics) => SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Métriques clients principales
                  _buildCustomerMetricsCards(analytics.customers),
                  SizedBox(height: 16.h),
                  
                  // Distribution des notes
                  _buildRatingDistribution(analytics.customers.ratingDistribution),
                  SizedBox(height: 16.h),
                  
                  // Comportement client
                  _buildCustomerBehavior(analytics.customers.behavior),
                  SizedBox(height: 16.h),
                  
                  // Segments clients
                  _buildCustomerSegments(analytics.customers.segments),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(
            MerchantErrorHandler.handleError(error),
          ),
        );
      },
    );
  }
  
  // Widgets composants
  
  Widget _buildGlobalScoreCard(double score) {
    final color = _getScoreColor(score);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Text(
              'Score de Performance Global',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 120.w,
              height: 120.w,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          score.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          '/100',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              _getScoreLabel(score),
              style: TextStyle(
                fontSize: 14.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRealtimeMetrics(AsyncValue<Either<Failure, RealtimeDashboard>> dashboardAsync) {
    return dashboardAsync.when(
      data: (result) => result.fold(
        (_) => const SizedBox.shrink(),
        (dashboard) => GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard(
              title: 'Offres actives',
              value: dashboard.activeOffers.toString(),
              icon: Icons.local_offer,
              color: Colors.blue,
              trend: null,
            ),
            _buildMetricCard(
              title: 'Réservations en attente',
              value: dashboard.pendingReservations.toString(),
              icon: Icons.pending_actions,
              color: Colors.orange,
              trend: null,
            ),
            _buildMetricCard(
              title: 'Collectes aujourd\'hui',
              value: dashboard.todayPickups.toString(),
              icon: Icons.shopping_basket,
              color: Colors.green,
              trend: null,
            ),
            _buildMetricCard(
              title: 'Revenus du jour',
              value: '${dashboard.todayRevenue.toStringAsFixed(2)}€',
              icon: Icons.euro,
              color: Colors.purple,
              trend: null,
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
  
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? trend,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24.sp),
              if (trend != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: trend.startsWith('+') ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: trend.startsWith('+') ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildRevenueChart(Analytics analytics) {
    final sales = analytics.sales;
    final dailyRevenue = sales.dailyRevenue.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    if (dailyRevenue.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Évolution du chiffre d\'affaires',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${sales.totalRevenue.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: sales.totalRevenue / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toStringAsFixed(0)}€',
                            style: TextStyle(fontSize: 10.sp),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < dailyRevenue.length) {
                            final date = dailyRevenue[value.toInt()].key;
                            return Text(
                              '${date.day}/${date.month}',
                              style: TextStyle(fontSize: 10.sp),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: dailyRevenue.length.toDouble() - 1,
                  minY: 0,
                  maxY: dailyRevenue.map((e) => e.value).reduce(math.max) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dailyRevenue.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.value);
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInsights() {
    return Consumer(
      builder: (context, ref, child) {
        final insightsAsync = ref.watch(merchantInsightsProvider);
        
        return insightsAsync.when(
          data: (result) => result.fold(
            (_) => const SizedBox.shrink(),
            (insights) {
              if (insights.isEmpty) return const SizedBox.shrink();
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Insights & Recommandations',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...insights.take(3).map((insight) => _buildInsightCard(insight)),
                ],
              );
            },
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }
  
  Widget _buildInsightCard(Insight insight) {
    final color = _getInsightColor(insight.type);
    
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getInsightIcon(insight.type),
            color: color,
            size: 20.sp,
          ),
        ),
        title: Text(
          insight.title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          insight.recommendation,
          style: TextStyle(fontSize: 12.sp),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            '+${insight.impactScore.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildComparisonCards() {
    return Consumer(
      builder: (context, ref, child) {
        final comparisonAsync = ref.watch(performanceComparisonProvider);
        
        return comparisonAsync.when(
          data: (result) => result.fold(
            (_) => const SizedBox.shrink(),
            (comparison) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comparaison avec la période précédente',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                ...comparison.changes.entries.map((entry) {
                  final change = entry.value;
                  return _buildComparisonTile(
                    metric: change.metric,
                    current: change.currentValue,
                    previous: change.previousValue,
                    changePercent: change.changePercent,
                  );
                }),
              ],
            ),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }
  
  Widget _buildComparisonTile({
    required String metric,
    required double current,
    required double previous,
    required double changePercent,
  }) {
    final isPositive = changePercent >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        title: Text(metric),
        subtitle: Text(
          'Actuel: ${_formatMetricValue(metric, current)} | '
          'Précédent: ${_formatMetricValue(metric, previous)}',
          style: TextStyle(fontSize: 12.sp),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: color,
                size: 16.sp,
              ),
              Text(
                '${changePercent.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Méthodes utilitaires
  
  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
  
  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excellent !';
    if (score >= 60) return 'Bon';
    if (score >= 40) return 'À améliorer';
    return 'Attention requise';
  }
  
  Color _getInsightColor(InsightType type) {
    switch (type) {
      case InsightType.pricing:
        return Colors.blue;
      case InsightType.timing:
        return Colors.orange;
      case InsightType.inventory:
        return Colors.purple;
      case InsightType.customer:
        return Colors.green;
      case InsightType.ecological:
        return Colors.teal;
    }
  }
  
  IconData _getInsightIcon(InsightType type) {
    switch (type) {
      case InsightType.pricing:
        return Icons.euro;
      case InsightType.timing:
        return Icons.schedule;
      case InsightType.inventory:
        return Icons.inventory;
      case InsightType.customer:
        return Icons.people;
      case InsightType.ecological:
        return Icons.eco;
    }
  }
  
  String _formatMetricValue(String metric, double value) {
    if (metric.contains('€') || metric.contains('Chiffre')) {
      return '${value.toStringAsFixed(2)}€';
    }
    if (metric.contains('%') || metric.contains('Taux')) {
      return '${value.toStringAsFixed(1)}%';
    }
    if (metric.contains('CO₂')) {
      return '${value.toStringAsFixed(1)} kg';
    }
    return value.toStringAsFixed(0);
  }
  
  String _getPeriodLabel(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.daily:
        return 'Aujourd\'hui';
      case AnalyticsPeriod.weekly:
        return 'Cette semaine';
      case AnalyticsPeriod.monthly:
        return 'Ce mois';
      case AnalyticsPeriod.quarterly:
        return 'Ce trimestre';
      case AnalyticsPeriod.yearly:
        return 'Cette année';
      case AnalyticsPeriod.custom:
        return 'Personnalisé';
    }
  }
  
  Widget _buildErrorState(Failure failure) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              failure.userMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(merchantAnalyticsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Exporter les données',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Rapport PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _exportReport(ReportFormat.pdf);
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('Excel'),
                onTap: () {
                  Navigator.pop(context);
                  _exportData(ExportFormat.excel);
                },
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('CSV'),
                onTap: () {
                  Navigator.pop(context);
                  _exportData(ExportFormat.csv);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _exportReport(ReportFormat format) async {
    final result = await ref.read(generateReportProvider(format).future);
    
    result.fold(
      (failure) => context.showError(failure),
      (report) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rapport généré : ${report.downloadUrl}'),
            action: SnackBarAction(
              label: 'Télécharger',
              onPressed: () {
                // TODO: Implémenter le téléchargement
              },
            ),
          ),
        );
      },
    );
  }
  
  Future<void> _exportData(ExportFormat format) async {
    final result = await ref.read(
      exportDataProvider((format: format, types: ExportDataType.values)).future,
    );
    
    result.fold(
      (failure) => context.showError(failure),
      (url) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export prêt : $url'),
            action: SnackBarAction(
              label: 'Télécharger',
              onPressed: () {
                // TODO: Implémenter le téléchargement
              },
            ),
          ),
        );
      },
    );
  }
  
  // Méthodes de construction des widgets supplémentaires
  
  Widget _buildConversionFunnel(Analytics analytics) {
    return ConversionFunnelWidget(analytics: analytics);
  }
  
  Widget _buildOffersByHourChart(Map<int, int> offersByHour) {
    return OffersByHourChart(offersByHour: offersByHour);
  }
  
  Widget _buildPerformanceMetrics(PerformanceMetrics performance) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Métriques détaillées',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildMetricRow('Temps moyen de collecte', '${performance.avgPickupTime.inMinutes} min'),
            _buildMetricRow('Taux de no-show', '${performance.noShowRate.toStringAsFixed(1)}%'),
            _buildMetricRow('Score de satisfaction', '${performance.satisfactionScore.toStringAsFixed(1)}/5'),
            _buildMetricRow('Taux de fidélité', '${performance.repeatCustomerRate.toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPredictionsSection() {
    return Consumer(
      builder: (context, ref, child) {
        final predictionsAsync = ref.watch(merchantPredictionsProvider(0));
        
        return predictionsAsync.when(
          data: (result) => result.fold(
            (_) => const SizedBox.shrink(),
            (predictions) => Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prédictions',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildPredictionItem(
                      'Demande demain',
                      'N/A commandes',
                      Icons.trending_up,
                      Colors.blue,
                    ),
                    _buildPredictionItem(
                      'Meilleur créneau',
                      'N/A',
                      Icons.schedule,
                      Colors.orange,
                    ),
                    _buildPredictionItem(
                      'Produits recommandés',
                      '0 suggestions',
                      Icons.lightbulb,
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }
  
  Widget _buildPredictionItem(String label, String value, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSustainabilityScore(double score) {
    return SustainabilityScoreWidget(score: score);
  }
  
  Widget _buildEcoMetricsGrid(Map<String, dynamic> metrics) {
    return EcoMetricsGrid(metrics: metrics);
  }
  
  Widget _buildEcoEquivalences(Map<String, dynamic> metrics) {
    return EcoEquivalencesWidget(metrics: metrics);
  }
  
  Widget _buildEcoImpactChart() {
    return Consumer(
      builder: (context, ref, child) {
        final analyticsAsync = ref.watch(merchantAnalyticsProvider);
        
        return analyticsAsync.when(
          data: (result) => result.fold(
            (_) => const SizedBox.shrink(),
            (analytics) {
              final ecology = analytics.ecological;
              final monthlyImpact = ecology.monthlyImpact.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key));
              
              if (monthlyImpact.isEmpty) return const SizedBox.shrink();
              
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Impact écologique mensuel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        height: 200.h,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toStringAsFixed(0)} kg',
                                      style: TextStyle(fontSize: 10.sp),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 && value.toInt() < monthlyImpact.length) {
                                      final month = monthlyImpact[value.toInt()].key;
                                      return Text(
                                        month.substring(5),
                                        style: TextStyle(fontSize: 10.sp),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: monthlyImpact.asMap().entries.map((entry) {
                                  return FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.value['co2Saved'] ?? 0,
                                  );
                                }).toList(),
                                isCurved: true,
                                color: Colors.green,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.green.withValues(alpha: 0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }
  
  Widget _buildEcoAchievements() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements écologiques',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildAchievement(
              'Héros du climat',
              '100 kg CO₂ économisés',
              true,
              Icons.eco,
              Colors.green,
            ),
            _buildAchievement(
              'Sauveur de repas',
              '500 repas sauvés',
              true,
              Icons.restaurant,
              Colors.orange,
            ),
            _buildAchievement(
              'Champion zéro déchet',
              '1 tonne de déchets évités',
              false,
              Icons.delete_sweep,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAchievement(String title, String description, bool unlocked, IconData icon, Color color) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.4,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24.sp,
          ),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: unlocked
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }
  
  Widget _buildCustomerMetricsCards(CustomerMetrics customers) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          title: 'Clients totaux',
          value: customers.totalCustomers.toString(),
          icon: Icons.people,
          color: Colors.blue,
          trend: '+${customers.newCustomers}',
        ),
        _buildMetricCard(
          title: 'Clients actifs',
          value: customers.activeCustomers.toString(),
          icon: Icons.person_pin_circle,
          color: Colors.green,
          trend: null,
        ),
        _buildMetricCard(
          title: 'Note moyenne',
          value: '${customers.averageRating.toStringAsFixed(1)} ★',
          icon: Icons.star,
          color: Colors.orange,
          trend: null,
        ),
        _buildMetricCard(
          title: 'Taux de retour',
          value: '${customers.returnRate.toStringAsFixed(1)}%',
          icon: Icons.loop,
          color: Colors.purple,
          trend: null,
        ),
      ],
    );
  }
  
  Widget _buildRatingDistribution(Map<int, int> distribution) {
    return RatingDistributionChart(distribution: distribution);
  }
  
  Widget _buildCustomerBehavior(CustomerBehavior behavior) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comportement client',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildBehaviorItem(
              'Panier moyen',
              '${behavior.avgBasketValue.toStringAsFixed(2)}€',
              Icons.shopping_cart,
            ),
            _buildBehaviorItem(
              'Fréquence d\'achat',
              '${behavior.avgPurchaseFrequency.toStringAsFixed(1)} fois/mois',
              Icons.calendar_today,
            ),
            _buildBehaviorItem(
              'Produits préférés',
              behavior.topProducts.take(3).join(', '),
              Icons.favorite,
            ),
            _buildBehaviorItem(
              'Heure préférée',
              '${_getMostPreferredHour(behavior.pickupTimeDistribution)}h',
              Icons.schedule,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBehaviorItem(String label, String value, IconData icon) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20.sp),
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildCustomerSegments(List<CustomerSegment> segments) {
    return CustomerSegmentsWidget(segments: segments);
  }

  int _getMostPreferredHour(Map<int, int> pickupTimeDistribution) {
    if (pickupTimeDistribution.isEmpty) return 12;
    final mostPreferred = pickupTimeDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    return mostPreferred.key;
  }
}
