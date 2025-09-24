import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/stock_movement.dart';
import '../repositories/product_repository.dart';

/// Service pour la gestion de l'inventaire
@lazySingleton
class InventoryService {
  final ProductRepository _productRepository;
  
  const InventoryService(this._productRepository);
  
  /// Ajuste le stock d'un produit
  Future<Either<Failure, Product>> adjustStock({
    required String productId,
    required double quantityChange,
    required String reason,
    String? userId,
  }) async {
    final movementType = quantityChange > 0 
        ? MovementType.manualAdjustment 
        : MovementType.manualAdjustment;
        
    return _productRepository.adjustProductStock(
      productId: productId,
      quantityChange: quantityChange,
      movementType: movementType,
      reason: reason,
      userId: userId,
    );
  }
  
  /// Enregistre un achat/réapprovisionnement
  Future<Either<Failure, Product>> recordPurchase({
    required String productId,
    required double quantity,
    required double unitCost,
    String? supplierId,
    String? invoiceNumber,
    String? userId,
  }) async {
    return _productRepository.adjustProductStock(
      productId: productId,
      quantityChange: quantity,
      movementType: MovementType.purchase,
      reason: 'Achat - Facture: ${invoiceNumber ?? 'N/A'}',
      referenceId: invoiceNumber,
      userId: userId,
    );
  }
  
  /// Enregistre une vente normale (hors offre anti-gaspi)
  Future<Either<Failure, Product>> recordSale({
    required String productId,
    required double quantity,
    String? orderId,
    String? userId,
  }) async {
    // Vérifier la disponibilité du stock
    final availabilityResult = await _productRepository.validateStockAvailability(
      productId: productId,
      requestedQuantity: quantity,
    );
    
    return availabilityResult.fold(
      (failure) => Left(failure),
      (isAvailable) async {
        if (!isAvailable) {
          return const Left(ValidationFailure('Stock insuffisant pour cette vente'));
        }
        
        return _productRepository.adjustProductStock(
          productId: productId,
          quantityChange: -quantity,
          movementType: MovementType.sale,
          reason: 'Vente normale',
          referenceId: orderId,
          userId: userId,
        );
      },
    );
  }
  
  /// Enregistre une perte/casse
  Future<Either<Failure, Product>> recordDamage({
    required String productId,
    required double quantity,
    required String reason,
    String? userId,
  }) async {
    return _productRepository.adjustProductStock(
      productId: productId,
      quantityChange: -quantity,
      movementType: MovementType.damage,
      reason: reason,
      userId: userId,
    );
  }
  
  /// Enregistre une péremption
  Future<Either<Failure, Product>> recordExpiry({
    required String productId,
    required double quantity,
    String? userId,
  }) async {
    return _productRepository.adjustProductStock(
      productId: productId,
      quantityChange: -quantity,
      movementType: MovementType.expiry,
      reason: 'Produit périmé',
      userId: userId,
    );
  }
  
  /// Effectue un comptage d'inventaire
  Future<Either<Failure, Product>> performInventoryCount({
    required String productId,
    required double countedQuantity,
    String? userId,
  }) async {
    // Récupérer le stock actuel
    final productResult = await _productRepository.getProductById(productId);
    
    return productResult.fold(
      (failure) => Left(failure),
      (product) async {
        if (product == null) {
          return const Left(NotFoundFailure('Produit non trouvé'));
        }
        
        final difference = countedQuantity - product.stock.quantity;
        
        if (difference == 0) {
          return Right(product);
        }
        
        return _productRepository.updateProductStock(
          productId: productId,
          newQuantity: countedQuantity,
          movementType: MovementType.inventoryCount,
          reason: 'Comptage d\'inventaire - Écart: ${difference > 0 ? '+' : ''}$difference',
          userId: userId,
        );
      },
    );
  }
  
  /// Génère des alertes pour les stocks faibles
  Future<Either<Failure, List<StockAlert>>> generateLowStockAlerts(String merchantId) async {
    final productsResult = await _productRepository.getLowStockProducts(merchantId);
    
    return productsResult.fold(
      (failure) => Left(failure),
      (products) {
        final alerts = products.map((product) {
          return StockAlert(
            productId: product.id,
            productName: product.name,
            type: product.stock.isOutOfStock 
                ? StockAlertType.outOfStock 
                : StockAlertType.lowStock,
            currentQuantity: product.stock.quantity,
            minQuantity: product.stock.minQuantity,
            message: product.stock.isOutOfStock
                ? 'Rupture de stock pour ${product.name}'
                : 'Stock faible pour ${product.name} (${product.stock.quantity.toStringAsFixed(1)} restants)',
            severity: product.stock.isOutOfStock 
                ? AlertSeverity.high 
                : AlertSeverity.medium,
            createdAt: DateTime.now(),
          );
        }).toList();
        
        return Right(alerts);
      },
    );
  }
  
