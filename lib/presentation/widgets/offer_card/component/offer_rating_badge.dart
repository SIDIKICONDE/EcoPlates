import 'package:flutter/material.dart';

/// Badge affichant le rating de l'enseigne avec étoiles
class OfferRatingBadge extends StatelessWidget {
  const OfferRatingBadge({required this.rating, super.key});
  final double rating;

  @override
  Widget build(BuildContext context) {
    // Version compacte du badge de rating
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 12.0,
            color: Colors.white,
          ),
          SizedBox(width: 2.0),
          Text(
            rating.toStringAsFixed(1),
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
