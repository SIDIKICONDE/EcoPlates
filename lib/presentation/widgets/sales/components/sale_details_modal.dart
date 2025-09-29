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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(10.0),
        children: [
          // Handle
          Center(
            child: Container(
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.15,
                ),
                borderRadius: BorderRadius.circular(
                  4.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),

          // En-tête - Layout horizontal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commande #${sale.id}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Client: ${sale.customerName}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
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

          const SizedBox(height: 10.0),

          // Articles détaillés
          Text(
            'Articles commandés',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 10.0),
          ...sale.items.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Categories.colorOf(
                    item.category,
                  ).withValues(alpha: 0.1),
                  child: Icon(
                    Categories.iconOf(item.category),
                    color: Categories.colorOf(item.category),
                    size: 20.0,
                  ),
                ),
                title: Text(
                  item.offerTitle,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                subtitle: Text(
                  '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                trailing: Text(
                  '${item.totalPrice.toStringAsFixed(2)}€',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10.0),

          // Détails financiers
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails du paiement',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  _buildDetailRow(
                    'Sous-total',
                    '${sale.totalAmount.toStringAsFixed(2)}€',
                    null,
                    false,
                    context,
                  ),
                  _buildDetailRow(
                    'Réduction',
                    '-${sale.discountAmount.toStringAsFixed(2)}€',
                    Colors.green,
                    false,
                    context,
                  ),
                  const Divider(height: 16),
                  _buildDetailRow(
                    'Total',
                    '${sale.finalAmount.toStringAsFixed(2)}€',
                    theme.colorScheme.primary,
                    true,
                    context,
                  ),
                  const SizedBox(height: 10.0),
                  _buildDetailRow(
                    'Méthode',
                    sale.paymentMethod,
                    null,
                    false,
                    context,
                  ),
                  if (sale.paymentTransactionId != null)
                    _buildDetailRow(
                      'Transaction',
                      sale.paymentTransactionId!,
                      null,
                      false,
                      context,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10.0),

          // Informations temporelles
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historique',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  _buildDetailRow(
                    'Commandé le',
                    '${sale.createdAt.day}/${sale.createdAt.month} à ${sale.createdAt.hour}:${sale.createdAt.minute.toString().padLeft(2, '0')}',
                    null,
                    false,
                    context,
                  ),
                  if (sale.collectedAt != null)
                    _buildDetailRow(
                      'Récupéré le',
                      '${sale.collectedAt!.day}/${sale.collectedAt!.month} à ${sale.collectedAt!.hour}:${sale.collectedAt!.minute.toString().padLeft(2, '0')}',
                      null,
                      false,
                      context,
                    ),
                  if (sale.remainingTime != null && sale.isActive)
                    _buildDetailRow(
                      'Temps restant',
                      _formatDuration(sale.remainingTime!),
                      sale.remainingTime!.inMinutes < 30 ? Colors.orange : null,
                      false,
                      context,
                    ),
                ],
              ),
            ),
          ),

          if (sale.notes != null) ...[
            const SizedBox(height: 10.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      sale.notes!,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
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
    BuildContext? context,
  ]) {
    final textStyle = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: valueColor,
      fontSize: context != null ? 14.0 : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: context != null ? 13.0 : null,
            ),
          ),
          Text(
            value,
            style: textStyle,
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
