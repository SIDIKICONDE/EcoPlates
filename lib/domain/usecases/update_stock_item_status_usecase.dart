import '../entities/stock_item.dart';
import '../repositories/stock_repository.dart';

/// Use case pour modifier le statut d'un article de stock
/// 
/// Encapsule la logique métier de changement de statut :
/// - Validation des paramètres
/// - Mise à jour via le repository
/// - Gestion des erreurs métier
class UpdateStockItemStatusUseCase {
  const UpdateStockItemStatusUseCase(this._repository);

  final StockRepository _repository;

  /// Exécute le changement de statut
  /// 
  /// [itemId] identifiant de l'article
  /// [newStatus] nouveau statut à appliquer
  /// 
  /// Retourne l'article avec le statut mis à jour
  /// Lève [ArgumentError] si les paramètres sont invalides
  /// Lève [Exception] si l'article n'existe pas
  Future<StockItem> call(String itemId, StockItemStatus newStatus) async {
    // Validation des paramètres
    if (itemId.trim().isEmpty) {
      throw ArgumentError.value(
        itemId,
        'itemId',
        'L\'identifiant de l\'article ne peut pas être vide',
      );
    }

    // Vérification que l'article existe
    final currentItem = await _repository.getStockItemById(itemId);
    if (currentItem == null) {
      throw Exception('Article non trouvé : $itemId');
    }

    // Si le statut est déjà le bon, pas de modification nécessaire
    if (currentItem.status == newStatus) {
      return currentItem;
    }

    // Mise à jour du statut via le repository
    return _repository.updateStatus(itemId, newStatus);
  }

  /// Bascule le statut d'un article (actif <-> inactif)
  /// 
  /// [itemId] identifiant de l'article
  /// 
  /// Retourne l'article avec le statut inversé
  Future<StockItem> toggle(String itemId) async {
    final currentItem = await _repository.getStockItemById(itemId);
    if (currentItem == null) {
      throw Exception('Article non trouvé : $itemId');
    }

    final newStatus = currentItem.status == StockItemStatus.active
        ? StockItemStatus.inactive
        : StockItemStatus.active;

    return call(itemId, newStatus);
  }
}