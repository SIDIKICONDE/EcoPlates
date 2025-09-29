import 'package:flutter/material.dart';

/// Widget pour afficher les informations de prix
class PriceInfo extends StatelessWidget {
  const PriceInfo({
    required this.hasActiveOffer,
    super.key,
    this.originalPrice,
    this.discountedPrice,
    this.minPrice,
  });
  final bool hasActiveOffer;
  final double? originalPrice;
  final double? discountedPrice;
  final double? minPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasActiveOffer &&
            originalPrice != null &&
            discountedPrice != null) ...[
          Text(
            '${originalPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: 12.0,
            ),
          ),
          Text(
            '${discountedPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ] else if (minPrice != null) ...[
          Text(
            'Dès ${minPrice!.toStringAsFixed(2)}€',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.0,
            ),
          ),
        ],
      ],
    );
  }
}
