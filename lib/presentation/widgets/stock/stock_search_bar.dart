import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../providers/stock_items_provider.dart';

/// Barre de recherche avancée pour filtrer les articles de stock
///
/// Utilise un debounce pour éviter les appels trop fréquents lors de la frappe.
/// Met à jour automatiquement les filtres via le provider stockFiltersProvider.
/// Optimisée pour Material 3 et Cupertino avec animations fluides.
class StockSearchBar extends ConsumerStatefulWidget {
  const StockSearchBar({
    super.key,
    this.hintText = 'Rechercher un article...',
    this.debounceDuration = const Duration(milliseconds: 300),
    this.showAnimations = true,
    this.compactMode = false,
    this.enableSuggestions = true,
    this.maxSuggestions = 5,
  });

  /// Texte d'indication dans le champ de recherche
  final String hintText;

  /// Durée du debounce pour éviter les appels excessifs
  final Duration debounceDuration;

  /// Active les animations et transitions
  final bool showAnimations;

  /// Mode compact pour affichage réduit
  final bool compactMode;

  /// Active les suggestions de recherche
  final bool enableSuggestions;

  /// Nombre maximum de suggestions à afficher
  final int maxSuggestions;

  @override
  ConsumerState<StockSearchBar> createState() => _StockSearchBarState();
}

class _StockSearchBarState extends ConsumerState<StockSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Initialise le contrôleur avec la valeur actuelle du filtre
    final currentFilters = ref.read(stockFiltersProvider);
    _controller.text = currentFilters.searchQuery;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Annule le timer précédent
    _debounceTimer?.cancel();

    // Démarre un nouveau timer
    _debounceTimer = Timer(widget.debounceDuration, () {
      // Met à jour les filtres seulement après le délai
      ref.read(stockFiltersProvider.notifier).updateSearchQuery(query.trim());
    });
  }

  void _clearSearch() {
    _controller.clear();
    _debounceTimer?.cancel();

    // Met à jour immédiatement pour effacer la recherche
    ref.read(stockFiltersProvider.notifier).updateSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: DeepColorTokens.neutral400.withValues(
            alpha: DeepColorTokens.opacity10,
          ),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.search,
            color: DeepColorTokens.neutral600,
            size: 20.0,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: DeepColorTokens.neutral600,
                    size: 20.0,
                  ),
                  onPressed: _clearSearch,
                  tooltip: 'Effacer la recherche',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        style: TextStyle(
          color: DeepColorTokens.neutral800,
          fontSize: 16.0,
          height: 1.2,
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
