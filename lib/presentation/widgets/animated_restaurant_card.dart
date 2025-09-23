import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/restaurant.dart';

/// Carte de restaurant animée avec effets visuels avancés
class AnimatedRestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;
  final Function(bool)? onFavoriteChanged;

  const AnimatedRestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onFavoriteChanged,
  });

  @override
  State<AnimatedRestaurantCard> createState() => _AnimatedRestaurantCardState();
}

class _AnimatedRestaurantCardState extends State<AnimatedRestaurantCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _favoriteController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _favoriteAnimation;
  late Animation<double> _pulseAnimation;

  bool _isPressed = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.restaurant.isFavorite;

    // Animation d'échelle pour le tap
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Animation pour le favori
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
    );

    // Animation de pulsation pour les offres limitées
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Démarrer la pulsation si peu d'offres
    if (widget.restaurant.availableOffers > 0 &&
        widget.restaurant.availableOffers <= 3) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _favoriteController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    _favoriteController.forward().then((_) {
      _favoriteController.reverse();
    });
    widget.onFavoriteChanged?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _scaleController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _scaleController.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _scaleController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: _isPressed ? 20 : 15,
                    offset: Offset(0, _isPressed ? 8 : 6),
                    spreadRadius: _isPressed ? 2 : 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image avec overlay et badges
                    Stack(
                      children: [
                        _buildImage(),
                        _buildGradientOverlay(),
                        _buildTopBadges(),
                        _buildBottomBadges(),
                      ],
                    ),
                    // Contenu
                    _buildContent(theme, isDarkMode),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Hero(
        tag: 'restaurant_${widget.restaurant.id}',
        child: widget.restaurant.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: widget.restaurant.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => ShimmerLoadingCard(),
                errorWidget: (context, url, error) => Container(
                  color: _getCategoryColor(widget.restaurant.category),
                  child: Icon(
                    _getCategoryIcon(widget.restaurant.category),
                    size: 50,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor(widget.restaurant.category),
                      _getCategoryColor(
                        widget.restaurant.category,
                      ).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(widget.restaurant.category),
                  size: 50,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBadges() {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Badge de réduction avec animation
          if (widget.restaurant.hasActiveOffer)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '-${widget.restaurant.discountPercentage}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          // Bouton favori animé
          GestureDetector(
            onTap: _toggleFavorite,
            child: AnimatedBuilder(
              animation: _favoriteAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _favoriteAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_isFavorite),
                        color: _isFavorite ? Colors.red : Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBadges() {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Badge de distance
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.near_me, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  widget.restaurant.distanceText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Badge d'offres disponibles avec pulsation
          if (widget.restaurant.availableOffers > 0)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.restaurant.availableOffers <= 3
                      ? _pulseAnimation.value
                      : 1.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.restaurant.availableOffers <= 3
                            ? [Colors.orange, Colors.deepOrange]
                            : [Colors.green, Colors.lightGreen],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (widget.restaurant.availableOffers <= 3
                                      ? Colors.orange
                                      : Colors.green)
                                  .withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.restaurant.availableOffers <= 3
                              ? Icons.timer
                              : Icons.shopping_bag,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.restaurant.availableOffers <= 3
                              ? 'Plus que ${widget.restaurant.availableOffers}!'
                              : '${widget.restaurant.availableOffers} dispos',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nom et note
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.restaurant.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.restaurant.rating != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.restaurant.rating!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // Type de cuisine
          Text(
            widget.restaurant.cuisineType,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Prix et horaire
          Row(
            children: [
              // Prix
              if (widget.restaurant.hasActiveOffer) ...[
                Text(
                  '${widget.restaurant.originalPrice.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.restaurant.discountedPrice.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ] else
                Text(
                  'À partir de ${widget.restaurant.minPrice.toStringAsFixed(2)}€',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              const Spacer(),
              // Horaire
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.restaurant.pickupTime,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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

/// Widget Shimmer pour le chargement
class ShimmerLoadingCard extends StatelessWidget {
  const ShimmerLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
