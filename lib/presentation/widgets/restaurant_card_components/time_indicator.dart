import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Indicateur animé pour les offres urgentes
class TimeIndicator extends StatelessWidget {
  final int availableOffers;
  
  const TimeIndicator({
    super.key,
    required this.availableOffers,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: availableOffers <= 2 ? Colors.red : Colors.orange,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (availableOffers <= 2 ? Colors.red : Colors.orange)
                  .withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 2 * math.pi,
                  child: const Icon(
                    Icons.timer,
                    size: 14,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(width: 6),
            Text(
              availableOffers == 1
                  ? 'Dernière chance!'
                  : 'Plus que $availableOffers!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}