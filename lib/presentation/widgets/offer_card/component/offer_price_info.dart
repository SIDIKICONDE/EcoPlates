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
              fontSize: 12.0,
              decoration: TextDecoration.lineThrough,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 4.0),
        ],
        Text(
          priceText,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: isFree ? Colors.green : primaryColor,
          ),
        ),
      ],
    );
  }
}
