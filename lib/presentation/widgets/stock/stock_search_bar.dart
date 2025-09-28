import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
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
    final theme = Theme.of(context);

    return Container(
      height: EcoPlatesDesignTokens.size.minTouchTarget,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: EcoPlatesDesignTokens.typography.text(context),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
            size: EcoPlatesDesignTokens.size.icon(context),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: EcoPlatesDesignTokens.size.icon(context),
                  ),
                  onPressed: _clearSearch,
                  tooltip: 'Effacer la recherche',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.scaleXS_SM_MD_LG,
            vertical: context.scaleXXS_XS_SM_MD,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: EcoPlatesDesignTokens.typography.text(context),
          height: 1.2,
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
