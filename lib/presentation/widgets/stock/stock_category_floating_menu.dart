import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/stock_items_provider.dart';

/// Menu flottant pour filtrer par catégorie
///
/// Affiche un bouton d'action flottant qui, lorsqu'il est pressé,
/// ouvre un menu élégant avec toutes les catégories disponibles
class StockCategoryFloatingMenu extends ConsumerStatefulWidget {
  const StockCategoryFloatingMenu({super.key});

  @override
  ConsumerState<StockCategoryFloatingMenu> createState() =>
      _StockCategoryFloatingMenuState();
}

class _StockCategoryFloatingMenuState
    extends ConsumerState<StockCategoryFloatingMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isOpen = false;

  // Catégories centralisées avec icônes et couleurs
  late final List<
    ({String label, String slug, FoodCategory id, IconData icon, Color color})
  >
  _categories = [
    (
      label: 'Tous',
      slug: '',
      id: FoodCategory.autre,
      icon: Icons.grid_view_rounded,
      color: Colors.blueGrey,
    ),
    ...Categories.ordered.map(
      (c) => (
        label: Categories.labelOf(c),
        slug: Categories.slugOf(c),
        id: c,
        icon: Categories.iconOf(c),
        color: Categories.colorOf(c),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        unawaited(_animationController.forward());
      } else {
        unawaited(_animationController.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentFilters = ref.watch(stockFiltersProvider);
    final selectedCategory = currentFilters.searchQuery.isEmpty
        ? 'Tous'
        : currentFilters.searchQuery;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Overlay pour fermer le menu en cliquant ailleurs
        if (_isOpen)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

        // Menu des catégories
        if (_isOpen)
          Positioned(
            bottom: 80.0,
            right: 16.0,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 400.0,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Titre du menu
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Catégories',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    // Liste des catégories
                    ..._categories.map((c) {
                      final isSelected =
                          selectedCategory == c.label ||
                          selectedCategory == c.slug;
                      final color = c.color;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Mettre à jour le filtre en stockant le slug (ou vide pour 'Tous')
                            ref
                                .read(stockFiltersProvider.notifier)
                                .updateSearchQuery(c.slug);
                            _toggleMenu();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              border: isSelected
                                  ? Border(
                                      left: BorderSide(
                                        color: color,
                                        width: 2.0,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? color.withValues(alpha: 0.2)
                                        : color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Icon(
                                    c.icon,
                                    size: 16.0,
                                    color: isSelected
                                        ? color
                                        : color.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    c.label,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? color
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    size: 16.0,
                                    color: color,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),

        // Bouton flottant principal
        FloatingActionButton.small(
          onPressed: _toggleMenu,
          backgroundColor: theme.colorScheme.primary,
          elevation: 16.0,
          child: Icon(
            _isOpen ? Icons.close : Icons.filter_list,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
