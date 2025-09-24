import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/stock_movement.dart';
import '../datasources/product_data_source.dart';

/// Interface du repository pour les produits
abstract class ProductRepository {
  /// Récupère tous les produits d'un marchand
  Future<Either<Failure, List<Product>>> getProductsByMerchant(String merchantId);
  
  /// Récupère un produit par son ID
  Future<Either<Failure, Product?>> getProductById(String productId);
  
  /// Récupère des produits par leurs IDs
  Future<Either<Failure, List<Product>>> getProductsByIds(List<String> productIds);
  
  /// Recherche des produits
  Future<Either<Failure, List<Product>>> searchProducts({
    required String merchantId,
    String? query,
    ProductCategory? category,
    bool? isActive,
    bool? isLowStock,
    bool? isExpiringSoon,
  });
  
  /// Ajoute un nouveau produit
  Future<Either<Failure, Product>> addProduct(Product product);
  
  /// Met à jour un produit
  Future<Either<Failure, Product>> updateProduct(Product product);
  
  /// Supprime un produit
  Future<Either<Failure, void>> deleteProduct(String productId);
  
  /// Supprime plusieurs produits
  Future<Either<Failure, void>> deleteProducts(List<String> productIds);
  
  /// Récupère les produits avec stock faible
  Future<Either<Failure, List<Product>>> getLowStockProducts(String merchantId);
  
  /// Récupère les produits expirant bientôt
  Future<Either<Failure, List<Product>>> getExpiringSoonProducts(String merchantId);
  
  /// Récupère l'historique des mouvements de stock
  Future<Either<Failure, List<StockMovement>>> getStockMovements({
    required String productId,
    DateTime? startDate,
    DateTime? endDate,
    MovementType? type,
    int? limit,
  });
  
  /// Ajoute un mouvement de stock
  Future<Either<Failure, StockMovement>> addStockMovement(StockMovement movement);
  
  /// Met à jour le stock d'un produit
  Future<Either<Failure, Product>> updateProductStock({
    required String productId,
    required double newQuantity,
    required MovementType movementType,
    String? reason,
    String? referenceId,
    String? userId,
  });
  
  /// Ajuste le stock d'un produit (relatif)
  Future<Either<Failure, Product>> adjustProductStock({
    required String productId,
    required double quantityChange,
    required MovementType movementType,
    String? reason,
    String? referenceId,
    String? userId,
  });
  
  /// Importe des produits en masse
  Future<Either<Failure, List<Product>>> bulkImportProducts(List<Product> products);
  
  /// Exporte tous les produits d'un marchand
  Future<Either<Failure, List<Product>>> exportProducts(String merchantId);
  
  /// Récupère les statistiques de stock
  Future<Either<Failure, StockStatistics>> getStockStatistics(String merchantId);
  
  /// Récupère un produit par code-barres
  Future<Either<Failure, Product?>> getProductByBarcode({
    required String barcode,
    required String merchantId,
  });
  
  /// Valide la disponibilité du stock pour une quantité donnée
  Future<Either<Failure, bool>> validateStockAvailability({
    required String productId,
    required double requestedQuantity,
  });
  
  /// Réserve du stock pour une offre
  Future<Either<Failure, Product>> reserveStock({
    required String productId,
    required double quantity,
    required String offerId,
  });
  
  /// Libère du stock réservé
  Future<Either<Failure, Product>> releaseStock({
    required String productId,
    required double quantity,
    required String offerId,
  });
}