import 'package:equatable/equatable.dart';

/// Entité représentant un produit dans l'inventaire du marchand
class Product extends Equatable {
  final String id;
  final String merchantId;
  final String name;
  final String description;
  final String barcode;
  final List<String> images;
  final ProductCategory category;
  final Money price;
  final Money? costPrice; // Prix d'achat pour calcul de marge
  final Stock stock;
  final NutritionalInfo nutritionalInfo;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isHalal;
  final bool isBio;
  final DateTime? expirationDate;
  final String unit; // "kg", "unité", "litre", etc.
  final double weight; // Poids en grammes
  final bool isActive; // Produit actif ou archivé
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? customFields; // Champs personnalisés

  const Product({
    required this.id,
    required this.merchantId,
    required this.name,
    required this.description,
    required this.barcode,
    required this.images,
    required this.category,
    required this.price,
    this.costPrice,
    required this.stock,
    required this.nutritionalInfo,
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isHalal = false,
    this.isBio = false,
    this.expirationDate,
    this.unit = 'unité',
    this.weight = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.customFields,
  });

  /// Vérifie si le produit est périmé
  bool get isExpired {
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  /// Vérifie si le produit expire bientôt (dans les 3 prochains jours)
  bool get isExpiringSoon {
    if (expirationDate == null) return false;
    final daysUntilExpiry = expirationDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 3 && daysUntilExpiry > 0;
  }

  /// Calcule la marge bénéficiaire
  double get profitMargin {
    if (costPrice == null || costPrice!.amount == 0) return 0;
    return ((price.amount - costPrice!.amount) / costPrice!.amount) * 100;
  }

  /// Valeur totale du stock
  Money get stockValue => Money(
        amount: price.amount * stock.quantity,
        currency: price.currency,
      );

  /// Crée une copie avec des modifications
  Product copyWith({
    String? id,
    String? merchantId,
    String? name,
    String? description,
    String? barcode,
    List<String>? images,
    ProductCategory? category,
    Money? price,
    Money? costPrice,
    Stock? stock,
    NutritionalInfo? nutritionalInfo,
    List<String>? allergens,
    bool? isVegetarian,
    bool? isVegan,
    bool? isHalal,
    bool? isBio,
    DateTime? expirationDate,
    String? unit,
    double? weight,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? customFields,
  }) {
    return Product(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      name: name ?? this.name,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      images: images ?? this.images,
      category: category ?? this.category,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      allergens: allergens ?? this.allergens,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isHalal: isHalal ?? this.isHalal,
      isBio: isBio ?? this.isBio,
      expirationDate: expirationDate ?? this.expirationDate,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customFields: customFields ?? this.customFields,
    );
  }

  @override
  List<Object?> get props => [
        id,
        merchantId,
        name,
        description,
        barcode,
        images,
        category,
        price,
        costPrice,
        stock,
        nutritionalInfo,
        allergens,
        isVegetarian,
        isVegan,
        isHalal,
        isBio,
        expirationDate,
        unit,
        weight,
        isActive,
        createdAt,
        updatedAt,
        customFields,
      ];
}

/// Catégories de produits
enum ProductCategory {
  boulangerie,
  patisserie,
  fruitLegume,
  viande,
  poisson,
  produitLaitier,
  epicerie,
  boisson,
  platsPrePares,
  snack,
  autre,
}

/// Value object représentant une valeur monétaire
class Money extends Equatable {
  final double amount;
  final String currency;

  const Money({
    required this.amount,
    this.currency = 'EUR',
  });

  String get formatted => '${amount.toStringAsFixed(2)} $currency';

  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add different currencies');
    }
    return Money(amount: amount + other.amount, currency: currency);
  }

  Money operator -(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot subtract different currencies');
    }
    return Money(amount: amount - other.amount, currency: currency);
  }

  @override
  List<Object> get props => [amount, currency];
}

/// Value object représentant le stock d'un produit
class Stock extends Equatable {
  final double quantity;
  final double minQuantity; // Seuil d'alerte
  final double maxQuantity; // Capacité maximale
  final StockStatus status;
  final DateTime? lastRestockDate;
  final DateTime? lastMovementDate;

  const Stock({
    required this.quantity,
    required this.minQuantity,
    this.maxQuantity = double.infinity,
    required this.status,
    this.lastRestockDate,
    this.lastMovementDate,
  });

  /// Vérifie si le stock est faible
  bool get isLow => quantity <= minQuantity;

  /// Vérifie si le stock est en rupture
  bool get isOutOfStock => quantity == 0;

  /// Pourcentage du stock restant
  double get percentageRemaining {
    if (maxQuantity == double.infinity) return 100;
    return (quantity / maxQuantity) * 100;
  }

  Stock copyWith({
    double? quantity,
    double? minQuantity,
    double? maxQuantity,
    StockStatus? status,
    DateTime? lastRestockDate,
    DateTime? lastMovementDate,
  }) {
    return Stock(
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      status: status ?? this.status,
      lastRestockDate: lastRestockDate ?? this.lastRestockDate,
      lastMovementDate: lastMovementDate ?? this.lastMovementDate,
    );
  }

  @override
  List<Object?> get props => [
        quantity,
        minQuantity,
        maxQuantity,
        status,
        lastRestockDate,
        lastMovementDate,
      ];
}

/// Statut du stock
enum StockStatus {
  inStock, // En stock
  lowStock, // Stock faible
  outOfStock, // Rupture de stock
  discontinued, // Discontinué
}

/// Informations nutritionnelles
class NutritionalInfo extends Equatable {
  final double? calories; // kcal pour 100g
  final double? proteins; // g pour 100g
  final double? carbohydrates; // g pour 100g
  final double? sugars; // g pour 100g
  final double? fat; // g pour 100g
  final double? saturatedFat; // g pour 100g
  final double? fiber; // g pour 100g
  final double? salt; // g pour 100g
  final Map<String, double>? vitamins; // Autres nutriments

  const NutritionalInfo({
    this.calories,
    this.proteins,
    this.carbohydrates,
    this.sugars,
    this.fat,
    this.saturatedFat,
    this.fiber,
    this.salt,
    this.vitamins,
  });

  @override
  List<Object?> get props => [
        calories,
        proteins,
        carbohydrates,
        sugars,
        fat,
        saturatedFat,
        fiber,
        salt,
        vitamins,
      ];
}

/// Extension pour les noms de catégories
extension ProductCategoryX on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.boulangerie:
        return 'Boulangerie';
      case ProductCategory.patisserie:
        return 'Pâtisserie';
      case ProductCategory.fruitLegume:
        return 'Fruits & Légumes';
      case ProductCategory.viande:
        return 'Viande';
      case ProductCategory.poisson:
        return 'Poisson';
      case ProductCategory.produitLaitier:
        return 'Produits laitiers';
      case ProductCategory.epicerie:
        return 'Épicerie';
      case ProductCategory.boisson:
        return 'Boissons';
      case ProductCategory.platsPrePares:
        return 'Plats préparés';
      case ProductCategory.snack:
        return 'Snacks';
      case ProductCategory.autre:
        return 'Autre';
    }
  }
}