import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/consumer/search_provider.dart';
import '../providers/consumer/restaurants_provider.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/search_filter_bar.dart';

/// Page d'accueil principale type Too Good To Go
/// Affiche tous les restaurants et leurs offres anti-gaspi
class MainHomeScreen extends ConsumerStatefulWidget {
  const MainHomeScreen({super.key});

  @override
  ConsumerState<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends ConsumerState<MainHomeScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isSearchExpanded = false;

  // Catégories principales comme Too Good To Go
  final List<RestaurantCategory> _categories = [
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar personnalisé avec recherche intégrée
          SliverAppBar(
            expandedHeight: _isSearchExpanded ? 180.0 : 120.0,
            floating: true,
            pinned: true,
            backgroundColor: theme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              title: const Text(
                'EcoPlates',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              // Icône de localisation
              IconButton(
                icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                onPressed: () => _showLocationPicker(context),
              ),
              // Panier avec badge
              Consumer(
                builder: (context, ref, child) {
                  final cartCount = ref.watch(cartCountProvider);
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                        onPressed: () => context.go('/cart'),
                      ),
                      if (cartCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                cartCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(_isSearchExpanded ? 100 : 50),
              child: Column(
                children: [
                  // Barre de recherche
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      onTap: () {
                        setState(() {
                          _isSearchExpanded = !_isSearchExpanded;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Rechercher un restaurant ou une offre...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.filter_list),
                              onPressed: () => _showFilterSheet(context),
                            ),
                          ],
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                    ),
                  ),
                  // Filtres rapides si recherche étendue
                  if (_isSearchExpanded)
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildQuickFilter('< 1km', Icons.near_me),
                          const SizedBox(width: 8),
                          _buildQuickFilter('Nouveau', Icons.new_releases),
                          const SizedBox(width: 8),
                          _buildQuickFilter('Top vendeur', Icons.star),
                          const SizedBox(width: 8),
                          _buildQuickFilter('Gratuit', Icons.volunteer_activism),
                          const SizedBox(width: 8),
                          _buildQuickFilter('< 3€', Icons.euro),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Catégories horizontales
          SliverToBoxAdapter(
            child: Container(
              color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Catégories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return _buildCategoryCard(category);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Section "Près de vous"
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🔥 Près de vous',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Afficher sur la carte
                          context.go('/map');
                        },
                        child: const Text('Voir sur la carte'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sauvez de la nourriture à proximité',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Liste des restaurants avec leurs offres
          Consumer(
            builder: (context, ref, child) {
              final restaurantsAsync = ref.watch(nearbyRestaurantsProvider);
              
              return restaurantsAsync.when(
                data: (restaurants) {
                  if (restaurants.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun restaurant disponible',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Revenez plus tard pour découvrir des offres',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final restaurant = restaurants[index];
                          return RestaurantCard(
                            restaurant: restaurant,
                            onTap: () {
                              context.go('/restaurant/${restaurant.id}');
                            },
                          );
                        },
                        childCount: restaurants.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Erreur de chargement',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(nearbyRestaurantsProvider);
                          },
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Espacement en bas
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      
      // FAB pour ajouter aux favoris ou filtrer
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFilterSheet(context),
        backgroundColor: theme.primaryColor,
        icon: const Icon(Icons.tune),
        label: const Text('Filtrer'),
      ),
    );
  }

  Widget _buildCategoryCard(RestaurantCategory category) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = category.id;
      },
      child: Container(
        width: 65,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: category.color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilter(String label, IconData icon) {
    return FilterChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Colors.white,
      selected: false,
      onSelected: (selected) {
        // Logique de filtre rapide
      },
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choisir une localisation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.my_location),
                title: const Text('Ma position actuelle'),
                onTap: () {
                  Navigator.pop(context);
                  // Activer la géolocalisation
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Rechercher une adresse'),
                onTap: () {
                  Navigator.pop(context);
                  // Ouvrir la recherche d'adresse
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const SearchFilterBar();
      },
    );
  }
}

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