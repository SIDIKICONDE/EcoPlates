import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/stock_movement.dart';
import '../datasources/product_data_source.dart';
import '../models/product_model.dart';
import '../models/stock_movement_model.dart';
import 'product_repository.dart';

/// Implémentation du repository pour les produits
@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource localDataSource;
  final ProductDataSource? remoteDataSource;
  
  const ProductRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
  });
  
  @override
  Future<Either<Failure, List<Product>>> getProductsByMerchant(String merchantId) async {
    try {
      final products = await localDataSource.getProductsByMerchant(merchantId);
      return Right(products.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération des produits: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Product?>> getProductById(String productId) async {
    try {
      final product = await localDataSource.getProductById(productId);
      return Right(product?.toDomain());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération du produit: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> getProductsByIds(List<String> productIds) async {
    try {
      final products = await localDataSource.getProductsByIds(productIds);
      return Right(products.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération des produits: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> searchProducts({
    required String merchantId,
    String? query,
    ProductCategory? category,
    bool? isActive,
    bool? isLowStock,
    bool? isExpiringSoon,
  }) async {
    try {
      final products = await localDataSource.searchProducts(
        merchantId: merchantId,
        query: query,
        category: category,
        isActive: isActive,
        isLowStock: isLowStock,
        isExpiringSoon: isExpiringSoon,
      );
      return Right(products.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la recherche de produits: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Product>> addProduct(Product product) async {
    try {
      // Validation
      if (product.name.isEmpty) {
        return const Left(ValidationFailure('Le nom du produit est requis'));
      }
      if (product.price.amount < 0) {
        return const Left(ValidationFailure('Le prix ne peut pas être négatif'));
      }
      if (product.stock.quantity < 0) {
        return const Left(ValidationFailure('La quantité ne peut pas être négative'));
      }
      
      final model = ProductModel.fromDomain(product);
      final savedModel = await localDataSource.addProduct(model);
      
      // Synchroniser avec le serveur si disponible
      if (remoteDataSource != null) {
        try {
          await remoteDataSource!.addProduct(model);
        } catch (_) {
          // Ignorer les erreurs de synchronisation
        }
      }
      
      return Right(savedModel.toDomain());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de l\'ajout du produit: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      final model = ProductModel.fromDomain(product);
      final updatedModel = await localDataSource.updateProduct(model);
      
      // Synchroniser avec le serveur si disponible
      if (remoteDataSource != null) {
        try {
          await remoteDataSource!.updateProduct(model);
        } catch (_) {
          // Ignorer les erreurs de synchronisation
        }
      }
      
      return Right(updatedModel.toDomain());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la mise à jour du produit: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await localDataSource.deleteProduct(productId);
      
      // Synchroniser avec le serveur si disponible
      if (remoteDataSource != null) {
        try {
          await remoteDataSource!.deleteProduct(productId);
        } catch (_) {
          // Ignorer les erreurs de synchronisation
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la suppression du produit: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteProducts(List<String> productIds) async {
    try {
      await localDataSource.deleteProducts(productIds);
      
      // Synchroniser avec le serveur si disponible
      if (remoteDataSource != null) {
        try {
          await remoteDataSource!.deleteProducts(productIds);
        } catch (_) {
          // Ignorer les erreurs de synchronisation
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la suppression des produits: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> getLowStockProducts(String merchantId) async {
    try {
      final products = await localDataSource.getLowStockProducts(merchantId);
      return Right(products.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération des produits en rupture: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> getExpiringSoonProducts(String merchantId) async {
    try {
      final products = await localDataSource.getExpiringSoonProducts(merchantId);
      return Right(products.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération des produits expirant: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<StockMovement>>> getStockMovements({
    required String productId,
    DateTime? startDate,
    DateTime? endDate,
    MovementType? type,
    int? limit,
  }) async {
    try {
      final movements = await localDataSource.getStockMovements(
        productId: productId,
        startDate: startDate,
        endDate: endDate,
        type: type,
        limit: limit,
      );
      return Right(movements.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération des mouvements: $e'));
    }
  }
  
  @override
  Future<Either<Failure, StockMovement>> addStockMovement(StockMovement movement) async {
    try {
      final model = StockMovementModel.fromDomain(movement);
      final savedModel = await localDataSource.addStockMovement(model);
      return Right(savedModel.toDomain());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de l\'ajout du mouvement: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Product>> updateProductStock({
    required String productId,
    required double newQuantity,
    required MovementType movementType,
    String? reason,
    String? referenceId,
    String? userId,
  }) async {
    try {
      if (newQuantity < 0) {
        return const Left(ValidationFailure('La quantité ne peut pas être négative'));
      }
      
      final updatedModel = await localDataSource.updateProductStock(
        productId: productId,
        newQuantity: newQuantity,
        movementType: movementType,
        reason: reason,
        referenceId: referenceId,
        userId: userId,
      );
      
      return Right(updatedModel.toDomain());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la mise à jour du stock: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Product>> adjustProductStock({
    required String productId,
    required double quantityChange,
    required MovementType movementType,
    String? reason,
    String? referenceId,
    String? userId,
  }) async {
    try {
      // Récupérer le produit actuel
      final productResult = await getProductById(productId);
      return productResult.fold(
        (failure) => Left(failure),
        (product) async {
          if (product == null) {
            return const Left(NotFoundFailure('Produit non trouvé'));
          }
          
          final newQuantity = product.stock.quantity + quantityChange;
          
          return updateProductStock(
            productId: productId,
            newQuantity: newQuantity,
            movementType: movementType,
            reason: reason,
            referenceId: referenceId,
            userId: userId,
          );
        },
      );
    } catch (e) {
      return Left(CacheFailure('Erreur lors de l\'ajustement du stock: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> bulkImportProducts(List<Product> products) async {
    try {
      final models = products.map((p) => ProductModel.fromDomain(p)).toList();
      final savedModels = await localDataSource.bulkImportProducts(models);
      return Right(savedModels.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de l\'import des produits: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> exportProducts(String merchantId) async {
    try {
      final products = await localDataSource.exportProducts(merchantId);
      return Right(products.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de l\'export des produits: $e'));
    }
  }
  
  @override
  Future<Either<Failure, StockStatistics>> getStockStatistics(String merchantId) async {
    try {
      final stats = await localDataSource.getStockStatistics(merchantId);
      return Right(stats);
    } catch (e) {
      return Left(CacheFailure('Erreur lors du calcul des statistiques: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Product?>> getProductByBarcode({
    required String barcode,
    required String merchantId,
  }) async {
    try {
      final product = await localDataSource.getProductByBarcode(
        barcode: barcode,
        merchantId: merchantId,
      );
      return Right(product?.toDomain());
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la recherche par code-barres: $e'));
    }
  }
  
  @override
  Future<Either<Failure, bool>> validateStockAvailability({
    required String productId,
    required double requestedQuantity,
  }) async {
    try {
      final productResult = await getProductById(productId);
      return productResult.fold(
        (failure) => Left(failure),
        (product) {
          if (product == null) {
            return const Left(NotFoundFailure('Produit non trouvé'));
          }
          
          final isAvailable = product.stock.quantity >= requestedQuantity;
          return Right(isAvailable);
        },
      );
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la validation du stock: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Product>> reserveStock({
    required String productId,
    required double quantity,
    required String offerId,
  }) async {
    return adjustProductStock(
      productId: productId,
      quantityChange: -quantity,
      movementType: MovementType.offerReservation,
      reason: 'Réservation pour offre',
      referenceId: offerId,
    );
  }
  
  @override
  Future<Either<Failure, Product>> releaseStock({
    required String productId,
    required double quantity,
    required String offerId,
  }) async {
    return adjustProductStock(
      productId: productId,
      quantityChange: quantity,
      movementType: MovementType.offerCancellation,
      reason: 'Libération suite à annulation',
      referenceId: offerId,
    );
  }
}