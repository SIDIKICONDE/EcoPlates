import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/commerce/offers_provider.dart';
import '../../widgets/commerce/offer_card.dart';

/// Écran principal affichant la liste des offres anti-gaspillage
class OffersListScreen extends ConsumerStatefulWidget {
  const OffersListScreen({super.key});

  @override
  ConsumerState<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends ConsumerState<OffersListScreen> {
  bool showFreeOnly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offersAsync = showFreeOnly
        ? ref.watch(freeOffersProvider)
        : ref.watch(nearbyOffersProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Offres Anti-Gaspillage'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: _requestLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle simple entre toutes les offres et gratuites seulement
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Offres gratuites uniquement',
                  style: TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Switch.adaptive(
                  value: showFreeOnly,
                  onChanged: (value) {
                    setState(() {
                      showFreeOnly = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Liste des offres
          Expanded(
            child: offersAsync.when(
              data: (offers) {
                if (offers.isEmpty) {
                  return _buildEmptyState();
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    // Rafraîchir les offres
                    ref.invalidate(nearbyOffersProvider);
                    ref.invalidate(freeOffersProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return OfferCard(
                        offer: offer,
                        onTap: () => _navigateToOfferDetail(offer),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune offre disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revenez plus tard pour découvrir\nde nouvelles offres anti-gaspillage',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(nearbyOffersProvider);
              ref.invalidate(freeOffersProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Actualiser'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(nearbyOffersProvider);
                ref.invalidate(freeOffersProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOfferDetail(FoodOffer offer) {
    // Navigation vers le détail de l'offre
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferDetailScreen(offerId: offer.id),
      ),
    );
  }

  void _requestLocation() async {
    // Logique pour demander la localisation
    // Pour l'instant on simule
    ref.read(userLocationProvider.notifier).state = const UserLocation(
      latitude: 48.8566,
      longitude: 2.3522,
    );
    
    // Rafraîchir les offres avec la nouvelle localisation
    ref.invalidate(nearbyOffersProvider);
    ref.invalidate(freeOffersProvider);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Localisation mise à jour'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// Placeholder pour l'écran de détail (à créer ensuite)
class OfferDetailScreen extends StatelessWidget {
  final String offerId;
  
  const OfferDetailScreen({
    super.key,
    required this.offerId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'offre'),
      ),
      body: Center(
        child: Text('Offre ID: $offerId'),
      ),
    );
  }
}