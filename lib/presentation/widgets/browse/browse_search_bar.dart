import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/map_service.dart';
import '../../providers/browse_search_provider.dart';

/// Barre de recherche pour la page Parcourir
class BrowseSearchBar extends ConsumerStatefulWidget {
  const BrowseSearchBar({super.key, this.onFilterTap, this.onLocationTap});

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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          // Champ de recherche
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!.withValues(alpha: 0.5),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).update(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 18),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 36,
                    minHeight: 18,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // Bouton GPS
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  FocusScope.of(context).unfocus();

                  // Activer automatiquement la localisation si elle n'est pas activée
                  final isLocationActive = ref.read(isLocationActiveProvider);
                  if (!isLocationActive) {
                    ref
                        .read(isLocationActiveProvider.notifier)
                        .set(value: true);
                  }

                  try {
                    // Centrer automatiquement sur la position utilisateur
                    await MapService().centerOnUserLocation();
                  } on Exception {
                    // Ne rien afficher en cas d'erreur de localisation
                  }

                  widget.onLocationTap?.call();
                },
                child: Icon(
                  isLocationActive ? Icons.near_me : Icons.near_me_outlined,
                  color: isLocationActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                  size: 18,
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // Bouton Filtres avec badge
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
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
                        size: 18,
                      ),
                    ),
                    if (filters.activeFiltersCount > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${filters.activeFiltersCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
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
