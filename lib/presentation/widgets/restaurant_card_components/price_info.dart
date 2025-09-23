import 'package:flutter/material.dart';

/// Widget pour afficher les informations de prix
class PriceInfo extends StatelessWidget {
  final bool hasActiveOffer;
  final double? originalPrice;
  final double? discountedPrice;
  final double? minPrice;
  
  const PriceInfo({
    super.key,
    required this.hasActiveOffer,
    this.originalPrice,
    this.discountedPrice,
    this.minPrice,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasActiveOffer && originalPrice != null && discountedPrice != null) ...[
          Text(
            '${originalPrice!.toStringAsFixed(2)}€',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            '${discountedPrice!.toStringAsFixed(2)}€',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ] else if (minPrice != null)
          Text(
            'Dès ${minPrice!.toStringAsFixed(2)}€',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
      ],
    );
  }
}