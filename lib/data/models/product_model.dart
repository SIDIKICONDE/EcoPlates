import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/product.dart';

part 'product_model.g.dart';

/// Modèle de données pour Product avec sérialisation JSON
@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 10)
class ProductModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String merchantId;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final String barcode;
  
  @HiveField(5)
  final List<String> images;
  
  @HiveField(6)
  final String category;
  
  @HiveField(7)
  final double price;
  
  @HiveField(8)
  final double? costPrice;
  
  @HiveField(9)
  final StockModel stock;
  
  @HiveField(10)
  final NutritionalInfoModel? nutritionalInfo;
  
  @HiveField(11)
  final List<String> allergens;
  
  @HiveField(12)
  final bool isVegetarian;
  
  @HiveField(13)
  final bool isVegan;
  
  @HiveField(14)
  final bool isHalal;
  
  @HiveField(15)
  final bool isBio;
  
  @HiveField(16)
  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJson)
  final DateTime? expirationDate;
  
  @HiveField(17)
  final String unit;
  
  @HiveField(18)
  final double weight;
  
  @HiveField(19)
  final bool isActive;
  
  @HiveField(20)
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  
  @HiveField(21)
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;
  
  @HiveField(22)
  final Map<String, dynamic>? customFields;

  const ProductModel({
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
    this.nutritionalInfo,
    required this.allergens,
    required this.isVegetarian,
    required this.isVegan,
    required this.isHalal,
    required this.isBio,
    this.expirationDate,
    required this.unit,
    required this.weight,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.customFields,
  });

  /// Convertit depuis l'entité du domaine
  factory ProductModel.fromDomain(Product product) {
    return ProductModel(
      id: product.id,
      merchantId: product.merchantId,
      name: product.name,
      description: product.description,
      barcode: product.barcode,
      images: product.images,
      category: product.category.name,
      price: product.price.amount,
      costPrice: product.costPrice?.amount,
      stock: StockModel.fromDomain(product.stock),
      nutritionalInfo: NutritionalInfoModel.fromDomain(product.nutritionalInfo),
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
      updatedAt: product.updatedAt,
      customFields: product.customFields,
    );
  }

  /// Convertit vers l'entité du domaine
  Product toDomain() {
    return Product(
      id: id,
      merchantId: merchantId,
      name: name,
      description: description,
      barcode: barcode,
      images: images,
      category: ProductCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => ProductCategory.autre,
      ),
      price: Money(amount: price),
      costPrice: costPrice != null ? Money(amount: costPrice!) : null,
      stock: stock.toDomain(),
      nutritionalInfo: nutritionalInfo?.toDomain() ?? const NutritionalInfo(),
      allergens: allergens,
      isVegetarian: isVegetarian,
      isVegan: isVegan,
      isHalal: isHalal,
      isBio: isBio,
      expirationDate: expirationDate,
      unit: unit,
      weight: weight,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      customFields: customFields,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  static DateTime _dateTimeFromJson(dynamic json) {
    if (json == null) return DateTime.now();
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return DateTime.now();
  }
  
  static DateTime? _dateTimeFromJsonNullable(dynamic json) {
    if (json == null) return null;
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return null;
  }

  static dynamic _dateTimeToJson(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }
}

/// Modèle pour les informations de stock
@JsonSerializable()
@HiveType(typeId: 11)
class StockModel {
  @HiveField(0)
  final double quantity;
  
  @HiveField(1)
  final double minQuantity;
  
  @HiveField(2)
  final double maxQuantity;
  
  @HiveField(3)
  final String status;
  
  @HiveField(4)
  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJson)
  final DateTime? lastRestockDate;
  
  @HiveField(5)
  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJson)
  final DateTime? lastMovementDate;

  const StockModel({
    required this.quantity,
    required this.minQuantity,
    required this.maxQuantity,
    required this.status,
    this.lastRestockDate,
    this.lastMovementDate,
  });

  factory StockModel.fromDomain(Stock stock) {
    return StockModel(
      quantity: stock.quantity,
      minQuantity: stock.minQuantity,
      maxQuantity: stock.maxQuantity,
      status: stock.status.name,
      lastRestockDate: stock.lastRestockDate,
      lastMovementDate: stock.lastMovementDate,
    );
  }

  Stock toDomain() {
    return Stock(
      quantity: quantity,
      minQuantity: minQuantity,
      maxQuantity: maxQuantity,
      status: StockStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => StockStatus.inStock,
      ),
      lastRestockDate: lastRestockDate,
      lastMovementDate: lastMovementDate,
    );
  }

  factory StockModel.fromJson(Map<String, dynamic> json) =>
      _$StockModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockModelToJson(this);

  static DateTime? _dateTimeFromJsonNullable(dynamic json) {
    if (json == null) return null;
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return null;
  }

  static dynamic _dateTimeToJson(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }
}

/// Modèle pour les informations nutritionnelles
@JsonSerializable()
@HiveType(typeId: 12)
class NutritionalInfoModel {
  @HiveField(0)
  final double? calories;
  
  @HiveField(1)
  final double? proteins;
  
  @HiveField(2)
  final double? carbohydrates;
  
  @HiveField(3)
  final double? sugars;
  
  @HiveField(4)
  final double? fat;
  
  @HiveField(5)
  final double? saturatedFat;
  
  @HiveField(6)
  final double? fiber;
  
  @HiveField(7)
  final double? salt;
  
  @HiveField(8)
  final Map<String, double>? vitamins;

  const NutritionalInfoModel({
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

  factory NutritionalInfoModel.fromDomain(NutritionalInfo info) {
    return NutritionalInfoModel(
      calories: info.calories,
      proteins: info.proteins,
      carbohydrates: info.carbohydrates,
      sugars: info.sugars,
      fat: info.fat,
      saturatedFat: info.saturatedFat,
      fiber: info.fiber,
      salt: info.salt,
      vitamins: info.vitamins,
    );
  }

  NutritionalInfo toDomain() {
    return NutritionalInfo(
      calories: calories,
      proteins: proteins,
      carbohydrates: carbohydrates,
      sugars: sugars,
      fat: fat,
      saturatedFat: saturatedFat,
      fiber: fiber,
      salt: salt,
      vitamins: vitamins,
    );
  }

  factory NutritionalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionalInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionalInfoModelToJson(this);
}