  /// Génère des alertes pour les produits expirant bientôt
  Future<Either<Failure, List<StockAlert>>> generateExpiryAlerts(String merchantId) async {
    final productsResult = await _productRepository.getExpiringSoonProducts(merchantId);
    
    return productsResult.fold(
      (failure) => Left(failure),
      (products) {
        final alerts = products.map((product) {
          final daysUntilExpiry = product.expirationDate?.difference(DateTime.now()).inDays ?? 0;
          
          return StockAlert(
            productId: product.id,
            productName: product.name,
            type: product.isExpired 
                ? StockAlertType.expired 
                : StockAlertType.expiringSoon,
            currentQuantity: product.stock.quantity,
            message: product.isExpired
                ? '${product.name} est périmé'
                : '${product.name} expire dans $daysUntilExpiry jour(s)',
            severity: product.isExpired || daysUntilExpiry <= 1 
                ? AlertSeverity.high 
                : AlertSeverity.medium,
            expirationDate: product.expirationDate,
            createdAt: DateTime.now(),
          );
        }).toList();
        
        return Right(alerts);
      },
    );
  }
  
  /// Calcule la valeur totale du stock
  Future<Either<Failure, StockValue>> calculateStockValue(String merchantId) async {
    final statsResult = await _productRepository.getStockStatistics(merchantId);
    
    return statsResult.fold(
      (failure) => Left(failure),
      (stats) {
        // Calculer les valeurs par catégorie
        final valueByCategory = <ProductCategory, double>{};
        
        // Cette partie nécessiterait plus de détails dans StockStatistics
        // Pour l'instant, on retourne juste la valeur totale
        
        return Right(StockValue(
          totalValue: stats.totalStockValue,
          valueByCategory: valueByCategory,
          currency: 'EUR',
          calculatedAt: DateTime.now(),
        ));
      },
    );
  }
  
  /// Obtient l'historique des mouvements pour analyse
  Future<Either<Failure, StockMovementAnalysis>> analyzeStockMovements({
    required String productId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final movementsResult = await _productRepository.getStockMovements(
      productId: productId,
      startDate: startDate,
      endDate: endDate,
    );
    
    return movementsResult.fold(
      (failure) => Left(failure),
      (movements) {
        double totalIn = 0;
        double totalOut = 0;
        int salesCount = 0;
        int purchaseCount = 0;
        double totalDamage = 0;
        double totalExpired = 0;
        
        for (final movement in movements) {
          if (movement.isIncoming) {
            totalIn += movement.absoluteQuantity;
            if (movement.type == MovementType.purchase) {
              purchaseCount++;
            }
          } else {
            totalOut += movement.absoluteQuantity;
            if (movement.type == MovementType.sale) {
              salesCount++;
            } else if (movement.type == MovementType.damage) {
              totalDamage += movement.absoluteQuantity;
            } else if (movement.type == MovementType.expiry) {
              totalExpired += movement.absoluteQuantity;
            }
          }
        }
        
        final turnoverRate = totalIn > 0 ? totalOut / totalIn : 0.0;
        
        return Right(StockMovementAnalysis(
          productId: productId,
          startDate: startDate,
          endDate: endDate,
          totalIncoming: totalIn,
          totalOutgoing: totalOut,
          turnoverRate: turnoverRate,
          salesCount: salesCount,
          purchaseCount: purchaseCount,
          totalDamage: totalDamage,
          totalExpired: totalExpired,
          movements: movements,
        ));
      },
    );
  }
}

/// Alerte de stock
class StockAlert {
  final String productId;
  final String productName;
  final StockAlertType type;
  final double currentQuantity;
  final double? minQuantity;
  final String message;
  final AlertSeverity severity;
  final DateTime? expirationDate;
  final DateTime createdAt;
  
  const StockAlert({
    required this.productId,
    required this.productName,
    required this.type,
    required this.currentQuantity,
    this.minQuantity,
    required this.message,
    required this.severity,
    this.expirationDate,
    required this.createdAt,
  });
}

/// Types d'alertes de stock
enum StockAlertType {
  lowStock,
  outOfStock,
  expiringSoon,
  expired,
}

/// Sévérité des alertes
enum AlertSeverity {
  low,
  medium,
  high,
}

/// Valeur du stock
class StockValue {
  final double totalValue;
  final Map<ProductCategory, double> valueByCategory;
  final String currency;
  final DateTime calculatedAt;
  
  const StockValue({
    required this.totalValue,
    required this.valueByCategory,
    required this.currency,
    required this.calculatedAt,
  });
}

/// Analyse des mouvements de stock
class StockMovementAnalysis {
  final String productId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncoming;
  final double totalOutgoing;
  final double turnoverRate;
  final int salesCount;
  final int purchaseCount;
  final double totalDamage;
  final double totalExpired;
  final List<StockMovement> movements;
  
  const StockMovementAnalysis({
    required this.productId,
    required this.startDate,
    required this.endDate,
    required this.totalIncoming,
    required this.totalOutgoing,
    required this.turnoverRate,
    required this.salesCount,
    required this.purchaseCount,
    required this.totalDamage,
    required this.totalExpired,
    required this.movements,
  });
}