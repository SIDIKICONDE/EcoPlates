import 'package:flutter/material.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
import '../../core/utils/accessibility_helper.dart';
import '../../core/widgets/eco_cached_image.dart';
import '../../domain/entities/merchant.dart';
import 'common/offer_card_favorite_button.dart';
import 'restaurant_card_components/popularity_badge.dart';
import 'restaurant_card_components/price_info.dart';
import 'restaurant_card_components/rating_display.dart';
import 'restaurant_card_components/restaurant_tag.dart';

/// Carte de merchant moderne et modulaire
class MerchantCard extends StatefulWidget {
  const MerchantCard({
    required this.merchant,
    super.key,
    this.onTap,
  });

  final Merchant merchant;
  final VoidCallback? onTap;

  @override
  State<MerchantCard> createState() => _MerchantCardState();
}

class _MerchantCardState extends State<MerchantCard> {
  bool _isPressed = false;

  // Getters helper
  bool get _isPopular => widget.merchant.rating >= 4.5;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accessibilityLabel = AccessibilityHelper.buildMerchantLabel(
      name: widget.merchant.name,
      rating: widget.merchant.rating,
      category: widget.merchant.category,
      hasDiscount: widget.merchant.discountPercentage > 0,
      discountPercentage: widget.merchant.discountPercentage,
    );

    return AspectRatio(
      aspectRatio: 3 / 4, // Ratio 3:4 pour une carte verticale équilibrée
      child: Semantics(
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
      ),
    );
  }

  // ================== BUILD METHODS ==================

  Widget _buildCard(BuildContext context, bool isDarkMode) {
    final borderRadius = ResponsiveUtils.getBorderRadius(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.shadowLight,
            blurRadius: 16.0,
            spreadRadius: _isPressed ? -1.0 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackgroundImage(isDarkMode),
            _buildGradientOverlay(),
            _buildMainContent(context),
            _buildTopBadges(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(bool isDarkMode) {
    return EcoCachedImage(
      imageUrl: widget.merchant.imageUrl,
      placeholder: ColoredBox(
        color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
      ),
      errorWidget: ColoredBox(
        color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
        child: Icon(
          Icons.restaurant_outlined,
          color: isDarkMode
              ? DeepColorTokens.neutral0.withValues(alpha: 0.5)
              : DeepColorTokens.neutral1000.withValues(alpha: 0.5),
          size: 48.0,
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0x00000000),
            DeepColorTokens.neutral1000.withValues(alpha: 0.1),
            DeepColorTokens.neutral1000.withValues(alpha: 0.4),
            DeepColorTokens.neutral1000.withValues(alpha: 0.7),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final responsivePadding = ResponsiveUtils.getResponsivePadding(context);

    return Padding(
      padding: EdgeInsets.all(responsivePadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFavoriteButton(),
          _buildBottomInfo(context),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OfferCardFavoriteButton(
          isFavorite: widget.merchant.isFavorite,
        ),
      ],
    );
  }

  Widget _buildBottomInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTags(),
        _buildMerchantName(context),
        _buildCuisineType(context),
        _buildInfoRow(),
        const SizedBox(height: 4.0),
        _buildPickupTime(),
      ],
    );
  }

  Widget _buildTags() {
    if (widget.merchant.tags?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          children: widget.merchant.tags!
              .take(3)
              .map((tag) => RestaurantTag(tag: tag))
              .toList(),
        ),
        const SizedBox(height: 4.0),
      ],
    );
  }

  Widget _buildMerchantName(BuildContext context) {
    return Text(
      widget.merchant.name,
      style: TextStyle(
        color: DeepColorTokens.neutral0,
        fontSize: FontSizes.bodyLarge.getSize(context),
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            blurRadius: 16.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildCuisineType(BuildContext context) {
    return Text(
      widget.merchant.cuisineType,
      style: TextStyle(
        color: DeepColorTokens.neutral0.withValues(alpha: 0.8),
        fontSize: FontSizes.bodyMedium.getSize(context),
        shadows: const [
          Shadow(
            blurRadius: 16.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingDisplay(rating: widget.merchant.rating),
              const SizedBox(width: 12.0),
              _buildDistanceBadge(),
            ],
          ),
        ),
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
    final horizontalSpacing =
        ResponsiveUtils.getHorizontalSpacing(context) * 0.33;
    final verticalSpacing = ResponsiveUtils.getVerticalSpacing(context) * 0.17;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalSpacing,
        vertical: verticalSpacing,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral1000.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context) * 0.75,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: FontSizes.caption.getSize(context),
            color: DeepColorTokens.neutral0,
          ),
          SizedBox(width: horizontalSpacing * 0.25),
          Text(
            widget.merchant.distanceText,
            style: TextStyle(
              color: DeepColorTokens.neutral0,
              fontSize: FontSizes.caption.getSize(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupTime() {
    final horizontalSpacing =
        ResponsiveUtils.getHorizontalSpacing(context) * 0.33;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalSpacing,
        vertical: ResponsiveUtils.getVerticalSpacing(context) * 0.08,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.neutral0.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context) * 0.5,
        ),
        border: Border.all(
          color: DeepColorTokens.neutral0.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: FontSizes.caption.getSize(context),
            color: DeepColorTokens.neutral0,
          ),
          SizedBox(width: horizontalSpacing * 0.75),
          Flexible(
            child: Text(
              'Collecte : ${widget.merchant.pickupTime}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: DeepColorTokens.neutral0,
                fontSize: FontSizes.caption.getSize(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBadges() {
    if (!_isPopular) {
      return const SizedBox.shrink();
    }

    return const Positioned(
      top: 0,
      left: 0,
      child: PopularityBadge(),
    );
  }

  // ================== GESTURE HANDLERS ==================

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
}
