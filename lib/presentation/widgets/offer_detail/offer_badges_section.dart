import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/food_offer.dart';

/// Section des allergènes avec slider moderne
class OfferBadgesSection extends StatelessWidget {
  const OfferBadgesSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    // N'afficher que s'il y a des allergènes
    if (offer.allergens.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec icône moderne
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.sm,
                ),
              ),
              child: Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                size: EcoPlatesDesignTokens.size.indicator(context),
              ),
            ),
            SizedBox(width: context.scaleMD_LG_XL_XXL),
            Text(
              'Allergènes présents',
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.text(context),
                fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: context.scaleMD_LG_XL_XXL),

        // Slider horizontal des allergènes
        SizedBox(
          height: EcoPlatesDesignTokens.size.minTouchTarget,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offer.allergens.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: context.scaleXS_SM_MD_LG),
            itemBuilder: (context, index) {
              final allergen = offer.allergens[index];
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleMD_LG_XL_XXL,
                  vertical: context.scaleXS_SM_MD_LG,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xxl,
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.subtle,
                    ),
                    width: EcoPlatesDesignTokens.layout.cardBorderWidth,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info,
                      size: EcoPlatesDesignTokens.size.indicator(context),
                      color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                    ),
                    SizedBox(width: context.scaleXXS_XS_SM_MD),
                    Text(
                      allergen,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(
                              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                            ),
                        fontWeight: EcoPlatesDesignTokens.typography.medium,
                        fontSize: EcoPlatesDesignTokens.typography.hint(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
