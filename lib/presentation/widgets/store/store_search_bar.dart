import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/store_offers_provider.dart';

/// Barre de recherche pour filtrer les offres de la boutique
class StoreSearchBar extends ConsumerStatefulWidget {
  const StoreSearchBar({super.key});

  @override
  ConsumerState<StoreSearchBar> createState() => _StoreSearchBarState();
}

class _StoreSearchBarState extends ConsumerState<StoreSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchQuery = ref.watch(
      storeFiltersProvider.select((filters) => filters.searchQuery),
    );

    // Synchroniser le contrôleur si la requête change depuis l'extérieur
    if (_controller.text != searchQuery) {
      _controller.text = searchQuery;
    }

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            fontSize: 12,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  onPressed: () {
                    _controller.clear();
                    ref
                        .read(storeFiltersProvider.notifier)
                        .updateSearchQuery('');
                    _focusNode.unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
        ),
        onChanged: (value) {
          ref.read(storeFiltersProvider.notifier).updateSearchQuery(value);
        },
        onSubmitted: (_) {
          _focusNode.unfocus();
        },
        textInputAction: TextInputAction.search,
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 12),
      ),
    );
  }
}
