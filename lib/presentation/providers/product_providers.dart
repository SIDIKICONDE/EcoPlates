import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_product_data_source.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/services/inventory_service.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/stock_movement.dart';
import 'product_state.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provider pour la source de données locale
final localProductDataSourceProvider = Provider<LocalProductDataSource>((ref) {
  return LocalProductDataSource();
});

// ============================================================================
// Repository Providers
// ============================================================================

/// Provider pour le repository des produits
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final localDataSource = ref.watch(localProductDataSourceProvider);
  return ProductRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: null, // TODO: Ajouter quand l'API sera disponible
  );
});

/// Provider pour le service d'inventaire
final inventoryServiceProvider = Provider<InventoryService>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return InventoryService(repository);
});

// ============================================================================
// State Providers
// ============================================================================

/// Provider pour gérer la liste des produits d'un marchand
final productListProvider = StateNotifierProvider.autoDispose
    .family<ProductListNotifier, AsyncValue<ProductListState>, String>(
  (ref, merchantId) => ProductListNotifier(
    ref.watch(productRepositoryProvider),
    merchantId,
  ),
);

/// Notifier pour gérer l'état de la liste des produits
class ProductListNotifier extends StateNotifier<AsyncValue<ProductListState>> {
  final ProductRepository _repository;
  final String _merchantId;

  ProductListNotifier(this._repository, this._merchantId)
      : super(const AsyncValue.loading()) {
    loadProducts();
  }

  /// Charge les produits du marchand
  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    
    final result = await _repository.getProductsByMerchant(_merchantId);
    
    result.fold(
      (failure) => state = AsyncValue.error(
        failure.message,
        StackTrace.current,
      ),
      (products) {
        final productListState = ProductListState(
          products: products,
          filteredProducts: products,
        );
        state = AsyncValue.data(productListState);
      },
    );
  }

  /// Rafraîchit la liste des produits
  Future<void> refresh() async {
    state.whenData((currentState) {
      state = AsyncValue.data(currentState.copyWith(isRefreshing: true));
    });
    
    await loadProducts();
  }

  /// Filtre les produits selon les critères
  void applyFilters({
    String? searchQuery,
    ProductCategory? category,
    bool? showActiveOnly,
    bool? showLowStockOnly,
  }) {
    state.whenData((currentState) {
      final newState = currentState.copyWith(
        searchQuery: searchQuery ?? currentState.searchQuery,
        selectedCategory: category,
        showActiveOnly: showActiveOnly ?? currentState.showActiveOnly,
        showLowStockOnly: showLowStockOnly ?? currentState.showLowStockOnly,
      );
      
      var filtered = newState.products;
      
      // Filtre par recherche
      if (newState.searchQuery.isNotEmpty) {
        filtered = filtered.where((p) => 
          p.name.toLowerCase().contains(newState.searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(newState.searchQuery.toLowerCase()) ||
          p.barcode.contains(newState.searchQuery)
        ).toList();
      }
      
      // Filtre par catégorie
      if (newState.selectedCategory != null) {
        filtered = filtered.where((p) => p.category == newState.selectedCategory).toList();
      }
      
      // Filtre par statut actif
      if (newState.showActiveOnly) {
        filtered = filtered.where((p) => p.isActive).toList();
      }
      
      // Filtre par stock faible
      if (newState.showLowStockOnly) {
        filtered = filtered.where((p) => p.stock.isLow).toList();
      }
      
      // Applique le tri
      filtered = _sortProducts(filtered, newState.sortOption);
      
      state = AsyncValue.data(newState.copyWith(filteredProducts: filtered));
    });
  }

  /// Trie les produits selon l'option sélectionnée
  List<Product> _sortProducts(List<Product> products, ProductSortOption option) {
    final sorted = List<Product>.from(products);
    
    switch (option) {
      case ProductSortOption.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.category:
        sorted.sort((a, b) => a.category.index.compareTo(b.category.index));
        break;
      case ProductSortOption.price:
        sorted.sort((a, b) => a.price.amount.compareTo(b.price.amount));
        break;
      case ProductSortOption.stock:
        sorted.sort((a, b) => a.stock.quantity.compareTo(b.stock.quantity));
        break;
      case ProductSortOption.expiration:
        sorted.sort((a, b) {
          if (a.expirationDate == null && b.expirationDate == null) return 0;
          if (a.expirationDate == null) return 1;
          if (b.expirationDate == null) return -1;
          return a.expirationDate!.compareTo(b.expirationDate!);
        });
        break;
    }
    
    return sorted;
  }

  /// Change l'option de tri
  void setSortOption(ProductSortOption option) {
    state.whenData((currentState) {
      final filtered = _sortProducts(currentState.filteredProducts, option);
      state = AsyncValue.data(currentState.copyWith(
        sortOption: option,
        filteredProducts: filtered,
      ));
    });
  }

  /// Supprime un produit
  Future<void> deleteProduct(String productId) async {
    final result = await _repository.deleteProduct(productId);
    
    result.fold(
      (failure) {
        // TODO: Afficher une erreur à l'utilisateur
      },
      (_) => loadProducts(),
    );
  }
}

// ============================================================================
// Product Detail Provider
// ============================================================================

/// Provider pour un produit spécifique
final productDetailProvider = FutureProvider.autoDispose
    .family<Product?, String>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getProductById(productId);
  
  return result.fold(
    (failure) => throw failure,
    (product) => product,
  );
});

