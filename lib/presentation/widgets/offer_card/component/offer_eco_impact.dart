import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

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
          size: EcoPlatesDesignTokens.size.indicator(context),
          color: EcoPlatesDesignTokens.colors.snackbarSuccess,
        ),
        SizedBox(width: context.scaleXXS_XS_SM_MD),
        Text(
          '${(co2Saved / 1000).toStringAsFixed(1)} kg CO₂ économisés',
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.hint(context),
            color: EcoPlatesDesignTokens.colors.snackbarSuccess,
            fontWeight: EcoPlatesDesignTokens.typography.medium,
          ),
        ),
      ],
    );
  }
}
