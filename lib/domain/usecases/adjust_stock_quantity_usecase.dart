import '../entities/stock_item.dart';
import '../repositories/stock_repository.dart';

/// Exception levée lors d'un ajustement de quantité invalide
class InvalidQuantityAdjustmentException implements Exception {
  const InvalidQuantityAdjustmentException(this.message);
  
  final String message;
  
  @override
  String toString() => 'InvalidQuantityAdjustmentException: $message';
}

/// Use case pour ajuster la quantité d'un article de stock
/// 
/// Encapsule la logique métier d'ajustement des quantités :
/// - Validation des paramètres (delta, quantité résultante)
/// - Prévention des quantités négatives
/// - Mise à jour de la date de modification
class AdjustStockQuantityUseCase {
  const AdjustStockQuantityUseCase(this._repository);

  final StockRepository _repository;

  /// Exécute l'ajustement de quantité
  /// 
  /// [itemId] identifiant de l'article
  /// [delta] variation de quantité (positive ou négative)
  /// 
  /// Retourne l'article avec la quantité mise à jour
  /// Lève [InvalidQuantityAdjustmentException] si l'ajustement est invalide
  /// Lève [Exception] si l'article n'existe pas
  Future<StockItem> call(String itemId, int delta) async {
    // Validation des paramètres
    if (itemId.trim().isEmpty) {
      throw const InvalidQuantityAdjustmentException(
        'L\'identifiant de l\'article ne peut pas être vide',
      );
    }

    if (delta == 0) {
      throw const InvalidQuantityAdjustmentException(
        'La variation de quantité doit être différente de zéro',
      );
    }

    // Récupération de l'article actuel pour validation
    final currentItem = await _repository.getStockItemById(itemId);
    if (currentItem == null) {
      throw Exception('Article non trouvé : $itemId');
    }

    // Validation de la quantité résultante
    final newQuantity = currentItem.quantity + delta;
    if (newQuantity < 0) {
      throw InvalidQuantityAdjustmentException(
        'La quantité ne peut pas être négative. '
        'Quantité actuelle: ${currentItem.quantity}, '
        'ajustement: $delta',
      );
    }

    // Ajustement via le repository
    return _repository.adjustQuantity(itemId, delta);
  }
}