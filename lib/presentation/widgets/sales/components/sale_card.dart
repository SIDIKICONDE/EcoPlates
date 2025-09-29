import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/categories.dart';
import '../../../../domain/entities/sale.dart';
import '../../../providers/sales_provider.dart';
import '../../qr_code/qr_code_display_widget.dart';
import 'sale_details_modal.dart';

/// Carte individuelle pour une vente
class SaleCard extends ConsumerWidget {
  const SaleCard({required Sale sale, super.key}) : _sale = sale;

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
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
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
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16.0,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 4.0),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        sale.status.label,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.0),

            // Articles
            ...sale.items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Categories.iconOf(item.category),
                      size: 16.0,
                      color: Categories.colorOf(item.category),
                    ),
                    SizedBox(width: 8.0),
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

            Divider(height: 12.0),

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
                          fontSize: 12.0,
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
                      if (sale.qrCode != null || sale.secureQrEnabled)
                        IconButton(
                          onPressed: () => sale.secureQrEnabled
                              ? _showSecureQRCode(context)
                              : _showQRCode(context),
                          icon: Icon(
                            sale.secureQrEnabled
                                ? Icons.qr_code_scanner
                                : Icons.qr_code,
                          ),
                          iconSize: 20.0,
                          tooltip: sale.secureQrEnabled
                              ? 'QR Code Sécurisé'
                              : 'Voir QR Code',
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
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) =>
              SaleDetailsModal(sale: _sale, scrollController: scrollController),
        ),
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Icon(Icons.qr_code, size: 150.0, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16.0),
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
      ),
    );
  }

  void _showSecureQRCode(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          margin: EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => Column(
              children: [
                // Handle
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        QRCodeDisplayWidget(
                          orderId: _sale.id,
                          size: 250.0,
                          onExpired: () {
                            // Vibration ou notification si disponible
                          },
                        ),
                        SizedBox(height: 16.0),
                        // Informations de sécurité
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.security,
                                color: Colors.green,
                                size: 24.0,
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'QR Code Sécurisé',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      "Ce code ne peut être utilisé qu'une seule fois",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmSale(BuildContext context, WidgetRef ref) {
    unawaited(
      ref
          .read(salesProvider.notifier)
          .updateSaleStatus(_sale.id, SaleStatus.confirmed),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vente confirmée')),
    );
  }

  void _collectSale(BuildContext context, WidgetRef ref) {
    unawaited(
      ref
          .read(salesProvider.notifier)
          .updateSaleStatus(_sale.id, SaleStatus.collected),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande marquée comme récupérée'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
