import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';
import '../offer_card/offer_card_configs.dart';

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
            backgroundColor: DeepColorTokens.error,
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
    final canDecrease = widget.item.quantity > widget.minQuantity;
    final canIncrease = widget.item.quantity < widget.maxQuantity;

    if (widget.compactMode) {
      return _buildCompactAdjuster(context, canDecrease, canIncrease);
    } else {
      return _buildStandardAdjuster(context, canDecrease, canIncrease);
    }
  }

  Widget _buildStandardAdjuster(
    BuildContext context,
    bool canDecrease,
    bool canIncrease,
  ) {
    final config = OfferCardConfigs.defaultConfig;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: DeepColorTokens.neutral400.withValues(
            alpha: DeepColorTokens.opacity10,
          ),
        ),
        borderRadius: config.imageBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton diminuer
          IconButton(
            onPressed: canDecrease && !_isAdjusting
                ? () => _adjustQuantity(-widget.step)
                : null,
            icon: (widget.showLoading && _isAdjusting)
                ? SizedBox(
                    width: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
                    height: ResponsiveUtils.getIconSize(
                      context,
                      baseSize: 16.0,
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  )
                : Icon(Icons.remove),
            tooltip: 'Diminuer la quantité',
            style: IconButton.styleFrom(
              foregroundColor: canDecrease
                  ? DeepColorTokens.primary
                  : DeepColorTokens.neutral500.withValues(
                      alpha: DeepColorTokens.opacity10,
                    ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(context) / 2,
              ),
            ),
          ),

          // Affichage de la quantité et unité
          if (!widget.showLoading || !_isAdjusting)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.item.quantity.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      16.0,
                    ),
                    color: DeepColorTokens.neutral800,
                  ),
                ),
                Text(
                  widget.item.unit,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      16.0,
                    ),
                    color: DeepColorTokens.neutral600,
                  ),
                ),
              ],
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
                  ? DeepColorTokens.primary
                  : DeepColorTokens.neutral500.withValues(
                      alpha: DeepColorTokens.opacity10,
                    ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(context) / 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactAdjuster(
    BuildContext context,
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
              ResponsiveUtils.getVerticalSpacing(context),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: canDecrease
                    ? DeepColorTokens.secondaryContainer
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove,
                size: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
                color: canDecrease
                    ? DeepColorTokens.secondary
                    : DeepColorTokens.neutral500.withValues(
                        alpha: DeepColorTokens.opacity10,
                      ),
              ),
            ),
          ),
        ),

        // Quantité compacte
        if (widget.showLoading && _isAdjusting)
          SizedBox(
            width: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
            height: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getHorizontalSpacing(context) / 2,
            ),
            child: Text(
              widget.item.formattedQuantity,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
                color: DeepColorTokens.neutral800,
              ),
            ),
          ),

        // Bouton augmenter compact
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canIncrease && !_isAdjusting
                ? () => _adjustQuantity(widget.step)
                : null,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getVerticalSpacing(context),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: canIncrease
                    ? DeepColorTokens.secondaryContainer
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
                color: canIncrease
                    ? DeepColorTokens.secondary
                    : DeepColorTokens.neutral500.withValues(
                        alpha: DeepColorTokens.opacity10,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
