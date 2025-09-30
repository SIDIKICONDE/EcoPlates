import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget pour afficher le logo du restaurant avec badge de quantité disponible
class MerchantLogoWithBadge extends StatelessWidget {
  const MerchantLogoWithBadge({
    required this.merchantName,
    required this.availableQuantity,
    super.key,
  });

  final String merchantName;
  final int availableQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral0,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.shadowLight,
            blurRadius: 4.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Logo du restaurant (première lettre pour l'instant)
          Container(
            width: 60.0,
            height: 60.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DeepColorTokens.primaryLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              merchantName.isNotEmpty ? merchantName[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: DeepColorTokens.primary,
              ),
            ),
          ),

          // Badge de quantité disponible
          Positioned(
            top: -2.0,
            right: -2.0,
            child: Container(
              width: 20.0,
              height: 20.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: availableQuantity <= 3
                    ? DeepColorTokens.urgent
                    : DeepColorTokens.success,
                border: Border.all(
                  color: DeepColorTokens.neutral0,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                availableQuantity.toString(),
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: DeepColorTokens.neutral0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
