import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_utils.dart';

/// Ligne affichant les statistiques de la marque (offres actives et réduction moyenne)
class BrandStatsRow extends StatelessWidget {
  const BrandStatsRow({
    required this.activeOffers,
    required this.averageDiscount,
    super.key,
  });

  final int activeOffers;
  final double averageDiscount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Badge des offres
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getHorizontalSpacing(context) * 0.33,
            vertical: ResponsiveUtils.getVerticalSpacing(context) * 0.17,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getBorderRadius(context) * 0.75,
            ),
          ),
          child: Text(
            '$activeOffers offres',
            style: TextStyle(
              fontSize: FontSizes.caption.getSize(context),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: ResponsiveUtils.getHorizontalSpacing(context) * 0.33),
        // Badge de réduction
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getHorizontalSpacing(context) * 0.25,
            vertical: ResponsiveUtils.getVerticalSpacing(context) * 0.08,
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getBorderRadius(context) * 0.5,
            ),
          ),
          child: Text(
            '${averageDiscount.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: FontSizes.caption.getSize(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
        // Icône flèche
        Icon(
          Icons.arrow_forward_ios,
          size: FontSizes.caption.getSize(context) * 1.33,
          color: Colors.white,
        ),
      ],
    );
  }
}
