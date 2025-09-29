import 'package:flutter/material.dart';

import '../../core/services/image_cache_service.dart';
import '../../core/widgets/eco_cached_image.dart';
import '../../domain/entities/brand.dart';

/// Carte horizontale avec image de fond de nourriture
class BrandCard extends StatelessWidget {
  const BrandCard({required this.brand, super.key, this.onTap});
  final Brand brand;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: 16.0 * 2.5,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image de fond
              EcoCachedImage(
                imageUrl: _getFoodImageUrl(brand.category),
                size: ImageSize.small,
                placeholder: Container(
                  color: isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                ),
                errorWidget: Container(
                  color: isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              // Overlay gradient pour la lisibilité
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              // Contenu principal
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  children: [
                    // Zone texte pleine largeur, avec marge basse pour le logo
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 52.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Brand Name - Taille augmentée
                            Text(
                              brand.name,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 4.0,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            // Pousse le sous-titre et les offres vers le bas
                            const Spacer(),
                            // Sous-titre et offres décalés vers la droite
                            Padding(
                              padding: EdgeInsets.only(
                                left: 52.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category - Taille augmentée
                                  Text(
                                    brand.category,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  // Stats Row
                                  Row(
                                    children: [
                                      // Offers
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16.0,
                                          ),
                                        ),
                                        child: Text(
                                          '${brand.activeOffers} offres',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      // Discount
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 2.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade600,
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                        ),
                                        child: Text(
                                          '${brand.averageDiscount.toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Arrow
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Logo en bas à gauche
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: 16.0 * 3,
                        height: 16.0 * 3,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: EcoCachedImage(
                                imageUrl: brand.logoUrl,
                                width: 16.0 * 2,
                                height: 16.0 * 2,
                                fit: BoxFit.contain,
                                size: ImageSize.thumbnail,
                                placeholder: SizedBox(
                                  width: 16.0,
                                  height: 16.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.primaryColor.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                                errorWidget: Icon(
                                  Icons.storefront_outlined,
                                  size: 16.0,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            // Badge Premium/New
                            if (brand.isPremium || brand.isNew)
                              Positioned(
                                top: -4.0,
                                right: -4.0,
                                child: Container(
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: brand.isPremium
                                        ? Colors.amber.shade100
                                        : Colors.green.shade100,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Icon(
                                    brand.isPremium
                                        ? Icons.star
                                        : Icons.new_releases,
                                    size: 5.0,
                                    color: brand.isPremium
                                        ? Colors.amber.shade700
                                        : Colors.green.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Retourne l'URL d'une image de fond selon la catégorie
  String _getFoodImageUrl(String category) {
    switch (category.toLowerCase()) {
      case 'supermarché':
      case 'hypermarché':
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=200&fit=crop&crop=center';
      case 'boulangerie':
        return 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=200&fit=crop&crop=center';
      case 'café':
        return 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&h=200&fit=crop&crop=center';
      case 'restaurant':
        return 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=200&fit=crop&crop=center';
      case 'surgelés':
        return 'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?w=400&h=200&fit=crop&crop=center';
      default:
        return 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=200&fit=crop&crop=center';
    }
  }
}
