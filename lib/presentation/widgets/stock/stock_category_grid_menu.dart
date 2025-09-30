import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/stock_items_provider.dart';

/// Configurations centralisées pour le menu grille de catégories
class StockCategoryGridMenuConfigs {
  /// Configuration par défaut pour le menu grille
  static StockCategoryGridMenuConfig get defaultConfig =>
      const StockCategoryGridMenuConfig(
        aspectRatio: 1.0, // Carré parfait
        minTileSize: 80.0,
        maxTileSize: 140.0,
      );
}

/// Configuration pour le menu grille de catégories
class StockCategoryGridMenuConfig {
  const StockCategoryGridMenuConfig({
    required this.aspectRatio,
    required this.minTileSize,
    required this.maxTileSize,
  });

  /// Rapport largeur/hauteur pour les tuiles
  final double aspectRatio;

  /// Taille minimale d'une tuile
  final double minTileSize;

  /// Taille maximale d'une tuile
  final double maxTileSize;
}

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
    const CategoryItem(
      'Tous',
      Icons.grid_view_rounded,
      DeepColorTokens.neutral700,
    ),
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
                  color: DeepColorTokens.overlayMedium,
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
                width: ResponsiveUtils.getMaxContentWidth(context),
                constraints: BoxConstraints(
                  maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                ),
                padding: ResponsiveUtils.getResponsivePadding(context),
                decoration: BoxDecoration(
                  color: DeepColorTokens.surface,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: DeepColorTokens.shadowLight,
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
                          size: ResponsiveUtils.getIconSize(
                            context,
                            baseSize: 20.0,
                          ),
                          color: DeepColorTokens.primary,
                        ),
                        SizedBox(
                          width:
                              ResponsiveUtils.getHorizontalSpacing(context) / 2,
                        ),
                        Text(
                          'Catégories',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              18.0,
                            ),
                            fontWeight: FontWeight.bold,
                            color: DeepColorTokens.neutral0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getVerticalSpacing(context),
                    ),

                    // Grille de catégories
                    Flexible(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing:
                              ResponsiveUtils.getHorizontalSpacing(context) / 2,
                          runSpacing:
                              ResponsiveUtils.getVerticalSpacing(context) / 2,
                          alignment: WrapAlignment.center,
                          children: _categories.map((category) {
                            final isSelected =
                                selectedCategory == category.name;
                            final config =
                                StockCategoryGridMenuConfigs.defaultConfig;

                            // Calcul de la taille basée sur le rapport d'aspect et les contraintes
                            final availableWidth =
                                ResponsiveUtils.getMaxContentWidth(context);
                            final columnsCount =
                                ResponsiveUtils.responsiveValue(
                                  context,
                                  mobile: 3,
                                  tablet: 4,
                                  tabletLarge: 5,
                                  desktop: 6,
                                  desktopLarge: 7,
                                );

                            final spacing =
                                ResponsiveUtils.getHorizontalSpacing(context) /
                                2;
                            final totalSpacing = spacing * (columnsCount - 1);
                            final tileWidth =
                                (availableWidth - totalSpacing) / columnsCount;
                            final constrainedWidth = tileWidth.clamp(
                              config.minTileSize,
                              config.maxTileSize,
                            );
                            final tileHeight =
                                constrainedWidth / config.aspectRatio;

                            return SizedBox(
                              width: constrainedWidth,
                              height: tileHeight,
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

                    SizedBox(
                      height: ResponsiveUtils.getVerticalSpacing(context) * 0.8,
                    ),

                    // Bouton fermer
                    TextButton.icon(
                      onPressed: _toggleMenu,
                      icon: Icon(
                        Icons.close,
                        size: ResponsiveUtils.getIconSize(
                          context,
                          baseSize: 20.0,
                        ),
                      ),
                      label: Text(
                        'Fermer',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            16.0,
                          ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: DeepColorTokens.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getHorizontalSpacing(
                            context,
                          ),
                          vertical:
                              ResponsiveUtils.getVerticalSpacing(context) / 2,
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
            backgroundColor: DeepColorTokens.primary,
            elevation: 16.0,
            child: Icon(
              _isOpen ? Icons.close : Icons.category,
              color: DeepColorTokens.neutral0,
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
                : DeepColorTokens.surfaceContainer.withValues(
                    alpha: 0.1,
                  ),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: isSelected
                  ? category.color
                  : DeepColorTokens.neutral600.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône de la catégorie
              Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.getVerticalSpacing(context) / 3,
                ),
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
                  size: ResponsiveUtils.getIconSize(context),
                ),
              ),
              SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) / 6),
              // Nom de la catégorie
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    14.0,
                  ),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? category.color
                      : DeepColorTokens.neutral600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Badge de sélection
              if (isSelected) ...[
                SizedBox(
                  height: ResponsiveUtils.getVerticalSpacing(context) / 6,
                ),
                Container(
                  width: ResponsiveUtils.getIconSize(context, baseSize: 6.0),
                  height: ResponsiveUtils.getIconSize(context, baseSize: 6.0),
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
