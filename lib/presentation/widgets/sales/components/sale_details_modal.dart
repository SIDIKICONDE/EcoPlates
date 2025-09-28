import 'package:flutter/material.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/responsive/responsive.dart';
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
          top: Radius.circular(EcoPlatesDesignTokens.radius.lg),
        ),
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
        children: [
          // Handle
          Center(
            child: Container(
              width: EcoPlatesDesignTokens.layout.modalHandleWidth,
              height: EcoPlatesDesignTokens.layout.modalHandleHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: DesignConstants.opacitySubtle,
                ),
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.xs,
                ),
              ),
            ),
          ),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // En-tête - Responsive
          if (context.isMobileDevice)
            // Layout vertical pour mobiles
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commande #${sale.id}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: EcoPlatesDesignTokens.typography.modalTitle(
                          context,
                        ),
                      ),
                    ),
                    SizedBox(height: context.scaleXS_SM_MD_LG),
                    Text(
                      'Client: ${sale.customerName}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: EcoPlatesDesignTokens.typography.modalContent(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.scaleXS_SM_MD_LG),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleSM_MD_LG_XL,
                      vertical: context.scaleXS_SM_MD_LG,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(
                        alpha: DesignConstants.opacityVeryTransparent,
                      ),
                      borderRadius: BorderRadius.circular(
                        EcoPlatesDesignTokens.radius.xxl,
                      ),
                    ),
                    child: Text(
                      sale.status.label,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: EcoPlatesDesignTokens.typography.button(
                          context,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            // Layout horizontal pour tablettes et desktops
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
                      SizedBox(height: context.scaleXS_SM_MD_LG),
                      Text(
                        'Client: ${sale.customerName}',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleMD_LG_XL_XXL,
                    vertical: context.scaleXS_SM_MD_LG,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(
                      alpha: DesignConstants.opacityVeryTransparent,
                    ),
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.xxl,
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

          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // Articles détaillés
          Text(
            'Articles commandés',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: EcoPlatesDesignTokens.typography.modalSubtitle(context),
            ),
          ),
          SizedBox(height: context.scaleXS_SM_MD_LG),
          ...sale.items.map(
            (item) => Card(
              margin: EdgeInsets.only(bottom: context.scaleXS_SM_MD_LG),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Categories.colorOf(
                    item.category,
                  ).withValues(alpha: DesignConstants.opacityVeryTransparent),
                  child: Icon(
                    Categories.iconOf(item.category),
                    color: Categories.colorOf(item.category),
                    size: context.scaleIconStandard,
                  ),
                ),
                title: Text(
                  item.offerTitle,
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.modalContent(
                      context,
                    ),
                  ),
                ),
                subtitle: Text(
                  '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  ),
                ),
                trailing: Text(
                  '${item.totalPrice.toStringAsFixed(2)}€',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: EcoPlatesDesignTokens.typography.modalContent(
                      context,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: context.scaleSM_MD_LG_XL),

          // Détails financiers
          Card(
            child: Padding(
              padding: EdgeInsets.all(context.scaleSM_MD_LG_XL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails du paiement',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: EcoPlatesDesignTokens.typography.modalSubtitle(
                        context,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleXS_SM_MD_LG),
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
                  SizedBox(height: context.scaleXS_SM_MD_LG),
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

          SizedBox(height: context.scaleSM_MD_LG_XL),

          // Informations temporelles
          Card(
            child: Padding(
              padding: EdgeInsets.all(context.scaleSM_MD_LG_XL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historique',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: EcoPlatesDesignTokens.typography.modalSubtitle(
                        context,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaleXS_SM_MD_LG),
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
            SizedBox(height: context.scaleSM_MD_LG_XL),
            Card(
              child: Padding(
                padding: EdgeInsets.all(context.scaleSM_MD_LG_XL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: EcoPlatesDesignTokens.typography
                            .modalSubtitle(context),
                      ),
                    ),
                    SizedBox(height: context.scaleXS_SM_MD_LG),
                    Text(
                      sale.notes!,
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.modalContent(
                          context,
                        ),
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
      fontSize: context != null
          ? EcoPlatesDesignTokens.typography.modalContent(context)
          : null,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context?.scaleXXS_XS_SM_MD ?? 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: context != null
                  ? EcoPlatesDesignTokens.typography.modalContent(context)
                  : null,
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
