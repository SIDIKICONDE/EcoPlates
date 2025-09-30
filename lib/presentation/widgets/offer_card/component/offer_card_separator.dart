import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';

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
                    const Color(0x00000000),
                    if (isDark)
                      DeepColorTokens.neutral0.withValues(alpha: 0.1)
                    else
                      DeepColorTokens.neutral1000.withValues(alpha: 0.1),
                    const Color(0x00000000),
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
                  const Color(0x00000000), // Transparent
                  isDark
                      ? DeepColorTokens.success.withValues(alpha: 0.12)
                      : DeepColorTokens.success.withValues(alpha: 0.06),
                  isDark
                      ? DeepColorTokens.neutral500.withValues(alpha: 0.8)
                      : DeepColorTokens.neutral300.withValues(alpha: 0.7),
                  isDark
                      ? DeepColorTokens.success.withValues(alpha: 0.12)
                      : DeepColorTokens.success.withValues(alpha: 0.06),
                  const Color(0x00000000), // Transparent
                ],
                stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
              ),
              borderRadius: BorderRadius.circular(0.75),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? DeepColorTokens.neutral0.withValues(alpha: 0.1)
                      : DeepColorTokens.neutral400.withValues(alpha: 0.3),
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
                      const Color(0x00000000),
                      isDark
                          ? DeepColorTokens.neutral0.withValues(alpha: 0.3)
                          : DeepColorTokens.neutral400,
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
                      const Color(0x00000000),
                      isDark
                          ? DeepColorTokens.neutral0.withValues(alpha: 0.3)
                          : DeepColorTokens.neutral400,
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
