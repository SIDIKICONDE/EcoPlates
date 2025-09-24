import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/adaptive_widgets.dart';

/// Écran de gestion des ventes pour les marchands
class MerchantSalesScreen extends ConsumerStatefulWidget {
  const MerchantSalesScreen({super.key});

  @override
  ConsumerState<MerchantSalesScreen> createState() => 
      _MerchantSalesScreenState();
}

class _MerchantSalesScreenState extends ConsumerState<MerchantSalesScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Ventes'),
        actions: [
          AdaptiveIconButton(
            icon: const Icon(Icons.calendar_today),
            cupertinoIcon: CupertinoIcons.calendar,
            onPressed: () {
              // TODO: Sélectionner la période
            },
          ),
          AdaptiveIconButton(
            icon: const Icon(Icons.download),
            cupertinoIcon: CupertinoIcons.arrow_down_doc,
            onPressed: () {
              // TODO: Exporter les ventes
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'En cours'),
            Tab(text: 'Historique'),
            Tab(text: 'Statistiques'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOngoingSalesTab(),
          _buildHistoryTab(),
          _buildStatisticsTab(),
        ],
      ),
    );
  }

  /// Onglet des ventes en cours
  Widget _buildOngoingSalesTab() {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 5, // TODO: Utiliser les vraies données
        itemBuilder: (context, index) => _buildOngoingSaleItem(index),
      ),
    );
  }

  Widget _buildOngoingSaleItem(int index) {
    final statuses = ['pending', 'ready', 'collected'];
    final status = statuses[index % 3];
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // TODO: Ouvrir les détails
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Statut
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getStatusIcon(status),
                        color: _getStatusColor(status),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    
                    // Informations
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Commande #${1000 + index}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${(index + 1) * 3.99}€',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.person_outline, size: 16.sp, color: Colors.grey[600]),
                              SizedBox(width: 4.w),
                              Text(
                                'Client ${index + 1}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Icon(Icons.schedule, size: 16.sp, color: Colors.grey[600]),
                              SizedBox(width: 4.w),
                              Text(
                                '${18 + (index % 3)}:00 - ${19 + (index % 3)}:00',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Produits
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_basket, size: 20.sp, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          '${index + 1} x Panier surprise',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                
                // Actions
                Row(
                  children: [
                    _buildStatusBadge(status),
                    const Spacer(),
                    if (status == 'pending')
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Marquer comme prêt
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Prêt'),
                      ),
                    if (status == 'ready')
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Scanner le QR code
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Scanner'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Onglet historique des ventes
  Widget _buildHistoryTab() {
    return CustomScrollView(
      slivers: [
        // Résumé
        SliverToBoxAdapter(
          child: _buildHistorySummary(),
        ),
        
        // Liste des ventes passées
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildHistoryItem(index),
            childCount: 20, // TODO: Utiliser les vraies données
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySummary() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green,
            Colors.green[700]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            'Ce mois-ci',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryMetric(
                value: '156',
                label: 'Ventes',
                icon: Icons.shopping_cart,
              ),
              _buildSummaryMetric(
                value: '623.44€',
                label: 'Revenus',
                icon: Icons.euro,
              ),
              _buildSummaryMetric(
                value: '4.2',
                label: 'Note moyenne',
                icon: Icons.star,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(int index) {
    final date = DateTime.now().subtract(Duration(days: index));
    final isToday = index == 0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0 || date.day == 1)
            Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
              child: Text(
                isToday ? 'Aujourd\'hui' : '${date.day}/${date.month}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Commande #${2000 + index}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${15 + (index % 8)}:${(index % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(index + 1) * 3.99}€',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (index % 3 == 0)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14.sp),
                          Text(
                            '${4 + (index % 2)}.0',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Onglet statistiques
  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphique des ventes
          _buildSalesChart(),
          SizedBox(height: 24.h),
          
          // Produits les plus vendus
          _buildTopProducts(),
          SizedBox(height: 24.h),
          
          // Heures de pointe
          _buildPeakHours(),
          SizedBox(height: 24.h),
          
          // Performances par jour
          _buildDayPerformance(),
        ],
      ),
    );
  }

  Widget _buildSalesChart() {
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
        children: [
          Text(
            'Évolution des ventes',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          // TODO: Intégrer un vrai graphique
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'Graphique des ventes',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts() {
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
        children: [
          Text(
            'Produits les plus vendus',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(3, (index) => _buildTopProductItem(index)),
        ],
      ),
    );
  }

  Widget _buildTopProductItem(int index) {
    final products = ['Panier surprise', 'Viennoiseries', 'Sandwichs'];
    final sales = [45, 32, 23];
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  products[index],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                LinearProgressIndicator(
                  value: sales[index] / sales[0],
                  backgroundColor: Colors.grey[200],
                  minHeight: 4.h,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '${sales[index]} ventes',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeakHours() {
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
        children: [
          Text(
            'Heures de pointe',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHourIndicator('12h-14h', 0.8, true),
              _buildHourIndicator('18h-20h', 1.0, true),
              _buildHourIndicator('20h-22h', 0.6, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourIndicator(String time, double percentage, bool isPeak) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isPeak ? Colors.green : Colors.grey[300]!,
              width: 4,
            ),
          ),
          child: Center(
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isPeak ? Colors.green : Colors.grey[600],
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          time,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDayPerformance() {
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
        children: [
          Text(
            'Performance par jour',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                .asMap()
                .entries
                .map((entry) => _buildDayColumn(
                      entry.value,
                      entry.key == 4 || entry.key == 5,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDayColumn(String day, bool isHighest) {
    return Column(
      children: [
        Container(
          width: 32.w,
          height: isHighest ? 80.h : 60.h,
          decoration: BoxDecoration(
            color: isHighest 
                ? Theme.of(context).primaryColor 
                : Theme.of(context).primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          day,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isHighest 
                ? Theme.of(context).primaryColor 
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Helpers
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'ready':
        return Colors.blue;
      case 'collected':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'ready':
        return Icons.check_circle_outline;
      case 'collected':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildStatusBadge(String status) {
    final labels = {
      'pending': 'En attente',
      'ready': 'Prêt',
      'collected': 'Collecté',
    };
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
            size: 16.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            labels[status] ?? status,
            style: TextStyle(
              color: _getStatusColor(status),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}