import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/stock_item.dart';
import '../../pages/stock_item_form/page.dart';
import 'stock_alert_badge.dart';
import 'stock_quantity_adjuster.dart';
import 'stock_status_toggle.dart';

/// Widget représentant une ligne d'article dans la liste de stock
///
/// Affiche toutes les informations d'un article avec les contrôles
/// pour ajuster la quantité et basculer le statut.
/// Optimisé pour Material 3 et Cupertino avec animations fluides.
class StockListItem extends StatelessWidget {
  const StockListItem({
    required this.item,
    super.key,
    this.onTap,
    this.showDivider = true,
    this.showAnimations = true,
    this.compactMode = false,
    this.dense = false,
  });

  /// Article à afficher
  final StockItem item;

  /// Callback lors du tap sur l'item
  final VoidCallback? onTap;

  /// Affiche un diviseur en bas de l'item
  final bool showDivider;

  /// Active les animations et transitions
  final bool showAnimations;

  /// Mode compact pour affichage réduit
  final bool compactMode;

  /// Mode dense pour écrans très étroits (paddings/tailles réduits)
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: dense
                ? (compactMode
                      ? context.scaleXXS_XS_SM_MD
                      : context.scaleXS_SM_MD_LG)
                : (compactMode
                      ? context.scaleXS_SM_MD_LG
                      : context.scaleSM_MD_LG_XL),
            vertical: dense
                ? (compactMode
                      ? context.scaleXXS_XS_SM_MD / 2
                      : context.scaleXXS_XS_SM_MD)
                : (compactMode
                      ? context.scaleXXS_XS_SM_MD
                      : context.scaleXS_SM_MD_LG),
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              dense
                  ? (compactMode
                        ? EcoPlatesDesignTokens.radius.sm
                        : EcoPlatesDesignTokens.radius.md)
                  : (compactMode
                        ? EcoPlatesDesignTokens.radius.md
                        : EcoPlatesDesignTokens.radius.lg),
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                ),
                blurRadius: dense
                    ? (compactMode
                          ? EcoPlatesDesignTokens.elevation.smallBlur
                          : EcoPlatesDesignTokens.elevation.mediumBlur)
                    : (compactMode
                          ? EcoPlatesDesignTokens.elevation.mediumBlur
                          : EcoPlatesDesignTokens.elevation.largeBlur),
                offset: EcoPlatesDesignTokens.elevation.standardOffset,
              ),
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                ),
                blurRadius: dense
                    ? (compactMode
                          ? EcoPlatesDesignTokens.elevation.mediumBlur
                          : EcoPlatesDesignTokens.elevation.largeBlur)
                    : (compactMode
                          ? EcoPlatesDesignTokens.elevation.largeBlur
                          : EcoPlatesDesignTokens.elevation.largeBlur * 2),
                offset: EcoPlatesDesignTokens.elevation.elevatedOffset,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(
                compactMode
                    ? EcoPlatesDesignTokens.radius.md
                    : EcoPlatesDesignTokens.radius.lg,
              ),
              child: AnimatedContainer(
                duration: showAnimations
                    ? const Duration(milliseconds: 200)
                    : Duration.zero,
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(
                  dense
                      ? (compactMode
                            ? context.scaleXS_SM_MD_LG
                            : context.scaleSM_MD_LG_XL)
                      : (compactMode
                            ? context.scaleSM_MD_LG_XL
                            : context.scaleMD_LG_XL_XXL),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations principales de l'article
                    Expanded(child: _buildItemInfo(context, theme)),

                    SizedBox(
                      width: dense
                          ? (compactMode
                                ? context.scaleXXS_XS_SM_MD
                                : context.scaleXS_SM_MD_LG)
                          : (compactMode
                                ? context.scaleXXS_XS_SM_MD
                                : context.scaleXS_SM_MD_LG),
                    ),

                    // Contrôles (quantité et statut)
                    _buildItemControls(context, theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemInfo(BuildContext context, ThemeData theme) {
    final fontSize = dense
        ? (compactMode
              ? EcoPlatesDesignTokens.typography.hint(context)
              : EcoPlatesDesignTokens.typography.text(context))
        : (compactMode
              ? EcoPlatesDesignTokens.typography.text(context)
              : EcoPlatesDesignTokens.typography.titleSize(context));
    final smallFontSize = dense
        ? (compactMode
              ? EcoPlatesDesignTokens.typography.hint(context) - 2
              : EcoPlatesDesignTokens.typography.hint(context))
        : (compactMode
              ? EcoPlatesDesignTokens.typography.hint(context)
              : EcoPlatesDesignTokens.typography.text(context));
    final spacing = dense
        ? (compactMode
              ? context.scaleXXS_XS_SM_MD / 4
              : context.scaleXXS_XS_SM_MD / 2)
        : (compactMode
              ? context.scaleXXS_XS_SM_MD / 2
              : context.scaleXXS_XS_SM_MD);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom et badges avec animation
        Row(
          children: [
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: showAnimations
                    ? const Duration(milliseconds: 200)
                    : Duration.zero,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                child: Text(
                  item.name,
                  maxLines: compactMode ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Badge d'alerte avec animation
            SizedBox(
              width: dense
                  ? (compactMode
                        ? context.scaleXXS_XS_SM_MD / 2
                        : context.scaleXXS_XS_SM_MD)
                  : (compactMode
                        ? context.scaleXXS_XS_SM_MD
                        : context.scaleXS_SM_MD_LG),
            ),
            AnimatedScale(
              scale: showAnimations ? 1.0 : 0.8,
              duration: showAnimations
                  ? const Duration(milliseconds: 300)
                  : Duration.zero,
              child: StockAlertBadge(
                alertLevel: item.alertLevel,
                showLabel: !compactMode,
                compact: compactMode || dense,
              ),
            ),
          ],
        ),

        SizedBox(height: spacing),

        // SKU et catégorie avec amélioration visuelle
        Wrap(
          spacing: compactMode
              ? context.scaleXXS_XS_SM_MD
              : context.scaleXS_SM_MD_LG,
          runSpacing: compactMode
              ? context.scaleXXS_XS_SM_MD
              : context.scaleXXS_XS_SM_MD,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: compactMode
                    ? context.scaleXXS_XS_SM_MD
                    : context.scaleXXS_XS_SM_MD,
                vertical: compactMode
                    ? context.scaleXXS_XS_SM_MD / 4
                    : context.scaleXXS_XS_SM_MD / 2,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                borderRadius: BorderRadius.circular(
                  compactMode
                      ? EcoPlatesDesignTokens.radius.xs
                      : EcoPlatesDesignTokens.radius.sm,
                ),
              ),
              child: Text(
                item.sku,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: compactMode
                    ? context.scaleXXS_XS_SM_MD
                    : context.scaleXS_SM_MD_LG,
                vertical: compactMode
                    ? context.scaleXXS_XS_SM_MD / 2
                    : context.scaleXXS_XS_SM_MD / 4 * 3,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                ),
                borderRadius: BorderRadius.circular(
                  compactMode
                      ? EcoPlatesDesignTokens.radius.sm
                      : EcoPlatesDesignTokens.radius.md,
                ),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                  ),
                  width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
                ),
              ),
              child: Text(
                item.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: dense
              ? (compactMode
                    ? context.scaleXXS_XS_SM_MD / 2
                    : context.scaleXXS_XS_SM_MD)
              : (compactMode
                    ? context.scaleXXS_XS_SM_MD
                    : context.scaleXS_SM_MD_LG),
        ),

        // Prix et dernière mise à jour avec amélioration
        Wrap(
          spacing: compactMode
              ? context.scaleXS_SM_MD_LG
              : context.scaleSM_MD_LG_XL,
          runSpacing: compactMode
              ? context.scaleXXS_XS_SM_MD
              : context.scaleXXS_XS_SM_MD,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: compactMode
                    ? context.scaleXXS_XS_SM_MD
                    : context.scaleXS_SM_MD_LG,
                vertical: compactMode
                    ? context.scaleXXS_XS_SM_MD / 2
                    : context.scaleXXS_XS_SM_MD,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                borderRadius: BorderRadius.circular(
                  compactMode
                      ? EcoPlatesDesignTokens.radius.sm
                      : EcoPlatesDesignTokens.radius.md,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.formattedPrice,
                    style: TextStyle(
                      fontSize: compactMode
                          ? EcoPlatesDesignTokens.typography.hint(context)
                          : EcoPlatesDesignTokens.typography.text(context),
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  SizedBox(
                    width: compactMode
                        ? context.scaleXXS_XS_SM_MD / 2
                        : context.scaleXXS_XS_SM_MD,
                  ),
                  Text(
                    '/ ${item.unit}',
                    style: TextStyle(
                      fontSize: compactMode
                          ? EcoPlatesDesignTokens.typography.hint(context) - 2
                          : EcoPlatesDesignTokens.typography.hint(context),
                      color: theme.colorScheme.onSecondaryContainer.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Indicateur de dernière mise à jour avec icône
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update,
                  size: compactMode
                      ? EcoPlatesDesignTokens.size.indicator(context)
                      : EcoPlatesDesignTokens.size.icon(context),
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                  ),
                ),
                SizedBox(
                  width: compactMode
                      ? context.scaleXXS_XS_SM_MD / 2
                      : context.scaleXXS_XS_SM_MD,
                ),
                Text(
                  _formatLastUpdate(item.updatedAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Description optionnelle avec animation
        if (item.description?.isNotEmpty ?? false) ...[
          SizedBox(
            height: dense
                ? (compactMode
                      ? context.scaleXXS_XS_SM_MD / 2
                      : context.scaleXXS_XS_SM_MD / 4 * 5)
                : (compactMode
                      ? context.scaleXXS_XS_SM_MD
                      : context.scaleXXS_XS_SM_MD / 4 * 6),
          ),
          AnimatedOpacity(
            opacity: showAnimations
                ? EcoPlatesDesignTokens.opacity.almostOpaque
                : 1.0,
            duration: showAnimations
                ? const Duration(milliseconds: 400)
                : Duration.zero,
            child: Container(
              padding: EdgeInsets.all(
                compactMode
                    ? context.scaleXXS_XS_SM_MD
                    : context.scaleXS_SM_MD_LG,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                ),
                borderRadius: BorderRadius.circular(
                  compactMode
                      ? EcoPlatesDesignTokens.radius.sm
                      : EcoPlatesDesignTokens.radius.md,
                ),
              ),
              child: Text(
                item.description!,
                style: TextStyle(
                  fontSize: compactMode
                      ? EcoPlatesDesignTokens.typography.hint(context)
                      : EcoPlatesDesignTokens.typography.text(context),
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                  height: EcoPlatesDesignTokens.layout.textLineHeight,
                ),
                maxLines: compactMode ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildItemControls(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton d'édition
        AnimatedScale(
          scale: showAnimations ? 1.0 : 0.95,
          duration: showAnimations
              ? const Duration(milliseconds: 150)
              : Duration.zero,
          child: IconButton(
            icon: Icon(
              Icons.edit_outlined,
              size: dense
                  ? (compactMode
                        ? EcoPlatesDesignTokens.size.icon(context) - 4
                        : EcoPlatesDesignTokens.size.icon(context) - 2)
                  : (compactMode
                        ? EcoPlatesDesignTokens.size.icon(context) - 2
                        : EcoPlatesDesignTokens.size.icon(context)),
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              // Navigation vers la page d'édition
              unawaited(
                Navigator.of(context).push(
                  MaterialPageRoute<Widget>(
                    builder: (context) => StockItemFormPage(item: item),
                  ),
                ),
              );
            },
            tooltip: 'Modifier',
            constraints: BoxConstraints(
              minWidth: dense
                  ? (compactMode
                        ? EcoPlatesDesignTokens.size.minTouchTarget / 2
                        : EcoPlatesDesignTokens.size.minTouchTarget / 4 * 3)
                  : (compactMode
                        ? EcoPlatesDesignTokens.size.minTouchTarget / 4 * 3
                        : EcoPlatesDesignTokens.size.minTouchTarget),
              minHeight: dense
                  ? (compactMode
                        ? EcoPlatesDesignTokens.size.minTouchTarget / 2
                        : EcoPlatesDesignTokens.size.minTouchTarget / 4 * 3)
                  : (compactMode
                        ? EcoPlatesDesignTokens.size.minTouchTarget / 4 * 3
                        : EcoPlatesDesignTokens.size.minTouchTarget),
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
              ),
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ),

        SizedBox(
          height: compactMode
              ? context.scaleXXS_XS_SM_MD
              : context.scaleXS_SM_MD_LG,
        ),

        // Toggle statut sans animation
        StockStatusToggle(
          item: item,
          compactMode: compactMode,
          showLabel: !compactMode,
        ),

        SizedBox(
          height: compactMode
              ? context.scaleXS_SM_MD_LG
              : context.scaleSM_MD_LG_XL,
        ),

        // Ajusteur de quantité avec animation
        AnimatedScale(
          scale: showAnimations ? 1.0 : 0.95,
          duration: showAnimations
              ? const Duration(milliseconds: 250)
              : Duration.zero,
          child: StockQuantityAdjuster(item: item, compactMode: compactMode),
        ),
      ],
    );
  }

  /// Formate la date de dernière mise à jour
  String _formatLastUpdate(DateTime updatedAt) {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inMinutes < 1) {
      return "À l'instant";
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
    }
  }
}
