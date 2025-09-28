import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/services/promotion_service.dart';
import '../../../domain/entities/food_offer.dart';

/// Widget pour gérer les promotions d'une offre individuelle
class OfferPromotionManager extends ConsumerStatefulWidget {
  const OfferPromotionManager({
    required this.offer,
    this.onPromotionUpdated,
    super.key,
  });

  final FoodOffer offer;
  final VoidCallback? onPromotionUpdated;

  @override
  ConsumerState<OfferPromotionManager> createState() =>
      _OfferPromotionManagerState();
}

class _OfferPromotionManagerState extends ConsumerState<OfferPromotionManager> {
  final _discountController = TextEditingController();
  bool _isLoading = false;
  final _promotionService = PromotionService();

  @override
  void initState() {
    super.initState();
    if (widget.offer.discountPercentage > 0) {
      _discountController.text = widget.offer.discountPercentage
          .toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPromotion = widget.offer.discountPercentage > 0;

    return Container(
      padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasPromotion ? Icons.local_offer : Icons.local_offer_outlined,
                color: hasPromotion
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: context.scaleXXS_XS_SM_MD),
              Text(
                hasPromotion ? 'Promotion active' : 'Ajouter une promotion',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // Prix actuel
          _buildPriceInfo(context, theme),

          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // Champ de réduction
          TextFormField(
            controller: _discountController,
            decoration: InputDecoration(
              labelText: 'Pourcentage de réduction (%)',
              hintText: hasPromotion
                  ? widget.offer.discountPercentage.toStringAsFixed(0)
                  : 'Ex: 20',
              prefixIcon: const Icon(Icons.percent),
              suffixText: '%',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
            ),
            keyboardType: TextInputType.number,
            enabled: !_isLoading,
          ),

          const SizedBox(height: 16),

          // Aperçu du prix réduit
          if (_discountController.text.isNotEmpty)
            _buildPricePreview(context, theme),

          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // Boutons d'action
          Row(
            children: [
              if (hasPromotion) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _removePromotion,
                    icon: const Icon(Icons.clear),
                    label: const Text('Supprimer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                ),
                SizedBox(width: context.scaleXXS_XS_SM_MD),
              ],
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _applyPromotion,
                  icon: _isLoading
                      ? SizedBox(
                          width: EcoPlatesDesignTokens.size.icon(context),
                          height: EcoPlatesDesignTokens.size.icon(context),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(hasPromotion ? 'Modifier' : 'Appliquer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(
          alpha: EcoPlatesDesignTokens.opacity.subtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.offer.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prix actuel',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${widget.offer.discountedPrice.toStringAsFixed(2)}€',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if (widget.offer.originalPrice != widget.offer.discountedPrice) ...[
            SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prix original',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  '${widget.offer.originalPrice.toStringAsFixed(2)}€',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricePreview(BuildContext context, ThemeData theme) {
    final discountText = _discountController.text;
    if (discountText.isEmpty) return const SizedBox.shrink();

    final discount = double.tryParse(discountText);
    if (discount == null || discount <= 0 || discount > 90) {
      return Container(
        padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xs),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning,
              size: EcoPlatesDesignTokens.size.icon(context),
              color: theme.colorScheme.onErrorContainer,
            ),
            SizedBox(width: context.scaleXXS_XS_SM_MD),
            Text(
              'Pourcentage invalide (1-90%)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      );
    }

    final newPrice = widget.offer.originalPrice * (1 - discount / 100);
    final savings = widget.offer.originalPrice - newPrice;

    return Container(
      padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(
          alpha: EcoPlatesDesignTokens.opacity.subtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aperçu avec ${discount.toStringAsFixed(0)}% de réduction',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          SizedBox(height: context.scaleXXS_XS_SM_MD),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nouveau prix',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              Text(
                '${newPrice.toStringAsFixed(2)}€',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Économie',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              Text(
                '${savings.toStringAsFixed(2)}€',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _applyPromotion() async {
    final discountText = _discountController.text;
    if (discountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un pourcentage de réduction'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final discount = double.tryParse(discountText);
    if (discount == null || discount <= 0 || discount > 90) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le pourcentage doit être entre 1 et 90'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _promotionService.applyOfferPromotion(
        offerId: widget.offer.id,
        discountPercentage: discount,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(
          const Duration(days: 7),
        ), // TODO: Configurable
      );

      widget.onPromotionUpdated?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Promotion de ${discount.toStringAsFixed(0)}% appliquée !',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'application de la promotion: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _removePromotion() async {
    setState(() => _isLoading = true);

    try {
      await _promotionService.removeOfferPromotion(widget.offer.id);

      _discountController.clear();
      widget.onPromotionUpdated?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Promotion supprimée'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
