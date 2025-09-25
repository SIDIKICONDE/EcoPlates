import 'package:flutter/material.dart';

/// Widget affichant les informations de prix de l'offre
class OfferPriceInfo extends StatelessWidget {
  const OfferPriceInfo({
    required this.isFree,
    required this.originalPrice,
    required this.priceText,
    required this.primaryColor,
    super.key,
  });
  final bool isFree;
  final double originalPrice;
  final String priceText;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFree) ...[
          Text(
            '€${originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          priceText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isFree ? Colors.green : primaryColor,
          ),
        ),
      ],
    );
  }
}
