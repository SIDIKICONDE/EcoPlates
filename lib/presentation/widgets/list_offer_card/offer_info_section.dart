import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';

/// Widget pour afficher les informations détaillées d'une offre
class OfferInfoSection extends StatelessWidget {
  const OfferInfoSection({
    required this.merchantName,
    required this.title,
    required this.priceText,
    required this.isFree,
    required this.pickupTime,
    required this.distance,
    super.key,
  });

  final String merchantName;
  final String title;
  final String priceText;
  final bool isFree;
  final String pickupTime;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nom du restaurant
          Text(
            merchantName,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
              fontWeight: EcoPlatesDesignTokens.typography.semiBold,
              color: EcoPlatesDesignTokens.colors.textPrimary,
              shadows: [
                Shadow(
                  blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

          // Titre de l'offre
          Text(
            title,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              color: EcoPlatesDesignTokens.colors.textPrimary.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
              shadows: [
                Shadow(
                  blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: context.scaleXXS_XS_SM_MD),

          // Stats Row
          Row(
            children: [
              // Prix
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleXS_SM_MD_LG,
                  vertical: context.scaleXXS_XS_SM_MD / 2,
                ),
                decoration: BoxDecoration(
                  color: isFree
                      ? EcoPlatesDesignTokens.colors.snackbarSuccess
                      : EcoPlatesDesignTokens.colors.textPrimary.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.sm,
                  ),
                  border: Border.all(
                    color: EcoPlatesDesignTokens.colors.textPrimary.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.subtle,
                    ),
                    width: EcoPlatesDesignTokens.layout.cardBorderWidth / 2,
                  ),
                ),
                child: Text(
                  priceText,
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.hint(context),
                    fontWeight: EcoPlatesDesignTokens.typography.bold,
                    color: EcoPlatesDesignTokens.colors.textPrimary,
                  ),
                ),
              ),

              SizedBox(width: context.scaleXS_SM_MD_LG),

              // Distance
              if (distance != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleXXS_XS_SM_MD,
                    vertical: context.scaleXXS_XS_SM_MD / 4,
                  ),
                  decoration: BoxDecoration(
                    color: EcoPlatesDesignTokens.colors.textPrimary.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.subtle,
                    ),
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.sm,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: EcoPlatesDesignTokens.size.indicator(context) / 2,
                        color: EcoPlatesDesignTokens.colors.textPrimary,
                      ),
                      SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
                      Text(
                        '${distance!.toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
                          fontWeight: EcoPlatesDesignTokens.typography.medium,
                          color: EcoPlatesDesignTokens.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Horaire
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: EcoPlatesDesignTokens.size.indicator(context),
                    color: EcoPlatesDesignTokens.colors.textPrimary,
                  ),
                  SizedBox(width: context.scaleXXS_XS_SM_MD),
                  Text(
                    pickupTime,
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                      color: EcoPlatesDesignTokens.colors.textPrimary,
                    ),
                  ),
                ],
              ),

              SizedBox(width: context.scaleXS_SM_MD_LG),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: EcoPlatesDesignTokens.size.indicator(context),
                color: EcoPlatesDesignTokens.colors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
