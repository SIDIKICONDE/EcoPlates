import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/urgent_offers_provider.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail/index.dart';
import '../../domain/entities/food_offer.dart';

/// Page affichant toutes les offres urgentes à sauver
class AllUrgentOffersScreen extends ConsumerStatefulWidget {
  const AllUrgentOffersScreen({super.key});

  @override
  ConsumerState<AllUrgentOffersScreen> createState() => _AllUrgentOffersScreenState();
}

class _AllUrgentOffersScreenState extends ConsumerState<AllUrgentOffersScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(urgentOffersProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: const Text('🔥'),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text('À sauver d\'urgence'),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.red[50],
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: offersAsync.when(
        data: (offers) {
          if (offers.isEmpty) {
            return _buildEmptyState(context);
          }
          
          // Trier les offres par urgence
          final sortedOffers = List<FoodOffer>.from(offers)
            ..sort((a, b) {
              final aTime = a.pickupEndTime.difference(DateTime.now());
              final bTime = b.pickupEndTime.difference(DateTime.now());
              return aTime.compareTo(bTime);
            });
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(urgentOffersProvider);
              await ref.read(urgentOffersProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedOffers.length,
              itemBuilder: (context, index) {
                final offer = sortedOffers[index];
                final remainingTime = offer.pickupEndTime.difference(DateTime.now());
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Stack(
                    children: [
                      OfferCard(
                        offer: offer,
                        compact: false,
                        showDistance: true,
                        distance: 0.3 + (index * 0.1),
                        onTap: () {
                          _navigateToOfferDetail(context, offer);
                        },
                      ),
                      
                      // Badge urgence en overlay
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _buildUrgencyIndicator(remainingTime),
                      ),
                      
                      // Indicateur de stock faible
                      if (offer.quantity <= 3)
                        Positioned(
                          bottom: 70,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: offer.quantity == 1 
                                ? Colors.red 
                                : Colors.orange,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.flash_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  offer.quantity == 1 
                                    ? 'Dernier disponible !' 
                                    : 'Plus que ${offer.quantity} restants',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Recherche des offres urgentes...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => _buildErrorState(context, ref, error),
      ),
    );
  }

  Widget _buildUrgencyIndicator(Duration remainingTime) {
    if (remainingTime.isNegative) {
      return Container(); // Offre expirée
    }
    
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes % 60;
    
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;
    
    if (hours == 0 && minutes <= 30) {
      bgColor = Colors.red;
      textColor = Colors.white;
      label = '⚡ $minutes min';
      icon = Icons.warning;
    } else if (hours == 0) {
      bgColor = Colors.orange;
      textColor = Colors.white;
      label = '⏰ $minutes min';
      icon = Icons.timer;
    } else if (hours <= 2) {
      bgColor = Colors.amber;
      textColor = Colors.black87;
      label = '${hours}h ${minutes}min';
      icon = Icons.access_time;
    } else {
      bgColor = Colors.blue;
      textColor = Colors.white;
      label = '${hours}h';
      icon = Icons.schedule;
    }
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: hours == 0 ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: textColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 60,
              color: Colors.green[600],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tout a été sauvé ! 🎉',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Aucune offre urgente en ce moment.\nRevenez plus tard pour sauver de la nourriture !',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Oops ! Erreur de chargement',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Impossible de récupérer les offres urgentes',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(urgentOffersProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOfferDetail(BuildContext context, FoodOffer offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOfferDetailModal(context, offer),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    final remainingTime = offer.pickupEndTime.difference(DateTime.now());
    final isVeryUrgent = remainingTime.inMinutes <= 60;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header avec indication d'urgence
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isVeryUrgent 
                  ? [Colors.red[100]!, Colors.orange[50]!]
                  : [Colors.orange[100]!, Colors.yellow[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.red[700],
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Offre très urgente !',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'À récupérer avant ${_formatTime(offer.pickupEndTime)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge quantité limitée si applicable
                  if (offer.quantity <= 3)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange[200]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 12),
                          Text(
                            offer.quantity == 1
                              ? 'Dernier article disponible !'
                              : 'Plus que ${offer.quantity} articles disponibles',
                            style: TextStyle(
                              color: Colors.orange[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Informations principales
                  OfferInfoSection(offer: offer),
                  const SizedBox(height: 24),
                  
                  // Détails pratiques
                  OfferDetailsSection(offer: offer),
                  const SizedBox(height: 24),
                  
                  // Adresse
                  OfferAddressSection(offer: offer),
                  const SizedBox(height: 24),
                  
                  // Badges allergènes
                  OfferBadgesSection(offer: offer),
                  const SizedBox(height: 24),
                  
                  // Métadonnées
                  OfferMetadataSection(offer: offer),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          
          // Barre de réservation urgente
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[50]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                top: BorderSide(color: Colors.red[200]!),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Prix
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (offer.originalPrice > 0)
                        Text(
                          '${offer.originalPrice.toStringAsFixed(2)}€',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      Text(
                        offer.discountedPrice == 0 
                          ? 'Gratuit !'
                          : '${offer.discountedPrice.toStringAsFixed(2)}€',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: offer.discountedPrice == 0 
                            ? Colors.green 
                            : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Bouton de réservation
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Bravo ! Vous avez sauvé "${offer.title}"',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Sauver maintenant',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trier par',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.timer, color: Colors.red),
                title: const Text('Plus urgent d\'abord'),
                subtitle: const Text('Offres qui expirent bientôt'),
                onTap: () {
                  Navigator.pop(context);
                },
                selected: true,
                selectedTileColor: Colors.red[50],
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text('Plus proche'),
                subtitle: const Text('Distance la plus courte'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.euro, color: Colors.green),
                title: const Text('Prix le plus bas'),
                subtitle: const Text('Meilleures affaires'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.inventory, color: Colors.orange),
                title: const Text('Stock faible'),
                subtitle: const Text('Derniers articles disponibles'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrer les offres urgentes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Filtre par temps restant
              Text(
                'Temps restant',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('< 30 min'),
                    avatar: const Icon(Icons.warning, size: 18),
                    backgroundColor: Colors.red[50],
                    selectedColor: Colors.red[200],
                    onSelected: (selected) {},
                  ),
                  FilterChip(
                    label: const Text('< 1h'),
                    avatar: const Icon(Icons.timer, size: 18),
                    backgroundColor: Colors.orange[50],
                    selectedColor: Colors.orange[200],
                    onSelected: (selected) {},
                  ),
                  FilterChip(
                    label: const Text('< 2h'),
                    backgroundColor: Colors.amber[50],
                    selectedColor: Colors.amber[200],
                    onSelected: (selected) {},
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Filtre par quantité
              Text(
                'Quantité disponible',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Dernier article'),
                    avatar: const Icon(Icons.looks_one, size: 18),
                    onSelected: (selected) {},
                  ),
                  FilterChip(
                    label: const Text('< 3 restants'),
                    avatar: const Icon(Icons.inventory_2, size: 18),
                    onSelected: (selected) {},
                  ),
                  FilterChip(
                    label: const Text('< 5 restants'),
                    onSelected: (selected) {},
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Réinitialiser'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Filtres appliqués'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Appliquer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}