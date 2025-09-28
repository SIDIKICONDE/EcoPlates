import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/responsive/design_tokens.dart';
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
    unawaited(
      _animationManager.registerAnimation(
        id: 'restaurant_card_${widget.merchant.id}',
        controller: _controller,
        priority: true,
      ),
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
    unawaited(
      _animationManager.cancelAnimation(
        'restaurant_card_${widget.merchant.id}',
      ),
    );
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Build comprehensive accessibility description
    final accessibilityLabel = AccessibilityHelper.buildMerchantLabel(
      name: widget.merchant.name,
      rating: widget.merchant.rating,
      category: widget.merchant.category,
      hasDiscount: widget.merchant.discountPercentage > 0,
      discountPercentage: widget.merchant.discountPercentage,
    );

    return Semantics(
      button: true,
      label: accessibilityLabel,
      hint: 'Double-tap to view details',
      onTapHint: 'Opens ${widget.merchant.name} details',
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
    unawaited(_controller.forward());
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    if (_animationsEnabled) {
      unawaited(_controller.reverse());
    }
    widget.onTap?.call();
  }

  void _onTapCancel() {
    if (!_animationsEnabled) return;
    setState(() => _isPressed = false);
    unawaited(_controller.reverse());
  }

  Widget _buildCard(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xl),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  )
                : Colors.black.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                  ),
            blurRadius: _isPressed
                ? EcoPlatesDesignTokens.elevation.mediumBlur
                : EcoPlatesDesignTokens.elevation.largeBlur,
            offset: Offset(
              0,
              _isPressed
                  ? EcoPlatesDesignTokens.elevation.standardOffset.dy
                  : EcoPlatesDesignTokens.elevation.elevatedOffset.dy,
            ),
            spreadRadius: _isPressed ? -1.0 : 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xl),
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
      padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
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
            spacing: context.scaleXXS_XS_SM_MD * 1.5,
            children: widget.merchant.tags!
                .take(3)
                .map((tag) => RestaurantTag(tag: tag))
                .toList(),
          ),
          SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
        ],

        // Nom du commerçant
        Text(
          widget.merchant.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
              ),
            ],
            letterSpacing: 0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: widget.merchant.name,
        ),

        SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

        // Type de cuisine
        Text(
          widget.merchant.cuisineType,
          style: TextStyle(
            color: Colors.white.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
            fontSize: EcoPlatesDesignTokens.typography.hint(context),
            shadows: [
              Shadow(
                blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

        // Ligne d'infos (rating, distance, prix)
        _buildInfoRow(),

        SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

        // Horaire de collecte
        _buildPickupTime(),
      ],
    );
  }

  Widget _buildInfoRow() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: context.scaleXXS_XS_SM_MD,
      runSpacing: context.scaleXXS_XS_SM_MD / 2,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingDisplay(rating: widget.merchant.rating),
            SizedBox(width: context.scaleXXS_XS_SM_MD * 1.5),
            _buildDistanceBadge(),
          ],
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: PriceInfo(
                hasActiveOffer: widget.merchant.hasActiveOffer,
                originalPrice: widget.merchant.originalPrice,
                discountedPrice: widget.merchant.discountedPrice,
                minPrice: widget.merchant.minPrice,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXXS_XS_SM_MD,
        vertical: context.scaleXXS_XS_SM_MD / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: EcoPlatesDesignTokens.opacity.subtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: EcoPlatesDesignTokens.size.icon(context) / 2,
            color: Colors.white,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD / 4),
          Text(
            widget.merchant.distanceText,
            style: TextStyle(
              color: Colors.white,
              fontSize: EcoPlatesDesignTokens.typography.hint(context) - 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupTime() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXXS_XS_SM_MD,
        vertical: context.scaleXXS_XS_SM_MD / 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: EcoPlatesDesignTokens.opacity.pressed,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: EcoPlatesDesignTokens.opacity.subtle,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: EcoPlatesDesignTokens.size.icon(context) * 0.8,
            color: Colors.white,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD * 1.5),
          Flexible(
            child: Text(
              'Collecte : ${widget.merchant.pickupTime}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: EcoPlatesDesignTokens.typography.hint(context) - 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBadges() {
    return Positioned(
      top: context.scaleXS_SM_MD_LG,
      left: context.scaleXS_SM_MD_LG,
      right: EcoPlatesDesignTokens.size.minTouchTarget,
      child: Row(
        children: [
          // Badge de réduction
          if (widget.merchant.hasActiveOffer) ...[
            DiscountBadge(
              discountPercentage: widget.merchant.discountPercentage,
              animationsEnabled: _animationsEnabled,
            ),
            if (_isPopular) SizedBox(width: context.scaleXXS_XS_SM_MD),
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
