import 'package:flutter/material.dart';

/// Badge affichant la quantité restante d'offres
class OfferQuantityBadge extends StatelessWidget {
  const OfferQuantityBadge({required this.quantity, super.key});
  final int quantity;

  @override
  Widget build(BuildContext context) {
    // Version ultra-compacte du badge
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2, color: Colors.white, size: 10),
          const SizedBox(width: 2),
          Text(
            '$quantity',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
