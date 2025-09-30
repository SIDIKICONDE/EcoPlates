import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Badge affichant la réduction sur l'offre
class OfferDiscountBadge extends StatelessWidget {
  const OfferDiscountBadge({
    required this.isFree,
    required this.discountBadge,
    super.key,
  });
  final bool isFree;
  final String discountBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: isFree ? DeepColorTokens.success : DeepColorTokens.urgent,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.26),
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFree ? Icons.card_giftcard : Icons.discount,
            size: 13.0,
            color: DeepColorTokens.neutral0,
          ),
          const SizedBox(width: 4.0),
          Text(
            discountBadge,
            style: TextStyle(
              color: DeepColorTokens.neutral0,
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
