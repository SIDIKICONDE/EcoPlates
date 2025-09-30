import 'package:flutter/material.dart';

import '../../../../domain/entities/sale.dart';

/// Actions disponibles pour une vente (QR code, confirmer, récupérer)
class SaleActions extends StatelessWidget {
  const SaleActions({
    required this.sale,
    required this.onShowQRCode,
    required this.onConfirmSale,
    required this.onCollectSale,
    super.key,
  });

  final Sale sale;
  final VoidCallback onShowQRCode;
  final VoidCallback onConfirmSale;
  final VoidCallback onCollectSale;

  @override
  Widget build(BuildContext context) {
    if (!sale.isActive) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (sale.secureQrEnabled)
          IconButton(
            onPressed: onShowQRCode,
            icon: Icon(
              sale.secureQrEnabled ? Icons.qr_code_scanner : Icons.qr_code,
            ),
            iconSize: 20.0,
            tooltip: sale.secureQrEnabled ? 'QR Code Sécurisé' : 'Voir QR Code',
          ),
        if (sale.status == SaleStatus.pending)
          TextButton(
            onPressed: onConfirmSale,
            child: const Text('Confirmer'),
          ),
        if (sale.status == SaleStatus.confirmed)
          TextButton(
            onPressed: onCollectSale,
            child: const Text('Récupéré'),
          ),
      ],
    );
  }
}
