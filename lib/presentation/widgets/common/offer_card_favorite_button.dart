import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_utils.dart';

/// Bouton favori flottant réutilisable pour les cartes d'offres
class OfferCardFavoriteButton extends StatefulWidget {
  const OfferCardFavoriteButton({
    required this.isFavorite,
    super.key,
  });

  final bool isFavorite;

  @override
  State<OfferCardFavoriteButton> createState() =>
      _OfferCardFavoriteButtonState();
}

class _OfferCardFavoriteButtonState extends State<OfferCardFavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails details) async {
    try {
      await _controller.forward();
      await _controller.reverse();
    } on Exception {
      // Ignore animation errors
    }
    if (!mounted) return;
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(
        12,
        1,
      ), // Déplacement vers la droite et légèrement vers le haut
      child: Semantics(
        button: true,
        label: _isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
        child: GestureDetector(
          onTapDown: _onTapDown,
          behavior:
              HitTestBehavior.opaque, // Capte le tap et n'active pas la carte
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            child: Center(
              child: ScaleTransition(
                scale: _scale,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: _isFavorite
                      ? Icon(
                          Icons.favorite,
                          key: const ValueKey<bool>(true),
                          size: ResponsiveUtils.getIconSize(
                            context,
                            baseSize: 24.0,
                          ),
                          color: Colors.red,
                        )
                      : ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const RadialGradient(
                              center: Alignment.center,
                              radius: 1.0,
                              colors: [
                                Color(0xFFF1F8E9), // Vert ultra-clair (centre)
                                Color(0xFFE8F5E8), // Vert très clair
                                Color(0xFFC8E6C9), // Vert pastel
                                Color(0xFFA5D6A7), // Vert clair
                                Color(0xFF81C784), // Vert
                                Color(0xFF66BB6A), // Vert vif
                                Color(0xFF4CAF50), // Vert standard
                                Color(0xFF43A047), // Vert profond
                                Color.fromARGB(255, 9, 68, 11), // Vert foncé
                                Color(0xFFF1F8E9), // Vert ultra-clair (bord)
                              ],
                              stops: [
                                0.0,
                                0.1,
                                0.2,
                                0.3,
                                0.4,
                                0.5,
                                0.6,
                                0.7,
                                0.8,
                                1.0,
                              ],
                            ).createShader(bounds);
                          },
                          child: Icon(
                            Icons.favorite_border,
                            key: const ValueKey<bool>(false),
                            size: ResponsiveUtils.getIconSize(
                              context,
                              baseSize: 24,
                            ),
                            color:
                                Colors.white, // Couleur de base pour le shader
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
