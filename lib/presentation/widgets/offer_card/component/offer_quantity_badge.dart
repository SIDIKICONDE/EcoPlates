import 'package:flutter/material.dart';

/// Badge affichant la quantité restante d'offres
class OfferQuantityBadge extends StatelessWidget {
  const OfferQuantityBadge({required this.quantity, super.key});
  final int quantity;

  @override
  Widget build(BuildContext context) {
    // Version ultra-compacte du badge
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2,
            size: 12.0,
            color: Colors.white,
          ),
          const SizedBox(width: 2.0),
          Text(
            '$quantity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
