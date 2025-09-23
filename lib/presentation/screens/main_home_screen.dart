import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/restaurant.dart';
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
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 65,
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

          // Sections multiples de restaurants
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section "Près de vous"
                _buildRestaurantSection(
                  title: '🔥 Près de vous',
                  subtitle: 'Restaurants à moins de 1km',
                  actionText: 'Voir tout',
                  onActionTap: () => context.go('/nearby'),
                ),
                
                // Section "Nouveautés"
                _buildRestaurantSection(
                  title: '✨ Nouveautés',
                  subtitle: 'Découvrez les derniers arrivés',
                  actionText: 'Voir tout',
                  onActionTap: () => context.go('/new'),
                ),
                
                // Section "Meilleures offres"
                _buildRestaurantSection(
                  title: '💎 Meilleures offres',
                  subtitle: 'Les plus grandes réductions',
                  actionText: 'Voir tout',
                  onActionTap: () => context.go('/best-deals'),
                ),
                
                // Section "Ferment bientôt"
                _buildRestaurantSection(
                  title: '⏰ Dernière chance',
                  subtitle: 'À récupérer avant fermeture',
                  actionText: 'Voir tout',
                  onActionTap: () => context.go('/closing-soon'),
                  isUrgent: true,
                ),
                
                // Section "Colis anti-gaspi"
                _buildSurpriseBoxSection(),
              ],
            ),
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

  Widget _buildRestaurantSection({
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onActionTap,
    bool isUrgent = false,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final restaurantsAsync = ref.watch(nearbyRestaurantsProvider);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de la section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isUrgent ? Colors.orange : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: onActionTap,
                      child: Text(
                        actionText,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Slider horizontal de restaurants
              restaurantsAsync.when(
                data: (restaurants) {
                  if (restaurants.isEmpty) {
                    return Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pas d\'offres disponibles',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  // Filtrer selon le type de section
                  List<Restaurant> filteredRestaurants = restaurants;
                  if (title.contains('Nouveautés')) {
                    // Prendre les 5 derniers ajoutés
                    filteredRestaurants = restaurants.take(5).toList();
                  } else if (title.contains('Meilleures offres')) {
                    // Trier par réduction et prendre les 5 premiers
                    filteredRestaurants = restaurants
                      .where((r) => r.hasActiveOffer)
                      .toList()
                      ..sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
                    filteredRestaurants = filteredRestaurants.take(5).toList();
                  } else if (title.contains('Dernière chance')) {
                    // Filtrer ceux qui ferment bientôt
                    filteredRestaurants = restaurants
                      .where((r) => r.availableOffers > 0 && r.availableOffers <= 3)
                      .take(5)
                      .toList();
                  } else {
                    // Près de vous - prendre les 10 premiers
                    filteredRestaurants = restaurants.take(10).toList();
                  }
                  
                  return SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = filteredRestaurants[index];
                        return Container(
                          width: 340,
                          margin: const EdgeInsets.only(right: 16),
                          child: RestaurantCard(
                            restaurant: restaurant,
                            onTap: () {
                              context.go('/restaurant/${restaurant.id}');
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 340,
                        margin: const EdgeInsets.only(right: 16),
                        child: _buildShimmerCard(),
                      );
                    },
                  ),
                ),
                error: (error, stack) => Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 50,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Erreur de chargement',
                          style: TextStyle(
                            color: Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            ref.invalidate(nearbyRestaurantsProvider);
                          },
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          // Content placeholder
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 16,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurpriseBoxSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.purple, Colors.deepPurple],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'NOUVEAU',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '🎁 Colis anti-gaspi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Paniers surprises à prix mini',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go('/surprise-boxes'),
                  child: Text(
                    'Voir tout',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Slider horizontal de colis
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildSurpriseBoxCard(
                  index: index,
                  onTap: () {
                    // Naviguer vers le détail du colis
                    context.go('/surprise-box/${index}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSurpriseBoxCard({
    required int index,
    required VoidCallback onTap,
  }) {
    // Données de démo pour les colis
    final boxes = [
      {
        'title': 'Panier Gourmand',
        'subtitle': 'Mélange sucré/salé',
        'price': 4.99,
        'originalPrice': 15.0,
        'items': '3-5 articles',
        'color': Colors.orange,
        'icon': Icons.fastfood,
        'badge': 'TOP VENTE',
      },
      {
        'title': 'Box Végétarienne',
        'subtitle': '100% végétal',
        'price': 5.99,
        'originalPrice': 18.0,
        'items': '4-6 articles',
        'color': Colors.green,
        'icon': Icons.eco,
        'badge': 'BIO',
      },
      {
        'title': 'Panier Boulangerie',
        'subtitle': 'Pains et viennoiseries',
        'price': 3.99,
        'originalPrice': 12.0,
        'items': '5-7 articles',
        'color': Colors.brown,
        'icon': Icons.bakery_dining,
        'badge': 'POPULAIRE',
      },
      {
        'title': 'Box Fruits & Légumes',
        'subtitle': 'Produits frais du jour',
        'price': 6.99,
        'originalPrice': 20.0,
        'items': '2kg minimum',
        'color': Colors.lightGreen,
        'icon': Icons.apple,
        'badge': 'FRAIS',
      },
      {
        'title': 'Panier Mystère',
        'subtitle': 'Surprise totale !',
        'price': 7.99,
        'originalPrice': 25.0,
        'items': '6-8 articles',
        'color': Colors.purple,
        'icon': Icons.help_outline,
        'badge': 'SURPRISE',
      },
      {
        'title': 'Box Petit-déjeuner',
        'subtitle': 'Pour bien démarrer',
        'price': 4.49,
        'originalPrice': 13.0,
        'items': '4-5 articles',
        'color': Colors.amber,
        'icon': Icons.free_breakfast,
        'badge': 'MATIN',
      },
    ];
    
    final box = boxes[index % boxes.length];
    final discount = (((box['originalPrice'] as double) - (box['price'] as double)) / 
                     (box['originalPrice'] as double) * 100).round();
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (box['color'] as Color),
                (box['color'] as Color).withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (box['color'] as Color).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Pattern de fond
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomPaint(
                    painter: _PatternPainter(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
              // Contenu
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge et réduction
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            box['badge'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '-$discount%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Icône centrale
                    Center(
                      child: Icon(
                        box['icon'] as IconData,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    // Titre et sous-titre
                    Text(
                      box['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      box['subtitle'] as String,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Nombre d'articles
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shopping_bag,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            box['items'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Prix
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(box['price'] as double).toStringAsFixed(2)}€',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(box['originalPrice'] as double).toStringAsFixed(2)}€',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(RestaurantCategory category) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = category.id;
      },
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
              child: Icon(
                category.icon,
                color: category.color,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 10,
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

/// Painter pour créer un pattern de fond
class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double spacing = 30;
    const double radius = 3;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) => color != oldDelegate.color;
}
