import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
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

            SizedBox(height: EcoPlatesDesignTokens.spacing.dialogGap(context)),

            // Contenu principal
            Expanded(
              child: allOffersAsync.when(
                data: (offers) {
                  // Afficher la vue selon le mode sélectionné
                  return AnimatedSwitcher(
                    duration:
                        EcoPlatesDesignTokens.layout.viewTransitionDuration,
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
                        size: EcoPlatesDesignTokens.layout.errorStateIconSize,
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.error.withValues(
                              alpha:
                                  EcoPlatesDesignTokens.opacity.textSecondary,
                            ),
                      ),
                      SizedBox(
                        height: EcoPlatesDesignTokens.spacing.dialogGap(
                          context,
                        ),
                      ),
                      Text(
                        'Erreur de chargement',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: EcoPlatesDesignTokens.typography.medium,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      SizedBox(
                        height: EcoPlatesDesignTokens.spacing.microGap(context),
                      ),
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
          height:
              MediaQuery.of(context).size.height *
              EcoPlatesDesignTokens.layout.filtersModalHeightRatio,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(EcoPlatesDesignTokens.radius.lg),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(
                  EcoPlatesDesignTokens.spacing.dialogGap(context),
                ),
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
                        fontSize: EcoPlatesDesignTokens.typography.titleSize(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
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
                      fontSize: EcoPlatesDesignTokens.typography.text(context),
                    ),
                  ),
                ),
              ),

              // Bouton appliquer
              Container(
                padding: EdgeInsets.all(
                  EcoPlatesDesignTokens.spacing.dialogGap(context),
                ),
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
                      padding: EdgeInsets.symmetric(
                        vertical: EcoPlatesDesignTokens.spacing.dialogGap(
                          context,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens.radius.sm,
                        ),
                      ),
                    ),
                    child: Text(
                      'Appliquer les filtres',
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.button(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
                      ),
                    ),
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
