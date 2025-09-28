import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/food_offer.dart';

/// Barre de réservation flottante en bas de l'écran
class OfferReservationBar extends StatelessWidget {
  const OfferReservationBar({
    required this.offer,
    required this.isReserving,
    required this.onReserve,
    super.key,
  });
  final FoodOffer offer;
  final bool isReserving;
  final VoidCallback onReserve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Bouton de réservation (plein largeur)
            Expanded(
              child: ElevatedButton(
                onPressed: offer.isAvailable && !isReserving ? onReserve : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: context.scaleMD_LG_XL_XXL,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.lg,
                    ),
                  ),
                ),
                child: isReserving
                    ? SizedBox(
                        height: EcoPlatesDesignTokens.size.indicator(context),
                        width: EcoPlatesDesignTokens.size.indicator(context),
                        child: CircularProgressIndicator(
                          strokeWidth: EcoPlatesDesignTokens
                              .layout
                              .loadingIndicatorStrokeWidth,
                          color: EcoPlatesDesignTokens.colors.textPrimary,
                        ),
                      )
                    : Text(
                        offer.isFree
                            ? 'Réserver gratuitement'
                            : 'Réserver pour ${offer.discountedPrice.toStringAsFixed(2)}€',
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.text(
                            context,
                          ),
                          fontWeight: EcoPlatesDesignTokens.typography.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
