import 'package:hive/hive.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/stock_movement.dart';
import '../models/product_model.dart';
import '../models/stock_movement_model.dart';
import 'product_data_source.dart';

/// Implémentation locale de ProductDataSource avec Hive
class LocalProductDataSource implements ProductDataSource {
  static const String _productsBox = 'products';
  static const String _stockMovementsBox = 'stock_movements';
  
  /// Ouvre les boîtes Hive nécessaires
  Future<void> init() async {
    if (!Hive.isBoxOpen(_productsBox)) {
      await Hive.openBox<ProductModel>(_productsBox);
    }
    if (!Hive.isBoxOpen(_stockMovementsBox)) {
      await Hive.openBox<StockMovementModel>(_stockMovementsBox);
    }
  }
  
  Box<ProductModel> get _productsBoxRef => Hive.box<ProductModel>(_productsBox);
  Box<StockMovementModel> get _movementsBoxRef => Hive.box<StockMovementModel>(_stockMovementsBox);
  
  @override
  Future<List<ProductModel>> getProductsByMerchant(String merchantId) async {
    await init();
    return _productsBoxRef.values
        .where((product) => product.merchantId == merchantId)
        .toList();
  }
  
  @override
  Future<ProductModel?> getProductById(String productId) async {
    await init();
    return _productsBoxRef.get(productId);
  }
  
  @override
  Future<List<ProductModel>> getProductsByIds(List<String> productIds) async {
    await init();
    final products = <ProductModel>[];
    for (final id in productIds) {
      final product = _productsBoxRef.get(id);
      if (product != null) {
        products.add(product);
      }
    }
    return products;
  }
  
  @override
  Future<List<ProductModel>> searchProducts({
    required String merchantId,
    String? query,
    ProductCategory? category,
    bool? isActive,
    bool? isLowStock,
    bool? isExpiringSoon,
  }) async {
    await init();
    
    var products = _productsBoxRef.values
        .where((product) => product.merchantId == merchantId);
    
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      products = products.where((product) =>
          product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.barcode.toLowerCase().contains(lowerQuery));
    }
    
    if (category != null) {
      products = products.where((product) => product.category == category.name);
    }
    
    if (isActive != null) {
      products = products.where((product) => product.isActive == isActive);
    }
    
    if (isLowStock == true) {
      products = products.where((product) {
        final domainProduct = product.toDomain();
        return domainProduct.stock.isLow;
      });
    }
    
    if (isExpiringSoon == true) {
      products = products.where((product) {
        final domainProduct = product.toDomain();
        return domainProduct.isExpiringSoon;
      });
    }
    
