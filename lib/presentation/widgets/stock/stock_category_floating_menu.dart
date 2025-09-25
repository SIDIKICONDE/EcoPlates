import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isOpen = false;

  // Liste des catégories disponibles avec leurs icônes
  final Map<String, IconData> _categoryIcons = {
    'Tous': Icons.grid_view_rounded,
    'Fruits': Icons.apple,
    'Légumes': Icons.eco,
    'Plats': Icons.restaurant,
    'Boulangerie': Icons.bakery_dining,
    'Boissons': Icons.local_drink,
    'Épicerie': Icons.shopping_basket,
    'Viande': Icons.kebab_dining,
    'Poisson': Icons.set_meal,
    'Produits laitiers': Icons.icecream,
    'Surgelés': Icons.ac_unit,
    'Autre': Icons.more_horiz,
  };

  // Couleurs associées aux catégories
  final Map<String, Color> _categoryColors = {
    'Tous': Colors.blueGrey,
    'Fruits': Colors.orange,
    'Légumes': Colors.green,
    'Plats': Colors.deepOrange,
    'Boulangerie': Colors.brown,
    'Boissons': Colors.blue,
    'Épicerie': Colors.purple,
    'Viande': Colors.red,
    'Poisson': Colors.cyan,
    'Produits laitiers': Colors.amber,
    'Surgelés': Colors.lightBlue,
    'Autre': Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
        _animationController.forward();
      } else {
        _animationController.reverse();
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
            bottom: 80,
            right: 16,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.bottomRight,
              child: Container(
                width: 200,
                constraints: const BoxConstraints(maxHeight: 400),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titre du menu
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Catégories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        // Liste des catégories
                        ..._categoryIcons.entries.map((entry) {
                          final isSelected = selectedCategory == entry.key;
                          final color = _categoryColors[entry.key]!;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Mettre à jour le filtre
                                ref
                                    .read(stockFiltersProvider.notifier)
                                    .state = currentFilters.copyWith(
                                  searchQuery: entry.key == 'Tous'
                                      ? ''
                                      : entry.key,
                                );
                                _toggleMenu();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  border: isSelected
                                      ? Border(
                                          left: BorderSide(
                                            color: color,
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? color.withValues(alpha: 0.2)
                                            : color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        entry.value,
                                        size: 20,
                                        color: isSelected
                                            ? color
                                            : color.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: 15,
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
                                        size: 20,
                                        color: color,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Bouton flottant principal
        FloatingActionButton.small(
          onPressed: _toggleMenu,
          backgroundColor: theme.colorScheme.primary,
          elevation: 4,
          highlightElevation: 6,
          tooltip: _isOpen ? 'Fermer' : 'Filtrer par catégorie',
          child: RotationTransition(
            turns: _rotationAnimation,
            child: Icon(
              _isOpen ? Icons.close : Icons.category,
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
