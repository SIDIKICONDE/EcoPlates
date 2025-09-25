import '../repositories/stock_repository.dart';

/// Use case pour supprimer un article de stock
class DeleteStockItemUseCase {
  const DeleteStockItemUseCase(this._repository);

  final StockRepository _repository;

  /// Supprime un article de stock par son ID
  /// 
  /// [itemId] : L'identifiant unique de l'article à supprimer
  /// 
  /// Retourne true si la suppression a réussi, false sinon
  Future<bool> call(String itemId) async {
    if (itemId.trim().isEmpty) {
      throw ArgumentError('L\'ID de l\'article ne peut pas être vide');
    }

    return await _repository.deleteItem(itemId);
  }
}