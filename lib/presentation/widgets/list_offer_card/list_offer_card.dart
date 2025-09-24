import 'package:flutter/material.dart';

import '../../../core/extensions/food_offer_extensions.dart';
import '../../../domain/entities/food_offer.dart';
import '../closed_badge.dart';
import 'merchant_logo_with_badge.dart';
import 'offer_background_image.dart';
import 'offer_info_section.dart';

/// Carte horizontale style BrandCard pour les offres
class ListOfferCard extends StatefulWidget {
  const ListOfferCard({
    required this.offer,
    super.key,
    this.onTap,
    this.distance,
  });

  final FoodOffer offer;
  final VoidCallback? onTap;
  final double? distance;

  @override
  State<ListOfferCard> createState() => _ListOfferCardState();
}

class _ListOfferCardState extends State<ListOfferCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _elevationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: widget.offer.semanticLabel,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDarkMode
                        ? 0.3 + (0.1 * _elevationAnimation.value)
                        : 0.08 + (0.06 * _elevationAnimation.value),
                    ),
                    blurRadius: 10 + (8 * _elevationAnimation.value),
                    offset: Offset(0, 4 + (4 * _elevationAnimation.value)),
                  ),
                  // Ombre secondaire pour plus de profondeur
                  if (_elevationAnimation.value > 0)
                    BoxShadow(
                      color: theme.primaryColor.withValues(
                        alpha: 0.1 * _elevationAnimation.value,
                      ),
                      blurRadius: 20 * _elevationAnimation.value,
                      offset: Offset(0, 8 * _elevationAnimation.value),
                    ),
                ],
              ),
              child: Stack(
                children: [
                  // Image de fond
                  OfferBackgroundImage(offer: widget.offer),

                  // Badge FERMÉ (si la boutique est fermée)
                  if (widget.offer.isClosed)
                    Positioned(
                      top: 3,
                      right: 3,
                      child: ClosedBadge(
                        size: BadgeSize.small,
                        reopenTime: widget.offer.reopenTime,
                      ),
                    ),

                  // Contenu principal
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Logo Restaurant
                        MerchantLogoWithBadge(
                          merchantName: widget.offer.merchantName,
                          availableQuantity: widget.offer.availableQuantity,
                        ),

                        const SizedBox(width: 12),

                        // Info Section
                        OfferInfoSection(
                          merchantName: widget.offer.merchantName,
                          title: widget.offer.title,
                          priceText: widget.offer.priceText,
                          isFree: widget.offer.isFree,
                          pickupTime: widget.offer.pickupTimeFormatted,
                          distance: widget.distance,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
