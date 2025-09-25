import 'package:flutter/material.dart';

import '../../domain/entities/food_offer.dart';
import 'offer_card/widgets/offer_card_content.dart';
import 'offer_card/widgets/offer_card_image.dart';

/// Widget de carte pour afficher une offre anti-gaspillage
/// Utilisable dans toutes les listes et grilles de l'application
class OfferCard extends StatefulWidget {
  // Mode compact pour réduire la hauteur

  const OfferCard({
    required this.offer,
    super.key,
    this.onTap,
    this.showDistance = true,
    this.distance,
    this.compact = false,
    this.showInactiveBadge = false,
  });
  final FoodOffer offer;
  final VoidCallback? onTap;
  final bool showDistance;
  final double? distance; // en km
  final bool compact;
  final bool showInactiveBadge;

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard>
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
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _elevationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark
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
              child: ColorFiltered(
                colorFilter: !widget.offer.isAvailable
                    ? const ColorFilter.matrix(<double>[
                        0.2126, 0.7152, 0.0722, 0, 0, // Rouge
                        0.2126, 0.7152, 0.0722, 0, 0, // Vert
                        0.2126, 0.7152, 0.0722, 0, 0, // Bleu
                        0, 0, 0, 1, 0, // Alpha
                      ])
                    : const ColorFilter.matrix(<double>[
                        1, 0, 0, 0, 0, // Rouge
                        0, 1, 0, 0, 0, // Vert
                        0, 0, 1, 0, 0, // Bleu
                        0, 0, 0, 1, 0, // Alpha
                      ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image avec badges
                    OfferCardImage(
                      offer: widget.offer,
                      compact: widget.compact,
                      showInactiveBadge: widget.showInactiveBadge,
                    ),

                    // Contenu de la carte
                    OfferCardContent(
                      offer: widget.offer,
                      showDistance: widget.showDistance,
                      distance: widget.distance,
                      compact: widget.compact,
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
      buffer.write(
        'Réduction de ${widget.offer.discountPercentage.toStringAsFixed(0)}%. ',
      );
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
