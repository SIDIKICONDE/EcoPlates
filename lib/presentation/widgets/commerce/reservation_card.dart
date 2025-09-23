import 'package:flutter/material.dart';
import '../../../domain/entities/reservation.dart';

/// Widget de carte pour afficher une réservation
class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final bool isHistory;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const ReservationCard({
    super.key,
    required this.reservation,
    this.isHistory = false,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec statut
              Row(
                children: [
                  _buildStatusIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Réservation #${reservation.id.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusText(),
                          style: TextStyle(
                            fontSize: 14,
                            color: _getStatusColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isHistory &&
                      reservation.status == ReservationStatus.confirmed)
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: onCancel,
                      color: Colors.orange,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Informations de collecte
              if (!isHistory &&
                  reservation.status == ReservationStatus.confirmed) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 20,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatPickupTime(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (reservation.canCollect) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '✓ Prêt à collecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ] else if (reservation.timeUntilExpiry.isNegative) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Expiré',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Code de confirmation
              if (!isHistory &&
                  reservation.status == ReservationStatus.confirmed)
                Row(
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Code: ${reservation.confirmationCode}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.qr_code, size: 20, color: Colors.grey[600]),
                  ],
                ),

              // Informations de paiement
              if (reservation.paymentInfo != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _getPaymentIcon(reservation.paymentInfo!.method),
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reservation.paymentInfo!.amount == 0
                          ? 'Gratuit'
                          : '${reservation.paymentInfo!.amount.toStringAsFixed(2)}€',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    if (reservation.quantity > 1) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'x${reservation.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              // Date pour l'historique
              if (isHistory) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(reservation.reservedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (reservation.status) {
      case ReservationStatus.confirmed:
        icon = Icons.schedule;
        color = Colors.blue;
        break;
      case ReservationStatus.collected:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case ReservationStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.orange;
        break;
      case ReservationStatus.noShow:
        icon = Icons.error;
        color = Colors.red;
        break;
      default:
        icon = Icons.pending;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _getStatusText() {
    switch (reservation.status) {
      case ReservationStatus.confirmed:
        return 'À récupérer';
      case ReservationStatus.collected:
        return 'Collectée';
      case ReservationStatus.cancelled:
        return 'Annulée';
      case ReservationStatus.noShow:
        return 'Non récupérée';
      default:
        return 'En attente';
    }
  }

  Color _getStatusColor() {
    switch (reservation.status) {
      case ReservationStatus.confirmed:
        return Colors.blue;
      case ReservationStatus.collected:
        return Colors.green;
      case ReservationStatus.cancelled:
        return Colors.orange;
      case ReservationStatus.noShow:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.paypal:
        return Icons.payment;
      case PaymentMethod.applePay:
        return Icons.apple;
      case PaymentMethod.googlePay:
        return Icons.g_mobiledata;
      case PaymentMethod.free:
        return Icons.card_giftcard;
      case PaymentMethod.cash:
        return Icons.payments;
    }
  }

  String _formatPickupTime() {
    final start = reservation.pickupStartTime;
    final end = reservation.pickupEndTime;
    final now = DateTime.now();

    String day;
    if (start.day == now.day) {
      day = "Aujourd'hui";
    } else if (start.day == now.day + 1) {
      day = 'Demain';
    } else {
      day = '${start.day}/${start.month}';
    }

    return '$day ${start.hour.toString().padLeft(2, '0')}h${start.minute.toString().padLeft(2, '0')} - '
        '${end.hour.toString().padLeft(2, '0')}h${end.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui à ${date.hour.toString().padLeft(2, '0')}h${date.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return 'Hier à ${date.hour.toString().padLeft(2, '0')}h${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
