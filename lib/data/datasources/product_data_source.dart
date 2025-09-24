import '../../domain/entities/product.dart';
import '../../domain/entities/stock_movement.dart';
import '../models/product_model.dart';
import '../models/stock_movement_model.dart';

/// Interface pour les sources de données des produits
abstract class ProductDataSource {
  /// Récupère tous les produits d'un marchand
  Future<List<ProductModel>> getProductsByMerchant(String merchantId);
  
  /// Récupère un produit par son ID
  Future<ProductModel?> getProductById(String productId);
  
  /// Récupère des produits par leurs IDs
  Future<List<ProductModel>> getProductsByIds(List<String> productIds);
  
  /// Recherche des produits
  Future<List<ProductModel>> searchProducts({
    required String merchantId,
    String? query,
    ProductCategory? category,
    bool? isActive,
    bool? isLowStock,
    bool? isExpiringSoon,
  });
  
  /// Ajoute un nouveau produit
  Future<ProductModel> addProduct(ProductModel product);
  
  /// Met à jour un produit
  Future<ProductModel> updateProduct(ProductModel product);
  
  /// Supprime un produit
  Future<void> deleteProduct(String productId);
  
  /// Supprime plusieurs produits
  Future<void> deleteProducts(List<String> productIds);
  
  /// Récupère les produits avec stock faible
  Future<List<ProductModel>> getLowStockProducts(String merchantId);
  
  /// Récupère les produits expirant bientôt
  Future<List<ProductModel>> getExpiringSoonProducts(String merchantId);
  
  /// Récupère l'historique des mouvements de stock
  Future<List<StockMovementModel>> getStockMovements({
    required String productId,
    DateTime? startDate,
    DateTime? endDate,
    MovementType? type,
    int? limit,
  });
  
  /// Ajoute un mouvement de stock
  Future<StockMovementModel> addStockMovement(StockMovementModel movement);
  
  /// Met à jour le stock d'un produit
  Future<ProductModel> updateProductStock({
    required String productId,
    required double newQuantity,
    required MovementType movementType,
    String? reason,
    String? referenceId,
    String? userId,
  });
  
  /// Importe des produits en masse
  Future<List<ProductModel>> bulkImportProducts(List<ProductModel> products);
  
  /// Exporte tous les produits d'un marchand
  Future<List<ProductModel>> exportProducts(String merchantId);
  
  /// Récupère les statistiques de stock
  Future<StockStatistics> getStockStatistics(String merchantId);
  
  /// Récupère les produits par code-barres
  Future<ProductModel?> getProductByBarcode({
    required String barcode,
    required String merchantId,
  });
}

/// Statistiques de stock
class StockStatistics {
  final int totalProducts;
  final int activeProducts;
  final int lowStockProducts;
  final int outOfStockProducts;
  final int expiringSoonProducts;
  final double totalStockValue;
  final Map<ProductCategory, int> productsByCategory;
  
  const StockStatistics({
    required this.totalProducts,
    required this.activeProducts,
    required this.lowStockProducts,
    required this.outOfStockProducts,
    required this.expiringSoonProducts,
    required this.totalStockValue,
    required this.productsByCategory,
  });
}