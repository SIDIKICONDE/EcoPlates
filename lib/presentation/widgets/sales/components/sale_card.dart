import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/sale.dart';
import 'sale_actions.dart';
import 'sale_card_actions.dart';
import 'sale_footer.dart';
import 'sale_header.dart';
import 'sale_items_list.dart';

/// Carte individuelle pour une vente
class SaleCard extends ConsumerWidget {
  const SaleCard({required Sale sale, super.key}) : _sale = sale;

  final Sale _sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sale = _sale;

    return InkWell(
      onTap: () => SaleCardActions.showSaleDetails(context, sale),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: DeepColorTokens.neutral50,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: DeepColorTokens.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header - Taille fixe
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: DeepColorTokens.neutral100,
                borderRadius: BorderRadius.zero, // Coins droits
                border: Border.all(
                  color: DeepColorTokens.neutral200.withValues(alpha: 0.5),
                  width: 0.5,
                ),
              ),
              child: SaleHeader(sale: sale),
            ),

            // Section Contenu Interne - 40% de l'espace disponible
            Expanded(
              flex: 4, // 40% (4/10)
              child: Container(
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(minHeight: 60.0),
                decoration: BoxDecoration(
                  color: DeepColorTokens
                      .neutral50, // Fond très clair au lieu de surface
                  borderRadius:
                      BorderRadius.zero, // Pas d'arrondi pour les bords
                  border: Border(
                    top: BorderSide(
                      color: DeepColorTokens.neutral200.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                    bottom: BorderSide(
                      color: DeepColorTokens.neutral200.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                ),
                child: SaleItemsList(items: sale.items),
              ),
            ),

            // Section Footer - Taille fixe avec style amélioré
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: DeepColorTokens.neutral100, // Même couleur que le header
                borderRadius: BorderRadius.zero, // Coins droits
                border: Border.all(
                  color: DeepColorTokens.neutral200.withValues(alpha: 0.5),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: DeepColorTokens.neutral200.withValues(alpha: 0.2),
                    blurRadius: 2.0,
                    offset: const Offset(0, -1), // Ombre vers le haut
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Prix
                  SaleFooter(sale: sale),
                  // Actions
                  SaleActions(
                    sale: sale,
                    onShowQRCode: () => sale.secureQrEnabled
                        ? SaleCardActions.showSecureQRCode(context, sale)
                        : SaleCardActions.showQRCode(context, sale),
                    onConfirmSale: () =>
                        SaleCardActions.confirmSale(context, ref, sale),
                    onCollectSale: () =>
                        SaleCardActions.collectSale(context, ref, sale),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
