import 'package:flutter/material.dart';

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
        16.0,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: 0.08,
            ),
            blurRadius: 8.0,
            offset: Offset(0, 4),
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
                size: 24.0,
              ),
              SizedBox(
                width: 12.0,
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
            height: 24.0,
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
              height: 16.0,
            ),
            SizedBox(
              height: 100.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: favoritePlaces.length,
                separatorBuilder: (context, index) => SizedBox(
                  width: 12.0,
                ),
                itemBuilder: (context, index) {
                  final place = favoritePlaces[index];
                  return FavoritePlaceCard(place: place);
                },
              ),
            ),
            SizedBox(height: 24.0),
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
              height: 16.0,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favoriteDishes.length > 3 ? 3 : favoriteDishes.length,
              separatorBuilder: (context, index) => SizedBox(
                height: 12.0,
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
              height: 16.0,
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
