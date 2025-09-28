import 'package:flutter/material.dart';

import '../../../../core/responsive/design_tokens.dart';

/// Badge affichant les informations diététiques (vegan, végétarien, halal)
class OfferDietBadge extends StatelessWidget {
  const OfferDietBadge({required this.label, required this.color, super.key});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXS_SM_MD_LG,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: EcoPlatesDesignTokens.opacity.verySubtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        border: Border.all(
          color: color.withValues(alpha: EcoPlatesDesignTokens.opacity.subtle),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: EcoPlatesDesignTokens.typography.hint(context),
          color: color,
          fontWeight: EcoPlatesDesignTokens.typography.semiBold,
        ),
      ),
    );
  }
}
