import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/food_offer.dart';

/// Section dédiée à l'adresse de récupération
class OfferAddressSection extends StatelessWidget {
  const OfferAddressSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.disabled,
          ),
          width: EcoPlatesDesignTokens.layout.cardBorderWidth,
        ),
      ),
      padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adresse principale avec icône simple
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                size: EcoPlatesDesignTokens.size.indicator(context),
              ),
              SizedBox(width: context.scaleXS_SM_MD_LG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.location.address,
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.text(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
                    Text(
                      '${offer.location.postalCode} ${offer.location.city}',
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.hint(
                          context,
                        ),
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(
                              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                            ),
                      ),
                    ),
                    SizedBox(height: context.scaleXXS_XS_SM_MD),
                    GestureDetector(
                      onTap: () {
                        // Navigation vers le profil du marchand
                        final merchantId = offer.merchantId;
                        debugPrint(
                          '🔗 Navigation vers profil marchand: $merchantId',
                        );

                        try {
                          unawaited(
                            context.push('/merchant-profile/$merchantId'),
                          );
                        } on Exception catch (e) {
                          debugPrint('❌ Erreur navigation: $e');
                          // Fallback: afficher un message ou naviguer vers une page d'erreur
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Impossible d'ouvrir le profil du marchand",
                              ),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Plus d'informations sur le marchand",
                            style: TextStyle(
                              fontSize: EcoPlatesDesignTokens.typography.hint(
                                context,
                              ),
                              color: Theme.of(context).colorScheme.primary,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(width: context.scaleXXS_XS_SM_MD),
                          Icon(
                            Icons.arrow_forward_ios,
                            size:
                                EcoPlatesDesignTokens.size.indicator(context) /
                                2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
