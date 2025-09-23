import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/restaurant.dart';
import '../providers/consumer/restaurants_provider.dart';

/// Page de détail d'un restaurant avec effet parallaxe
class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late TabController _tabController;
  
  double _imageOpacity = 1.0;
  double _imageScale = 1.0;
  bool _showTitle = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 3, vsync: this);
    
    // Animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Démarrer les animations
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
      _slideController.forward();
    });
    
    // Effet parallaxe
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      setState(() {
        _imageOpacity = (1.0 - (offset / 300)).clamp(0.0, 1.0);
        _imageScale = (1.0 + (offset / 500)).clamp(1.0, 1.5);
        _showTitle = offset > 200;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantByIdProvider(widget.restaurantId));
    
    if (restaurant == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    _isFavorite = restaurant.isFavorite;
    
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header avec image parallaxe
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                leading: _buildBackButton(),
                title: AnimatedOpacity(
                  opacity: _showTitle ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(restaurant.name),
                ),
                actions: [
                  _buildShareButton(),
                  _buildFavoriteButton(),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image avec effet parallaxe
                      Transform.scale(
                        scale: _imageScale,
                        child: Opacity(
                          opacity: _imageOpacity,
                          child: _buildHeaderImage(restaurant),
                        ),
                      ),
                      // Gradient overlay
                      _buildGradientOverlay(),
                      // Informations du restaurant
                      _buildRestaurantInfo(restaurant),
                    ],
                  ),
                ),
              ),
              
              // Corps de la page
              SliverToBoxAdapter(
                child: _buildBody(restaurant),
              ),
            ],
          ),
          
          // Bouton flottant pour réserver
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildFloatingActionButton(restaurant),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.share, color: Colors.white),
        onPressed: () {
          // Partager
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(_isFavorite),
            color: _isFavorite ? Colors.red : Colors.white,
          ),
        ),
        onPressed: () {
          setState(() {
            _isFavorite = !_isFavorite;
          });
          _scaleController.forward().then((_) {
            _scaleController.reverse();
          });
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildHeaderImage(Restaurant restaurant) {
    if (restaurant.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: restaurant.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor(restaurant.category),
            _getCategoryColor(restaurant.category).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        _getCategoryIcon(restaurant.category),
        size: 100,
        color: Colors.white.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo(Restaurant restaurant) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: FadeTransition(
        opacity: _fadeController,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOut,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badges
              Row(
                children: [
                  if (restaurant.hasActiveOffer)
                    _buildBadge(
                      Icons.local_fire_department,
                      '-${restaurant.discountPercentage}%',
                      Colors.red,
                    ),
                  const SizedBox(width: 8),
                  if (restaurant.availableOffers > 0)
                    _buildBadge(
                      Icons.shopping_bag,
                      '${restaurant.availableOffers} offres',
                      Colors.green,
                    ),
                  const SizedBox(width: 8),
                  _buildBadge(
                    Icons.near_me,
                    restaurant.distanceText,
                    Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Nom
              Text(
                restaurant.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Type de cuisine
              Text(
                restaurant.cuisineType,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              // Note et avis
              Row(
                children: [
                  if (restaurant.rating != null) ...[
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating!.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(127 avis)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Restaurant restaurant) {
    return Column(
      children: [
        // Tabs
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Offres', icon: Icon(Icons.local_offer)),
              Tab(text: 'Infos', icon: Icon(Icons.info)),
              Tab(text: 'Avis', icon: Icon(Icons.star)),
            ],
          ),
        ),
        
        // Contenu des tabs
        SizedBox(
          height: 600,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOffersTab(restaurant),
              _buildInfoTab(restaurant),
              _buildReviewsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOffersTab(Restaurant restaurant) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _OfferCard(
          title: 'Panier Surprise ${index + 1}',
          description: 'Un assortiment de nos meilleurs produits du jour',
          originalPrice: 15.0 + index * 2,
          discountedPrice: 5.0 + index,
          pickupTime: '18:30 - 19:00',
          quantity: 3 - index,
          onTap: () {
            // Naviguer vers l'offre
          },
        );
      },
    );
  }

  Widget _buildInfoTab(Restaurant restaurant) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          _buildSectionTitle('À propos'),
          const SizedBox(height: 8),
          Text(
            restaurant.description ?? 
            'Découvrez nos délicieux produits et aidez-nous à réduire le gaspillage alimentaire. Chaque jour, nous proposons des paniers surprises avec nos invendus du jour à prix réduit.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          
          // Horaires
          _buildSectionTitle('Horaires de collecte'),
          const SizedBox(height: 12),
          _buildTimeline(),
          const SizedBox(height: 24),
          
          // Localisation
          _buildSectionTitle('Localisation'),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 50, color: Colors.grey[600]),
                  const SizedBox(height: 8),
                  Text(
                    restaurant.address ?? '123 Rue de la Paix, 75001 Paris',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Contact
          _buildSectionTitle('Contact'),
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(restaurant.phone ?? '01 23 45 67 89'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _ReviewCard(
          userName: 'Utilisateur ${index + 1}',
          rating: 4.0 + (index % 2) * 0.5,
          comment: 'Excellent restaurant ! Les paniers surprises sont toujours de bonne qualité.',
          date: DateTime.now().subtract(Duration(days: index)),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTimeline() {
    final times = [
      {'day': 'Lundi', 'hours': '18:30 - 19:00'},
      {'day': 'Mardi', 'hours': '18:30 - 19:00'},
      {'day': 'Mercredi', 'hours': '18:30 - 19:00'},
      {'day': 'Jeudi', 'hours': '18:30 - 19:00'},
      {'day': 'Vendredi', 'hours': '19:00 - 19:30'},
      {'day': 'Samedi', 'hours': '12:00 - 12:30'},
      {'day': 'Dimanche', 'hours': 'Fermé'},
    ];
    
    return Column(
      children: times.map((time) {
        final isToday = time['day'] == 'Lundi'; // À adapter
        final isClosed = time['hours'] == 'Fermé';
        
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500 + times.indexOf(time) * 100),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(50 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isToday 
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isToday 
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time['day']!,
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isToday ? Theme.of(context).primaryColor : null,
                        ),
                      ),
                      Text(
                        time['hours']!,
                        style: TextStyle(
                          color: isClosed ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildFloatingActionButton(Restaurant restaurant) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  // Naviguer vers la réservation
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Voir les offres disponibles',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'bakery':
      case 'boulangerie':
        return Colors.brown;
      case 'restaurant':
        return Colors.orange;
      case 'grocery':
      case 'épicerie':
        return Colors.green;
      case 'cafe':
      case 'café':
        return Colors.amber.shade800;
      case 'pizza':
        return Colors.red;
      case 'sushi':
        return Colors.pink;
      default:
        return Colors.indigo;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'bakery':
      case 'boulangerie':
        return Icons.bakery_dining;
      case 'restaurant':
        return Icons.restaurant;
      case 'grocery':
      case 'épicerie':
        return Icons.shopping_basket;
      case 'cafe':
      case 'café':
        return Icons.coffee;
      case 'pizza':
        return Icons.local_pizza;
      case 'sushi':
        return Icons.rice_bowl;
      default:
        return Icons.store;
    }
  }
}

// Widget pour une carte d'offre
class _OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final String pickupTime;
  final int quantity;
  final VoidCallback? onTap;

  const _OfferCard({
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.pickupTime,
    required this.quantity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final discount = ((originalPrice - discountedPrice) / originalPrice * 100).round();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (quantity <= 3)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Plus que $quantity!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            pickupTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
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
                    const SizedBox(height: 4),
                    Text(
                      '${originalPrice.toStringAsFixed(2)}€',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      '${discountedPrice.toStringAsFixed(2)}€',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget pour une carte d'avis
class _ReviewCard extends StatelessWidget {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  const _ReviewCard({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  userName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating.floor()
                              ? Icons.star
                              : index < rating
                                ? Icons.star_half
                                : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment),
        ],
      ),
    );
  }
}