import 'package:flutter/material.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              merchantName.isNotEmpty ? merchantName[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
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
                color: availableQuantity <= 3 ? Colors.red : Colors.green,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                availableQuantity.toString(),
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
