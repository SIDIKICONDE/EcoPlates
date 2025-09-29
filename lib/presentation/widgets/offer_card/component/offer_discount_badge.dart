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
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: isFree ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFree ? Icons.card_giftcard : Icons.discount,
            size: 13.0,
            color: Colors.white,
          ),
          const SizedBox(width: 4.0),
          Text(
            discountBadge,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
