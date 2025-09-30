import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_utils.dart';
import '../../domain/entities/food_offer.dart';
import '../providers/offer_reservation_provider.dart';

/// Indicateur de stock faible pour les offres urgentes
class LowStockIndicator extends StatelessWidget {
  const LowStockIndicator({
    required this.offer, super.key,
  });

  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing / 2,
        vertical: context.verticalSpacing / 4,
      ),
      decoration: BoxDecoration(
        color: offer.quantity == 1
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(context.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: context.borderRadius,
            offset: Offset(0, context.verticalSpacing / 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flash_on,
            color: Theme.of(context).colorScheme.onError,
            size: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
          ),
          SizedBox(width: context.horizontalSpacing / 4),
          Text(
            offer.quantity == 1
                ? 'Dernier disponible !'
                : 'Plus que ${offer.quantity} restants',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onError,
              fontWeight: FontWeight.bold,
              fontSize: FontSizes.caption.getSize(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton flottant d'ajout rapide au panier pour les offres urgentes
class QuickAddToCartButton extends ConsumerWidget {
  const QuickAddToCartButton({
    required this.offer, super.key,
  });

  final FoodOffer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: ResponsiveUtils.getIconSize(context, baseSize: 40.0),
      height: ResponsiveUtils.getIconSize(context, baseSize: 40.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: context.borderRadius,
            offset: Offset(0, context.verticalSpacing / 4),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.add_shopping_cart,
          color: Theme.of(context).colorScheme.onPrimary,
          size: ResponsiveUtils.getIconSize(context, baseSize: 20.0),
        ),
        onPressed: () async {
          try {
            await ref
                .read(offerReservationProvider.notifier)
                .reserve(offer: offer);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green.shade700,
                  content: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ajouté au panier !',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } on Exception catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red.shade700,
                  content: Text("Impossible d'ajouter au panier: $e"),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
