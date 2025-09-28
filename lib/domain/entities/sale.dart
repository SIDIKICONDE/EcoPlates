import 'package:freezed_annotation/freezed_annotation.dart';

import 'food_offer.dart';

part 'sale.freezed.dart';
part 'sale.g.dart';

/// Statut d'une vente
enum SaleStatus {
  pending, // En attente de récupération
  confirmed, // Confirmée par le client
  collected, // Récupérée
  cancelled, // Annulée
  refunded, // Remboursée
}

/// Entité représentant une vente/commande
@freezed
abstract class Sale with _$Sale {
  const factory Sale({
    required String id,
    required String merchantId,
    required String customerId,
    required String customerName,
    required List<SaleItem> items,
    required double totalAmount,
    required double discountAmount,
    required double finalAmount,
    required DateTime createdAt,
    required DateTime? collectedAt,
    required SaleStatus status,
    required String paymentMethod,
    String? paymentTransactionId,
    String? qrCode, // Deprecated - use secureQrEnabled instead
    @Default(false) bool secureQrEnabled,
    String? totpSecretId,
    String? notes,
    Map<String, dynamic>? metadata,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

/// Item d'une vente
@freezed
abstract class SaleItem with _$SaleItem {
  const factory SaleItem({
    required String offerId,
    required String offerTitle,
    required FoodCategory category,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
  }) = _SaleItem;

  factory SaleItem.fromJson(Map<String, dynamic> json) =>
      _$SaleItemFromJson(json);
}

/// Extension pour les méthodes utilitaires
extension SaleExtensions on Sale {
  /// Vérifie si la vente est en cours
  bool get isActive =>
      status == SaleStatus.pending || status == SaleStatus.confirmed;

  /// Vérifie si la vente est terminée
  bool get isCompleted => status == SaleStatus.collected;

  /// Vérifie si la vente est annulée
  bool get isCancelled =>
      status == SaleStatus.cancelled || status == SaleStatus.refunded;

  /// Obtient le temps restant pour la récupération (si applicable)
  Duration? get remainingTime {
    if (!isActive) return null;

    // On suppose que le client a 2h pour récupérer sa commande
    final deadline = createdAt.add(const Duration(hours: 2));
    final now = DateTime.now();

    if (now.isAfter(deadline)) return Duration.zero;
    return deadline.difference(now);
  }

  /// Obtient le pourcentage d'économie réalisé
  double get savingsPercentage {
    if (totalAmount == 0) return 0;
    return (discountAmount / totalAmount * 100).roundToDouble();
  }
}

/// Extension pour formater le statut
extension SaleStatusExtensions on SaleStatus {
  String get label {
    switch (this) {
      case SaleStatus.pending:
        return 'En attente';
      case SaleStatus.confirmed:
        return 'Confirmée';
      case SaleStatus.collected:
        return 'Récupérée';
      case SaleStatus.cancelled:
        return 'Annulée';
      case SaleStatus.refunded:
        return 'Remboursée';
    }
  }

  /// Obtient la couleur associée au statut
  String get colorHex {
    switch (this) {
      case SaleStatus.pending:
        return '#FFA500'; // Orange
      case SaleStatus.confirmed:
        return '#4CAF50'; // Green
      case SaleStatus.collected:
        return '#2196F3'; // Blue
      case SaleStatus.cancelled:
        return '#F44336'; // Red
      case SaleStatus.refunded:
        return '#9C27B0'; // Purple
    }
  }
}