// ============================================================================
// Stock Movement Providers
// ============================================================================

/// Provider pour l'historique des mouvements de stock
final stockMovementsProvider = FutureProvider.autoDispose
    .family<List<StockMovement>, String>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getStockMovements(
    productId: productId,
    limit: 50,
  );
  
  return result.fold(
    (failure) => throw failure,
    (movements) => movements,
  );
});

// ============================================================================
// Stock Alert Providers
// ============================================================================

/// Provider pour les alertes de stock
final stockAlertsProvider = StateNotifierProvider.autoDispose
    .family<StockAlertsNotifier, AsyncValue<StockAlertsState>, String>(
  (ref, merchantId) => StockAlertsNotifier(
    ref.watch(inventoryServiceProvider),
    merchantId,
  ),
);

/// Notifier pour gérer les alertes de stock
class StockAlertsNotifier extends StateNotifier<AsyncValue<StockAlertsState>> {
  final InventoryService _inventoryService;
  final String _merchantId;

  StockAlertsNotifier(this._inventoryService, this._merchantId)
      : super(const AsyncValue.loading()) {
    loadAlerts();
  }

  /// Charge toutes les alertes
  Future<void> loadAlerts() async {
    state = const AsyncValue.loading();
    
    try {
      // Charge les alertes de stock faible
      final lowStockResult = await _inventoryService.generateLowStockAlerts(_merchantId);
      final expiryResult = await _inventoryService.generateExpiryAlerts(_merchantId);
      
      final lowStockAlerts = lowStockResult.fold(
        (failure) => <StockAlert>[],
        (alerts) => alerts,
      );
      
      final expiryAlerts = expiryResult.fold(
        (failure) => <StockAlert>[],
        (alerts) => alerts,
      );
      
      state = AsyncValue.data(StockAlertsState(
        lowStockAlerts: lowStockAlerts,
        expiryAlerts: expiryAlerts,
        lastUpdate: DateTime.now(),
      ));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Rafraîchit les alertes
  Future<void> refresh() async {
    await loadAlerts();
  }
}

// ============================================================================
// Product Form Provider
// ============================================================================

/// Provider pour gérer le formulaire de produit
final productFormProvider = StateNotifierProvider.autoDispose
    <ProductFormNotifier, ProductFormState>((ref) {
  return ProductFormNotifier(ref.watch(productRepositoryProvider));
});

/// Notifier pour gérer l'état du formulaire de produit
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final ProductRepository _repository;

  ProductFormNotifier(this._repository) : super(const ProductFormState());

  /// Initialise le formulaire avec un produit existant
  void initializeWithProduct(Product product) {
    state = ProductFormState(product: product);
  }

  /// Met à jour un champ du produit
  void updateField(Product updatedProduct) {
    state = state.copyWith(
      product: updatedProduct,
      hasChanges: true,
    );
    _validateForm();
  }

  /// Valide le formulaire
  void _validateForm() {
    final product = state.product;
    if (product == null) {
      state = state.copyWith(isValid: false);
      return;
    }

    final errors = <String, String>{};
    
    if (product.name.isEmpty) {
      errors['name'] = 'Le nom est requis';
    }
    
    if (product.price.amount < 0) {
      errors['price'] = 'Le prix ne peut pas être négatif';
    }
    
    if (product.stock.quantity < 0) {
      errors['stock'] = 'La quantité ne peut pas être négative';
    }
    
    state = state.copyWith(
      fieldErrors: errors,
      isValid: errors.isEmpty,
    );
  }

  /// Sauvegarde le produit
  Future<void> saveProduct() async {
    final product = state.product;
    if (product == null || !state.isValid) return;
    
    state = state.copyWith(isSaving: true, errorMessage: null);
    
    final result = product.id.isEmpty
        ? await _repository.addProduct(product)
        : await _repository.updateProduct(product);
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
        );
      },
      (savedProduct) {
        state = state.copyWith(
          isSaving: false,
          product: savedProduct,
          hasChanges: false,
        );
      },
    );
  }
}

// ============================================================================
// Stock Adjustment Provider
// ============================================================================

/// Provider pour gérer les ajustements de stock
final stockAdjustmentProvider = StateNotifierProvider.autoDispose
    <StockAdjustmentNotifier, AsyncValue<void>>((ref) {
  return StockAdjustmentNotifier(ref.watch(inventoryServiceProvider));
});

/// Notifier pour gérer les ajustements de stock
class StockAdjustmentNotifier extends StateNotifier<AsyncValue<void>> {
  final InventoryService _inventoryService;

  StockAdjustmentNotifier(this._inventoryService) : super(const AsyncValue.data(null));

  /// Effectue un ajustement de stock
  Future<void> adjustStock({
    required String productId,
    required double quantityChange,
    required String reason,
    String? userId,
  }) async {
    state = const AsyncValue.loading();
    
    final result = await _inventoryService.adjustStock(
      productId: productId,
      quantityChange: quantityChange,
      reason: reason,
      userId: userId,
    );
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }

  /// Effectue un comptage d'inventaire
  Future<void> performInventoryCount({
    required String productId,
    required double countedQuantity,
    String? userId,
  }) async {
    state = const AsyncValue.loading();
    
    final result = await _inventoryService.performInventoryCount(
      productId: productId,
      countedQuantity: countedQuantity,
      userId: userId,
    );
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}