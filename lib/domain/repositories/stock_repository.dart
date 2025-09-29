import '../entities/stock_item.dart';

/// Filtre pour la recherche d'articles de stock
class StockItemsFilter {
  const StockItemsFilter({
    this.searchQuery,
    this.status,
    this.category,
  });

  /// Terme de recherche (nom ou SKU)
  final String? searchQuery;
  
  /// Filtrage par statut
  final StockItemStatus? status;
  
  /// Filtrage par catégorie
  final String? category;

  /// Filtre vide (pas de restrictions)
  static const StockItemsFilter none = StockItemsFilter();
  
  /// Crée une copie du filtre avec les champs modifiés
  StockItemsFilter copyWith({
    String? searchQuery,
    StockItemStatus? status,
    String? category,
  }) {
    return StockItemsFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }
}

/// Options de tri pour les articles de stock
enum StockSortOption {
  /// Tri par nom (A-Z)
  nameAsc,
  
  /// Tri par nom (Z-A)
  nameDesc,
  
  /// Tri par quantité (croissant)
  quantityAsc,
  
  /// Tri par quantité (décroissant)
  quantityDesc,
  
  /// Tri par dernière mise à jour (plus récent en premier)
  updatedDesc,
  
  /// Tri par prix (croissant)
  priceAsc,
  
  /// Tri par prix (décroissant)
  priceDesc,
}

/// Extension pour l'affichage des options de tri
extension StockSortOptionExtension on StockSortOption {
  /// Label localisé de l'option de tri
  String get label {
    switch (this) {
      case StockSortOption.nameAsc:
        return 'Nom (A-Z)';
      case StockSortOption.nameDesc:
        return 'Nom (Z-A)';
      case StockSortOption.quantityAsc:
        return 'Quantité (croissant)';
      case StockSortOption.quantityDesc:
        return 'Quantité (décroissant)';
      case StockSortOption.updatedDesc:
        return 'Récemment modifié';
      case StockSortOption.priceAsc:
        return 'Prix (croissant)';
      case StockSortOption.priceDesc:
        return 'Prix (décroissant)';
    }
  }
}

/// Repository abstrait pour la gestion des articles de stock
/// 
/// Définit les contrats pour :
/// - Consultation des articles (avec filtres et tri)
/// - Mise à jour des articles (statut, prix, métadonnées)
/// - Ajustement des quantités en stock
abstract class StockRepository {
  /// Récupère tous les articles de stock
  /// 
  /// [filter] permet de filtrer par terme de recherche, statut ou catégorie
  /// [sortBy] définit l'ordre de tri des résultats
  /// 
  /// Retourne la liste des articles correspondant aux critères
  Future<List<StockItem>> getStockItems({
    StockItemsFilter filter = StockItemsFilter.none,
    StockSortOption sortBy = StockSortOption.nameAsc,
  });

  /// Récupère un article de stock par son identifiant
  /// 
  /// [id] identifiant unique de l'article
  /// 
  /// Retourne l'article s'il existe, null sinon
  Future<StockItem?> getStockItemById(String id);

  /// Met à jour un article de stock
  /// 
  /// [item] article avec les nouvelles valeurs
  /// 
  /// Retourne l'article mis à jour
  /// Lève une [Exception] si l'article n'existe pas
  Future<StockItem> updateStockItem(StockItem item);

  /// Ajuste la quantité d'un article de stock
  /// 
  /// [id] identifiant de l'article
  /// [delta] variation de quantité (peut être négative)
  /// 
  /// Retourne l'article avec la quantité mise à jour
  /// Lève une [Exception] si l'article n'existe pas ou si la quantité
  /// résultante est négative
  Future<StockItem> adjustQuantity(String id, int delta);

  /// Change le statut d'un article de stock
  /// 
  /// [id] identifiant de l'article
  /// [status] nouveau statut
  /// 
  /// Retourne l'article avec le statut mis à jour
  /// Lève une [Exception] si l'article n'existe pas
  Future<StockItem> updateStatus(String id, StockItemStatus status);

  /// Crée un nouvel article de stock
  /// 
  /// [item] article à créer (l'implémentation assigne l'ID et updatedAt)
  /// 
  /// Retourne l'article créé
  Future<StockItem> createStockItem(StockItem item);

  /// Supprime un article de stock
  /// 
  /// [id] identifiant de l'article à supprimer
  /// 
  /// Retourne true si la suppression a réussi, false sinon
  Future<bool> deleteItem(String id);
}
