import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/home/categories_section.dart';
import '../widgets/home/home_sections/index.dart';
import '../widgets/home/surprise_box_section.dart';

/// Page d'accueil principale type Too Good To Go
/// Affiche tous les restaurants et leurs offres anti-gaspi
class MainHomeScreen extends ConsumerStatefulWidget {
  const MainHomeScreen({super.key});

  @override
  ConsumerState<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends ConsumerState<MainHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EcoPlates',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        actions: [
          // Bouton localisation
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () => _showLocationPicker(context),
            tooltip: 'Localisation',
          ),
          // Bouton notifications
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {}, // TODO: Implement notifications
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section des grandes enseignes (en premier, position premium)
            const BrandSection(),
            
            // Section "Dernières Minutes" - URGENCE MAXIMALE
            const LastMinuteSection(),

            // Section des catégories
            const CategoriesSection(),

            // Section vidéos - Nouveau!
            const VideoSection(),

            // Section "Recommandé pour vous"
            const RecommendedSection(),
            
            // Section "Végétarien & Vegan"
            const VegetarianSection(),

            // Section "🍞 Boulangeries & Pâtisseries"
            const BakerySection(),

            // Section "Petit Budget - Offres"
            const OffersSection(
              title: '💰 Petit Budget',
              subtitle: 'Offres à moins de 5€ !',
              route: '/budget-offers',
            ),

            // Section "Près de vous - Offres"
            const OffersSection(
              title: '🔥 Près de vous',
              subtitle: 'Offres à proximité immédiate',
              route: '/nearby-offers',
            ),

            // Section "Nouveautés - Offres"
            const OffersSection(
              title: '✨ Nouveautés',
              subtitle: 'Découvrez les dernières offres',
              route: '/new-offers',
            ),

            // Section "Meilleures offres"
            const OffersSection(
              title: '💎 Meilleures offres',
              subtitle: 'Les plus grandes réductions',
              route: '/best-offers',
            ),

            // Section "Dernière chance"
            const ClosingSoonSection(),

            // Section "Colis anti-gaspi"
            const SurpriseBoxSection(),

            // Espacement en bas
            const SizedBox(height: 80),
          ],
        ),
      ),

      // FAB pour ajouter aux favoris ou filtrer
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFilterSheet(context),
        backgroundColor: theme.primaryColor,
        icon: const Icon(Icons.tune),
        label: const Text('Filtrer'),
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sélectionner une localisation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text('Ma position actuelle'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Choisir sur la carte'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Rechercher une adresse'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // void _showNotifications(BuildContext context) {
  //   context.go('/notifications');
  // }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtres',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Distance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _buildFilterChip('< 500m'),
                _buildFilterChip('< 1km'),
                _buildFilterChip('< 2km'),
                _buildFilterChip('< 5km'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Prix',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _buildFilterChip('< 3€'),
                _buildFilterChip('3-5€'),
                _buildFilterChip('5-10€'),
                _buildFilterChip('> 10€'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Type de nourriture',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _buildFilterChip('Végétarien'),
                _buildFilterChip('Végan'),
                _buildFilterChip('Sans gluten'),
                _buildFilterChip('Halal'),
                _buildFilterChip('Casher'),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Appliquer les filtres',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (selected) {},
      backgroundColor: Colors.grey.shade100,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      labelStyle: const TextStyle(fontSize: 14),
    );
  }
}
