import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/food_offer.dart';
import 'offer_discount_badge.dart';
import 'offer_time_badge.dart';
import 'offer_quantity_badge.dart';

/// Widget spécialisé pour afficher l'image principale d'une carte d'offre
/// Inclut tous les badges informatifs (réduction, temps restant, quantité)
/// Utilise CachedNetworkImage pour optimiser les performances réseau
/// Respecte les standards EcoPlates avec une mise en page moderne et accessible
class OfferCardImage extends StatelessWidget {
  /// L'offre alimentaire dont on affiche l'image et les badges
  final FoodOffer offer;

  const OfferCardImage({
    super.key,
    required this.offer,
  });

  /// Construit le widget avec une mise en page en stack pour superposer les badges
  /// Utilise un système de padding cohérent avec les autres composants de carte
  /// Optimise les performances avec CachedNetworkImage et gestion d'erreur
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          // Section image principale avec coins arrondis
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Image principale avec ratio 16:9 optimisé pour mobile
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: offer.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: offer.images.first,
                          fit: BoxFit.cover,
                          // Placeholder pendant le chargement
                          placeholder: (context, url) => const _ImagePlaceholder(
                            child: CircularProgressIndicator(),
                          ),
                          // Widget d'erreur avec icône contextuelle
                          errorWidget: (context, url, error) =>
                              _OfferPlaceholderImage(type: offer.type),
                        )
                      : _OfferPlaceholderImage(type: offer.type),
                ),
                // Bordure interne subtile pour améliorer la définition visuelle
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 0.25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Badge promotionnel en haut à gauche (priorité haute visibilité)
          Positioned(
            top: 16,
            left: 16,
            child: OfferDiscountBadge(
              isFree: offer.isFree,
              discountBadge: offer.discountBadge,
            ),
          ),

          // Badge temporel en haut à droite (urgence pour dernières minutes)
          if (offer.canPickup)
            Positioned(
              top: 16,
              right: 16,
              child: _buildContextualBadge(),
            ),

          // Indicateur de stock en bas à droite (quantité restante)
          if (offer.quantity > 0)
            Positioned(
              bottom: 16,
              right: 16,
              child: OfferQuantityBadge(
                quantity: offer.quantity,
              ),
            ),
        ],
      ),
    );
  }
  
  /// Construit le badge contextuel selon l'état de l'offre
  Widget _buildContextualBadge() {
    final timeUntilEnd = offer.pickupEndTime.difference(DateTime.now());
    
    // Badge "Dernière minute" si moins de 2 heures
    if (timeUntilEnd.inHours < 2) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer, color: Colors.white, size: 12),
            SizedBox(width: 4),
            Text(
              'Dernière minute',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    // Badge "Nouveau" si créé dans les dernières 24h
    final isNew = DateTime.now().difference(offer.createdAt).inHours < 24;
    if (isNew) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: 12),
            SizedBox(width: 4),
            Text(
              'Nouveau',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    // Badge "Populaire" si beaucoup de quantité vendue (on simule)
    if (offer.quantity < 5 && offer.quantity > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department, color: Colors.white, size: 12),
            SizedBox(width: 4),
            Text(
              'Populaire',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    // Badge temps restant par défaut
    return OfferTimeBadge(
      timeRemaining: offer.timeRemaining,
    );
  }
}

/// Widget placeholder générique pour afficher pendant le chargement d'images
/// Utilise une couleur de fond neutre et centre le contenu enfant
/// Peut contenir un CircularProgressIndicator ou autre indicateur de chargement
class _ImagePlaceholder extends StatelessWidget {
  /// Le widget enfant à afficher au centre (typiquement un indicateur de chargement)
  final Widget child;

  const _ImagePlaceholder({
    required this.child,
  });

  /// Construit un container avec couleur de fond et centrage du contenu
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(child: child),
    );
  }
}

/// Widget d'image par défaut contextuel selon le type d'offre alimentaire
/// Affiche une icône représentative du type de nourriture pour améliorer l'identification
/// Utilisé quand l'image réseau n'est pas disponible ou en cas d'erreur de chargement
/// Respecte le design system avec des icônes Material Design cohérentes
class _OfferPlaceholderImage extends StatelessWidget {
  /// Le type d'offre pour déterminer l'icône appropriée
  final OfferType type;

  const _OfferPlaceholderImage({
    required this.type,
  });

  /// Construit un container avec icône centrée et stylisée
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          _getIconForType(type),
          size: 48,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  /// Sélectionne l'icône Material Design appropriée selon le type d'offre
  /// Utilise des icônes évocatrices pour faciliter la reconnaissance visuelle
  /// Retourne une icône par défaut si le type n'est pas reconnu
  IconData _getIconForType(OfferType type) {
    switch (type) {
      case OfferType.panier:
        return Icons.shopping_basket; // Panier complet
      case OfferType.plat:
        return Icons.restaurant; // Repas préparé
      case OfferType.boulangerie:
        return Icons.bakery_dining; // Produits de boulangerie
      case OfferType.fruits:
        return Icons.apple; // Fruits et légumes
      case OfferType.epicerie:
        return Icons.storefront; // Épicerie générale
      default:
        return Icons.fastfood; // Nourriture générique par défaut
    }
  }
}