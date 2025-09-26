import '../entities/stock_item.dart';
import '../repositories/stock_repository.dart';

/// Use case pour récupérer les articles de stock avec filtrage et tri
/// 
/// Encapsule la logique métier de consultation du stock :
/// - Application des filtres (recherche, statut, catégorie)
/// - Tri selon les critères demandés
/// - Validation des paramètres d'entrée
class GetStockItemsUseCase {
  const GetStockItemsUseCase(this._repository);

  final StockRepository _repository;

  /// Exécute le use case de récupération des articles
  /// 
  /// [filter] critères de filtrage optionnels
  /// [sortBy] option de tri (par défaut : nom A-Z)
  /// 
  /// Retourne la liste des articles correspondant aux critères
  Future<List<StockItem>> call({
    StockItemsFilter filter = StockItemsFilter.none,
    StockSortOption sortBy = StockSortOption.nameAsc,
  }) async {
    // Validation des paramètres si nécessaire
    final normalizedFilter = _normalizeFilter(filter);
    
    // Délégation au repository
    final items = await _repository.getStockItems(
      filter: normalizedFilter,
      sortBy: sortBy,
    );
    
    // Post-traitement si nécessaire (ex: logs, métriques)
    return items;
  }

  /// Normalise le filtre de recherche
  /// 
  /// Trim les espaces, convertit en minuscules pour la recherche textuelle
  StockItemsFilter _normalizeFilter(StockItemsFilter filter) {
    final searchQuery = filter.searchQuery?.trim().toLowerCase();
    
    // Si la recherche est vide, on la supprime
    if (searchQuery?.isEmpty ?? true) {
      return filter.copyWith();
    }
    
    return filter.copyWith(searchQuery: searchQuery);
  }
}
