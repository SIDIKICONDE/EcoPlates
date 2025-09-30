import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/sale.dart';
import '../../../providers/sales_provider.dart';
import '../../qr_code/qr_code_display_widget.dart';
import 'sale_details_modal.dart';

/// Utilitaires pour les actions de la carte de vente
class SaleCardActions {
  const SaleCardActions._();

  /// Affiche les détails de la vente dans une modal
  static void showSaleDetails(BuildContext context, Sale sale) {
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
              SaleDetailsModal(sale: sale, scrollController: scrollController),
        ),
      ),
    );
  }

  /// Affiche le QR code standard
  static void showQRCode(BuildContext context, Sale sale) {
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
                  border: Border.all(color: DeepColorTokens.neutral500),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(
                    Icons.qr_code,
                    size: 150.0,
                    color: DeepColorTokens.neutral500,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                sale.totpSecretId ?? 'QR Code',
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

  /// Affiche le QR code sécurisé
  static void showSecureQRCode(BuildContext context, Sale sale) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: DeepColorTokens.neutral0,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
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
                  margin: const EdgeInsets.only(top: 8.0),
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: DeepColorTokens.neutral400,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        QRCodeDisplayWidget(
                          orderId: sale.id,
                          size: 250.0,
                          onExpired: () {
                            // Vibration ou notification si disponible
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Informations de sécurité
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: DeepColorTokens.success.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: DeepColorTokens.success),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.security,
                                color: DeepColorTokens.success,
                                size: 24.0,
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'QR Code Sécurisé',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: DeepColorTokens.success,
                                      ),
                                    ),
                                    Text(
                                      "Ce code ne peut être utilisé qu'une seule fois",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: DeepColorTokens.success,
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

  /// Confirme une vente
  static void confirmSale(BuildContext context, WidgetRef ref, Sale sale) {
    unawaited(
      ref
          .read(salesProvider.notifier)
          .updateSaleStatus(sale.id, SaleStatus.confirmed),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vente confirmée')),
    );
  }

  /// Marque une vente comme récupérée
  static void collectSale(BuildContext context, WidgetRef ref, Sale sale) {
    unawaited(
      ref
          .read(salesProvider.notifier)
          .updateSaleStatus(sale.id, SaleStatus.collected),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Commande marquée comme récupérée'),
        backgroundColor: DeepColorTokens.success,
      ),
    );
  }
}
