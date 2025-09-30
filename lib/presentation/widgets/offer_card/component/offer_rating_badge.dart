import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Badge affichant le rating de l'enseigne avec étoiles
class OfferRatingBadge extends StatelessWidget {
  const OfferRatingBadge({required this.rating, super.key});
  final double rating;

  @override
  Widget build(BuildContext context) {
    // Version compacte du badge de rating
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral0,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: DeepColorTokens.success),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 12.0,
            color: DeepColorTokens.success,
          ),
          const SizedBox(width: 2.0),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: DeepColorTokens.success,
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
