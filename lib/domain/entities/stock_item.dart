import 'package:equatable/equatable.dart';

/// Niveau d'alerte pour le stock
enum StockAlertLevel {
  /// Stock normal
  normal,
  
  /// Stock faible (basé sur le seuil configuré)
  low,
  
  /// Rupture de stock
  outOfStock,
}

/// Extension pour l'affichage des niveaux d'alerte
extension StockAlertLevelExtension on StockAlertLevel {
  /// Label localisé du niveau
  String get label {
    switch (this) {
      case StockAlertLevel.normal:
        return 'Stock normal';
      case StockAlertLevel.low:
        return 'Stock faible';
      case StockAlertLevel.outOfStock:
        return 'Rupture de stock';
    }
  }
  
  /// Couleur associée au niveau
  String get colorKey {
    switch (this) {
      case StockAlertLevel.normal:
        return 'success';
      case StockAlertLevel.low:
        return 'warning';
      case StockAlertLevel.outOfStock:
        return 'error';
    }
  }
  
  /// Icône associée au niveau
  String get iconName {
    switch (this) {
      case StockAlertLevel.normal:
        return 'check_circle';
      case StockAlertLevel.low:
        return 'warning';
      case StockAlertLevel.outOfStock:
        return 'error';
    }
  }
}

/// Statut d'un article de stock
enum StockItemStatus {
  /// Article actif et disponible à la vente
  active,
  
  /// Article inactif/masqué (non visible dans le catalogue)
  inactive,
}

/// Extension pour l'affichage du statut
extension StockItemStatusExtension on StockItemStatus {
  /// Label localisé du statut
  String get label {
    switch (this) {
      case StockItemStatus.active:
        return 'Actif';
      case StockItemStatus.inactive:
        return 'Inactif';
    }
  }
  
  /// Couleur associée au statut
  String get colorKey {
    switch (this) {
      case StockItemStatus.active:
        return 'success';
      case StockItemStatus.inactive:
        return 'neutral';
    }
  }
}

/// Entité représentant un article de stock pour les marchands
/// 
/// Contient les informations essentielles pour la gestion de stock :
/// nom, référence, prix, quantité, statut et métadonnées.
class StockItem extends Equatable {
  const StockItem({
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

  /// Identifiant unique de l'article
  final String id;
  
  /// Nom de l'article
  final String name;
  
  /// Référence/SKU de l'article
  final String sku;
  
  /// Catégorie de l'article (ex: Fruits, Légumes, Plats)
  final String category;
  
  /// Prix unitaire en euros
  final double price;
  
  /// Quantité en stock
  final int quantity;
  
  /// Unité de mesure (ex: kg, pièce, litre)
  final String unit;
  
  /// Statut de l'article (actif/inactif)
  final StockItemStatus status;
  
  /// Date de dernière mise à jour
  final DateTime updatedAt;
  
  /// Description optionnelle de l'article
  final String? description;
  
  /// Seuil de stock faible (optionnel)
  /// Si défini, une alerte sera déclenchée quand quantity <= lowStockThreshold
  final int? lowStockThreshold;

  /// Indique si l'article est en rupture de stock
  bool get isOutOfStock => quantity <= 0;
  
  /// Indique si l'article est actif et disponible
  bool get isAvailable => status == StockItemStatus.active && !isOutOfStock;
  
  /// Indique si le stock est faible (basé sur le seuil configuré)
  bool get isLowStock => 
      lowStockThreshold != null && quantity <= lowStockThreshold! && quantity > 0;
  
  /// Niveau d'alerte du stock
  StockAlertLevel get alertLevel {
    if (isOutOfStock) return StockAlertLevel.outOfStock;
    if (isLowStock) return StockAlertLevel.low;
    return StockAlertLevel.normal;
  }
  
  /// Prix formaté avec devise
  String get formattedPrice => '${price.toStringAsFixed(2)}€';
  
  /// Quantité formatée avec unité
  String get formattedQuantity => '$quantity $unit';

  /// Crée une copie de l'article avec les champs modifiés
  StockItem copyWith({
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
    return StockItem(
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
  List<Object?> get props => [
        id,
        name,
        sku,
        category,
        price,
        quantity,
        unit,
        status,
        updatedAt,
        description,
        lowStockThreshold,
      ];

  @override
  String toString() => 'StockItem(id: $id, name: $name, sku: $sku, '
      'quantity: $quantity, status: $status)';
}
