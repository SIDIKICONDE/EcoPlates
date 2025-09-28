import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../providers/stock_items_provider.dart';

/// Widget affichant un résumé des alertes de stock
class StockAlertsSummary extends ConsumerWidget {
  const StockAlertsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lowStockItems = ref.watch(lowStockItemsProvider);
    final outOfStockItems = ref.watch(outOfStockItemsProvider);

    // Ne rien afficher s'il n'y a pas d'alertes
    if (lowStockItems.isEmpty && outOfStockItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.scaleMD_LG_XL_XXL,
        vertical: context.scaleSM_MD_LG_XL,
      ),
      padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: DesignConstants.opacitySubtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: DesignConstants.opacitySubtle,
          ),
          width: DesignConstants.zeroPointFive,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: context.scaleIconStandard,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: context.scaleSM_MD_LG_XL),
              Text(
                'Alertes de stock',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.modalContent(
                    context,
                  ),
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleXS_SM_MD_LG),

          Wrap(
            spacing: context.scaleXS_SM_MD_LG,
            runSpacing: context.scaleSM_MD_LG_XL,
            children: [
              if (outOfStockItems.isNotEmpty)
                _buildAlertChip(
                  context,
                  theme: theme,
                  count: outOfStockItems.length,
                  label: outOfStockItems.length == 1
                      ? 'article en rupture'
                      : 'articles en rupture',
                  color: theme.colorScheme.error,
                  icon: Icons.error_outline,
                ),

              if (lowStockItems.isNotEmpty)
                _buildAlertChip(
                  context,
                  theme: theme,
                  count: lowStockItems.length,
                  label: lowStockItems.length == 1
                      ? 'article stock faible'
                      : 'articles stock faible',
                  color: Colors.orange,
                  icon: Icons.warning_outlined,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertChip(
    BuildContext context, {
    required ThemeData theme,
    required int count,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXS_SM_MD_LG,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: DesignConstants.opacityVeryTransparent),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xxl),
        border: Border.all(
          color: color.withValues(alpha: DesignConstants.opacitySubtle),
          width: DesignConstants.zeroPointFive,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: context.scaleIconStandard,
            color: color,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),
          Text(
            '$count',
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.modalContent(context),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),
          Text(
            label,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
              color: color.withValues(
                alpha: DesignConstants.opacityAlmostOpaque,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
