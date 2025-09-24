import 'package:flutter/material.dart';
import '../../../domain/entities/food_offer.dart';

/// Barre de réservation flottante en bas de l'écran
class OfferReservationBar extends StatelessWidget {
  final FoodOffer offer;
  final bool isReserving;
  final VoidCallback onReserve;

  const OfferReservationBar({
    super.key,
    required this.offer,
    required this.isReserving,
    required this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Bouton de réservation (plein largeur)
            Expanded(
              child: ElevatedButton(
                onPressed: offer.isAvailable && !isReserving ? onReserve : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isReserving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        offer.isFree
                            ? 'Réserver gratuitement'
                            : 'Réserver pour ${offer.discountedPrice.toStringAsFixed(2)}€',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
