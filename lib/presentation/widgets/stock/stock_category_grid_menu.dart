import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../domain/entities/food_offer.dart';
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

  // Catégories avec style (centralisé)
  late final List<CategoryItem> _categories = [
    const CategoryItem('Tous', Icons.grid_view_rounded, Colors.blueGrey),
    ...Categories.ordered.map(
      (c) => CategoryItem(
        Categories.labelOf(c),
        Categories.iconOf(c),
        Categories.colorOf(c),
        category: c,
      ),
    ),
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
      children: [
        // Overlay avec effet de flou
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Container(),
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
                width: 350.0,
                constraints: BoxConstraints(
                  maxWidth: 350.0,
                ),
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 16.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // En-tête
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category,
                          size: 20.0,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 12.0),
                        Text(
                          'Catégories',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),

                    // Grille de catégories
                    Flexible(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 12.0,
                          runSpacing: 12.0,
                          alignment: WrapAlignment.center,
                          children: _categories.map((category) {
                            final isSelected =
                                selectedCategory == category.name;
                            const tileSize = 100.0;
                            return SizedBox(
                              width: tileSize,
                              height: tileSize,
                              child: _buildCategoryTile(
                                context,
                                category,
                                isSelected,
                                theme,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Bouton fermer
                    TextButton.icon(
                      onPressed: _toggleMenu,
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                      ),
                      label: Text(
                        'Fermer',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Bouton flottant principal
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: FloatingActionButton(
            onPressed: _toggleMenu,
            backgroundColor: theme.colorScheme.primary,
            elevation: 16.0,
            child: Icon(
              _isOpen ? Icons.close : Icons.category,
              color: theme.colorScheme.onPrimary,
              size: 24.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    CategoryItem category,
    bool isSelected,
    ThemeData theme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref
              .read(stockFiltersProvider.notifier)
              .updateSearchQuery(
                // On stocke le slug (ou vide pour 'Tous') pour un traitement robuste
                category.name == 'Tous'
                    ? ''
                    : (category.category != null
                          ? Categories.slugOf(category.category!)
                          : category.name),
              );
          _toggleMenu();
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? category.color.withValues(alpha: 0.1)
                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: isSelected
                  ? category.color
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône de la catégorie
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color.withValues(alpha: 0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: isSelected
                      ? category.color
                      : category.color.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 8.0),
              // Nom de la catégorie
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
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
                SizedBox(height: 4.0),
                Container(
                  width: 6.0,
                  height: 6.0,
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
  const CategoryItem(this.name, this.icon, this.color, {this.category});
  final String name;
  final IconData icon;
  final Color color;
  final FoodCategory? category;
}
