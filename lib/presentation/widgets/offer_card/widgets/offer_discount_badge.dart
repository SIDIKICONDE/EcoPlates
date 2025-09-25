import 'package:flutter/material.dart';

/// Badge affichant la réduction sur l'offre
class OfferDiscountBadge extends StatelessWidget {
  const OfferDiscountBadge({
    required this.isFree,
    required this.discountBadge,
    super.key,
  });
  final bool isFree;
  final String discountBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isFree ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        discountBadge,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
