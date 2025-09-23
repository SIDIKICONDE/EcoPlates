import 'package:flutter/material.dart';

/// Widget pour afficher la note avec des étoiles
class RatingDisplay extends StatelessWidget {
  final double rating;
  
  const RatingDisplay({
    super.key,
    required this.rating,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          final filled = index < rating.floor();
          return Icon(
            filled ? Icons.star : Icons.star_border,
            size: 12,
            color: Colors.amber,
          );
        }),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}