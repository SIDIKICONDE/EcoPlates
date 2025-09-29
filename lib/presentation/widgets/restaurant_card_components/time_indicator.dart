import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Indicateur animé pour les offres urgentes
class TimeIndicator extends StatefulWidget {
  const TimeIndicator({required this.availableOffers, super.key});
  final int availableOffers;

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8.0,
      right: 8.0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: widget.availableOffers <= 2
                    ? Colors.red.shade600
                    : Colors.orange.shade600,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color:
                        (widget.availableOffers <= 2
                                ? Colors.red
                                : Colors.orange)
                            .withValues(alpha: 0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    size: 16.0,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    widget.availableOffers == 1
                        ? 'Dernière chance!'
                        : 'Plus que ${widget.availableOffers}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
