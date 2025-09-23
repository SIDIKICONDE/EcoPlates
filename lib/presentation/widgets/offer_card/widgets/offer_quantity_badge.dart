import 'package:flutter/material.dart';

/// Badge affichant la quantité restante d'offres
class OfferQuantityBadge extends StatelessWidget {
  final int quantity;
  
  const OfferQuantityBadge({
    super.key,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$quantity restant${quantity > 1 ? 's' : ''}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}