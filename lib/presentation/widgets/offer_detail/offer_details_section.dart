import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/utils/offer_formatters.dart';
import '../../../domain/entities/food_offer.dart';

/// Section des informations pratiques pour la récupération
class OfferDetailsSection extends StatelessWidget {
  const OfferDetailsSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          Text(
            'Infos pratiques',
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
              fontWeight: EcoPlatesDesignTokens.typography.bold,
            ),
          ),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // Horaire de récupération
          _buildCompactInfo(
            context: context,
            icon: Icons.access_time_filled,
            label: 'À récupérer',
            value: OfferFormatters.formatPickupTime(offer),
            iconColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfo({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: EcoPlatesDesignTokens.size.indicator(context),
        ),
        SizedBox(width: context.scaleXS_SM_MD_LG),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.text(context),
                  fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
