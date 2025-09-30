import 'package:flutter/material.dart';

import '../../core/themes/tokens/deep_color_tokens.dart';
import '../../domain/entities/food_offer.dart';
import 'offer_card/component/offer_card_content.dart';
import 'offer_card/component/offer_card_image.dart';
import 'offer_card/offer_card_configs.dart';

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
    this.imageBorderRadius,
    this.isHomeSection =
        false, // Indique si c'est utilisé dans une section d'accueil
  });
  final FoodOffer offer;
  final VoidCallback? onTap;
  final bool showDistance;
  final double? distance; // en km
  final bool compact;
  final BorderRadius? imageBorderRadius;
  final bool isHomeSection;

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
                color: isDark
                    ? DeepColorTokens.surface
                    : DeepColorTokens.neutral0,
                borderRadius: BorderRadius.circular(
                  8.0,
                ), // Radius réduit pour un look moins arrondi
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
                    // Section image - prend l'espace restant
                    Expanded(
                      child: OfferCardImage(
                        offer: widget.offer,
                        compact: widget.compact,
                        borderRadius:
                            widget.imageBorderRadius ??
                            (widget.isHomeSection
                                ? OfferCardConfigs
                                      .homeSections
                                      .imageBorderRadius
                                : OfferCardConfigs
                                      .defaultConfig
                                      .imageBorderRadius),
                      ),
                    ),

                    // Section contenu - hauteur augmentée pour réduire l'espace en bas
                    SizedBox(
                      height: widget.compact ? 100.0 : 140.0,
                      child: OfferCardContent(
                        offer: widget.offer,
                        showDistance: widget.showDistance,
                        distance: widget.distance,
                        compact: widget.compact,
                      ),
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
    final buffer = StringBuffer()
      ..write('${widget.offer.title} chez ${widget.offer.merchantName}. ')
      ..write('Prix: ${widget.offer.priceText}. ');

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
