import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../core/responsive/responsive.dart';
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
                child: ColoredBox(
                  color: Colors.black.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.pressed,
                  ),
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
                constraints: BoxConstraints(
                  maxWidth:
                      EcoPlatesDesignTokens.layout.mainContainerMaxWidth(
                        context,
                      ) *
                      0.9,
                ),
                padding: EdgeInsets.all(context.scaleLG_XL_XXL_XXXL),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xxl,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.subtle,
                      ),
                      blurRadius: EcoPlatesDesignTokens.elevation.largeBlur,
                      offset: EcoPlatesDesignTokens.elevation.elevatedOffset,
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
                            size: EcoPlatesDesignTokens.size.icon(context),
                          ),
                          SizedBox(width: context.scaleXS_SM_MD_LG),
                          Text(
                            'Catégories',
                            style: TextStyle(
                              fontSize: EcoPlatesDesignTokens.typography
                                  .modalTitle(context),
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.scaleLG_XL_XXL_XXXL),

                      // Grille de catégories
                      Flexible(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: context.scaleXS_SM_MD_LG,
                            runSpacing: context.scaleXS_SM_MD_LG,
                            alignment: WrapAlignment.center,
                            children: _categories.map((category) {
                              final isSelected =
                                  selectedCategory == category.name;
                              final tileSize =
                                  (size.width * 0.9 -
                                      context.scaleLG_XL_XXL_XXXL * 2 -
                                      context.scaleXS_SM_MD_LG * 2) /
                                  3;
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

                      SizedBox(height: context.scaleMD_LG_XL_XXL),

                      // Bouton fermer
                      TextButton.icon(
                        onPressed: _toggleMenu,
                        icon: Icon(
                          Icons.close,
                          size: context.scaleIconStandard,
                        ),
                        label: Text(
                          'Fermer',
                          style: TextStyle(
                            fontSize: EcoPlatesDesignTokens.typography
                                .modalContent(context),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleLG_XL_XXL_XXXL,
                            vertical: context.scaleXS_SM_MD_LG,
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
          bottom: context.scaleMD_LG_XL_XXL,
          right: context.scaleMD_LG_XL_XXL,
          child: FloatingActionButton(
            onPressed: _toggleMenu,
            backgroundColor: theme.colorScheme.primary,
            elevation: EcoPlatesDesignTokens.elevation.modal,
            child: AnimatedRotation(
              turns: _isOpen ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isOpen ? Icons.close : Icons.category,
                color: theme.colorScheme.onPrimary,
                size: context.scaleIconStandard,
              ),
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
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? category.color.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.pressed,
                  )
                : theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.pressed,
                  ),
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.md,
            ),
            border: Border.all(
              color: isSelected
                  ? category.color
                  : theme.colorScheme.outline.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                    ),
              width: isSelected
                  ? EcoPlatesDesignTokens.layout.cardBorderWidth
                  : EcoPlatesDesignTokens.layout.subtleBorderWidth,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône avec animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        )
                      : category.color.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                        ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: isSelected
                      ? category.color
                      : category.color.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                        ),
                  size: EcoPlatesDesignTokens.size.icon(context),
                ),
              ),
              SizedBox(height: context.scaleSM_MD_LG_XL),
              // Nom de la catégorie
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
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
                SizedBox(height: context.scaleXXS_XS_SM_MD),
                Container(
                  width: context.scaleXXS_XS_SM_MD,
                  height: context.scaleXXS_XS_SM_MD,
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
