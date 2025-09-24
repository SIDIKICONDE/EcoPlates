import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/brand.dart';

/// Carte horizontale avec image de fond de nourriture
class BrandCard extends StatelessWidget {
  final Brand brand;
  final VoidCallback? onTap;

  const BrandCard({
    super.key,
    required this.brand,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100, // Hauteur fixe pour la carte
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Image de fond de nourriture
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: _getFoodImageUrl(brand.category),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fastfood,
                      size: 40,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
            
            // Overlay gradient pour la lisibilité
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            
            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Logo Section
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            imageUrl: brand.logoUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.primaryColor.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.storefront_outlined,
                              size: 24,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        
                        // Badge Premium/New
                        if (brand.isPremium || brand.isNew)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: brand.isPremium
                                    ? Colors.amber.shade100
                                    : Colors.green.shade100,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                brand.isPremium ? Icons.star : Icons.new_releases,
                                size: 8,
                                color: brand.isPremium
                                    ? Colors.amber.shade700
                                    : Colors.green.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Info Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand Name
                        Text(
                          brand.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        
                        // Category
                        Text(
                          brand.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 6),
                        
                        // Stats Row
                        Row(
                          children: [
                            // Offers
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                '${brand.activeOffers} offres',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // Discount
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${brand.averageDiscount.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Arrow
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
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
          ],
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