import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_utils.dart';

/// Badge indiquant si une marque est premium ou nouvelle
class BrandPremiumBadge extends StatelessWidget {
  const BrandPremiumBadge({
    required this.isPremium,
    required this.isNew,
    super.key,
  });

  final bool isPremium;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    // N'affiche rien si ni premium ni nouveau
    if (!isPremium && !isNew) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top:
          ResponsiveUtils.getHorizontalSpacing(context) *
          0.5, // Offset responsive basé sur l'espacement horizontal
      right: ResponsiveUtils.getHorizontalSpacing(context) * 0.5,
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveUtils.getBorderRadius(context) * 0.125,
        ), // Padding basé sur le border radius
        decoration: BoxDecoration(
          color: isPremium ? Colors.amber.shade100 : Colors.green.shade100,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white),
        ),
        child: Icon(
          isPremium ? Icons.star : Icons.new_releases,
          size:
              FontSizes.caption.getSize(context) *
              1.67, // Taille proportionnelle à la police caption
          color: isPremium ? Colors.amber.shade700 : Colors.green.shade700,
        ),
      ),
    );
  }
}
