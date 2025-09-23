import 'package:flutter/material.dart';
import '../../../domain/entities/food_offer.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Widget de carte pour afficher une offre anti-gaspillage
/// Utilisable dans toutes les listes et grilles de l'application
class OfferCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
              Stack(
                children: [
                  // Image principale
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: offer.images.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: offer.images.first,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  _buildPlaceholderImage(),
                            )
                          : _buildPlaceholderImage(),
                    ),
                  ),

                  // Badge de réduction en haut à gauche
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: offer.isFree ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        offer.discountBadge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  // Badge de temps restant en haut à droite
                  if (offer.canPickup)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimeRemaining(offer.timeRemaining),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Quantité disponible
                  if (offer.quantity > 0)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${offer.quantity} restant${offer.quantity > 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Contenu de la carte
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom du commerçant et catégorie
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            offer.merchantName,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildCategoryChip(offer.category),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Titre de l'offre
                    Text(
                      offer.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Description
                    Text(
                      offer.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Informations du bas
                    Row(
                      children: [
                        // Prix
                        Expanded(
                          child: Row(
                            children: [
                              if (!offer.isFree) ...[
                                Text(
                                  '€${offer.originalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                offer.priceText,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: offer.isFree
                                      ? Colors.green
                                      : theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Distance et horaire
                        Row(
                          children: [
                            if (showDistance && distance != null) ...[
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${distance!.toStringAsFixed(1)} km',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatPickupTime(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Badges diététiques
                    if (offer.isVegetarian || offer.isVegan || offer.isHalal)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            if (offer.isVegan)
                              _buildDietBadge('Vegan', Colors.green),
                            if (offer.isVegetarian && !offer.isVegan)
                              _buildDietBadge('Végétarien', Colors.lightGreen),
                            if (offer.isHalal)
                              _buildDietBadge('Halal', Colors.orange),
                          ],
                        ),
                      ),

                    // Impact écologique
                    if (offer.co2Saved > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(Icons.eco, size: 16, color: Colors.green[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${(offer.co2Saved / 1000).toStringAsFixed(1)} kg CO₂ économisés',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[600],
                              ),
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
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          _getIconForType(offer.type),
          size: 48,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  IconData _getIconForType(OfferType type) {
    switch (type) {
      case OfferType.panier:
        return Icons.shopping_basket;
      case OfferType.plat:
        return Icons.restaurant;
      case OfferType.boulangerie:
        return Icons.bakery_dining;
      case OfferType.fruits:
        return Icons.apple;
      case OfferType.epicerie:
        return Icons.storefront;
      default:
        return Icons.fastfood;
    }
  }

  Widget _buildCategoryChip(FoodCategory category) {
    String label;
    Color color;

    switch (category) {
      case FoodCategory.petitDejeuner:
        label = 'Petit-déj';
        color = Colors.orange;
        break;
      case FoodCategory.dejeuner:
        label = 'Déjeuner';
        color = Colors.blue;
        break;
      case FoodCategory.diner:
        label = 'Dîner';
        color = Colors.purple;
        break;
      case FoodCategory.snack:
        label = 'Snack';
        color = Colors.pink;
        break;
      case FoodCategory.dessert:
        label = 'Dessert';
        color = Colors.brown;
        break;
      case FoodCategory.boisson:
        label = 'Boisson';
        color = Colors.cyan;
        break;
      case FoodCategory.boulangerie:
        label = 'Boulangerie';
        color = Colors.amber;
        break;
      case FoodCategory.fruitLegume:
        label = 'Fruits/Légumes';
        color = Colors.green;
        break;
      case FoodCategory.epicerie:
        label = 'Épicerie';
        color = Colors.teal;
        break;
      default:
        label = 'Autre';
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDietBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatPickupTime() {
    final start = offer.pickupStartTime;
    final end = offer.pickupEndTime;
    return '${start.hour.toString().padLeft(2, '0')}h${start.minute.toString().padLeft(2, '0')} - '
        '${end.hour.toString().padLeft(2, '0')}h${end.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}j';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}min';
    } else {
      return 'Urgent';
    }
  }
}
