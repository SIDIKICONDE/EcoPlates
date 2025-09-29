import 'package:flutter/material.dart';

/// Badge affichant les informations diététiques (vegan, végétarien, halal)
class OfferDietBadge extends StatelessWidget {
  const OfferDietBadge({required this.label, required this.color, super.key});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
