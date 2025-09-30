import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
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
    final searchQuery = ref.watch(
      storeFiltersProvider.select((filters) => filters.searchQuery),
    );

    // Synchroniser le contrôleur si la requête change depuis l'extérieur
    if (_controller.text != searchQuery) {
      _controller.text = searchQuery;
    }

    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          hintStyle: TextStyle(
            color: DeepColorTokens.neutral600.withValues(
              alpha: 0.1,
            ),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: DeepColorTokens.neutral600,
            size: 16.0,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: DeepColorTokens.neutral600,
                    size: 16.0,
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
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
        ),
        onChanged: (value) {
          ref.read(storeFiltersProvider.notifier).updateSearchQuery(value);
        },
        onSubmitted: (_) {
          _focusNode.unfocus();
        },
        textInputAction: TextInputAction.search,
        style: TextStyle(
          color: DeepColorTokens.neutral0,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
