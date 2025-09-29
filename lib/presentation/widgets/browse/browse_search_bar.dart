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
      margin: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Champ de recherche
          Expanded(
            child: Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4.0,
                    offset: Offset(0, 2.0),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).update(value);
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20.0,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 40.0,
                    minHeight: 20.0,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 8.0),

          // Bouton GPS
          Container(
            height: 48.0,
            width: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4.0,
                  offset: Offset(0, 2.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
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
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20.0,
                ),
              ),
            ),
          ),

          SizedBox(width: 8.0),

          // Bouton Filtres avec badge
          Container(
            height: 48.0,
            width: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4.0,
                  offset: Offset(0, 2.0),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
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
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20.0,
                      ),
                    ),
                    if (filters.activeFiltersCount > 0)
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${filters.activeFiltersCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
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