    return products.toList();
  }
  
  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    await init();
    await _productsBoxRef.put(product.id, product);
    return product;
  }
  
  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await init();
    await _productsBoxRef.put(product.id, product);
    return product;
  }
  
  @override
  Future<void> deleteProduct(String productId) async {
    await init();
    await _productsBoxRef.delete(productId);
  }
  
  @override
  Future<void> deleteProducts(List<String> productIds) async {
    await init();
    await _productsBoxRef.deleteAll(productIds);
  }
  
  @override
  Future<List<ProductModel>> getLowStockProducts(String merchantId) async {
    await init();
    return _productsBoxRef.values.where((product) {
      if (product.merchantId != merchantId) return false;
      final domainProduct = product.toDomain();
      return domainProduct.stock.isLow;
    }).toList();
  }
  
  @override
  Future<List<ProductModel>> getExpiringSoonProducts(String merchantId) async {
    await init();
    return _productsBoxRef.values.where((product) {
      if (product.merchantId != merchantId) return false;
      final domainProduct = product.toDomain();
      return domainProduct.isExpiringSoon;
    }).toList();
  }
  
  @override
  Future<List<StockMovementModel>> getStockMovements({
    required String productId,
    DateTime? startDate,
    DateTime? endDate,
    MovementType? type,
    int? limit,
  }) async {
    await init();
    
    var movements = _movementsBoxRef.values
        .where((movement) => movement.productId == productId);
    
    if (startDate != null) {
      movements = movements.where((movement) =>
          movement.createdAt.isAfter(startDate) ||
          movement.createdAt.isAtSameMomentAs(startDate));
    }
    
    if (endDate != null) {
      movements = movements.where((movement) =>
          movement.createdAt.isBefore(endDate) ||
          movement.createdAt.isAtSameMomentAs(endDate));
    }
    
    if (type != null) {
      movements = movements.where((movement) => movement.type == type.name);
    }
    
    var sortedMovements = movements.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    if (limit != null) {
      sortedMovements = sortedMovements.take(limit).toList();
    }
    
    return sortedMovements;
  }
  
  @override
  Future<StockMovementModel> addStockMovement(StockMovementModel movement) async {
    await init();
    await _movementsBoxRef.put(movement.id, movement);
    return movement;
  }
  
  @override
  Future<ProductModel> updateProductStock({
    required String productId,
    required double newQuantity,
    required MovementType movementType,
    String? reason,
    String? referenceId,
    String? userId,
  }) async {
    await init();
    
    final product = await getProductById(productId);
    if (product == null) {
      throw Exception('Product not found: $productId');
    }
    
    final oldQuantity = product.stock.quantity;
    final quantityChange = newQuantity - oldQuantity;
    
    // Créer le mouvement de stock
    final movement = StockMovementModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: productId,
      merchantId: product.merchantId,
      type: movementType.name,
      quantity: quantityChange,
      stockBefore: oldQuantity,
      stockAfter: newQuantity,
      reason: reason,
      referenceId: referenceId,
      userId: userId,
      createdAt: DateTime.now(),
    );
    
    await addStockMovement(movement);
    
    // Mettre à jour le produit
    final updatedStock = StockModel(
      quantity: newQuantity,
      minQuantity: product.stock.minQuantity,
      maxQuantity: product.stock.maxQuantity,
      status: _calculateStockStatus(newQuantity, product.stock.minQuantity),
      lastRestockDate: quantityChange > 0 
          ? DateTime.now() 
          : product.stock.lastRestockDate,
      lastMovementDate: DateTime.now(),
    );
    
    final updatedProduct = ProductModel(
      id: product.id,
      merchantId: product.merchantId,
      name: product.name,
      description: product.description,
      barcode: product.barcode,
      images: product.images,
      category: product.category,
      price: product.price,
      costPrice: product.costPrice,
      stock: updatedStock,
      nutritionalInfo: product.nutritionalInfo,
      allergens: product.allergens,
      isVegetarian: product.isVegetarian,
      isVegan: product.isVegan,
      isHalal: product.isHalal,
      isBio: product.isBio,
      expirationDate: product.expirationDate,
      unit: product.unit,
      weight: product.weight,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: DateTime.now(),
      customFields: product.customFields,
    );
    
    return await updateProduct(updatedProduct);
  }
  
  String _calculateStockStatus(double quantity, double minQuantity) {
    if (quantity == 0) {
      return StockStatus.outOfStock.name;
    } else if (quantity <= minQuantity) {
      return StockStatus.lowStock.name;
    } else {
      return StockStatus.inStock.name;
    }
  }
  
  @override
  Future<List<ProductModel>> bulkImportProducts(List<ProductModel> products) async {
    await init();
    final Map<String, ProductModel> productsMap = {
      for (var product in products) product.id: product
    };
    await _productsBoxRef.putAll(productsMap);
    return products;
  }
  
  @override
  Future<List<ProductModel>> exportProducts(String merchantId) async {
    return getProductsByMerchant(merchantId);
  }
  
  @override
  Future<StockStatistics> getStockStatistics(String merchantId) async {
    await init();
    
    final products = await getProductsByMerchant(merchantId);
    final domainProducts = products.map((p) => p.toDomain()).toList();
    
    int totalProducts = products.length;
    int activeProducts = 0;
    int lowStockProducts = 0;
    int outOfStockProducts = 0;
    int expiringSoonProducts = 0;
    double totalStockValue = 0;
    Map<ProductCategory, int> productsByCategory = {};
    
    for (final product in domainProducts) {
      if (product.isActive) activeProducts++;
      if (product.stock.isLow) lowStockProducts++;
      if (product.stock.isOutOfStock) outOfStockProducts++;
      if (product.isExpiringSoon) expiringSoonProducts++;
      
      totalStockValue += product.stockValue.amount;
      
      productsByCategory[product.category] = 
          (productsByCategory[product.category] ?? 0) + 1;
    }
    
    return StockStatistics(
      totalProducts: totalProducts,
      activeProducts: activeProducts,
      lowStockProducts: lowStockProducts,
      outOfStockProducts: outOfStockProducts,
      expiringSoonProducts: expiringSoonProducts,
      totalStockValue: totalStockValue,
      productsByCategory: productsByCategory,
    );
  }
  
  @override
  Future<ProductModel?> getProductByBarcode({
    required String barcode,
    required String merchantId,
  }) async {
    await init();
    
    try {
      return _productsBoxRef.values.firstWhere(
        (product) => 
            product.barcode == barcode && 
            product.merchantId == merchantId,
      );
    } catch (_) {
      return null;
    }
  }
}