import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget affichant l'impact écologique de l'offre
class OfferEcoImpact extends StatelessWidget {
  // en grammes

  const OfferEcoImpact({required this.co2Saved, super.key});
  final int co2Saved;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.eco,
          size: 13.0,
          color: DeepColorTokens.success,
        ),
        const SizedBox(width: 4.0),
        Text(
          '${(co2Saved / 1000).toStringAsFixed(1)} kg CO₂ économisés',
          style: TextStyle(
            fontSize: 12.0,
            color: DeepColorTokens.success,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
