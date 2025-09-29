import 'package:flutter/material.dart';

/// Widget pour afficher la note avec des étoiles accessibles WCAG
class RatingDisplay extends StatelessWidget {
  const RatingDisplay({required this.rating, super.key});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final starCount = rating.floor();
    final halfStar = rating - starCount >= 0.5;

    return Semantics(
      label: 'Noté ${rating.toStringAsFixed(1)} sur 5 étoiles',
      child: Row(
        children: [
          ...List.generate(5, (index) {
            if (index < starCount) {
              return Icon(
                Icons.star,
                size: 16.0,
                color: Colors.amber,
                semanticLabel: '',
              );
            } else if (index == starCount && halfStar) {
              return Icon(
                Icons.star_half,
                size: 16.0,
                color: Colors.amber,
                semanticLabel: '',
              );
            } else {
              return Icon(
                Icons.star_border,
                size: 16.0,
                color: Colors.amber.withValues(alpha: 0.25),
                semanticLabel: '',
              );
            }
          }),
          SizedBox(width: 4.0),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.amber,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
