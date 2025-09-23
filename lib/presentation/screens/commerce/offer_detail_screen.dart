import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/commerce/offers_provider.dart';
import '../../providers/commerce/reservations_provider.dart';

/// Écran de détail d'une offre anti-gaspillage
class OfferDetailScreen extends ConsumerStatefulWidget {
  final String offerId;

  const OfferDetailScreen({
    super.key,
    required this.offerId,
  });

  @override
  ConsumerState<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends ConsumerState<OfferDetailScreen> {
  int quantity = 1;
  bool isReserving = false;


  Widget _buildContent(FoodOffer offer, ThemeData theme) {
    return CustomScrollView(
      slivers: [
        // Image avec AppBar transparent
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Image principale
                offer.images.isNotEmpty
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
                            _buildPlaceholderImage(offer),
                      )
                    : _buildPlaceholderImage(offer),
                
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                
                // Badges
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Badge de réduction
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
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
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge temps restant
                      if (offer.canPickup)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
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
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatTimeRemaining(offer.timeRemaining),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        
        // Contenu
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre et prix
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            offer.merchantName,
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!offer.isFree)
                          Text(
                            '€${offer.originalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[500],
                            ),
                          ),
                        Text(
                          offer.priceText,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: offer.isFree ? Colors.green : theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  offer.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Informations de collecte
                _buildInfoSection(
                  icon: Icons.schedule,
                  title: 'Horaire de collecte',
                  content: _formatPickupTime(offer),
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                
                // Adresse
                _buildInfoSection(
                  icon: Icons.location_on,
                  title: 'Adresse',
                  content: '${offer.location.address}\n${offer.location.postalCode} ${offer.location.city}',
                  subtitle: offer.location.additionalInfo,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                
                // Quantité disponible
                _buildInfoSection(
                  icon: Icons.inventory_2,
                  title: 'Disponibilité',
                  content: '${offer.quantity} panier${offer.quantity > 1 ? 's' : ''} disponible${offer.quantity > 1 ? 's' : ''}',
                  color: Colors.orange,
                ),
                const SizedBox(height: 24),
                
                // Badges diététiques
                if (offer.isVegetarian || offer.isVegan || offer.isHalal) ...[
                  const Text(
                    'Régimes alimentaires',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      if (offer.isVegan)
                        _buildDietChip('🌱 Vegan', Colors.green),
                      if (offer.isVegetarian && !offer.isVegan)
                        _buildDietChip('🥗 Végétarien', Colors.lightGreen),
                      if (offer.isHalal)
                        _buildDietChip('☪️ Halal', Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Allergènes
                if (offer.allergens.isNotEmpty) ...[
                  const Text(
                    'Allergènes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: offer.allergens.map((allergen) {
                      return Chip(
                        label: Text(allergen),
                        backgroundColor: Colors.red[50],
                        labelStyle: TextStyle(color: Colors.red[700]),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Impact écologique
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.eco,
                        size: 32,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Impact écologique',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'En réservant ce panier, vous économisez ${(offer.co2Saved / 1000).toStringAsFixed(1)} kg de CO₂',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Espacement pour le bouton flottant
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget flottant en bas pour la réservation
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offerAsync = ref.watch(offerByIdProvider(widget.offerId));
    
    return Scaffold(
      body: offerAsync.when(
        data: (offer) => Stack(
          children: [
            _buildContent(offer, theme),
            // Barre de réservation en bas
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Sélecteur de quantité
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: quantity < offer.quantity
                                  ? () => setState(() => quantity++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Bouton de réservation
                      Expanded(
                        child: ElevatedButton(
                          onPressed: offer.isAvailable && !isReserving
                              ? () => _reserveOffer(offer)
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isReserving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  offer.isFree
                                      ? 'Réserver gratuitement'
                                      : 'Réserver pour ${(offer.discountedPrice * quantity).toStringAsFixed(2)}€',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(offerByIdProvider(widget.offerId)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
    String? subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDietChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(FoodOffer offer) {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.restaurant,
          size: 64,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _formatPickupTime(FoodOffer offer) {
    final start = offer.pickupStartTime;
    final end = offer.pickupEndTime;
    final now = DateTime.now();
    
    String day = '';
    if (start.day == now.day) {
      day = 'Aujourd\'hui';
    } else if (start.day == now.day + 1) {
      day = 'Demain';
    } else {
      day = '${start.day}/${start.month}';
    }
    
    return '$day de ${start.hour.toString().padLeft(2, '0')}h${start.minute.toString().padLeft(2, '0')} '
           'à ${end.hour.toString().padLeft(2, '0')}h${end.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} jour${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} heure${duration.inHours > 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} min';
    } else {
      return 'Urgent';
    }
  }

  Future<void> _reserveOffer(FoodOffer offer) async {
    setState(() => isReserving = true);
    
    try {
      // Créer la réservation
      await ref.read(
        createReservationProvider((offerId: widget.offerId, quantity: quantity)).future,
      );
      
      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              offer.isFree 
                  ? 'Réservation gratuite confirmée !' 
                  : 'Réservation confirmée pour ${(offer.discountedPrice * quantity).toStringAsFixed(2)}€',
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Naviguer vers l'écran de réservations
        Navigator.of(context).pushReplacementNamed('/reservations');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isReserving = false);
      }
    }
  }
}