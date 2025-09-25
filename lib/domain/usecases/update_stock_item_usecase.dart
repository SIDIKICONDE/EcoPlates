import '../entities/stock_item.dart';
import '../repositories/stock_repository.dart';

/// Use case pour mettre à jour un article de stock existant
class UpdateStockItemUseCase {
  const UpdateStockItemUseCase(this._repository);

  final StockRepository _repository;

  /// Met à jour un article de stock
  /// 
  /// [item] : L'article mis à jour avec toutes ses nouvelles valeurs
  /// 
  /// Retourne l'article mis à jour avec ses métadonnées système
  /// (par exemple, updatedAt sera automatiquement mis à jour)
  Future<StockItem> call(StockItem item) async {
    // Validation des données
    if (item.name.trim().isEmpty) {
      throw ArgumentError("Le nom de l'article ne peut pas être vide");
    }

    if (item.price <= 0) {
      throw ArgumentError('Le prix doit être supérieur à 0');
    }

    if (item.quantity < 0) {
      throw ArgumentError('La quantité ne peut pas être négative');
    }

    if (item.unit.trim().isEmpty) {
      throw ArgumentError("L'unité ne peut pas être vide");
    }

    // Mise à jour via le repository
    return _repository.updateStockItem(item);
  }
}