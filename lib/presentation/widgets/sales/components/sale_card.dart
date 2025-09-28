import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/responsive/design_tokens.dart';
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
      borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
      child: Container(
        padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
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
                      SizedBox(height: context.scaleXXS_XS_SM_MD),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: EcoPlatesDesignTokens.size.indicator(context),
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: context.scaleXXS_XS_SM_MD),
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
                    horizontal: context.scaleXS_SM_MD_LG,
                    vertical: context.scaleXXS_XS_SM_MD,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.xxl,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: EcoPlatesDesignTokens.layout.statusDotSize,
                        height: EcoPlatesDesignTokens.layout.statusDotSize,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: context.scaleXXS_XS_SM_MD),
                      Text(
                        sale.status.label,
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: context.scaleSM_MD_LG_XL),

            // Articles
            ...sale.items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: context.scaleXXS_XS_SM_MD),
                child: Row(
                  children: [
                    Icon(
                      Categories.iconOf(item.category),
                      size: EcoPlatesDesignTokens.size.icon(context),
                      color: Categories.colorOf(item.category),
                    ),
                    SizedBox(width: context.scaleXXS_XS_SM_MD),
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

            Divider(height: context.scaleSM_MD_LG_XL),

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
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
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
                          iconSize: EcoPlatesDesignTokens.size.icon(context),
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
          margin: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  margin: EdgeInsets.only(top: context.scaleXXS_XS_SM_MD),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
                    child: Column(
                      children: [
                        QRCodeDisplayWidget(
                          orderId: _sale.id,
                          size: 250,
                          onExpired: () {
                            // Vibration ou notification si disponible
                          },
                        ),
                        SizedBox(height: context.scaleMD_LG_XL_XXL),
                        // Informations de sécurité
                        Container(
                          padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.md,
                            ),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.security,
                                color: Colors.green,
                                size: 32,
                              ),
                              SizedBox(width: context.scaleXS_SM_MD_LG),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'QR Code Sécurisé',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      "Ce code ne peut être utilisé qu'une seule fois",
                                      style: TextStyle(
                                        fontSize: EcoPlatesDesignTokens
                                            .typography
                                            .hint(context),
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Vente confirmée')));
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
