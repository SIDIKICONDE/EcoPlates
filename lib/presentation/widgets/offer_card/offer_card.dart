import 'package:flutter/material.dart';
import '../../../domain/entities/food_offer.dart';
import 'widgets/offer_card_image.dart';
import 'widgets/offer_card_content.dart';

/// Widget de carte pour afficher une offre anti-gaspillage
/// Utilisable dans toutes les listes et grilles de l'application
class OfferCard extends StatefulWidget {
  final FoodOffer offer;
  final VoidCallback? onTap;
  final bool showDistance;
  final double? distance; // en km

  const OfferCard({
    super.key,
    required this.offer,
    this.onTap,
    this.showDistance = true,
    this.distance,
  });

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
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
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: _buildSemanticLabel(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image avec badges
                OfferCardImage(offer: widget.offer),
                
                // Contenu de la carte
                OfferCardContent(
                  offer: widget.offer,
                  showDistance: widget.showDistance,
                  distance: widget.distance,
                ),
              ],
            ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _buildSemanticLabel() {
    final buffer = StringBuffer();
    buffer.write('${widget.offer.title} chez ${widget.offer.merchantName}. ');
    buffer.write('Prix: ${widget.offer.priceText}. ');
    
    if (widget.offer.isFree) {
      buffer.write('Offre gratuite. ');
    } else {
      buffer.write('Réduction de ${widget.offer.discountPercentage.toStringAsFixed(0)}%. ');
    }
    
    if (widget.showDistance && widget.distance != null) {
      buffer.write('À ${widget.distance!.toStringAsFixed(1)} kilomètres. ');
    }
    
    if (widget.offer.canPickup) {
      buffer.write('Collecte disponible. ');
    }
    
    return buffer.toString();
  }
}