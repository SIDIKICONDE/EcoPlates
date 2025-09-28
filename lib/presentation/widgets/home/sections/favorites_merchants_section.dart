import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/design_tokens.dart';
import '../../../../core/router/routes/route_constants.dart';
import '../../../providers/merchants_provider.dart';
import '../../favorite_merchant_card.dart';

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
            context.scaleMD_LG_XL_XXL,
            context.scaleXS_SM_MD_LG,
            context.scaleMD_LG_XL_XXL,
            context.scaleMD_LG_XL_XXL,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vos favoris',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.modalTitle(
                    context,
                  ),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                ),
              ),
              if (favorites.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // Aller à l’onglet Favoris via GoRouter (reste dans le shell)
                    context.go(RouteConstants.consumerFavorites);
                  },
                  child: const Text('Voir tout'),
                ),
            ],
          ),
        ),

        SizedBox(
          height: favorites.isEmpty ? DesignConstants.eighty.toDouble() : 152,
          child: favorites.isEmpty
              ? Center(
                  child: Text(
                    'Aucun favori pour l’instant',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleMD_LG_XL_XXL,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final merchant = favorites[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleXS_SM_MD_LG,
                      ),
                      child: SizedBox(
                        width: context.scaleLG_XL_XXL_XXXL,
                        child: FavoriteMerchantCard(
                          merchant: merchant,
                          onTap: () {
                            // TODO: Navigation vers le détail du commerçant
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),

        SizedBox(
          height: context.scaleMD_LG_XL_XXL,
        ),
      ],
    );
  }
}
