import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/adaptive_widgets.dart';
import '../../../domain/entities/product.dart';
import '../../providers/product_providers.dart';
import '../../providers/product_state.dart';

/// Écran de gestion du stock pour les marchands
class MerchantStockScreen extends ConsumerStatefulWidget {
  const MerchantStockScreen({super.key});

  @override
  ConsumerState<MerchantStockScreen> createState() => 
      _MerchantStockScreenState();
}

class _MerchantStockScreenState extends ConsumerState<MerchantStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  String get _merchantId {
    // TODO: Récupérer l'ID du marchand depuis le contexte/auth
    return 'merchant_123';
  }
  
  @override
  Widget build(BuildContext context) {
    final productListAsync = ref.watch(productListProvider(_merchantId));
    final alertsAsync = ref.watch(stockAlertsProvider(_merchantId));
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
              context.push('/merchant/offers/create');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: productListAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  'Erreur lors du chargement',
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(height: 8.h),
                AdaptiveButton(
                  onPressed: () => ref.refresh(productListProvider(_merchantId)),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
          data: (state) => RefreshIndicator.adaptive(
            onRefresh: () async {
              await ref.read(productListProvider(_merchantId).notifier).refresh();
              await ref.read(stockAlertsProvider(_merchantId).notifier).refresh();
            },
            child: CustomScrollView(
              slivers: [
                // En-tête avec résumé du stock
                SliverToBoxAdapter(
                  child: _buildStockSummary(state),
                ),
                
                // Alertes
                if (alertsAsync.hasValue)
                  SliverToBoxAdapter(
                    child: _buildAlerts(alertsAsync),
                  ),
                
                // Barre de recherche
                SliverToBoxAdapter(
                  child: _buildSearchBar(),
                ),
                
                // Filtre par catégorie
                SliverToBoxAdapter(
                  child: _buildCategoryFilter(state),
                ),
                
                // Liste des produits
                if (state.filteredProducts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.searchQuery.isNotEmpty
                                ? 'Aucun produit trouvé'
                                : 'Aucun produit dans votre inventaire',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (state.searchQuery.isEmpty) ...[
                            SizedBox(height: 16.h),
                            AdaptiveButton(
                              onPressed: () {
                                context.push('/merchant/offers/create');
                              },
                              child: const Text('Ajouter un produit'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.all(16.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildProductItem(
                          state.filteredProducts[index],
                        ),
                        childCount: state.filteredProducts.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockSummary(ProductListState state) {
    final totalProducts = state.products.length;
    final lowStockProducts = state.products.where((p) => p.stock.isLow).length;
    final totalValue = state.products.fold<double>(
      0,
      (sum, product) => sum + product.stockValue.amount,
    );
    
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
                value: totalProducts.toString(),
                icon: Icons.inventory,
              ),
              _buildSummaryItem(
                label: 'Stock faible',
                value: lowStockProducts.toString(),
                icon: Icons.warning,
                isWarning: lowStockProducts > 0,
              ),
              _buildSummaryItem(
                label: 'Valeur totale',
                value: '${totalValue.toStringAsFixed(0)}€',
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
        controller: _searchController,
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
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(productListProvider(_merchantId).notifier)
                        .applyFilters(searchQuery: '');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          ref.read(productListProvider(_merchantId).notifier)
              .applyFilters(searchQuery: value);
        },
      ),
    );
  }
  
  Widget _buildAlerts(AsyncValue<StockAlertsState> alertsState) {
    return alertsState.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (alerts) {
        if (alerts.totalAlerts == 0) return const SizedBox.shrink();
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: alerts.highPriorityAlerts > 0
                ? Colors.red[50]
                : Colors.orange[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: alerts.highPriorityAlerts > 0
                  ? Colors.red[200]!
                  : Colors.orange[200]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: alerts.highPriorityAlerts > 0
                    ? Colors.red[700]
                    : Colors.orange[700],
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '${alerts.totalAlerts} alerte${alerts.totalAlerts > 1 ? 's' : ''} '
                  '(${alerts.lowStockAlerts.length} stock faible, '
                  '${alerts.expiryAlerts.length} péremption)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: alerts.highPriorityAlerts > 0
                        ? Colors.red[700]
                        : Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Afficher les détails des alertes
                },
                child: const Text('Voir'),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCategoryFilter(ProductListState state) {
    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildFilterChip(
            label: 'Tous',
            isSelected: state.selectedCategory == null,
            onTap: () {
              ref.read(productListProvider(_merchantId).notifier)
                  .applyFilters(category: null);
            },
          ),
          ...ProductCategory.values.map((category) => 
            _buildFilterChip(
              label: category.displayName,
              isSelected: state.selectedCategory == category,
              onTap: () {
                ref.read(productListProvider(_merchantId).notifier)
                    .applyFilters(category: category);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.grey[100],
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    final isLowStock = product.stock.isLow;
    final isOutOfStock = product.stock.isOutOfStock;
    final isExpiringSoon = product.isExpiringSoon;
    
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
            context.push('/merchant/products/${product.id}');
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
                    image: product.images.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(product.images.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: product.images.isEmpty
                      ? Icon(
                          _getCategoryIcon(product.category),
                          color: Colors.grey[400],
                          size: 32.sp,
                        )
                      : null,
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
                              product.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isExpiringSoon)
                            _buildStockBadge('Expire bientôt', Colors.purple)
                          else if (isOutOfStock)
                            _buildStockBadge('Rupture', Colors.red)
                          else if (isLowStock)
                            _buildStockBadge('Stock faible', Colors.orange),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        product.category.displayName,
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
                            value: product.stock.quantity.toStringAsFixed(
                              product.stock.quantity == product.stock.quantity.roundToDouble() ? 0 : 1
                            ),
                            unit: product.unit,
                            color: isOutOfStock 
                                ? Colors.red 
                                : isLowStock 
                                    ? Colors.orange 
                                    : Colors.green,
                          ),
                          SizedBox(width: 16.w),
                          _buildProductMetric(
                            label: 'Prix',
                            value: product.price.formatted,
                            color: Colors.blue,
                          ),
                          if (product.expirationDate != null) ...[
                            SizedBox(width: 16.w),
                            _buildProductMetric(
                              label: 'DLC',
                              value: _formatExpirationDate(product.expirationDate!),
                              color: isExpiringSoon ? Colors.purple : Colors.grey,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Modifier'),
                    ),
                    PopupMenuItem(
                      value: 'adjust',
                      child: Text('Ajuster le stock'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Supprimer'),
                    ),
                  ],
                  onSelected: (value) async {
                    switch (value) {
                      case 'edit':
                        context.push('/merchant/products/${product.id}/edit');
                        break;
                      case 'adjust':
                        // TODO: Ouvrir une bottom sheet d'ajustement rapide
                        break;
                      case 'delete':
                        await ref.read(productListProvider(_merchantId).notifier)
                            .deleteProduct(product.id);
                        break;
                    }
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
    String? unit,
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            if (unit != null) ...[
              SizedBox(width: 2.w),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12.sp,
                      color: color.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  
  void _showFilterDialog() {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('Filtres'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile.adaptive(
                title: const Text('Produits actifs uniquement'),
                value: ref.read(productListProvider(_merchantId)).asData?.value.showActiveOnly ?? true,
                onChanged: (value) {
                  ref.read(productListProvider(_merchantId).notifier)
                      .applyFilters(showActiveOnly: value);
                  Navigator.of(context).pop();
                },
              ),
              SwitchListTile.adaptive(
                title: const Text('Stock faible uniquement'),
                value: ref.read(productListProvider(_merchantId)).asData?.value.showLowStockOnly ?? false,
                onChanged: (value) {
                  ref.read(productListProvider(_merchantId).notifier)
                      .applyFilters(showLowStockOnly: value);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
  
  IconData _getCategoryIcon(ProductCategory category) {
    switch (category) {
      case ProductCategory.boulangerie:
        return Icons.bakery_dining;
      case ProductCategory.patisserie:
        return Icons.cake;
      case ProductCategory.fruitLegume:
        return Icons.eco;
      case ProductCategory.viande:
        return Icons.kebab_dining;
      case ProductCategory.poisson:
        return Icons.set_meal;
      case ProductCategory.produitLaitier:
        return Icons.water_drop;
      case ProductCategory.epicerie:
        return Icons.shopping_basket;
      case ProductCategory.boisson:
        return Icons.local_drink;
      case ProductCategory.platsPrePares:
        return Icons.dining;
      case ProductCategory.snack:
        return Icons.cookie;
      case ProductCategory.autre:
        return Icons.category;
    }
  }
  
  String _formatExpirationDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.isNegative) {
      return 'Expiré';
    } else if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Demain';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}j';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
