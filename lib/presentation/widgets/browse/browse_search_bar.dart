import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      height: 56,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône de recherche
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.search,
              color: Colors.grey,
              size: 24,
            ),
          ),
          
          // Champ de recherche
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                hintText: 'Rechercher une offre...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
            ),
          ),
          
          // Bouton GPS
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onLocationTap,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  isLocationActive ? Icons.location_on : Icons.location_on_outlined,
                  color: isLocationActive 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey[700],
                  size: 24,
                ),
              ),
            ),
          ),
          
          // Séparateur vertical
          Container(
            width: 1,
            height: 24,
            color: Colors.grey[300],
          ),
          
          // Bouton Filtres avec badge
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onFilterTap,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Icon(
                      filters.hasActiveFilters 
                          ? Icons.filter_alt 
                          : Icons.filter_alt_outlined,
                      color: filters.hasActiveFilters 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey[700],
                      size: 24,
                    ),
                    if (filters.activeFiltersCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
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
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}