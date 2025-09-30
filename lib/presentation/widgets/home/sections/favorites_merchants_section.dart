import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../core/router/routes/route_constants.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../providers/merchants_provider.dart';
import '../../favorite_merchant_card.dart';
import 'responsive_card_config.dart';

/// Section affichant un slider des commerçants favoris de l'utilisateur
class FavoritesMerchantsSection extends ConsumerWidget {
  const FavoritesMerchantsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteMerchantsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: EdgeInsets.fromLTRB(
            ResponsiveCardConfig.getSliderPadding(context).left,
            ResponsiveUtils.getVerticalSpacing(context) * 0.6,
            ResponsiveCardConfig.getSliderPadding(context).right,
            ResponsiveUtils.getVerticalSpacing(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vos favoris',
                style: TextStyle(
                  fontSize: ResponsiveCardConfig.getSectionTitleFontSize(
                    context,
                  ),
                  fontWeight: FontWeight.w600,
                  color: DeepColorTokens.neutral900.withValues(alpha: 0.9),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Aller à l’onglet Favoris via GoRouter (reste dans le shell)
                  context.go(RouteConstants.consumerFavorites);
                },
                child: Text(
                  'Voir tout',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      14.0,
                    ),
                    color: DeepColorTokens.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: favorites.isEmpty
              ? ResponsiveUtils.getVerticalSpacing(context) * 5
              : 152.0,
          child: favorites.isEmpty
              ? Center(
                  child: Text(
                    'Aucun favori pour l’instant',
                    style: TextStyle(
                      color: DeepColorTokens.neutral600.withValues(alpha: 0.6),
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        14.0,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: ResponsiveCardConfig.getSliderPadding(context),
                  physics: const BouncingScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final merchant = favorites[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            ResponsiveCardConfig.getCardSpacing(context) / 2,
                      ),
                      child: SizedBox(
                        width: ResponsiveCardConfig.getSliderCardWidth(context),
                        child: FavoriteMerchantCard(
                          merchant: merchant,
                          onTap: () {
                            // TODO(navigation): Add merchant detail navigation
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),

        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),
      ],
    );
  }
}
