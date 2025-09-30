import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/stock_item.dart';
import '../../pages/stock_item_form/page.dart';
import '../offer_card/offer_card_configs.dart';
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
    final config = OfferCardConfigs.defaultConfig;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: dense
                ? ResponsiveUtils.getHorizontalSpacing(context) / 4
                : ResponsiveUtils.getHorizontalSpacing(context) / 2,
            vertical: dense
                ? ResponsiveUtils.getVerticalSpacing(context) / 8
                : ResponsiveUtils.getVerticalSpacing(context) / 4,
          ),
          decoration: BoxDecoration(
            color: DeepColorTokens.neutral0,
            borderRadius:
                config.imageBorderRadius ??
                BorderRadius.circular(
                  ResponsiveUtils.getVerticalSpacing(context),
                ),
            border: Border.all(
              color: DeepColorTokens.neutral300.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              borderRadius:
                  config.imageBorderRadius ??
                  BorderRadius.circular(
                    ResponsiveUtils.getVerticalSpacing(context),
                  ),
              child: AnimatedContainer(
                duration: showAnimations
                    ? const Duration(milliseconds: 200)
                    : Duration.zero,
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(
                  dense
                      ? ResponsiveUtils.getVerticalSpacing(context) / 8
                      : ResponsiveUtils.getVerticalSpacing(context) / 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations principales de l'article
                    Expanded(child: _buildItemInfo(context)),

                    SizedBox(
                      width: ResponsiveUtils.getHorizontalSpacing(context) / 4,
                    ),

                    // Contrôles (quantité et statut)
                    _buildItemControls(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemInfo(BuildContext context) {
    final fontSize = ResponsiveUtils.getResponsiveFontSize(context, 16.0);
    final smallFontSize = ResponsiveUtils.getResponsiveFontSize(context, 12.0);
    final spacing = ResponsiveUtils.getVerticalSpacing(context) / 4;

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
                  color: DeepColorTokens.neutral900,
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
              width: ResponsiveUtils.getHorizontalSpacing(context) / 4,
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
          spacing: ResponsiveUtils.getHorizontalSpacing(context) / 4,
          runSpacing: ResponsiveUtils.getVerticalSpacing(context) / 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(context) / 8,
                vertical: ResponsiveUtils.getVerticalSpacing(context) / 16,
              ),
              decoration: BoxDecoration(
                color: DeepColorTokens.neutral100.withValues(
                  alpha: 0.6,
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getVerticalSpacing(context) / 4,
                ),
              ),
              child: Text(
                item.sku,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: DeepColorTokens.neutral600,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(context) / 6,
                vertical: ResponsiveUtils.getVerticalSpacing(context) / 12,
              ),
              decoration: BoxDecoration(
                color: DeepColorTokens.primaryContainer.withValues(
                  alpha: 0.15,
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getVerticalSpacing(context) / 2,
                ),
                border: Border.all(
                  color: DeepColorTokens.primary.withValues(
                    alpha: 0.2,
                  ),
                  width: 0.25,
                ),
              ),
              child: Text(
                item.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: DeepColorTokens.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: spacing),

        // Prix et dernière mise à jour avec amélioration
        Wrap(
          spacing: ResponsiveUtils.getHorizontalSpacing(context) / 3,
          runSpacing: ResponsiveUtils.getVerticalSpacing(context) / 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(context) / 6,
                vertical: ResponsiveUtils.getVerticalSpacing(context) / 8,
              ),
              decoration: BoxDecoration(
                color: DeepColorTokens.secondaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getVerticalSpacing(context) / 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.formattedPrice,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        14.0,
                      ),
                      fontWeight: FontWeight.w700,
                      color: DeepColorTokens.neutral900,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.getHorizontalSpacing(context) / 8,
                  ),
                  Text(
                    '/ ${item.unit}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        12.0,
                      ),
                      color: DeepColorTokens.neutral600,
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
                  size: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
                  color: DeepColorTokens.neutral600.withValues(
                    alpha: 0.8,
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.getHorizontalSpacing(context) / 8,
                ),
                Text(
                  _formatLastUpdate(item.updatedAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: DeepColorTokens.neutral600.withValues(
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
          SizedBox(height: spacing),
          AnimatedOpacity(
            opacity: showAnimations ? 0.9 : 1.0,
            duration: showAnimations
                ? const Duration(milliseconds: 400)
                : Duration.zero,
            child: Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.getVerticalSpacing(context) / 8,
              ),
              decoration: BoxDecoration(
                color: DeepColorTokens.neutral100.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getVerticalSpacing(context) / 2,
                ),
              ),
              child: Text(
                item.description!,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    12.0,
                  ),
                  color: DeepColorTokens.neutral700,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
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

  Widget _buildItemControls(BuildContext context) {
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
              size: ResponsiveUtils.getIconSize(context, baseSize: 18.0),
              color: DeepColorTokens.primary,
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
              minWidth: ResponsiveUtils.getIconSize(context, baseSize: 48.0),
              minHeight: ResponsiveUtils.getIconSize(context, baseSize: 48.0),
            ),
            style: IconButton.styleFrom(
              backgroundColor: DeepColorTokens.primary.withValues(
                alpha: 0.1,
              ),
              foregroundColor: DeepColorTokens.primary,
            ),
          ),
        ),

        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) / 4),

        // Toggle statut sans animation
        StockStatusToggle(
          item: item,
          compactMode: compactMode,
          showLabel: !compactMode,
        ),

        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) / 4),

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
