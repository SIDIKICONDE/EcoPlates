import 'package:flutter/material.dart';

import '../../../domain/entities/stock_item.dart';
import '../../pages/stock_item_form_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = compactMode ? 12.0 : 16.0;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: compactMode ? 8 : 12,
            vertical: compactMode ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(compactMode ? 12 : 16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: compactMode ? 4 : 8,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.02),
                blurRadius: compactMode ? 8 : 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(compactMode ? 12 : 16),
              child: AnimatedContainer(
                duration: showAnimations
                    ? const Duration(milliseconds: 200)
                    : Duration.zero,
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations principales de l'article
                    Expanded(child: _buildItemInfo(theme)),

                    SizedBox(width: compactMode ? 8 : 12),

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

  Widget _buildItemInfo(ThemeData theme) {
    final fontSize = compactMode ? 14.0 : 16.0;
    final smallFontSize = compactMode ? 10.0 : 12.0;
    final spacing = compactMode ? 2.0 : 4.0;

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

            // Badge rupture de stock avec animation
            if (item.isOutOfStock) ...[
              SizedBox(width: compactMode ? 4 : 8),
              AnimatedScale(
                scale: showAnimations ? 1.0 : 0.8,
                duration: showAnimations
                    ? const Duration(milliseconds: 300)
                    : Duration.zero,
                child: _buildOutOfStockBadge(theme),
              ),
            ],
          ],
        ),

        SizedBox(height: spacing),

        // SKU et catégorie avec amélioration visuelle
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: compactMode ? 4 : 6,
                vertical: compactMode ? 1 : 2,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(compactMode ? 4 : 6),
              ),
              child: Text(
                item.sku,
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(width: compactMode ? 6 : 12),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: compactMode ? 6 : 8,
                vertical: compactMode ? 2 : 3,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.2,
                ),
                borderRadius: BorderRadius.circular(compactMode ? 6 : 8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Text(
                item.category,
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: compactMode ? 4 : 8),

        // Prix et dernière mise à jour avec amélioration
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: compactMode ? 6 : 8,
                vertical: compactMode ? 2 : 4,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(compactMode ? 6 : 8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.formattedPrice,
                    style: TextStyle(
                      fontSize: compactMode ? 13 : 15,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  SizedBox(width: compactMode ? 2 : 4),
                  Text(
                    '/ ${item.unit}',
                    style: TextStyle(
                      fontSize: compactMode ? 10 : 12,
                      color: theme.colorScheme.onSecondaryContainer.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Indicateur de dernière mise à jour avec icône
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update,
                  size: compactMode ? 10 : 12,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
                SizedBox(width: compactMode ? 2 : 4),
                Text(
                  _formatLastUpdate(item.updatedAt),
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
          SizedBox(height: compactMode ? 4 : 6),
          AnimatedOpacity(
            opacity: showAnimations ? 0.8 : 1.0,
            duration: showAnimations
                ? const Duration(milliseconds: 400)
                : Duration.zero,
            child: Container(
              padding: EdgeInsets.all(compactMode ? 6 : 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.2,
                ),
                borderRadius: BorderRadius.circular(compactMode ? 6 : 8),
              ),
              child: Text(
                item.description!,
                style: TextStyle(
                  fontSize: compactMode ? 11 : 13,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                  height: 1.3,
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
              size: compactMode ? 18 : 20,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              // Navigation vers la page d'édition
              Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (context) => StockItemFormPage(item: item),
                ),
              );
            },
            tooltip: 'Modifier',
            constraints: BoxConstraints(
              minWidth: compactMode ? 32 : 40,
              minHeight: compactMode ? 32 : 40,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: 0.08,
              ),
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ),

        SizedBox(height: compactMode ? 4 : 8),

        // Toggle statut avec animation
        AnimatedScale(
          scale: showAnimations ? 1.0 : 0.95,
          duration: showAnimations
              ? const Duration(milliseconds: 200)
              : Duration.zero,
          child: StockStatusToggle(
            item: item,
            compactMode: compactMode,
            showLabel: !compactMode,
          ),
        ),

        SizedBox(height: compactMode ? 8 : 12),

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

  Widget _buildOutOfStockBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compactMode ? 6 : 8,
        vertical: compactMode ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(compactMode ? 8 : 12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.error.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_rounded,
            size: compactMode ? 12 : 14,
            color: theme.colorScheme.onErrorContainer,
          ),
          SizedBox(width: compactMode ? 3 : 4),
          Text(
            'Rupture',
            style: TextStyle(
              fontSize: compactMode ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
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
