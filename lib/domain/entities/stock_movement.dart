import 'package:equatable/equatable.dart';

/// Entité représentant un mouvement de stock
class StockMovement extends Equatable {
  final String id;
  final String productId;
  final String merchantId;
  final MovementType type;
  final double quantity; // Positive pour entrée, négative pour sortie
  final double stockBefore;
  final double stockAfter;
  final String? reason;
  final String? referenceId; // ID de la commande/offre liée
  final String? userId; // Utilisateur qui a effectué le mouvement
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const StockMovement({
    required this.id,
    required this.productId,
    required this.merchantId,
    required this.type,
    required this.quantity,
    required this.stockBefore,
    required this.stockAfter,
    this.reason,
    this.referenceId,
    this.userId,
    required this.createdAt,
    this.metadata,
  });

  /// Vérifie si c'est une entrée de stock
  bool get isIncoming => quantity > 0;

  /// Vérifie si c'est une sortie de stock
  bool get isOutgoing => quantity < 0;

  /// Obtient la quantité absolue
  double get absoluteQuantity => quantity.abs();

  @override
  List<Object?> get props => [
        id,
        productId,
        merchantId,
        type,
        quantity,
        stockBefore,
        stockAfter,
        reason,
        referenceId,
        userId,
        createdAt,
        metadata,
      ];
}

/// Types de mouvements de stock
enum MovementType {
  manualAdjustment, // Ajustement manuel
  purchase, // Achat/Réapprovisionnement
  sale, // Vente normale
  offerReservation, // Réservation d'offre anti-gaspi
  offerCollection, // Collecte d'offre
  offerCancellation, // Annulation d'offre
  expiry, // Péremption
  damage, // Perte/Casse
  transfer, // Transfert entre stocks
  inventoryCount, // Comptage d'inventaire
  return_, // Retour produit
}

/// Extension pour l'affichage des types de mouvement
extension MovementTypeX on MovementType {
  String get displayName {
    switch (this) {
      case MovementType.manualAdjustment:
        return 'Ajustement manuel';
      case MovementType.purchase:
        return 'Achat';
      case MovementType.sale:
        return 'Vente';
      case MovementType.offerReservation:
        return 'Réservation d\'offre';
      case MovementType.offerCollection:
        return 'Collecte d\'offre';
      case MovementType.offerCancellation:
        return 'Annulation d\'offre';
      case MovementType.expiry:
        return 'Péremption';
      case MovementType.damage:
        return 'Perte/Casse';
      case MovementType.transfer:
        return 'Transfert';
      case MovementType.inventoryCount:
        return 'Inventaire';
      case MovementType.return_:
        return 'Retour';
    }
  }

  /// Icône associée au type de mouvement
  String get icon {
    switch (this) {
      case MovementType.manualAdjustment:
        return '✏️';
      case MovementType.purchase:
        return '📦';
      case MovementType.sale:
        return '💰';
      case MovementType.offerReservation:
        return '🎫';
      case MovementType.offerCollection:
        return '🛍️';
      case MovementType.offerCancellation:
        return '❌';
      case MovementType.expiry:
        return '⏰';
      case MovementType.damage:
        return '💔';
      case MovementType.transfer:
        return '🔄';
      case MovementType.inventoryCount:
        return '📊';
      case MovementType.return_:
        return '↩️';
    }
  }
}