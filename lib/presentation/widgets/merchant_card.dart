import 'package:flutter/material.dart';
import '../../core/utils/accessibility_helper.dart';
import '../../domain/entities/merchant.dart';
import 'common/offer_card_favorite_button.dart';
import 'restaurant_card_components/popularity_badge.dart';
import 'restaurant_card_components/price_info.dart';
import 'restaurant_card_components/rating_display.dart';
import 'restaurant_card_components/restaurant_tag.dart';

/// Carte de merchant moderne et modulaire
class MerchantCard extends StatefulWidget {
  const MerchantCard({required this.merchant, super.key, this.onTap});
  final Merchant merchant;
  final VoidCallback? onTap;

  @override
  State<MerchantCard> createState() => _MerchantCardState();
}

class _MerchantCardState extends State<MerchantCard> {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: _buildCard(context, isDarkMode),
        ),
      ),
    );
  }

  void _onTapDown() {
    if (mounted) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp() {
    if (mounted) {
      setState(() => _isPressed = false);
    }
    widget.onTap?.call();
  }

  void _onTapCancel() {
    if (mounted) {
      setState(() => _isPressed = false);
    }
  }

  Widget _buildCard(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16.0,
            spreadRadius: _isPressed ? -1.0 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            // Contenu principal
            _buildMainContent(context),

            // Badges supérieurs
            _buildTopBadges(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton favori en haut à droite
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OfferCardFavoriteButton(
                isFavorite: widget.merchant.isFavorite,
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
            spacing: 8.0,
            children: widget.merchant.tags!
                .take(3)
                .map((tag) => RestaurantTag(tag: tag))
                .toList(),
          ),
          const SizedBox(height: 4.0),
        ],

        // Nom du commerçant
        Text(
          widget.merchant.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                blurRadius: 16.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),

        // Type de cuisine
        Text(
          widget.merchant.cuisineType,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14.0,
            shadows: const [
              Shadow(
                blurRadius: 16.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),

        // Ligne d'infos (rating, distance, prix)
        _buildInfoRow(),

        const SizedBox(height: 4.0),

        // Horaire de collecte
        _buildPickupTime(),
      ],
    );
  }

  Widget _buildInfoRow() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingDisplay(rating: widget.merchant.rating),
            const SizedBox(width: 12.0),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: 12.0,
            color: Colors.white,
          ),
          const SizedBox(width: 2.0),
          Text(
            widget.merchant.distanceText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupTime() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 12.0,
            color: Colors.white,
          ),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              'Collecte : ${widget.merchant.pickupTime}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
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
      top: 16.0,
      left: 16.0,
      right: 16.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Badge de popularité
          if (_isPopular) const PopularityBadge(),
        ],
      ),
    );
  }

  // Getters helper
  bool get _isPopular => widget.merchant.rating >= 4.5;
}
