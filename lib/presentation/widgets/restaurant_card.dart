import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/restaurant.dart';
import 'dart:math' as math;

/// Carte de restaurant moderne avec animations et design amélioré
class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.12),
                    blurRadius: _isPressed ? 8 : 15,
                    offset: Offset(0, _isPressed ? 4 : 8),
                    spreadRadius: _isPressed ? -2 : 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Image de fond
                    _buildBackgroundImage(isDarkMode),
                    
                    // Gradient overlay
                    _buildGradientOverlay(),
                    
                    // Contenu principal
                    _buildContent(context, isDarkMode),
                    
                    // Badges alignés en haut horizontalement
                    _buildTopBadges(context),
                    
                    // Badges verticaux à gauche
                    _buildFloatingBadges(context),
                    
                    // Indicateur de temps restant
                    if (widget.restaurant.availableOffers <= 3)
                      _buildTimeIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundImage(bool isDarkMode) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: widget.restaurant.imageUrl != null
          ? CachedNetworkImage(
              imageUrl: widget.restaurant.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor(widget.restaurant.category),
                      _getCategoryColor(widget.restaurant.category)
                          .withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(widget.restaurant.category),
                  size: 60,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColor(widget.restaurant.category),
                    _getCategoryColor(widget.restaurant.category)
                        .withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                _getCategoryIcon(widget.restaurant.category),
                size: 60,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.black.withValues(alpha: 0.3),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
          ],
          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section supérieure avec bouton favori seulement
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Bouton favori animé
              GestureDetector(
                onTap: () {
                  // Toggle favoris avec animation
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
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
                      widget.restaurant.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      key: ValueKey(widget.restaurant.isFavorite),
                      color: widget.restaurant.isFavorite
                          ? Colors.red
                          : Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Section inférieure avec infos
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tags visuels
              if (widget.restaurant.tags != null &&
                  widget.restaurant.tags!.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: widget.restaurant.tags!
                      .take(3)
                      .map((tag) => _buildTag(tag))
                      .toList(),
                ),
              const SizedBox(height: 8),
              
              // Nom du restaurant
              Text(
                widget.restaurant.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Type de cuisine
              Text(
                widget.restaurant.cuisineType,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 2,
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Ligne d'infos
              Row(
                children: [
                  // Note avec étoiles
                  if (widget.restaurant.rating != null) ...[
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final filled = index < widget.restaurant.rating!.floor();
                          return Icon(
                            filled ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          widget.restaurant.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                  ],
                  
                  // Distance
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.restaurant.distanceText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Prix
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.restaurant.hasActiveOffer) ...[
                        Text(
                          '${widget.restaurant.originalPrice}€',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          '${widget.restaurant.discountedPrice}€',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else
                        Text(
                          'Dès ${widget.restaurant.minPrice}€',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Horaire de collecte
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Collecte : ${widget.restaurant.pickupTime}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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

  // Nouveaux badges alignés horizontalement en haut
  Widget _buildTopBadges(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 60, // Laisser de la place pour le bouton favori
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Badge de réduction animé 🔥
          if (widget.restaurant.hasActiveOffer)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
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
                        colors: [Colors.red, Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.5),
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
          
          if (widget.restaurant.hasActiveOffer && 
              widget.restaurant.rating != null && 
              widget.restaurant.rating! >= 4.5)
            const SizedBox(width: 8), // Espacement entre les badges
          
          // Badge de popularité ⭐
          if (widget.restaurant.rating != null && widget.restaurant.rating! >= 4.5)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'POPULAIRE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingBadges(BuildContext context) {
    return Positioned(
      top: 56, // Décalé en dessous des badges horizontaux
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge "Nouveau" si applicable
          if (widget.restaurant.createdAt != null &&
              DateTime.now().difference(widget.restaurant.createdAt!).inDays < 7)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.new_releases, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'NOUVEAU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeIndicator() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: widget.restaurant.availableOffers <= 2
              ? Colors.red
              : Colors.orange,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (widget.restaurant.availableOffers <= 2
                      ? Colors.red
                      : Colors.orange)
                  .withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 2 * math.pi,
                  child: const Icon(
                    Icons.timer,
                    size: 14,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(width: 6),
            Text(
              widget.restaurant.availableOffers == 1
                  ? 'Dernière chance!'
                  : 'Plus que ${widget.restaurant.availableOffers}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    IconData icon;
    Color color;
    
    switch (tag.toLowerCase()) {
      case 'végétarien':
      case 'vegan':
      case 'végé':
        icon = Icons.eco;
        color = Colors.green;
        break;
      case 'bio':
        icon = Icons.grass;
        color = Colors.lightGreen;
        break;
      case 'halal':
        icon = Icons.verified;
        color = Colors.teal;
        break;
      case 'sans gluten':
        icon = Icons.grain_outlined;
        color = Colors.orange;
        break;
      default:
        icon = Icons.label;
        color = Colors.blue;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            tag,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
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