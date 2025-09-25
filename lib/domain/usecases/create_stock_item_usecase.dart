import '../entities/stock_item.dart';
import '../repositories/stock_repository.dart';

/// Use case pour créer un nouvel article de stock
class CreateStockItemUseCase {
  const CreateStockItemUseCase(this._repository);

  final StockRepository _repository;

  /// Crée un nouvel article de stock
  /// 
  /// [name] : Nom de l'article
  /// [sku] : Code SKU unique
  /// [category] : Catégorie de l'article
  /// [price] : Prix unitaire
  /// [quantity] : Quantité initiale
  /// [unit] : Unité de mesure
  /// [description] : Description optionnelle
  /// [lowStockThreshold] : Seuil d'alerte de stock faible
  /// [status] : Statut de l'article (actif/inactif)
  /// 
  /// Retourne l'article créé avec son ID généré
  Future<StockItem> call({
    required String name,
    required String sku,
    required String category,
    required double price,
    required int quantity,
    required String unit,
    String? description,
    int? lowStockThreshold,
    StockItemStatus? status,
  }) async {
    // Validation des données
    if (name.trim().isEmpty) {
      throw ArgumentError("Le nom de l'article ne peut pas être vide");
    }

    if (sku.trim().isEmpty) {
      throw ArgumentError('Le SKU ne peut pas être vide');
    }

    if (category.trim().isEmpty) {
      throw ArgumentError('La catégorie ne peut pas être vide');
    }

    if (price <= 0) {
      throw ArgumentError('Le prix doit être supérieur à 0');
    }

    if (quantity < 0) {
      throw ArgumentError('La quantité ne peut pas être négative');
    }

    if (unit.trim().isEmpty) {
      throw ArgumentError("L'unité ne peut pas être vide");
    }
    
    if (lowStockThreshold != null && lowStockThreshold < 0) {
      throw ArgumentError('Le seuil d\'alerte ne peut pas être négatif');
    }

    // Créer l'article avec un ID temporaire (sera remplacé par le repository)
    final newItem = StockItem(
      id: '', // Le repository assignera l'ID définitif
      name: name.trim(),
      sku: sku.trim(),
      category: category.trim(),
      price: price,
      quantity: quantity,
      unit: unit.trim(),
      status: status ?? StockItemStatus.active,
      description: description?.trim(),
      lowStockThreshold: lowStockThreshold,
      updatedAt: DateTime.now(),
    );

    // Création via le repository (l'impl implémentera l'ID et updatedAt)
    return _repository.createStockItem(newItem);
  }
}