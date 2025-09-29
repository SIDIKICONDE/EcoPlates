import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/stock_item.dart';

part 'stock_item_model.g.dart';

/// Modèle de données pour la sérialisation JSON des articles de stock
/// 
/// Correspond à l'entité [StockItem] du domaine avec des capacités
/// de sérialisation/désérialisation pour les échanges avec les APIs.
@JsonSerializable()
class StockItemModel {
  const StockItemModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.status,
    required this.updatedAt,
    this.description,
    this.lowStockThreshold,
  });

  /// Crée un modèle depuis un objet JSON
  factory StockItemModel.fromJson(Map<String, dynamic> json) =>
      _$StockItemModelFromJson(json);

  /// Crée un modèle depuis une entité du domaine
  factory StockItemModel.fromEntity(StockItem entity) {
    return StockItemModel(
      id: entity.id,
      name: entity.name,
      sku: entity.sku,
      category: entity.category,
      price: entity.price,
      quantity: entity.quantity,
      unit: entity.unit,
      status: entity.status,
      updatedAt: entity.updatedAt,
      description: entity.description,
      lowStockThreshold: entity.lowStockThreshold,
    );
  }

  /// Identifiant unique de l'article
  final String id;
  
  /// Nom de l'article
  final String name;
  
  /// Référence/SKU de l'article
  final String sku;
  
  /// Catégorie de l'article
  final String category;
  
  /// Prix unitaire en euros
  final double price;
  
  /// Quantité en stock
  final int quantity;
  
  /// Unité de mesure
  final String unit;
  
  /// Statut de l'article
  final StockItemStatus status;
  
  /// Date de dernière mise à jour
  final DateTime updatedAt;
  
  /// Description optionnelle de l'article
  final String? description;
  
  /// Seuil de stock faible (optionnel)
  @JsonKey(defaultValue: null)
  final int? lowStockThreshold;

  /// Convertit le modèle en objet JSON
  Map<String, dynamic> toJson() => _$StockItemModelToJson(this);

  /// Convertit le modèle en entité du domaine
  StockItem toEntity() {
    return StockItem(
      id: id,
      name: name,
      sku: sku,
      category: category,
      price: price,
      quantity: quantity,
      unit: unit,
      status: status,
      updatedAt: updatedAt,
      description: description,
      lowStockThreshold: lowStockThreshold,
    );
  }

  /// Crée une copie du modèle avec les champs modifiés
  StockItemModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    double? price,
    int? quantity,
    String? unit,
    StockItemStatus? status,
    DateTime? updatedAt,
    String? description,
    int? lowStockThreshold,
  }) {
    return StockItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    );
  }

  @override
  String toString() => 'StockItemModel(id: $id, name: $name, sku: $sku, '
      'quantity: $quantity, status: $status)';
}
