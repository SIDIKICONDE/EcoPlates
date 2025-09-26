import 'package:flutter/material.dart';

import '../../../../core/constants/categories.dart';
import '../../../../domain/entities/sale.dart';

/// Modal de détails d'une vente
class SaleDetailsModal extends StatelessWidget {
  const SaleDetailsModal({
    required Sale sale,
    required ScrollController scrollController,
    super.key,
  }) : _sale = sale,
       _scrollController = scrollController;

  final Sale _sale;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final sale = _sale;
    final scrollController = _scrollController;
    final theme = Theme.of(context);
    final statusColor = Color(
      int.parse(sale.status.colorHex.replaceAll('#', '0xFF')),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // En-tête
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commande #${sale.id}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Client: ${sale.customerName}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  sale.status.label,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Articles détaillés
          Text(
            'Articles commandés',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...sale.items.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Categories.colorOf(
                    item.category,
                  ).withValues(alpha: 0.1),
                  child: Icon(
                    Categories.iconOf(item.category),
                    color: Categories.colorOf(item.category),
                    size: 20,
                  ),
                ),
                title: Text(item.offerTitle),
                subtitle: Text(
                  '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)}€',
                ),
                trailing: Text(
                  '${item.totalPrice.toStringAsFixed(2)}€',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Détails financiers
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails du paiement',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Sous-total',
                    '${sale.totalAmount.toStringAsFixed(2)}€',
                  ),
                  _buildDetailRow(
                    'Réduction',
                    '-${sale.discountAmount.toStringAsFixed(2)}€',
                    Colors.green,
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    'Total',
                    '${sale.finalAmount.toStringAsFixed(2)}€',
                    theme.colorScheme.primary,
                    true,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Méthode', sale.paymentMethod),
                  if (sale.paymentTransactionId != null)
                    _buildDetailRow('Transaction', sale.paymentTransactionId!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Informations temporelles
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historique',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Commandé le',
                    '${sale.createdAt.day}/${sale.createdAt.month} à ${sale.createdAt.hour}:${sale.createdAt.minute.toString().padLeft(2, '0')}',
                  ),
                  if (sale.collectedAt != null)
                    _buildDetailRow(
                      'Récupéré le',
                      '${sale.collectedAt!.day}/${sale.collectedAt!.month} à ${sale.collectedAt!.hour}:${sale.collectedAt!.minute.toString().padLeft(2, '0')}',
                    ),
                  if (sale.remainingTime != null && sale.isActive)
                    _buildDetailRow(
                      'Temps restant',
                      _formatDuration(sale.remainingTime!),
                      sale.remainingTime!.inMinutes < 30 ? Colors.orange : null,
                    ),
                ],
              ),
            ),
          ),

          if (sale.notes != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(sale.notes!),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, [
    Color? valueColor,
    bool bold = false,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}min';
    }
    return '${duration.inMinutes}min';
  }
}
