import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/adaptive_widgets.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/stock_movement.dart';
import '../../../providers/product_providers.dart';

/// Écran de détail d'un produit
class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));
    final movementsAsync = ref.watch(stockMovementsProvider(productId));

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Détail du produit'),
        actions: [
          if (productAsync.hasValue && productAsync.value != null)
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
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
                    context.push('/merchant/products/$productId/edit');
                    break;
                  case 'adjust':
                    _showStockAdjustmentSheet(context, ref, productAsync.value!);
                    break;
                  case 'delete':
                    // TODO: Confirmation et suppression
                    break;
                }
              },
            ),
        ],
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
              SizedBox(height: 16.h),
              const Text('Erreur lors du chargement'),
              SizedBox(height: 16.h),
              AdaptiveButton(
                onPressed: () => ref.refresh(productDetailProvider(productId)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (product) {
          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  const Text('Produit non trouvé'),
                ],
              ),
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              ref.invalidate(productDetailProvider(productId));
              ref.invalidate(stockMovementsProvider(productId));
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image du produit
                  _buildProductImage(product),
                  
                  // Informations principales
                  _buildMainInfo(context, product),
                  
                  // Métriques
                  _buildMetrics(context, product),
                  
                  // Détails
                  _buildDetails(context, product),
                  
                  // Historique des mouvements
                  _buildMovementHistory(context, movementsAsync),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.images.isEmpty) {
      return Container(
        height: 200.h,
        width: double.infinity,
        color: Colors.grey[200],
        child: Icon(
          _getCategoryIcon(product.category),
          size: 64.sp,
          color: Colors.grey[400],
        ),
      );
    }

    return SizedBox(
      height: 200.h,
      child: PageView.builder(
        itemCount: product.images.length,
        itemBuilder: (context, index) {
          return Image.network(
            product.images[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Icon(Icons.error),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context, Product product) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  product.category.displayName,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (product.description.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
          if (product.barcode.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.qr_code, size: 16.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  product.barcode,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetrics(BuildContext context, Product product) {
    final isLowStock = product.stock.isLow;
    final isOutOfStock = product.stock.isOutOfStock;
    final isExpiringSoon = product.isExpiringSoon;
    final isExpired = product.isExpired;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Stock actuel',
                  value: product.stock.quantity.toStringAsFixed(
                    product.stock.quantity == product.stock.quantity.roundToDouble() ? 0 : 1
                  ),
                  unit: product.unit,
                  icon: Icons.inventory,
                  color: isOutOfStock
                      ? Colors.red
                      : isLowStock
                          ? Colors.orange
                          : Colors.green,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Valeur stock',
                  value: product.stockValue.formatted,
                  icon: Icons.euro,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Prix unitaire',
                  value: product.price.formatted,
                  icon: Icons.sell,
                  color: Colors.teal,
                ),
              ),
              if (product.expirationDate != null)
                Expanded(
                  child: _buildMetricCard(
                    context,
                    title: 'Péremption',
                    value: _formatExpirationDate(product.expirationDate!),
                    icon: Icons.schedule,
                    color: isExpired
                        ? Colors.red
                        : isExpiringSoon
                            ? Colors.purple
                            : Colors.grey,
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    String? unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: color),
              SizedBox(width: 4.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (unit != null) ...[
                SizedBox(width: 4.w),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context, Product product) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Options diététiques
          if (product.isVegetarian || product.isVegan || product.isHalal || product.isBio) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                if (product.isVegetarian) _buildTag('Végétarien', Colors.green),
                if (product.isVegan) _buildTag('Végan', Colors.green),
                if (product.isHalal) _buildTag('Halal', Colors.orange),
                if (product.isBio) _buildTag('Bio', Colors.blue),
              ],
            ),
            SizedBox(height: 16.h),
          ],
          
          // Allergènes
          if (product.allergens.isNotEmpty) ...[
            Text(
              'Allergènes',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: product.allergens
                  .map((allergen) => _buildTag(allergen, Colors.red[300]!))
                  .toList(),
            ),
            SizedBox(height: 16.h),
          ],
          
          // Informations supplémentaires
          _buildInfoRow('Stock minimum', '${product.stock.minQuantity} ${product.unit}'),
          if (product.weight > 0)
            _buildInfoRow('Poids', '${product.weight}g'),
          if (product.costPrice != null && product.profitMargin > 0)
            _buildInfoRow('Marge', '${product.profitMargin.toStringAsFixed(1)}%'),
          _buildInfoRow(
            'Dernière mise à jour',
            '${product.updatedAt.day}/${product.updatedAt.month}/${product.updatedAt.year}',
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementHistory(BuildContext context, AsyncValue<List<StockMovement>> movementsAsync) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historique des mouvements',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          movementsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                'Erreur lors du chargement',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
            data: (movements) {
              if (movements.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.timeline_outlined,
                          size: 48.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Aucun mouvement enregistré',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movements.length,
                itemBuilder: (context, index) {
                  final movement = movements[index];
                  return _buildMovementTile(context, movement);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMovementTile(BuildContext context, StockMovement movement) {
    final isIncoming = movement.isIncoming;
    final icon = _getMovementIcon(movement.type);
    final color = isIncoming ? Colors.green : Colors.red;

    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 20.sp,
        ),
      ),
      title: Text(
        movement.type.displayName,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (movement.reason != null)
            Text(
              movement.reason!,
              style: TextStyle(fontSize: 12.sp),
            ),
          Text(
            _formatDateTime(movement.createdAt),
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isIncoming ? '+' : ''}${movement.quantity.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            'Stock: ${movement.stockAfter.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showStockAdjustmentSheet(BuildContext context, WidgetRef ref, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _StockAdjustmentSheet(
        product: product,
        onAdjustment: (quantity, reason) async {
          await ref.read(stockAdjustmentProvider.notifier).adjustStock(
            productId: product.id,
            quantityChange: quantity,
            reason: reason,
          );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
          ref.invalidate(productDetailProvider(product.id));
          ref.invalidate(stockMovementsProvider(product.id));
        },
      ),
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

  IconData _getMovementIcon(MovementType type) {
    switch (type) {
      case MovementType.manualAdjustment:
        return Icons.edit;
      case MovementType.purchase:
        return Icons.add_shopping_cart;
      case MovementType.sale:
        return Icons.shopping_cart;
      case MovementType.offerReservation:
        return Icons.bookmark;
      case MovementType.offerCollection:
        return Icons.check_circle;
      case MovementType.offerCancellation:
        return Icons.cancel;
      case MovementType.expiry:
        return Icons.timer_off;
      case MovementType.damage:
        return Icons.broken_image;
      case MovementType.transfer:
        return Icons.swap_horiz;
      case MovementType.inventoryCount:
        return Icons.inventory;
      case MovementType.return_:
        return Icons.keyboard_return;
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

/// Bottom sheet pour l'ajustement rapide du stock
class _StockAdjustmentSheet extends StatefulWidget {
  final Product product;
  final Function(double quantity, String reason) onAdjustment;

  const _StockAdjustmentSheet({
    required this.product,
    required this.onAdjustment,
  });

  @override
  State<_StockAdjustmentSheet> createState() => _StockAdjustmentSheetState();
}

class _StockAdjustmentSheetState extends State<_StockAdjustmentSheet> {
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _isAdding = true;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajuster le stock',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Stock actuel: ${widget.product.stock.quantity} ${widget.product.unit}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),
            
            // Type d'ajustement
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    label: 'Ajouter',
                    icon: Icons.add,
                    isSelected: _isAdding,
                    color: Colors.green,
                    onTap: () => setState(() => _isAdding = true),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildTypeButton(
                    label: 'Retirer',
                    icon: Icons.remove,
                    isSelected: !_isAdding,
                    color: Colors.red,
                    onTap: () => setState(() => _isAdding = false),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            
            // Quantité
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantité',
                border: const OutlineInputBorder(),
                suffixText: widget.product.unit,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Raison
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Raison de l\'ajustement',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 24.h),
            
            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Valider'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8.r),
          color: isSelected ? color.withValues(alpha: 0.1) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une quantité valide'),
        ),
      );
      return;
    }

    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une raison'),
        ),
      );
      return;
    }

    final adjustedQuantity = _isAdding ? quantity : -quantity;
    widget.onAdjustment(adjustedQuantity, reason);
  }
}