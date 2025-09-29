import 'package:flutter/material.dart';

import '../../../domain/entities/food_offer.dart';

/// Barre de réservation flottante en bas de l'écran
class OfferReservationBar extends StatelessWidget {
  const OfferReservationBar({
    required this.offer,
    required this.isReserving,
    required this.onReserve,
    super.key,
  });
  final FoodOffer offer;
  final bool isReserving;
  final VoidCallback onReserve;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0.0, -2.0),
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
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: isReserving
                    ? SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Réserver',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
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
