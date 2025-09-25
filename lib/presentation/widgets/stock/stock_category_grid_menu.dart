import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/stock_items_provider.dart';

/// Menu flottant avec grille de catégories
/// 
/// Version alternative avec une présentation en grille
class StockCategoryGridMenu extends ConsumerStatefulWidget {
  const StockCategoryGridMenu({super.key});

  @override
  ConsumerState<StockCategoryGridMenu> createState() =>
      _StockCategoryGridMenuState();
}

class _StockCategoryGridMenuState extends ConsumerState<StockCategoryGridMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isOpen = false;

  // Catégories avec style
  final List<CategoryItem> _categories = [
    CategoryItem('Tous', Icons.grid_view_rounded, Colors.blueGrey),
    CategoryItem('Fruits', Icons.apple, Colors.orange),
    CategoryItem('Légumes', Icons.eco, Colors.green),
    CategoryItem('Plats', Icons.restaurant, Colors.deepOrange),
    CategoryItem('Boulangerie', Icons.bakery_dining, Colors.brown),
    CategoryItem('Boissons', Icons.local_drink, Colors.blue),
    CategoryItem('Épicerie', Icons.shopping_basket, Colors.purple),
    CategoryItem('Viande', Icons.kebab_dining, Colors.red),
    CategoryItem('Poisson', Icons.set_meal, Colors.cyan),
    CategoryItem('Produits laitiers', Icons.icecream, Colors.amber),
    CategoryItem('Surgelés', Icons.ac_unit, Colors.lightBlue),
    CategoryItem('Autre', Icons.more_horiz, Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
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
    final size = MediaQuery.of(context).size;
    final currentFilters = ref.watch(stockFiltersProvider);
    final selectedCategory = currentFilters.searchQuery.isEmpty
        ? 'Tous'
        : currentFilters.searchQuery;

    return Stack(
      children: [
        // Overlay avec effet de flou
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: BackdropFilter(
                    filter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.3),
                      BlendMode.multiply,
                    ),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),

        // Menu en grille centré
        if (_isOpen)
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre avec style
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category,
                            color: theme.colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Catégories',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Grille de catégories
                      Flexible(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: _categories.map((category) {
                              final isSelected = selectedCategory == category.name;
                              return SizedBox(
                                width: (size.width * 0.9 - 48 - 24) / 3,
                                height: (size.width * 0.9 - 48 - 24) / 3,
                                child: _buildCategoryTile(
                                  category,
                                  isSelected,
                                  theme,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Bouton fermer
                      TextButton.icon(
                        onPressed: _toggleMenu,
                        icon: const Icon(Icons.close),
                        label: const Text('Fermer'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Bouton flottant principal
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _toggleMenu,
            backgroundColor: theme.colorScheme.primary,
            elevation: 8,
            child: AnimatedRotation(
              turns: _isOpen ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isOpen ? Icons.close : Icons.category,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
    CategoryItem category,
    bool isSelected,
    ThemeData theme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final currentFilters = ref.read(stockFiltersProvider);
          ref.read(stockFiltersProvider.notifier).state =
              currentFilters.copyWith(
            searchQuery: category.name == 'Tous' ? '' : category.name,
          );
          _toggleMenu();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? category.color.withValues(alpha: 0.2)
                : theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? category.color
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône avec animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color.withValues(alpha: 0.3)
                      : category.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: isSelected
                      ? category.color
                      : category.color.withValues(alpha: 0.7),
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              // Nom de la catégorie
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? category.color
                      : theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Badge de sélection
              if (isSelected) ...[
                const SizedBox(height: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: category.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Classe pour représenter une catégorie
class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryItem(this.name, this.icon, this.color);
}