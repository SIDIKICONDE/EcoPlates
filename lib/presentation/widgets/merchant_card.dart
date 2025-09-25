import 'package:flutter/material.dart';

import '../../core/utils/accessibility_helper.dart';
import '../../core/utils/animation_manager.dart';
import '../../domain/entities/merchant.dart';
import 'restaurant_card_components/card_background.dart';
import 'restaurant_card_components/discount_badge.dart';
import 'restaurant_card_components/favorite_button.dart';
import 'restaurant_card_components/popularity_badge.dart';
import 'restaurant_card_components/price_info.dart';
import 'restaurant_card_components/rating_display.dart';
import 'restaurant_card_components/restaurant_tag.dart';
import 'restaurant_card_components/time_indicator.dart';

/// Carte de merchant moderne et modulaire
class MerchantCard extends StatefulWidget {
  const MerchantCard({required this.merchant, super.key, this.onTap});
  final Merchant merchant;
  final VoidCallback? onTap;

  @override
  State<MerchantCard> createState() => _MerchantCardState();
}

class _MerchantCardState extends State<MerchantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _animationsEnabled = true;
  final AnimationManager _animationManager = AnimationManager();

  @override
  void initState() {
    super.initState();
    // Créer le contrôleur d'animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Enregistrer l'animation dans le gestionnaire pour éviter les collisions
    _animationManager.registerAnimation(
      id: 'restaurant_card_${widget.merchant.id}',
      controller: _controller,
      priority: true,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Vérifier les préférences d'accessibilité
    final mediaQuery = MediaQuery.of(context);
    _animationsEnabled = !mediaQuery.disableAnimations;
  }

  @override
  void dispose() {
    _animationManager.cancelAnimation('restaurant_card_${widget.merchant.id}');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: 'Commerçant ${widget.merchant.name}',
      hint: 'Toucher pour voir les détails',
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: _onTapCancel,
        child: _animationsEnabled
            ? AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildCard(context, isDarkMode),
                ),
              )
            : _buildCard(context, isDarkMode),
      ),
    );
  }

  void _onTapDown() {
    if (!_animationsEnabled) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    if (_animationsEnabled) {
      _controller.reverse();
    }
    widget.onTap?.call();
  }

  void _onTapCancel() {
    if (!_animationsEnabled) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  Widget _buildCard(BuildContext context, bool isDarkMode) {
    return Container(
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
            // Background avec image et gradient
            CardBackground(
              imageUrl: widget.merchant.imageUrl,
              category: widget.merchant.category,
              isDarkMode: isDarkMode,
            ),

            // Contenu principal
            _buildMainContent(context),

            // Badges supérieurs
            _buildTopBadges(),

            // Indicateur de temps
            if (widget.merchant.availableOffers <= 3)
              TimeIndicator(availableOffers: widget.merchant.availableOffers),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton favori en haut à droite
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FavoriteButton(
                isFavorite: widget.merchant.isFavorite,
                onTap: () {
                  // TODO: Implémenter la logique de favoris
                },
              ),
            ],
          ),

          // Section inférieure avec infos
          _buildBottomInfo(context),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags
        if (widget.merchant.tags?.isNotEmpty ?? false) ...[
          Wrap(
            spacing: 6,
            children: widget.merchant.tags!
                .take(3)
                .map((tag) => RestaurantTag(tag: tag))
                .toList(),
          ),
          const SizedBox(height: 4),
        ],

        // Nom du commerçant
        Text(
          widget.merchant.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: AccessibleFontSizes.medium,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 4)],
            letterSpacing: 0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: widget.merchant.name,
        ),

        const SizedBox(height: 2),

        // Type de cuisine
        Text(
          widget.merchant.cuisineType,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            shadows: const [Shadow(blurRadius: 2)],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Ligne d'infos (rating, distance, prix)
        _buildInfoRow(),

        const SizedBox(height: 4),

        // Horaire de collecte
        _buildPickupTime(),
      ],
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        // Note
        RatingDisplay(rating: widget.merchant.rating),
        const SizedBox(width: 8),

        // Distance
        _buildDistanceBadge(),

        const Spacer(),

        // Prix
        PriceInfo(
          hasActiveOffer: widget.merchant.hasActiveOffer,
          originalPrice: widget.merchant.originalPrice,
          discountedPrice: widget.merchant.discountedPrice,
          minPrice: widget.merchant.minPrice,
        ),
      ],
    );
  }

  Widget _buildDistanceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            widget.merchant.distanceText,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupTime() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            'Collecte : ${widget.merchant.pickupTime}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBadges() {
    return Positioned(
      top: 12,
      left: 12,
      right: 60,
      child: Row(
        children: [
          // Badge de réduction
          if (widget.merchant.hasActiveOffer) ...[
            DiscountBadge(
              discountPercentage: widget.merchant.discountPercentage,
              animationsEnabled: _animationsEnabled,
            ),
            if (_isPopular) const SizedBox(width: 8),
          ],

          // Badge de popularité
          if (_isPopular) const PopularityBadge(),
        ],
      ),
    );
  }

  // Getters helper
  bool get _isPopular => widget.merchant.rating >= 4.5;
}
