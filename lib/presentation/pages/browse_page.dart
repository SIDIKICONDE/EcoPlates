import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/all_offers_provider.dart';
import '../providers/browse_search_provider.dart';
import '../providers/browse_view_provider.dart';
import '../widgets/browse/browse_list_view.dart';
import '../widgets/browse/browse_map_view.dart';
import '../widgets/browse/browse_search_bar.dart';
import '../widgets/browse/browse_view_segment.dart';

/// Page Parcourir - Recherche et navigation avancée
class BrowsePage extends ConsumerWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(browseViewModeProvider);
    final allOffersAsync = ref.watch(allOffersProvider);
    
    return Scaffold(
      backgroundColor: viewMode == BrowseViewMode.map ? Colors.transparent : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Barre de recherche
            BrowseSearchBar(
              onFilterTap: () => _showFiltersModal(context, ref),
              onLocationTap: () => _toggleLocation(context, ref),
            ),
            
            // Segment de navigation Liste/Carte
            const BrowseViewSegment(),
            
            const SizedBox(height: 16),
            
            // Contenu principal
            Expanded(
              child: allOffersAsync.when(
                data: (offers) {
                  // Afficher la vue selon le mode sélectionné
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: viewMode == BrowseViewMode.list
                        ? BrowseListView(
                            key: const ValueKey('list'),
                            offers: offers,
                          )
                        : BrowseMapView(
                            key: const ValueKey('map'),
                            offers: offers,
                          ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erreur de chargement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          ref.invalidate(allOffersProvider);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFiltersModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtres',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          ref.read(browseFiltersProvider.notifier).state = 
                              const BrowseFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('Réinitialiser'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Contenu des filtres
            const Expanded(
              child: Center(
                child: Text(
                  'Filtres à implémenter\n\n'
                  '• Distance\n'
                  '• Prix\n'
                  '• Catégories\n'
                  '• Régimes alimentaires\n'
                  '• Disponibilité',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            // Bouton appliquer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Appliquer les filtres',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _toggleLocation(BuildContext context, WidgetRef ref) {
    final isActive = ref.read(isLocationActiveProvider);
    final newState = !isActive;

    ref.read(isLocationActiveProvider.notifier).state = newState;

    // Si la localisation est activée et qu'on est en mode carte, centrer sur l'utilisateur
    if (newState && ref.read(browseViewModeProvider) == BrowseViewMode.map) {
      ref.invalidate(centerMapOnUserProvider); // Déclenche le centrage
    }
  }
}