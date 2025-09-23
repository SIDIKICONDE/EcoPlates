import 'package:flutter/material.dart';

/// Widget affichant l'impact écologique de l'offre
class OfferEcoImpact extends StatelessWidget {
  final int co2Saved; // en grammes
  
  const OfferEcoImpact({
    super.key,
    required this.co2Saved,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.eco, size: 16, color: Colors.green[600]),
        const SizedBox(width: 4),
        Text(
          '${(co2Saved / 1000).toStringAsFixed(1)} kg CO₂ économisés',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}