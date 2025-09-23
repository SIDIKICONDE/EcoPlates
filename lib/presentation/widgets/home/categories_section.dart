import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/category_provider.dart';


/// Section horizontale des catégories de restaurants
class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      RestaurantCategory(
        id: 'all',
        name: 'Tout',
        icon: Icons.apps,
        color: Colors.indigo,
      ),
      RestaurantCategory(
        id: 'bakery',
        name: 'Boulangerie',
        icon: Icons.bakery_dining,
        color: Colors.brown,
      ),
      RestaurantCategory(
        id: 'restaurant',
        name: 'Restaurant',
        icon: Icons.restaurant,
        color: Colors.orange,
      ),
      RestaurantCategory(
        id: 'grocery',
        name: 'Épicerie',
        icon: Icons.shopping_basket,
        color: Colors.green,
      ),
      RestaurantCategory(
        id: 'cafe',
        name: 'Café',
        icon: Icons.coffee,
        color: Colors.amber.shade800,
      ),
      RestaurantCategory(
        id: 'pizza',
        name: 'Pizza',
        icon: Icons.local_pizza,
        color: Colors.red,
      ),
      RestaurantCategory(
        id: 'sushi',
        name: 'Sushi',
        icon: Icons.rice_bowl,
        color: Colors.pink,
      ),
    ];

    return Container(
      color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Catégories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryCard(
                  category: category,
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state =
                        category.id;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte individuelle de catégorie
class _CategoryCard extends StatelessWidget {
  final RestaurantCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: category.color.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Icon(category.icon, color: category.color, size: 20),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Modèle pour une catégorie de restaurant
class RestaurantCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  RestaurantCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
