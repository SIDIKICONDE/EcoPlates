import 'package:flutter/material.dart';

/// Badge affichant le rating de l'enseigne avec étoiles
class OfferRatingBadge extends StatelessWidget {
  final double rating;
  
  const OfferRatingBadge({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    // Version compacte du badge de rating
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 10,
          ),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}