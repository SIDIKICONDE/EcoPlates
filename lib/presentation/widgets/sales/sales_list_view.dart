import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../domain/entities/sale.dart';
import '../../providers/sales_provider.dart';

/// Liste des ventes avec gestion des états de chargement
class SalesListView extends ConsumerWidget {
  const SalesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(salesProvider);

    return salesAsync.when(
      data: (sales) {
        if (sales.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune vente trouvée',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Modifiez vos filtres pour voir plus de résultats',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final sale = sales[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SaleCard(sale: sale),
            );
          }, childCount: sales.length),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(48),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => ref.read(salesProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Carte individuelle pour une vente
class _SaleCard extends ConsumerWidget {
  const _SaleCard({required Sale sale}) : _sale = sale;

  final Sale _sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sale = _sale;
    final theme = Theme.of(context);
    final statusColor = Color(
      int.parse(sale.status.colorHex.replaceAll('#', '0xFF')),
    );

    return InkWell(
      onTap: () => _showSaleDetails(context, ref),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec statut et heure
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Client et heure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sale.customerName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(sale.createdAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Statut
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        sale.status.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Articles
            ...sale.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Categories.iconOf(item.category),
                      size: 16,
                      color: Categories.colorOf(item.category),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.offerTitle}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      '${item.totalPrice.toStringAsFixed(2)}€',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 16),

            // Footer avec prix et actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Prix
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total: ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${sale.finalAmount.toStringAsFixed(2)}€',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    if (sale.discountAmount > 0)
                      Text(
                        'Économie: ${sale.discountAmount.toStringAsFixed(2)}€ (${sale.savingsPercentage.toStringAsFixed(0)}%)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                // Actions
                if (sale.isActive)
                  Row(
                    children: [
                      if (sale.qrCode != null)
                        IconButton(
                          onPressed: () => _showQRCode(context),
                          icon: const Icon(Icons.qr_code),
                          iconSize: 20,
                          tooltip: 'Voir QR Code',
                        ),
                      if (sale.status == SaleStatus.pending)
                        TextButton(
                          onPressed: () => _confirmSale(context, ref),
                          child: const Text('Confirmer'),
                        ),
                      if (sale.status == SaleStatus.confirmed)
                        TextButton(
                          onPressed: () => _collectSale(context, ref),
                          child: const Text('Récupéré'),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "À l'instant";
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month} à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showSaleDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) =>
            _SaleDetailsModal(sale: _sale, scrollController: scrollController),
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.qr_code, size: 150, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _sale.qrCode ?? 'QR Code',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _confirmSale(BuildContext context, WidgetRef ref) {
    ref
        .read(salesProvider.notifier)
        .updateSaleStatus(_sale.id, SaleStatus.confirmed);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Vente confirmée')));
  }

  void _collectSale(BuildContext context, WidgetRef ref) {
    ref
        .read(salesProvider.notifier)
        .updateSaleStatus(_sale.id, SaleStatus.collected);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande marquée comme récupérée'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

/// Modal de détails d'une vente
class _SaleDetailsModal extends StatelessWidget {
  const _SaleDetailsModal({
    required Sale sale,
    required ScrollController scrollController,
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
