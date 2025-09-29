

import 'package:flutter/material.dart';

/// Widget affichant une ligne de séparation élégante pour les cartes d'offre
/// Utilise un design moderne avec gradient et effets visuels raffinés
class OfferCardSeparator extends StatelessWidget {
  const OfferCardSeparator({
    super.key,
    this.compact = false,
  });

  /// Mode compact pour réduire la hauteur
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: compact ? 8.0 : 12.0,
      padding: EdgeInsets.symmetric(horizontal: compact ? 8.0 : 12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ombre subtile en arrière-plan
          Positioned(
            top: 2,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    if (isDark)
                      Colors.white.withValues(alpha: 0.1)
                    else
                      Colors.black.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Ligne principale avec gradient
          Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  if (isDark) Colors.white.withValues(alpha: 0.4) else Colors.grey.shade400,
                  if (isDark) Colors.white.withValues(alpha: 0.6) else Colors.grey.shade300,
                  if (isDark) Colors.white.withValues(alpha: 0.4) else Colors.grey.shade400,
                  Colors.transparent,
                  if (isDark) Colors.white.withValues(alpha: 0.6) else Colors.grey.shade300,
                  if (isDark) Colors.white.withValues(alpha: 0.4) else Colors.grey.shade400,
                  Colors.transparent,
                  isDark
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.grey.shade300,
                  isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.grey.shade400,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
              ),
              borderRadius: BorderRadius.circular(0.75),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade400.withValues(alpha: 0.3),
                  blurRadius: 2,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 0.5),
                ),
              ],
            ),
          ),
          // Points décoratifs aux extrémités (optionnel, seulement en mode normal)
          if (!compact) ...[
            Positioned(
              left: 0,
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      isDark
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.grey.shade400,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      isDark
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.grey.shade400,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
