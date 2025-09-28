import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';

/// Widget pour ajuster la quantité d'un article avec des boutons +/-
///
/// Affiche la quantité actuelle et des boutons pour l'augmenter ou la diminuer.
/// Utilise des mises à jour optimistes pour une meilleure réactivité.
class StockQuantityAdjuster extends ConsumerStatefulWidget {
  const StockQuantityAdjuster({
    required this.item,
    super.key,
    this.minQuantity = 0,
    this.maxQuantity = 999999,
    this.step = 1,
    this.compactMode = false,
    this.showLoading = false,
  });

  /// Article dont on ajuste la quantité
  final StockItem item;

  /// Quantité minimum (par défaut 0)
  final int minQuantity;

  /// Quantité maximum (par défaut 999999)
  final int maxQuantity;

  /// Pas d'ajustement (par défaut 1)
  final int step;

  /// Mode compact (boutons plus petits)
  final bool compactMode;

  /// Afficher un indicateur de chargement animé pendant l'ajustement
  final bool showLoading;

  @override
  ConsumerState<StockQuantityAdjuster> createState() =>
      _StockQuantityAdjusterState();
}

class _StockQuantityAdjusterState extends ConsumerState<StockQuantityAdjuster> {
  bool _isAdjusting = false;

  /// Ajuste la quantité avec gestion d'erreur et timeout de sécurité
  Future<void> _adjustQuantity(int delta) async {
    if (_isAdjusting) return;

    setState(() {
      _isAdjusting = true;
    });

    try {
      // Timeout de sécurité de 1 seconde maximum
      await ref
          .read(stockItemsProvider.notifier)
          .adjustQuantity(widget.item.id, delta)
          .timeout(
            const Duration(seconds: 1),
            onTimeout: () {
              throw Exception(
                "Délai d'attente dépassé pour l'ajustement de quantité",
              );
            },
          );
    } on Exception catch (error) {
      if (mounted) {
        // Affiche un snackbar en cas d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(StockErrorMessages.getErrorMessage(error)),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      // Garantit que le flag se remet toujours à false
      if (mounted) {
        setState(() {
          _isAdjusting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDecrease = widget.item.quantity > widget.minQuantity;
    final canIncrease = widget.item.quantity < widget.maxQuantity;

    if (widget.compactMode) {
      return _buildCompactAdjuster(context, theme, canDecrease, canIncrease);
    } else {
      return _buildStandardAdjuster(context, theme, canDecrease, canIncrease);
    }
  }

  Widget _buildStandardAdjuster(
    BuildContext context,
    ThemeData theme,
    bool canDecrease,
    bool canIncrease,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton diminuer
          IconButton(
            onPressed: canDecrease && !_isAdjusting
                ? () => _adjustQuantity(-widget.step)
                : null,
            icon: const Icon(Icons.remove),
            tooltip: 'Diminuer la quantité',
            style: IconButton.styleFrom(
              foregroundColor: canDecrease
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.subtle,
                    ),
            ),
          ),

          // Affichage de la quantité
          Container(
            constraints: BoxConstraints(
              minWidth: EcoPlatesDesignTokens.size.minTouchTarget * 1.5,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: context.scaleXXS_XS_SM_MD,
            ),
            child: (widget.showLoading && _isAdjusting)
                ? SizedBox(
                    width: EcoPlatesDesignTokens.size.icon(context),
                    height: EcoPlatesDesignTokens.size.icon(context),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.quantity.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: EcoPlatesDesignTokens.typography.titleSize(
                            context,
                          ),
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        widget.item.unit,
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          ),

          // Bouton augmenter
          IconButton(
            onPressed: canIncrease && !_isAdjusting
                ? () => _adjustQuantity(widget.step)
                : null,
            icon: const Icon(Icons.add),
            tooltip: 'Augmenter la quantité',
            style: IconButton.styleFrom(
              foregroundColor: canIncrease
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.subtle,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactAdjuster(
    BuildContext context,
    ThemeData theme,
    bool canDecrease,
    bool canIncrease,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton diminuer compact
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canDecrease && !_isAdjusting
                ? () => _adjustQuantity(-widget.step)
                : null,
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.xl,
            ),
            child: Container(
              width: EcoPlatesDesignTokens.size.minTouchTarget,
              height: EcoPlatesDesignTokens.size.minTouchTarget,
              decoration: BoxDecoration(
                color: canDecrease
                    ? theme.colorScheme.secondaryContainer.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.pressed,
                      )
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove,
                size: EcoPlatesDesignTokens.size.icon(context),
                color: canDecrease
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.subtle,
                      ),
              ),
            ),
          ),
        ),

        SizedBox(width: context.scaleXXS_XS_SM_MD),

        // Quantité compacte
        if (widget.showLoading && _isAdjusting)
          SizedBox(
            width: EcoPlatesDesignTokens.size.icon(context),
            height: EcoPlatesDesignTokens.size.icon(context),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: theme.colorScheme.primary,
            ),
          )
        else
          Text(
            widget.item.formattedQuantity,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              color: theme.colorScheme.onSurface,
            ),
          ),

        SizedBox(width: context.scaleXXS_XS_SM_MD),

        // Bouton augmenter compact
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canIncrease && !_isAdjusting
                ? () => _adjustQuantity(widget.step)
                : null,
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.xl,
            ),
            child: Container(
              width: EcoPlatesDesignTokens.size.minTouchTarget,
              height: EcoPlatesDesignTokens.size.minTouchTarget,
              decoration: BoxDecoration(
                color: canIncrease
                    ? theme.colorScheme.secondaryContainer.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.pressed,
                      )
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: EcoPlatesDesignTokens.size.icon(context),
                color: canIncrease
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.subtle,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
