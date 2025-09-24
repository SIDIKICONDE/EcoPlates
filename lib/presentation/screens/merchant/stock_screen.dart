import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/adaptive_widgets.dart';

/// Écran de gestion du stock pour les marchands
class MerchantStockScreen extends ConsumerStatefulWidget {
  const MerchantStockScreen({super.key});

  @override
  ConsumerState<MerchantStockScreen> createState() => 
      _MerchantStockScreenState();
}

class _MerchantStockScreenState extends ConsumerState<MerchantStockScreen> {
  String _selectedFilter = 'all';
  
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Gestion du stock'),
        actions: [
          AdaptiveIconButton(
            icon: const Icon(Icons.filter_list),
            cupertinoIcon: CupertinoIcons.slider_horizontal_3,
            onPressed: () {
              _showFilterDialog();
            },
          ),
          AdaptiveIconButton(
            icon: const Icon(Icons.add),
            cupertinoIcon: CupertinoIcons.plus,
            onPressed: () {
              // TODO: Ajouter un produit au stock
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            // TODO: Rafraîchir le stock
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            slivers: [
              // En-tête avec résumé du stock
              SliverToBoxAdapter(
                child: _buildStockSummary(),
              ),
              
              // Barre de recherche
              SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),
              
              // Liste des produits
              SliverPadding(
                padding: EdgeInsets.all(16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildStockItem(index),
                    childCount: 10, // TODO: Utiliser le vrai nombre
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockSummary() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                label: 'Total produits',
                value: '45',
                icon: Icons.inventory,
              ),
              _buildSummaryItem(
                label: 'Stock faible',
                value: '8',
                icon: Icons.warning,
                isWarning: true,
              ),
              _buildSummaryItem(
                label: 'Valeur totale',
                value: '1,250€',
                icon: Icons.euro,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Indicateur de santé du stock
          _buildStockHealthIndicator(),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required IconData icon,
    bool isWarning = false,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: isWarning ? Colors.orange[300] : Colors.white,
          size: 24.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
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

  Widget _buildStockHealthIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'Stock en bonne santé',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un produit...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        onChanged: (value) {
          // TODO: Implémenter la recherche
        },
      ),
    );
  }

  Widget _buildStockItem(int index) {
    // Données simulées
    final isLowStock = index % 4 == 0;
    final isOutOfStock = index % 7 == 0;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isOutOfStock 
              ? Colors.red[200]! 
              : isLowStock 
                  ? Colors.orange[200]! 
                  : Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // TODO: Ouvrir les détails du produit
          },
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                // Image du produit
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.grey[400],
                    size: 32.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                
                // Informations du produit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Produit ${index + 1}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isOutOfStock)
                            _buildStockBadge('Rupture', Colors.red)
                          else if (isLowStock)
                            _buildStockBadge('Stock faible', Colors.orange),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Catégorie: Boulangerie',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _buildProductMetric(
                            label: 'Stock',
                            value: isOutOfStock ? '0' : isLowStock ? '5' : '25',
                            color: isOutOfStock 
                                ? Colors.red 
                                : isLowStock 
                                    ? Colors.orange 
                                    : Colors.green,
                          ),
                          SizedBox(width: 16.w),
                          _buildProductMetric(
                            label: 'Prix',
                            value: '3.99€',
                            color: Colors.blue,
                          ),
                          SizedBox(width: 16.w),
                          _buildProductMetric(
                            label: 'DLC',
                            value: '2j',
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Modifier'),
                    ),
                    const PopupMenuItem(
                      value: 'adjust',
                      child: Text('Ajuster le stock'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Supprimer'),
                    ),
                  ],
                  onSelected: (value) {
                    // TODO: Gérer les actions
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProductMetric({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[500],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    if (PlatformUtils.shouldUseCupertino) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('Filtrer par'),
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Tous les produits'),
              onPressed: () {
                setState(() => _selectedFilter = 'all');
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Stock faible'),
              onPressed: () {
                setState(() => _selectedFilter = 'low');
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('En rupture'),
              onPressed: () {
                setState(() => _selectedFilter = 'out');
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('DLC proche'),
              onPressed: () {
                setState(() => _selectedFilter = 'dlc');
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrer par',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              _buildFilterOption('all', 'Tous les produits', Icons.list),
              _buildFilterOption('low', 'Stock faible', Icons.warning),
              _buildFilterOption('out', 'En rupture', Icons.cancel),
              _buildFilterOption('dlc', 'DLC proche', Icons.schedule),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildFilterOption(String value, String label, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: _selectedFilter == value 
          ? const Icon(Icons.check, color: Colors.green) 
          : null,
      onTap: () {
        setState(() => _selectedFilter = value);
        Navigator.pop(context);
      },
    );
  }
}