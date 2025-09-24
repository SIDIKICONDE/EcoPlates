import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/adaptive_widgets.dart';

/// Écran tableau de bord principal pour les marchands
class MerchantDashboardScreen extends ConsumerStatefulWidget {
  const MerchantDashboardScreen({super.key});

  @override
  ConsumerState<MerchantDashboardScreen> createState() => 
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState extends ConsumerState<MerchantDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Tableau de bord'),
        actions: [
          AdaptiveIconButton(
            icon: const Icon(Icons.notifications_outlined),
            cupertinoIcon: CupertinoIcons.bell,
            onPressed: () {
              // TODO: Afficher les notifications
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            // TODO: Rafraîchir les données
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carte de bienvenue
                _buildWelcomeCard(),
                SizedBox(height: 20.h),
                
                // Statistiques du jour
                _buildTodayStats(),
                SizedBox(height: 24.h),
                
                // Actions rapides
                _buildQuickActions(context),
                SizedBox(height: 24.h),
                
                // Activité récente
                _buildRecentActivity(),
                SizedBox(height: 24.h),
                
                // Performance écologique
                _buildEcoPerformance(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue !',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Voici l\'aperçu de votre activité d\'aujourd\'hui',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aujourd\'hui',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Ventes',
                value: '23',
                subtitle: 'paniers',
                icon: Icons.shopping_basket,
                color: Colors.green,
                trend: '+15%',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'Revenus',
                value: '92€',
                subtitle: 'générés',
                icon: Icons.euro,
                color: Colors.blue,
                trend: '+8%',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'CO₂',
                value: '46kg',
                subtitle: 'économisés',
                icon: Icons.eco,
                color: Colors.teal,
                trend: null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20.sp),
              if (trend != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 1.5,
          children: [
            _buildActionTile(
              icon: Icons.add_circle_outline,
              title: 'Nouvelle offre',
              color: Colors.green,
              onTap: () {
                // TODO: Navigation vers création d'offre
              },
            ),
            _buildActionTile(
              icon: Icons.qr_code_scanner,
              title: 'Scanner',
              color: Colors.orange,
              onTap: () {
                // TODO: Navigation vers scanner
              },
            ),
            _buildActionTile(
              icon: Icons.inventory_2_outlined,
              title: 'Gérer stock',
              color: Colors.blue,
              onTap: () {
                // TODO: Navigation vers stock
              },
            ),
            _buildActionTile(
              icon: Icons.analytics_outlined,
              title: 'Voir analytics',
              color: Colors.purple,
              onTap: () {
                // TODO: Navigation vers analytics
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32.sp),
              SizedBox(height: 8.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activité récente',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Voir toute l'activité
              },
              child: const Text('Voir tout'),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Exemple d'activités récentes
        _buildActivityItem(
          icon: Icons.shopping_cart,
          title: 'Nouvelle commande',
          subtitle: 'Marie L. - Panier surprise',
          time: 'Il y a 5 min',
          isNew: true,
        ),
        _buildActivityItem(
          icon: Icons.check_circle,
          title: 'Collecte confirmée',
          subtitle: 'Jean P. - Viennoiseries',
          time: 'Il y a 15 min',
          isNew: false,
        ),
        _buildActivityItem(
          icon: Icons.inventory,
          title: 'Stock mis à jour',
          subtitle: '3 paniers ajoutés',
          time: 'Il y a 30 min',
          isNew: false,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isNew,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isNew ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isNew ? Colors.blue[200]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isNew ? Colors.blue[100] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isNew ? Colors.blue : Colors.grey[600],
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoPerformance() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco, color: Colors.green[700], size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Impact écologique',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEcoMetric(
                label: 'Repas sauvés',
                value: '1,234',
                icon: Icons.restaurant,
              ),
              _buildEcoMetric(
                label: 'CO₂ économisé',
                value: '617 kg',
                icon: Icons.cloud_off,
              ),
              _buildEcoMetric(
                label: 'Eau économisée',
                value: '2,468 L',
                icon: Icons.water_drop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEcoMetric({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.green[600], size: 20.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.green[600],
          ),
        ),
      ],
    );
  }
}