/// Entité représentant une réservation d'offre anti-gaspillage
class Reservation {
  final String id;
  final String offerId;
  final String userId;
  final String merchantId;
  final DateTime reservedAt;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final ReservationStatus status;
  final String? cancellationReason;
  final DateTime? collectedAt;
  final String confirmationCode;
  final PaymentInfo? paymentInfo;
  final int quantity; // Nombre de paniers réservés
  
  const Reservation({
    required this.id,
    required this.offerId,
    required this.userId,
    required this.merchantId,
    required this.reservedAt,
    required this.pickupStartTime,
    required this.pickupEndTime,
    required this.status,
    this.cancellationReason,
    this.collectedAt,
    required this.confirmationCode,
    this.paymentInfo,
    this.quantity = 1,
  });
  
  /// Vérifie si la réservation est active
  bool get isActive => status == ReservationStatus.confirmed;
  
  /// Vérifie si on est dans la fenêtre de collecte
  bool get canCollect {
    if (status != ReservationStatus.confirmed) return false;
    final now = DateTime.now();
    return now.isAfter(pickupStartTime) && now.isBefore(pickupEndTime);
  }
  
  /// Temps restant avant expiration
  Duration get timeUntilExpiry => pickupEndTime.difference(DateTime.now());
  
  /// Vérifie si la réservation est expirée
  bool get isExpired {
    return status == ReservationStatus.confirmed && 
           DateTime.now().isAfter(pickupEndTime);
  }
}

/// Statut d'une réservation
enum ReservationStatus {
  pending,      // En attente de confirmation
  confirmed,    // Confirmée
  collected,    // Collectée
  cancelled,    // Annulée par l'utilisateur
  noShow,       // Non récupérée
  expired,      // Expirée
}

/// Informations de paiement
class PaymentInfo {
  final String paymentId;
  final PaymentMethod method;
  final double amount;
  final DateTime paidAt;
  final PaymentStatus status;
  
  const PaymentInfo({
    required this.paymentId,
    required this.method,
    required this.amount,
    required this.paidAt,
    required this.status,
  });
}

/// Méthodes de paiement
enum PaymentMethod {
  card,         // Carte bancaire
  paypal,       // PayPal
  applePay,     // Apple Pay
  googlePay,    // Google Pay
  free,         // Gratuit
  cash,         // Espèces (à la collecte)
}

/// Statut du paiement
enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  notRequired,  // Pour les offres gratuites
}