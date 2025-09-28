import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/spacing_tokens.dart';
import 'empty_favorites_widget.dart';
import 'favorite_dish_tile.dart';
import 'favorite_place_card.dart';
import 'favorites_models.dart';

/// Section des lieux et plats favoris du consommateur
class ConsumerFavoritesSection extends StatelessWidget {
  const ConsumerFavoritesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    // TODO: Récupérer les favoris depuis un provider
    final favoritePlaces = _getMockFavoritePlaces();
    final favoriteDishes = _getMockFavoriteDishes();

    return Container(
      padding: EdgeInsets.all(
        context.responsiveValue(
          mobile: EcoSpacing.md,
          tablet: EcoSpacing.lg,
          desktop: EcoSpacing.xl,
        ),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            mobile: EcoPlatesDesignTokens.radius.md,
            tablet: EcoPlatesDesignTokens.radius.lg,
            desktop: EcoPlatesDesignTokens.radius.xl,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: colors.error,
                size: context.responsiveValue(
                  mobile: context.scaleIconStandard,
                  tablet:
                      context.scaleIconStandard * 1.2, // 20% larger on tablet
                  desktop:
                      context.scaleIconStandard * 1.4, // 40% larger on desktop
                ),
              ),
              SizedBox(
                width: context.responsiveValue(
                  mobile: EcoSpacing.sm,
                  tablet: EcoSpacing.md,
                  desktop: EcoSpacing.lg,
                ),
              ),
              Text(
                'Mes Favoris',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(
            height: context.responsiveValue(
              mobile: EcoSpacing.lg,
              tablet: EcoSpacing.xl,
              desktop: EcoSpacing.xxl,
            ),
          ),

          // Restaurants favoris
          if (favoritePlaces.isNotEmpty) ...[
            Text(
              'Restaurants Favoris',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: context.responsiveValue(
                mobile: EcoSpacing.md,
                tablet: EcoSpacing.lg,
                desktop: EcoSpacing.xl,
              ),
            ),
            SizedBox(
              height: context.responsiveValue(
                mobile: DesignConstants.hundred.toDouble(),
                tablet: DesignConstants.hundred + DesignConstants.twenty,
                desktop: DesignConstants.hundred + DesignConstants.forty,
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: favoritePlaces.length,
                separatorBuilder: (context, index) => SizedBox(
                  width: context.responsiveValue(
                    mobile: EcoSpacing.sm,
                    tablet: EcoSpacing.md,
                    desktop: EcoSpacing.lg,
                  ),
                ),
                itemBuilder: (context, index) {
                  final place = favoritePlaces[index];
                  return FavoritePlaceCard(place: place);
                },
              ),
            ),
            SizedBox(
              height: context.responsiveValue(
                mobile: EcoSpacing.lg,
                tablet: EcoSpacing.xl,
                desktop: EcoSpacing.xxl,
              ),
            ),
          ],

          // Plats favoris
          if (favoriteDishes.isNotEmpty) ...[
            Text(
              'Plats Favoris',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: context.responsiveValue(
                mobile: EcoSpacing.md,
                tablet: EcoSpacing.lg,
                desktop: EcoSpacing.xl,
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favoriteDishes.length > DesignConstants.three.toInt()
                  ? DesignConstants.three.toInt()
                  : favoriteDishes.length,
              separatorBuilder: (context, index) => SizedBox(
                height: context.responsiveValue(
                  mobile: EcoSpacing.sm,
                  tablet: EcoSpacing.md,
                  desktop: EcoSpacing.lg,
                ),
              ),
              itemBuilder: (context, index) {
                final dish = favoriteDishes[index];
                return FavoriteDishTile(
                  dish: dish,
                  onToggleFavorite: () => _toggleFavorite(context, dish),
                );
              },
            ),
          ],

          // État vide
          if (favoritePlaces.isEmpty && favoriteDishes.isEmpty)
            const EmptyFavoritesWidget(),

          // Bouton voir plus
          if (favoritePlaces.isNotEmpty || favoriteDishes.isNotEmpty) ...[
            SizedBox(
              height: context.responsiveValue(
                mobile: EcoSpacing.md,
                tablet: EcoSpacing.lg,
                desktop: EcoSpacing.xl,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAllFavorites(context),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Voir tous mes favoris'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAllFavorites(BuildContext context) {
    // TODO: Naviguer vers la page des favoris
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Page des favoris à implémenter'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleFavorite(BuildContext context, FavoriteDish dish) {
    // TODO: Implémenter le toggle favori
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dish.name} retiré des favoris'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            // TODO: Annuler l'action
          },
        ),
      ),
    );
  }

  List<FavoritePlace> _getMockFavoritePlaces() {
    return [
      const FavoritePlace(
        name: 'Le Petit Bistrot',
        address: '123 Rue de la Paix',
        rating: 4.5,
        visitCount: 12,
      ),
      const FavoritePlace(
        name: 'Green Garden',
        address: '45 Avenue Verte',
        rating: 4.8,
        visitCount: 8,
      ),
      const FavoritePlace(
        name: 'Café Éco',
        address: '67 Boulevard Bio',
        rating: 4.3,
        visitCount: 5,
      ),
    ];
  }

  List<FavoriteDish> _getMockFavoriteDishes() {
    return [
      const FavoriteDish(
        name: 'Salade César',
        restaurantName: 'Le Petit Bistrot',
        price: 12.50,
        orderCount: 5,
      ),
      const FavoriteDish(
        name: 'Bowl Végétarien',
        restaurantName: 'Green Garden',
        price: 11.50,
        orderCount: 3,
      ),
      const FavoriteDish(
        name: 'Smoothie Détox',
        restaurantName: 'Café Éco',
        price: 6.80,
        orderCount: 7,
      ),
    ];
  }
}
