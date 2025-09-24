import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/map_service.dart';
import '../../providers/browse_search_provider.dart';

/// Barre de recherche pour la page Parcourir
class BrowseSearchBar extends ConsumerStatefulWidget {
  const BrowseSearchBar({
    super.key,
    this.onFilterTap,
    this.onLocationTap,
  });

  final VoidCallback? onFilterTap;
  final VoidCallback? onLocationTap;

  @override
  ConsumerState<BrowseSearchBar> createState() => _BrowseSearchBarState();
}

class _BrowseSearchBarState extends ConsumerState<BrowseSearchBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(browseFiltersProvider);
    final isLocationActive = ref.watch(isLocationActiveProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
      children: [
        // Champ de recherche
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[300]!.withValues(alpha: 0.5),
  
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                hintText: 'Rechercher une offre...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 20,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40,
                  minHeight: 20,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Bouton GPS
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                FocusScope.of(context).unfocus();

                // Activer automatiquement la localisation si elle n'est pas activée
                final isLocationActive = ref.read(isLocationActiveProvider);
                if (!isLocationActive) {
                  ref.read(isLocationActiveProvider.notifier).state = true;
                }

                try {
                  // Centrer automatiquement sur la position utilisateur
                  await MapService.instance.centerOnUserLocation();
                } catch (e) {
                  // Ne rien afficher en cas d'erreur de localisation
                }

                widget.onLocationTap?.call();
              },
              child: Icon(
                isLocationActive ? Icons.near_me : Icons.near_me_outlined,
                color: isLocationActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
                size: 20,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Bouton Filtres avec badge
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                FocusScope.of(context).unfocus();
                widget.onFilterTap?.call();
              },
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      filters.hasActiveFilters 
                          ? Icons.tune 
                          : Icons.tune_outlined,
                      color: filters.hasActiveFilters 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey[700],
                      size: 20,
                    ),
                  ),
                  if (filters.activeFiltersCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${filters.activeFiltersCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }
}
