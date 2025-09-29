import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/extensions/food_offer_extensions.dart';
import '../../../domain/entities/food_offer.dart';
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

class _ListOfferCardState extends State<ListOfferCard>
    with SingleTickerProviderStateMixin {
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
    _scaleAnimation =
        Tween<double>(
          begin: 1.0,
          end: 0.95,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ),
        );
    _elevationAnimation =
        Tween<double>(
          begin: 2.0,
          end: 8.0,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    unawaited(_controller.forward());
  }

  void _handleTapUp(TapUpDetails details) {
    unawaited(_controller.reverse());
  }

  void _handleTapCancel() {
    unawaited(_controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
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
              height: 120.0,
              margin: EdgeInsets.only(
                bottom: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8.0,
                    offset: Offset(0.0, 4.0),
                  ),
                  // Ombre secondaire pour plus de profondeur
                  if (_elevationAnimation.value > 0)
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.1),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0.0, _elevationAnimation.value / 2),
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
                      top: 8.0,
                      right: 8.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'FERMÉ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Contenu principal
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Logo Restaurant
                        MerchantLogoWithBadge(
                          merchantName: widget.offer.merchantName,
                          availableQuantity: widget.offer.availableQuantity,
                        ),

                        SizedBox(width: 16.0),

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
