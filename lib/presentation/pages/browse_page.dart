import 'dart:async';

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
      backgroundColor: viewMode == BrowseViewMode.map
          ? Colors.transparent
          : null,
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

            SizedBox(height: 16),

            // Contenu principal
            Expanded(
              child: allOffersAsync.when(
                data: (offers) {
                  // Afficher la vue selon le mode sélectionné
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
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
                        size: 48,
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withOpacity(0.7),
                      ),
                      Text(
                        'Erreur de chargement',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 16),
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
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtres',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            ref
                                .read(browseFiltersProvider.notifier)
                                .clearFilters();
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
              Expanded(
                child: Center(
                  child: Text(
                    'Filtres à implémenter\n\n'
                    '• Distance\n'
                    '• Prix\n'
                    '• Catégories\n'
                    '• Régimes alimentaires\n'
                    '• Disponibilité',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // Bouton appliquer
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Appliquer'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleLocation(BuildContext context, WidgetRef ref) {
    final wasActive = ref.read(isLocationActiveProvider);
    ref.read(isLocationActiveProvider.notifier).toggle();
    final isNowActive = !wasActive;

    // Si la localisation est activée et qu'on est en mode carte, centrer sur l'utilisateur
    if (isNowActive && ref.read(browseViewModeProvider) == BrowseViewMode.map) {
      ref.invalidate(centerMapOnUserProvider); // Déclenche le centrage
    }
  }
}
