import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/promotion_service.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
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
    final hasPromotion = widget.offer.discountPercentage > 0;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.shadowLight,
            blurRadius: 8.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasPromotion ? Icons.local_offer : Icons.local_offer_outlined,
                color: hasPromotion
                    ? DeepColorTokens.primary
                    : DeepColorTokens.neutral600,
              ),
              SizedBox(width: 8.0),
              Text(
                hasPromotion ? 'Promotion active' : 'Ajouter une promotion',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: DeepColorTokens.neutral1000,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          // Prix actuel
          _buildPriceInfo(context),

          SizedBox(height: 16.0),

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
              fillColor: DeepColorTokens.neutral100,
            ),
            keyboardType: TextInputType.number,
            enabled: !_isLoading,
          ),

          const SizedBox(height: 16),

          // Aperçu du prix réduit
          if (_discountController.text.isNotEmpty) _buildPricePreview(context),

          SizedBox(height: 16.0),

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
                      foregroundColor: DeepColorTokens.error,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
              ],
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _applyPromotion,
                  icon: _isLoading
                      ? SizedBox(
                          width: 16.0,
                          height: 16.0,
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

  Widget _buildPriceInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.offer.title,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.neutral1000,
            ),
          ),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prix actuel',
                style: TextStyle(
                  fontSize: 12.0,
                  color: DeepColorTokens.neutral600,
                ),
              ),
              Text(
                '${widget.offer.discountedPrice.toStringAsFixed(2)}€',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: DeepColorTokens.primary,
                ),
              ),
            ],
          ),
          if (widget.offer.originalPrice != widget.offer.discountedPrice) ...[
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prix original',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: DeepColorTokens.neutral600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  '${widget.offer.originalPrice.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: DeepColorTokens.neutral600,
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

  Widget _buildPricePreview(BuildContext context) {
    final discountText = _discountController.text;
    if (discountText.isEmpty) return const SizedBox.shrink();

    final discount = double.tryParse(discountText);
    if (discount == null || discount <= 0 || discount > 90) {
      return Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: DeepColorTokens.errorContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.error_outline,
              color: DeepColorTokens.error,
              size: 16.0,
            ),
            SizedBox(width: 8.0),
            Text(
              'Pourcentage invalide (1-90%)',
              style: TextStyle(
                fontSize: 12.0,
                color: DeepColorTokens.error,
              ),
            ),
          ],
        ),
      );
    }

    final newPrice = widget.offer.originalPrice * (1 - discount / 100);
    final savings = widget.offer.originalPrice - newPrice;

    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.successContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aperçu avec ${discount.toStringAsFixed(0)}% de réduction',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: DeepColorTokens.success,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nouveau prix',
                style: TextStyle(
                  fontSize: 14.0,
                  color: DeepColorTokens.success,
                ),
              ),
              Text(
                '${newPrice.toStringAsFixed(2)}€',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: DeepColorTokens.success,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Économie',
                style: TextStyle(
                  fontSize: 12.0,
                  color: DeepColorTokens.success,
                ),
              ),
              Text(
                '${savings.toStringAsFixed(2)}€',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: DeepColorTokens.success,
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
          backgroundColor: DeepColorTokens.warning,
        ),
      );
      return;
    }

    final discount = double.tryParse(discountText);
    if (discount == null || discount <= 0 || discount > 90) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le pourcentage doit être entre 1 et 90'),
          backgroundColor: DeepColorTokens.error,
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
            backgroundColor: DeepColorTokens.success,
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'application de la promotion: $e"),
            backgroundColor: DeepColorTokens.error,
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
            backgroundColor: DeepColorTokens.success,
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression: $e'),
            backgroundColor: DeepColorTokens.error,
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
