import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../core/services/image_cache_service.dart';
import '../../../../core/widgets/eco_cached_image.dart';
import '../../../../domain/entities/food_offer.dart';

/// Widget spécialisé pour afficher l'image principale d'une carte d'offre
/// Utilise CachedNetworkImage pour optimiser les performances réseau
/// Respecte les standards EcoPlates avec une mise en page moderne et accessible
class OfferCardImage extends StatelessWidget {
  const OfferCardImage({
    required this.offer,
    super.key,
    this.compact = false,
    this.borderRadius,
  });

  /// L'offre alimentaire dont on affiche l'image
  final FoodOffer offer;

  /// Mode compact pour réduire la hauteur de l'image
  final bool compact;

  /// Rayon des coins arrondis personnalisé (optionnel)
  final BorderRadius? borderRadius;

  /// Construit le widget avec une mise en page optimisée
  /// Utilise un système de padding cohérent avec les autres composants de carte
  /// Optimise les performances avec CachedNetworkImage et gestion d'erreur
  @override
  Widget build(BuildContext context) {
    // Calculer la hauteur optimale pour l'image sur PC et desktop
    final imageHeight = _calculateOptimalImageHeight(context);

    return Padding(
      padding: const EdgeInsets.all(1.0), // Valeur fixe simplifiée
      child: Stack(
        children: [
          // Section image principale avec coins arrondis
          ClipRRect(
            borderRadius:
                borderRadius ??
                BorderRadius.circular(
                  3.0,
                ), // Coins moins arrondis à 3 pixels
            child: AbsorbPointer(
              // absorbing: true est la valeur par défaut
              child: SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: offer.images.isNotEmpty
                    ? EcoCachedImage(
                        imageUrl: offer.images.first,
                        size: compact ? ImageSize.small : ImageSize.medium,
                        priority: Priority
                            .high, // Haute priorité pour les images d'offres
                        borderRadius:
                            borderRadius ??
                            BorderRadius.circular(
                              3.0,
                            ), // Cohérent avec l'image principale
                      )
                    : _OfferPlaceholderImage(height: imageHeight),
              ),
            ),
          ),

          // Bordure interne subtile pour améliorer la définition visuelle
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  3.0,
                ), // Cohérent avec l'image principale
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 6.0,
                ),
              ),
            ),
          ),

          // Logo du marchand en overlay
          if (offer.merchantLogo != null && offer.merchantLogo!.isNotEmpty)
            Positioned(
              bottom: compact
                  ? ResponsiveUtils.getVerticalSpacing(context) / 4
                  : ResponsiveUtils.getVerticalSpacing(context) / 2,
              left: compact
                  ? ResponsiveUtils.getHorizontalSpacing(context) / 4
                  : ResponsiveUtils.getHorizontalSpacing(context) / 2,
              child: Container(
                width: compact
                    ? ResponsiveUtils.getIconSize(context, baseSize: 32.0)
                    : ResponsiveUtils.getIconSize(context, baseSize: 40.0),
                height: compact
                    ? ResponsiveUtils.getIconSize(context, baseSize: 32.0)
                    : ResponsiveUtils.getIconSize(context, baseSize: 40.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      borderRadius ??
                      BorderRadius.circular(
                        3.0,
                      ), // Cohérent avec l'image principale
                  child: EcoCachedImage(
                    imageUrl: offer.merchantLogo!,
                    size: compact ? ImageSize.small : ImageSize.medium,
                    fit: BoxFit
                        .cover, // Les logos remplissent complètement le cercle
                  ),
                ),
              ),
            )
          else
            // Logo de fallback avec initiale
            Positioned(
              bottom: compact
                  ? ResponsiveUtils.getVerticalSpacing(context) / 4
                  : ResponsiveUtils.getVerticalSpacing(context) / 2,
              left: compact
                  ? ResponsiveUtils.getHorizontalSpacing(context) / 4
                  : ResponsiveUtils.getHorizontalSpacing(context) / 2,
              child: Container(
                width: compact
                    ? ResponsiveUtils.getIconSize(context, baseSize: 32.0)
                    : ResponsiveUtils.getIconSize(context, baseSize: 40.0),
                height: compact
                    ? ResponsiveUtils.getIconSize(context, baseSize: 32.0)
                    : ResponsiveUtils.getIconSize(context, baseSize: 40.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    offer.merchantName.isNotEmpty
                        ? offer.merchantName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: compact ? 10.0 : 12.0, // Valeurs fixes
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Calcule la hauteur optimale pour l'image avec Expanded parent
  double _calculateOptimalImageHeight(BuildContext context) {
    return double.infinity; // S'adapte à l'espace disponible (Expanded)
  }

  /// Logo de fallback avec la première lettre (en cercle)
  Widget getFallbackLogo(String merchantName, BuildContext context) {
    final firstLetter = offer.merchantName.isNotEmpty
        ? offer.merchantName[0].toUpperCase()
        : '?';

    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 14.0, // Valeur fixe
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Bouton favoris flottant déplacé dans OfferCardContent

/// Widget d'image par défaut contextuel selon le type d'offre alimentaire
/// Affiche une icône représentative du type de nourriture pour améliorer l'identification
/// Utilisé quand l'image réseau n'est pas disponible ou en cas d'erreur de chargement
/// Respecte le design system avec des icônes Material Design cohérentes
class _OfferPlaceholderImage extends StatelessWidget {
  const _OfferPlaceholderImage({required this.height});

  /// La hauteur disponible pour l'image placeholder
  final double height;

  /// Construit un container avec icône centrée et stylisée
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: height * 0.3, // L'icône prend 30% de la hauteur disponible
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
