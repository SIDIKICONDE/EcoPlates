import 'package:flutter/material.dart';

import '../../../../core/services/image_cache_service.dart';
import '../../../../core/widgets/eco_cached_image.dart';
import '../../../../domain/entities/food_offer.dart';
import 'offer_quantity_badge.dart';
import 'offer_rating_badge.dart';

/// Widget spécialisé pour afficher l'image principale d'une carte d'offre
/// Inclut tous les badges informatifs (réduction, temps restant, quantité)
/// Utilise CachedNetworkImage pour optimiser les performances réseau
/// Respecte les standards EcoPlates avec une mise en page moderne et accessible
class OfferCardImage extends StatelessWidget {
  const OfferCardImage({
    required this.offer,
    super.key,
    this.compact = false,
  });
  
  /// L'offre alimentaire dont on affiche l'image et les badges
  final FoodOffer offer;
  /// Mode compact pour réduire la hauteur de l'image
  final bool compact;

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
                // Image principale avec ratio adaptatif (compact: 2:1, normal: 16:9)
                AspectRatio(
                  aspectRatio: compact ? 2 / 1 : 16 / 9,
                  child: offer.images.isNotEmpty
                      ? EcoCachedImage(
                          imageUrl: offer.images.first,
                          fit: BoxFit.cover,
                          size: compact ? ImageSize.small : ImageSize.medium,
                          priority: Priority.high, // Haute priorité pour les images d'offres
                          borderRadius: BorderRadius.circular(12),
                          // Placeholder optimisé inclus
                          errorWidget: _OfferPlaceholderImage(type: offer.type),
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

          // Badge nombre de produits restants en haut à gauche
          if (offer.quantity > 0)
            Positioned(
              top: 16,
              left: 16,
              child: OfferQuantityBadge(
                quantity: offer.quantity,
              ),
            ),

          // Badge rating de l'enseigne en haut à droite
          Positioned(
            top: 16,
            right: 16,
            child: OfferRatingBadge(
              rating: _getMerchantRating(),
            ),
          ),

            
          // Logo de l'enseigne en bas à gauche
          Positioned(
            bottom: 12,
            left: 12,
            child: _buildMerchantLogo(),
          ),
        ],
      ),
    );
  }
  
  
  /// Construit le logo de l'enseigne
  Widget _buildMerchantLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: _getMerchantLogo(),
      ),
    );
  }
  
  /// Génère le logo selon le nom de l'enseigne
  Widget _getMerchantLogo() {
    final merchantName = offer.merchantName.toLowerCase();
    
    // URLs des vrais logos des enseignes
    String? logoUrl;
    var backgroundColor = Colors.white;
    
    if (merchantName.contains('mcdonald')) {
      logoUrl = 'https://logos-world.net/wp-content/uploads/2020/04/McDonalds-Logo.png';
      backgroundColor = Colors.red[50]!;
    }
    else if (merchantName.contains('carrefour')) {
      logoUrl = 'https://logos-world.net/wp-content/uploads/2020/11/Carrefour-Logo.png';
      backgroundColor = Colors.blue[50]!;
    }
    else if (merchantName.contains('starbucks')) {
      logoUrl = 'https://logos-world.net/wp-content/uploads/2020/04/Starbucks-Logo.png';
      backgroundColor = Colors.green[50]!;
    }
    else if (merchantName.contains('monoprix')) {
      logoUrl = 'https://logos-world.net/wp-content/uploads/2020/12/Monoprix-Logo.png';
      backgroundColor = Colors.purple[50]!;
    }
    else if (merchantName.contains('paul')) {
      logoUrl = 'https://upload.wikimedia.org/wikipedia/fr/thumb/3/3a/Logo_Paul.svg/1200px-Logo_Paul.svg.png';
      backgroundColor = Colors.brown[50]!;
    }
    
    // Si on a une URL de logo, on l'affiche
    if (logoUrl != null) {
      return ColoredBox(
        color: backgroundColor,
        child: EcoCachedImage(
          imageUrl: logoUrl,
          size: ImageSize.thumbnail, // Logos sont petits
          errorWidget: _getFallbackLogo(merchantName),
        ),
      );
    }
    
    // Fallback pour les enseignes inconnues
    return _getFallbackLogo(merchantName);
  }
  
  /// Logo de fallback avec la première lettre
  Widget _getFallbackLogo(String merchantName) {
    final firstLetter = offer.merchantName.isNotEmpty 
        ? offer.merchantName[0].toUpperCase()
        : '?';
        
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  /// Génère un rating pour l'enseigne
  double _getMerchantRating() {
    final merchantName = offer.merchantName.toLowerCase();
    
    // Ratings simulés pour les enseignes connues
    if (merchantName.contains('mcdonald')) {
      return 4.2;
    }
    else if (merchantName.contains('carrefour')) {
      return 4.1;
    }
    else if (merchantName.contains('starbucks')) {
      return 4.5;
    }
    else if (merchantName.contains('monoprix')) {
      return 3.9;
    }
    else if (merchantName.contains('paul')) {
      return 4.3;
    }
    // Rating générique pour les autres enseignes
    else {
      return 4.0;
    }
  }
}

/// Widget d'image par défaut contextuel selon le type d'offre alimentaire
/// Affiche une icône représentative du type de nourriture pour améliorer l'identification
/// Utilisé quand l'image réseau n'est pas disponible ou en cas d'erreur de chargement
/// Respecte le design system avec des icônes Material Design cohérentes
class _OfferPlaceholderImage extends StatelessWidget {
  const _OfferPlaceholderImage({
    required this.type,
  });
  
  /// Le type d'offre pour déterminer l'icône appropriée
  final OfferType type;

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
      case OfferType.autre:
        return Icons.fastfood; // Nourriture générique par défaut
    }
  }
}
