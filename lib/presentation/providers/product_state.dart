import 'package:equatable/equatable.dart';

import '../../data/services/inventory_service.dart';
import '../../domain/entities/product.dart';

/// État de la liste des produits
class ProductListState extends Equatable {
  final List<Product> products;
  final List<Product> filteredProducts;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final String searchQuery;
  final ProductCategory? selectedCategory;
  final bool showActiveOnly;
  final bool showLowStockOnly;
  final ProductSortOption sortOption;

  const ProductListState({
    this.products = const [],
    this.filteredProducts = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategory,
    this.showActiveOnly = true,
    this.showLowStockOnly = false,
    this.sortOption = ProductSortOption.name,
  });

  ProductListState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    String? searchQuery,
    ProductCategory? selectedCategory,
    bool? showActiveOnly,
    bool? showLowStockOnly,
    ProductSortOption? sortOption,
  }) {
    return ProductListState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory,
      showActiveOnly: showActiveOnly ?? this.showActiveOnly,
      showLowStockOnly: showLowStockOnly ?? this.showLowStockOnly,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [
        products,
        filteredProducts,
        isLoading,
        isRefreshing,
        errorMessage,
        searchQuery,
        selectedCategory,
        showActiveOnly,
        showLowStockOnly,
        sortOption,
      ];
}

/// Options de tri pour les produits
enum ProductSortOption {
  name,
  category,
  price,
  stock,
  expiration,
}

/// État des alertes de stock
class StockAlertsState extends Equatable {
  final List<StockAlert> lowStockAlerts;
  final List<StockAlert> expiryAlerts;
  final bool isLoading;
  final DateTime? lastUpdate;

  const StockAlertsState({
    this.lowStockAlerts = const [],
    this.expiryAlerts = const [],
    this.isLoading = false,
    this.lastUpdate,
  });

  StockAlertsState copyWith({
    List<StockAlert>? lowStockAlerts,
    List<StockAlert>? expiryAlerts,
    bool? isLoading,
    DateTime? lastUpdate,
  }) {
    return StockAlertsState(
      lowStockAlerts: lowStockAlerts ?? this.lowStockAlerts,
      expiryAlerts: expiryAlerts ?? this.expiryAlerts,
      isLoading: isLoading ?? this.isLoading,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  /// Nombre total d'alertes
  int get totalAlerts => lowStockAlerts.length + expiryAlerts.length;

  /// Nombre d'alertes de haute priorité
  int get highPriorityAlerts {
    return lowStockAlerts.where((a) => a.severity == AlertSeverity.high).length +
        expiryAlerts.where((a) => a.severity == AlertSeverity.high).length;
  }

  @override
  List<Object?> get props => [lowStockAlerts, expiryAlerts, isLoading, lastUpdate];
}

/// État du formulaire de produit
class ProductFormState extends Equatable {
  final Product? product;
  final bool isLoading;
  final bool isSaving;
  final bool isValid;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final bool hasChanges;

  const ProductFormState({
    this.product,
    this.isLoading = false,
    this.isSaving = false,
    this.isValid = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.hasChanges = false,
  });

  ProductFormState copyWith({
    Product? product,
    bool? isLoading,
    bool? isSaving,
    bool? isValid,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    bool? hasChanges,
  }) {
    return ProductFormState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
        product,
        isLoading,
        isSaving,
        isValid,
        errorMessage,
        fieldErrors,
        hasChanges,
      ];
}